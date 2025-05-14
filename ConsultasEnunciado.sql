/*

1. Listado de todos los usuarios registrados con membresía Premium 
2. Mostrar el nombre, ciudad y cantidad de usuarios registrados de todas las sucursales  
3. Obtener los usuarios registrados en más de una sucursal 
4. Listar los usuarios que se han unido a algún reto global 
5. Top 5 usuarios con más puntos disponibles (no expirados y no canjeados) 
6. Listado de grupos con más de 15 miembros activos durante los últimos 30 días 
7. Listado de usuarios que han asistido a algún gimnasio más de 8 veces en los últimos 30 días 
8. Top 3 usuarios con más retos globales completados durante el año pasado 
9. Mostrar los líderes de grupo que llevan más de 1 año en FitChain indicando la cantidad de puntos que ha conseguido todo su equipo durante los últimos 365 días (cada miembro suma puntos para el grupo si al momento de recibirlos pertenece a este) 
10. Listado de usuarios con membresía activa (que haya pagado su mensualidad), que tengan 3 sucursales registradas, hayan completado al menos un reto global y tengan más de 500 puntos activos. Debe mostrar código de usuario, nombres, cantidad de puntos, sucursal principal y sucursales secundarias) 
11. Listado de usuarios con membresía Premium que hayan tenido al menos una asistencia este mes en su sucursal principal y al menos una asistencia en una sucursal secundaria) 
12. Listado de sucursales con cantidad de usuarios registrados y monto recibido por mes durante los últimos 12 meses.

*/
 
 use FitChain
 go

-- 1

SELECT * 
FROM	Miembro m
		JOIN Membresia mb ON m.IDMiembro = mb.IDMiembro
		JOIN Tipo_Membresia tm ON mb.IDTipo_Membresia = tm.IDTipo_Membresia
WHERE tm.Nombre = 'Premium';

-- 2

SELECT	s.IDSucursal,
		s.Nombre, 
		c.Nombre AS Ciudad, 
		COUNT(ms.IDMiembro) AS Usuarios
FROM	Sucursal s
		JOIN Ciudad c ON s.IDCiudad = c.IDCiudad
		JOIN Miembro_Sucursal ms ON s.IDSucursal = ms.IDSucursal
GROUP BY s.IDSucursal, s.Nombre, c.Nombre;

-- 3

SELECT	IDMiembro, 
		COUNT(*) AS Sucursales
FROM Miembro_Sucursal
GROUP BY IDMiembro
HAVING COUNT(*) > 1;

-- 4

SELECT DISTINCT mr.IDMiembro,
		(m.Nombre1 + ' ' +m.Apellido1) as Miembro
FROM	Miembro_reto mr
		JOIN Reto r ON mr.IDReto = r.IDReto
		JOIN Miembro m ON mr.IDMiembro = m.IDMiembro
WHERE r.IDSucursal IS NULL;  -- Reto global

-- 5

SELECT TOP 5	p.IDMiembro, 
				SUM(p.Cantidad) as [Puntos positivos],
				SUM(c.Cantidad) as [Puntos negativos],
				SUM(p.Cantidad) - SUM(c.Cantidad) AS Puntos
FROM	Punteo p
		JOIN Miembro_Sucursal ms on p.IDMiembro = ms.IDMiembro
		JOIN Canje c on ms.IDMiembro_Sucursal = c.IDMiembro_Sucursal
WHERE p.Fecha_vencido > GETDATE() OR p.Fecha_vencido IS NULL
GROUP BY p.IDMiembro
ORDER BY Puntos DESC;

-- 6

SELECT g.IDGrupo, g.Nombre, COUNT(distinct mg.IDMiembro) AS MiembrosActivos
FROM Grupo g
JOIN Miembro_Grupo mg ON g.IDGrupo = mg.IDGrupo
JOIN Asistencia a ON mg.IDMiembro = (
    SELECT ms.IDMiembro 
    FROM Miembro_Sucursal ms 
    WHERE ms.IDMiembro_Sucursal = a.IDMiembro_Sucursal
)
WHERE a.FechaHora_Entrada >= DATEADD(DAY, -30, GETDATE())
GROUP BY g.IDGrupo, g.Nombre
HAVING COUNT(distinct mg.IDMiembro) > 15;

-- 7 

