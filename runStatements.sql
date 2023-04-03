-- 1.- Lista de lugares al que más viajan los chilenos por año, durante los últimos 4 años
SELECT Pe.lugar
FROM Pasaje AS Pe, Vuelo AS Vo, Cliente_Vuelo AS Ce_Vo, Cliente AS Ce
WHERE 
	Pe.id_vuelo = Vo.id_vuelo AND
	Ce_Vo.id_vuelo = Vo.id_vuelo AND
	Ce_Vo.id_cliente = Ce.id_cliente AND
	Pe.fecha > (CURRENT_DATE - interval '4 years') AND
	Ce.nacionalidad = 'Chile';

-- 2.- Lista con las secciones de vuelo más comprada por Argentinos
SELECT Sn.nombre, COUNT(*)
FROM Pasaje AS Pe, Vuelo AS Vo, Cliente_Vuelo AS Ce_Vo, Cliente AS Ce, Seccion Sn
WHERE
	Pe.id_vuelo = Vo.id_vuelo AND
	Ce_Vo.id_vuelo = Vo.id_vuelo AND
	Ce_Vo.id_cliente = Ce.id_cliente AND
	Sn.id_seccion = Pe.id_seccion AND
	Ce.nacionalidad = 'Argentina'
GROUP BY Sn.id_seccion;

-- 3.- Lista mensual de países que más gastan en volar (durante los últimos 4 años)
WITH pasajes_agrupados AS (
  SELECT cli.nacionalidad, date_trunc('month', pas.fecha) AS fecha_truncada, SUM(cos.cantidad) AS total_gastado,
    RANK() OVER (PARTITION BY cli.nacionalidad, date_trunc('month', pas.fecha) ORDER BY SUM(cos.cantidad) DESC) AS ranking
  FROM Pasaje AS pas
  INNER JOIN Cliente_vuelo AS cli_vue ON cli_vue.id_vuelo = pas.id_vuelo
  INNER JOIN Cliente AS cli ON cli_vue.id_cliente = cli.id_cliente
  INNER JOIN Costo AS cos ON cos.id_costo = pas.id_costo
  WHERE date_trunc('year', date_trunc('month', pas.fecha)) BETWEEN '2019-01-01' AND '2023-12-31'
  GROUP BY cli.nacionalidad, date_trunc('month', pas.fecha)
), pasajes_agrupados_mes AS (
  SELECT DISTINCT ON (TO_CHAR(date_trunc('month', fecha_truncada), 'MM/YYYY'))
    TO_CHAR(date_trunc('month', fecha_truncada), 'MM/YYYY') AS mes_anio, nacionalidad, total_gastado, fecha_truncada
  FROM pasajes_agrupados
  WHERE ranking = 1
  ORDER BY TO_CHAR(date_trunc('month', fecha_truncada), 'MM/YYYY'), total_gastado DESC
)
SELECT pasajes_agrupados_mes.nacionalidad, SUM(pasajes_agrupados_mes.total_gastado) AS total_gastado, pasajes_agrupados_mes.mes_anio
FROM pasajes_agrupados_mes
INNER JOIN Cliente AS cli ON pasajes_agrupados_mes.nacionalidad = cli.nacionalidad
WHERE date_trunc('month', TO_DATE(pasajes_agrupados_mes.mes_anio, 'MM/YYYY')) = date_trunc('month', pasajes_agrupados_mes.fecha_truncada)
GROUP BY pasajes_agrupados_mes.nacionalidad, pasajes_agrupados_mes.mes_anio
ORDER BY date_trunc('month', TO_DATE(pasajes_agrupados_mes.mes_anio, 'MM/YYYY'));

-- 4.- Lista de pasajeros que viajan en “First Class” más de 4 veces al mes
SELECT 
	id_cliente, EXTRACT(month FROM fecha) AS mes, 
	EXTRACT(year FROM fecha) AS año, COUNT(pas.id_seccion) AS veces_FirstClass
FROM public.pasaje as pas
INNER JOIN public.cliente_vuelo ON pas.id_vuelo = cliente_vuelo.id_vuelo
INNER JOIN seccion ON seccion.id_seccion = pas.id_seccion
WHERE pas.id_seccion = 4
GROUP BY id_cliente, año, mes
HAVING COUNT(pas.id_seccion) > 4;

--5.- Avión con menos vuelos
SELECT a.id_avion, COUNT(a.id_avion) AS vuelos
FROM Vuelo v
INNER JOIN Compania c ON c.id_compania = v.id_compania
INNER JOIN Avion a ON c.id_compania = a.id_compania
GROUP BY a.id_avion
ORDER BY vuelos ASC LIMIT 1;

--6.- Lista de mensual de pilotos con mayor sueldo durante los últimos 4 años
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

--7.- Lista de compañías indicando cual es el avión que más ha recaudado en los últimos 4 años y cual es el monto recaudado

--8.- Lista de compañías y total de aviones por año, en los últimos 10 años

-- 9.- lista anual de compañías que en promedio han pagado más a sus empleados durante los últimos 10 años
SELECT DISTINCT ON (anio)
	c.nombre as nombre, EXTRACT(year FROM s.fecha_inscrito) as anio, 
	avg(s.cantidad) as sueldo_promedio
FROM Compania c
INNER JOIN Empleado e ON c.id_compania = e.id_compania
INNER JOIN Sueldo s ON e.id_sueldo = s.id_sueldo
WHERE s.fecha_inscrito >= (CURRENT_DATE - interval '10 years')
GROUP BY c.nombre, EXTRACT(year FROM s.fecha_inscrito)
ORDER BY anio, sueldo_promedio DESC;

-- 10.- modelo de avión más usado por compañía durante el 2021
SELECT DISTINCT ON (c.nombre)
c.nombre AS compania, m.nombre AS modelo, COUNT(*) AS cantidad
FROM Compania c
INNER JOIN Avion a ON c.id_compania = a.id_compania
INNER JOIN Modelo m ON a.id_modelo = m.id_modelo
WHERE date_part('year', a.fecha) = 2021
GROUP BY c.nombre, m.nombre
ORDER BY compania, cantidad DESC;
