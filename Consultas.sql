select ms.IDSucursal, COUNT(m.IDMiembro) as mimbros, SUM(p.Monto_abonado) as monto
from	Miembro_Sucursal ms
		join Membresia m on ms.IDMiembro = m.IDMiembro
		join Pago p on m.IDMembresia = p.IDMembresia
where DATEDIFF(mm, p.Fecha_trasaccion, GETDATE()) <= 12
group by ms.IDSucursal

/*
Mostrar los líderes de grupo que llevan más de 1 año en FitChain 
indicando la cantidad de puntos que ha conseguido todo su equipo 
durante los últimos 365 días (cada miembro suma puntos para el grupo si 
al momento de recibirlos pertenece a este) 
*/
select *
from Miembro_reto mr
join 