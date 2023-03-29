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
INNER JOIN Avion a ON c.id_avion=a.id_avion
GROUP BY a.id_avion
ORDER BY vuelos ASC LIMIT 1