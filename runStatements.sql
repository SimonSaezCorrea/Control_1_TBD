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
group by Sn.id_seccion