Select Pe.lugar
from Pasaje as Pe, Vuelo as Vo, Cliente_Vuelo as Ce_Vo, Cliente as Ce
where 
	Pe.id_vuelo = Vo.id_vuelo and
	Ce_Vo.id_vuelo = Vo.id_vuelo and
	Ce_Vo.id_cliente = Ce.id_cliente and
	Pe.fecha>'2019-03-29' and
	Ce.nacionalidad = 'Chile';
	
Select Sn.nombre, count(*)
from Pasaje as Pe, Vuelo as Vo, Cliente_Vuelo as Ce_Vo, Cliente as Ce, Seccion Sn
where
	Pe.id_vuelo = Vo.id_vuelo and
	Ce_Vo.id_vuelo = Vo.id_vuelo and
	Ce_Vo.id_cliente = Ce.id_cliente and
	Sn.id_seccion = Pe.id_seccion and
	Ce.nacionalidad = 'Argentina'
group by Sn.id_seccion;

SELECT s.fecha_inscrito,e.id_empleado,e.rol,MAX(s.cantidad) AS vuelos
FROM Sueldo s
INNER JOIN Empleado e ON e.id_sueldo=s.id_sueldo
WHERE s.fecha_inscrito >= '2020-04-03' AND s.fecha_inscrito < '2023-04-03'
	AND e.rol='Piloto'
GROUP BY s.fecha_inscrito,e.id_empleado,e.rol,s.cantidad
ORDER BY s.fecha_inscrito DESC;

SELECT a.id_avion, COUNT(a.id_avion) AS vuelos
FROM Vuelo v
INNER JOIN Compania c ON c.id_compania=v.id_compania
INNER JOIN Avion a ON c.id_compania = a.id_compania
GROUP BY a.id_avion
ORDER BY vuelos ASC LIMIT 1

SELECT DISTINCT ON (anio)
	c.nombre as nombre,
SELECT c.nombre,
	EXTRACT(year FROM s.fecha_inscrito) as anio, 
	avg(s.cantidad) as sueldo_promedio
FROM Compania c
INNER JOIN Empleado e ON c.id_compania = e.id_compania
INNER JOIN Sueldo s ON e.id_sueldo = s.id_sueldo
WHERE s.fecha_inscrito >= date_trunc('day', CURRENT_DATE - interval '10 years')
GROUP BY c.nombre, EXTRACT(year FROM s.fecha_inscrito)
ORDER BY anio, sueldo_promedio DESC
ORDER BY sueldo_promedio DESC

SELECT DISTINCT ON (c.nombre)
c.nombre AS compania, m.nombre AS modelo, COUNT(*) AS cantidad
FROM Compania c
INNER JOIN Avion a ON c.id_compania = a.id_compania
INNER JOIN Modelo m ON a.id_modelo = m.id_modelo
JOIN Avion a ON c.id_compania = a.id_compania
JOIN Modelo m ON a.id_modelo = m.id_modelo
WHERE date_part('year', a.fecha) = 2021
GROUP BY c.nombre, m.nombre
ORDER BY compania, cantidad DESC

