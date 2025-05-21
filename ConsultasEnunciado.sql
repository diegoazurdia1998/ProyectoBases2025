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
-- Listado de todos los usuarios registrados con membresía Premium 

SELECT * 
FROM	Miembro m
		JOIN Membresia mb ON m.IDMiembro = mb.IDMiembro
		JOIN Tipo_Membresia tm ON mb.IDTipo_Membresia = tm.IDTipo_Membresia
WHERE tm.Nombre = 'Premium';

-- 2
-- Mostrar el nombre, ciudad y cantidad de usuarios registrados de todas las sucursales  

SELECT	s.IDSucursal,
		s.Nombre, 
		c.Nombre AS Ciudad, 
		COUNT(ms.IDMiembro) AS Usuarios
FROM	Sucursal s
		JOIN Ciudad c ON s.IDCiudad = c.IDCiudad
		JOIN Miembro_Sucursal ms ON s.IDSucursal = ms.IDSucursal
GROUP BY s.IDSucursal, s.Nombre, c.Nombre;

-- 3
-- Obtener los usuarios registrados en más de una sucursal 

SELECT	IDMiembro, 
		COUNT(*) AS Sucursales
FROM Miembro_Sucursal
GROUP BY IDMiembro
HAVING COUNT(*) > 1;

-- 4
-- Listar los usuarios que se han unido a algún reto global 

SELECT DISTINCT mr.IDMiembro,
		(m.Nombre1 + ' ' +m.Apellido1) as Miembro
FROM	Miembro_reto mr
		JOIN Reto r ON mr.IDReto = r.IDReto
		JOIN Miembro m ON mr.IDMiembro = m.IDMiembro
WHERE r.IDSucursal IS NULL;  -- Reto global


SELECT DISTINCT 
    m.IDMiembro,
    (m.Nombre1 + ' ' + m.Apellido1) as Miembro
FROM Miembro m
JOIN Miembro_reto mr ON m.IDMiembro = mr.IDMiembro
JOIN Reto r ON mr.IDReto = r.IDReto AND r.IDSucursal IS NULL;

-- 5
-- Top 5 usuarios con más puntos disponibles (no expirados y no canjeados) 

SELECT TOP 5
    m.IDMiembro,
    CONCAT(m.Nombre1, ' ', m.Apellido1) as Miembro,
    SUM(CASE WHEN p.Fecha_vencido > GETDATE() OR p.Fecha_vencido IS NULL THEN p.Cantidad ELSE 0 END) -
    ISNULL((
        SELECT SUM(c.Cantidad) 
        FROM Canje c 
        JOIN Miembro_Sucursal ms ON c.IDMiembro_Sucursal = ms.IDMiembro_Sucursal
        WHERE ms.IDMiembro = m.IDMiembro
    ), 0) AS PuntosDisponibles
FROM Miembro m
LEFT JOIN Punteo p ON m.IDMiembro = p.IDMiembro
GROUP BY m.IDMiembro, m.Nombre1, m.Apellido1
ORDER BY PuntosDisponibles DESC;

-- 6
-- Listado de grupos con más de 15 miembros activos durante los últimos 30 días 

SELECT 
    g.IDGrupo, 
    g.Nombre, 
    COUNT(DISTINCT a.IDMiembro_Sucursal) AS MiembrosActivos
FROM	Grupo g
		JOIN Miembro_Grupo mg ON g.IDGrupo = mg.IDGrupo
		JOIN Miembro_Sucursal ms ON mg.IDMiembro = ms.IDMiembro
		JOIN Asistencia a ON ms.IDMiembro_Sucursal = a.IDMiembro_Sucursal
WHERE	a.FechaHora_Entrada >= DATEADD(DAY, -30, GETDATE())
		AND (mg.Fecha_salida IS NULL OR mg.Fecha_salida > GETDATE())
