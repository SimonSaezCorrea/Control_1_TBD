SELECT Pe.lugar
FROM Pasaje AS Pe, Vuelo AS Vo, Cliente_Vuelo AS Ce_Vo, Cliente AS Ce
WHERE 
	Pe.id_vuelo = Vo.id_vuelo AND
	Ce_Vo.id_vuelo = Vo.id_vuelo AND
	Ce_Vo.id_cliente = Ce.id_cliente AND
	Pe.fecha>'2019-03-29' AND
	Ce.nacionalidad = 'Chile';
	
SELECT Sn.nombre, COUNT(*)
FROM Pasaje AS Pe, Vuelo AS Vo, Cliente_Vuelo AS Ce_Vo, Cliente AS Ce, Seccion Sn
WHERE
	Pe.id_vuelo = Vo.id_vuelo AND
	Ce_Vo.id_vuelo = Vo.id_vuelo AND
	Ce_Vo.id_cliente = Ce.id_cliente AND
	Sn.id_seccion = Pe.id_seccion AND
	Ce.nacionalidad = 'Argentina'
GROUP BY Sn.id_seccion;

WITH R AS (
SELECT s.fecha_inscrito,e.id_empleado,s.cantidad,
	ROW_NUMBER() OVER(PARTITION BY s.fecha_inscrito ORDER BY s.cantidad DESC) AS rn
FROM Sueldo s
INNER JOIN Empleado e ON e.id_sueldo=s.id_sueldo
WHERE e.rol='Piloto' AND s.fecha_inscrito >= (CURRENT_DATE - interval '3 years') 
	AND s.fecha_inscrito < CURRENT_DATE
)
SELECT fecha_inscrito, id_empleado,cantidad AS Sueldo_Mayor
FROM R
WHERE rn = 1;

SELECT a.id_avion, COUNT(a.id_avion) AS vuelos
FROM Vuelo v
INNER JOIN Compania c ON c.id_compania=v.id_compania
INNER JOIN Avion a ON c.id_compania = a.id_compania
GROUP BY a.id_avion
ORDER BY vuelos ASC LIMIT 1;

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
ORDER BY sueldo_promedio DESC;

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