SELECT ms.IDMiembro, COUNT(*) AS Asistencias
FROM	Asistencia a
		JOIN Miembro_Sucursal ms ON a.IDMiembro_Sucursal = ms.IDMiembro_Sucursal
WHERE a.FechaHora_Entrada >= DATEADD(DAY, -30, GETDATE())
GROUP BY ms.IDMiembro
HAVING COUNT(*) > 8
ORDER BY ms.IDMiembro;

-- 8

SELECT mr.IDMiembro, COUNT(*) AS RetosCompletados
FROM	Miembro_reto mr
		JOIN Reto r ON mr.IDReto = r.IDReto
WHERE	r.IDSucursal IS NULL  -- Reto global
		 AND mr.Fecha_completado >= DATEADD(YEAR, -1, GETDATE())
GROUP BY mr.IDMiembro
ORDER BY RetosCompletados asc;

-- 9

SELECT 
    mg.IDGrupo, 
    mg.IDMiembro AS IDLider,
    SUM(p.Cantidad) AS PuntosEquipo
FROM Miembro_Grupo mg
JOIN Miembro m ON mg.IDMiembro = m.IDMiembro
JOIN Punteo p ON mg.IDMiembro = p.IDMiembro
WHERE mg.esLider = 1
  AND m.Fecha_registro <= DATEADD(YEAR, -1, GETDATE())
  AND p.Fecha_obtenido >= DATEADD(DAY, -365, GETDATE())
GROUP BY mg.IDGrupo, mg.IDMiembro
ORDER BY PuntosEquipo DESC ;

-- 10

SELECT 
    m.IDMiembro, 
    m.Nombre1,
    (SELECT COUNT(*) FROM Miembro_Sucursal WHERE IDMiembro = m.IDMiembro) AS Sucursales,
    (SELECT SUM(p.Cantidad) FROM Punteo p WHERE p.IDMiembro = m.IDMiembro AND (p.Fecha_vencido > GETDATE() OR p.Fecha_vencido IS NULL)) AS Puntos
FROM Miembro m
WHERE EXISTS (
    SELECT 1 FROM Miembro_reto mr
    JOIN Reto r ON mr.IDReto = r.IDReto
    WHERE mr.IDMiembro = m.IDMiembro AND r.IDSucursal IS NULL
)
AND (SELECT COUNT(*) FROM Miembro_Sucursal WHERE IDMiembro = m.IDMiembro) = 3
AND (SELECT SUM(p.Cantidad) FROM Punteo p WHERE p.IDMiembro = m.IDMiembro AND (p.Fecha_vencido > GETDATE() OR p.Fecha_vencido IS NULL)) > 500
ORDER BY Puntos DESC;

-- 11

SELECT DISTINCT m.IDMiembro
FROM Miembro m
JOIN Membresia mb ON m.IDMiembro = mb.IDMiembro
JOIN Tipo_Membresia tm ON mb.IDTipo_Membresia = tm.IDTipo_Membresia
WHERE tm.Nombre = 'Premium'
AND EXISTS (
    SELECT 1 
    FROM Asistencia a
    JOIN Miembro_Sucursal ms ON a.IDMiembro_Sucursal = ms.IDMiembro_Sucursal
    WHERE ms.IDMiembro = m.IDMiembro AND ms.esPrincipal = 1
    AND a.FechaHora_Entrada >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
)
AND EXISTS (
    SELECT 1 
    FROM Asistencia a
    JOIN Miembro_Sucursal ms ON a.IDMiembro_Sucursal = ms.IDMiembro_Sucursal
    WHERE ms.IDMiembro = m.IDMiembro AND ms.esPrincipal = 0
    AND a.FechaHora_Entrada >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)
)
ORDER BY M.IDMiembro DESC;

-- 12

SELECT 
    s.IDSucursal, 
    s.Nombre,
    COUNT(DISTINCT ms.IDMiembro) AS UsuariosRegistrados,
    SUM(p.Monto_abonado) AS MontoTotal
FROM Sucursal s
JOIN Miembro_Sucursal ms ON s.IDSucursal = ms.IDSucursal
JOIN Membresia mb ON ms.IDMiembro = mb.IDMiembro
JOIN Pago p ON mb.IDMembresia = p.IDMembresia
WHERE p.Fecha_trasaccion >= DATEADD(MONTH, -12, GETDATE())
GROUP BY s.IDSucursal, s.Nombre;

--