GROUP BY g.IDGrupo, g.Nombre
HAVING COUNT(DISTINCT a.IDMiembro_Sucursal) > 15
ORDER BY MiembrosActivos desc;

-- 7 
-- Listado de usuarios que han asistido a algún gimnasio más de 8 veces en los últimos 30 días 

SELECT 
    m.IDMiembro,
    (m.Nombre1 + ' ' + m.Apellido1) as Miembro,
    COUNT(*) AS Asistencias
FROM Miembro m
JOIN Miembro_Sucursal ms ON m.IDMiembro = ms.IDMiembro
JOIN Asistencia a ON ms.IDMiembro_Sucursal = a.IDMiembro_Sucursal
WHERE a.FechaHora_Entrada >= DATEADD(DAY, -30, GETDATE())
GROUP BY m.IDMiembro, m.Nombre1, m.Apellido1
HAVING COUNT(*) > 8
ORDER BY Asistencias DESC;-- ms.IDMiembro

-- 8
-- Top 3 usuarios con más retos globales completados durante el año pasado 

SELECT TOP 3 
    mr.IDMiembro, 
    (m.Nombre1 + ' ' + m.Apellido1) as Miembro,
    COUNT(*) AS RetosCompletados
FROM Miembro_reto mr
JOIN Reto r ON mr.IDReto = r.IDReto
JOIN Miembro m ON mr.IDMiembro = m.IDMiembro
WHERE r.IDSucursal IS NULL  -- Reto global
	AND mr.Progreso >= 40
GROUP BY mr.IDMiembro, m.Nombre1, m.Apellido1
ORDER BY RetosCompletados DESC;

-- 9
-- Mostrar los líderes de grupo que llevan más de 1 año en FitChain indicando la cantidad de puntos que ha conseguido todo su equipo durante los últimos 365 días (cada miembro suma puntos para el grupo si al momento de recibirlos pertenece a este) 

SELECT 
    g.IDGrupo, 
    g.Nombre AS NombreGrupo,
    l.IDMiembro AS IDLider,
    (l.Nombre1 + ' ' + l.Apellido1) AS NombreLider,
    SUM(p.Cantidad) AS PuntosEquipo
FROM Miembro_Grupo mg
JOIN Grupo g ON mg.IDGrupo = g.IDGrupo
JOIN Miembro l ON mg.IDMiembro = l.IDMiembro
JOIN Miembro_Grupo mgm ON g.IDGrupo = mgm.IDGrupo
JOIN Punteo p ON mgm.IDMiembro = p.IDMiembro
    AND p.Fecha_obtenido BETWEEN mgm.Fecha_entrada AND ISNULL(mgm.Fecha_salida, GETDATE())
WHERE mg.esLider = 1
    AND l.Fecha_registro <= DATEADD(YEAR, -1, GETDATE())
    AND p.Fecha_obtenido >= DATEADD(DAY, -365, GETDATE())
GROUP BY g.IDGrupo, g.Nombre, l.IDMiembro, l.Nombre1, l.Apellido1
ORDER BY PuntosEquipo DESC;

-- 10
-- Listado de usuarios con membresía activa (que haya pagado su mensualidad), que tengan 3 sucursales registradas, hayan completado al menos un reto global y tengan más de 500 puntos activos. Debe mostrar código de usuario, nombres, cantidad de puntos, sucursal principal y sucursales secundarias) 

SELECT 
    m.IDMiembro, 
    CONCAT(m.Nombre1, ' ', m.Apellido1) AS NombreCompleto,
    (SELECT SUM(p.Cantidad) 
     FROM Punteo p 
     WHERE p.IDMiembro = m.IDMiembro 
     AND (p.Fecha_vencido > GETDATE() OR p.Fecha_vencido IS NULL)) AS Puntos,
    (SELECT TOP 1 s.Nombre 
     FROM Miembro_Sucursal ms 
     JOIN Sucursal s ON ms.IDSucursal = s.IDSucursal
     WHERE ms.IDMiembro = m.IDMiembro AND ms.esPrincipal = 1) AS SucursalPrincipal,
    STUFF((
        SELECT ', ' + s.Nombre
        FROM Miembro_Sucursal ms
        JOIN Sucursal s ON ms.IDSucursal = s.IDSucursal
        WHERE ms.IDMiembro = m.IDMiembro AND ms.esPrincipal = 0
        FOR XML PATH('')
    ), 1, 2, '') AS SucursalesSecundarias
FROM Miembro m
WHERE
EXISTS (
    SELECT 1 FROM Membresia mb
    JOIN Pago p ON mb.IDMembresia = p.IDMembresia
    WHERE mb.IDMiembro = m.IDMiembro
    AND p.Fecha_trasaccion >= DATEADD(MONTH, -1, GETDATE())
)
AND (SELECT COUNT(*) FROM Miembro_Sucursal WHERE IDMiembro = m.IDMiembro) = 3
AND EXISTS (
    SELECT 1 FROM Miembro_reto mr
    JOIN Reto r ON mr.IDReto = r.IDReto
    WHERE mr.IDMiembro = m.IDMiembro AND r.IDSucursal IS NULL
)
AND (SELECT SUM(p.Cantidad) 
     FROM Punteo p 
     WHERE p.IDMiembro = m.IDMiembro 
     AND (p.Fecha_vencido > GETDATE() OR p.Fecha_vencido IS NULL)) > 500
GROUP BY m.IDMiembro, m.Nombre1, m.Apellido1;

-- 11
-- Listado de usuarios con membresía Premium que hayan tenido al menos una asistencia este mes en su sucursal principal y al menos una asistencia en una sucursal secundaria) 

SELECT DISTINCT 
    m.IDMiembro,
    m.Nombre1 + ' ' + m.Apellido1 AS NombreCompleto
FROM Miembro m
JOIN Membresia mb ON m.IDMiembro = mb.IDMiembro
JOIN Tipo_Membresia tm ON mb.IDTipo_Membresia = tm.IDTipo_Membresia AND tm.Nombre = 'Premium'
WHERE EXISTS (
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
);

-- 12
-- Listado de sucursales con cantidad de usuarios registrados y monto recibido por mes durante los últimos 12 meses.

SELECT 
    s.IDSucursal, 
    s.Nombre,
    COUNT(DISTINCT ms.IDMiembro) AS UsuariosRegistrados,
    SUM(CASE 
        WHEN p.Fecha_trasaccion >= DATEADD(MONTH, DATEDIFF(MONTH, 0, DATEADD(MONTH, -12, GETDATE())), 0)
        THEN p.Monto_abonado 
        ELSE 0 
    END) AS MontoUltimos12Meses
FROM Sucursal s
JOIN Miembro_Sucursal ms ON s.IDSucursal = ms.IDSucursal
JOIN Membresia mb ON ms.IDMiembro = mb.IDMiembro
JOIN Pago p ON mb.IDMembresia = p.IDMembresia
GROUP BY s.IDSucursal, s.Nombre
ORDER BY MontoUltimos12Meses desc;

-- 
-- Miembros que utilizan QR, Huella digital
SELECT ta.Nombre, COUNT(*) as Conteo
FROM Miembro_Acceso ma
JOIN Tipo_Acceso ta on ma.IDTipoAcceso = ta.IDTipoAcceso
GROUP BY ta.Nombre;

--
-- Cantidad de personas que se inscribieron a un reto el ultimo trimestre
SELECT r.Nombre, COUNT(DISTINCT mr.IDMiembro) AS [Miembros asignados en el trimestre]
FROM Miembro_reto mr
JOIN Reto r on mr.IDReto =r.IDReto
WHERE DATEDIFF(mm, GETDATE(), mr.Fecha_inscripcion) <= 3
GROUP BY r.Nombre
ORDER BY [Miembros asignados en el trimestre] DESC;