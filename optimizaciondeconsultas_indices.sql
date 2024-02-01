--proyecto bases de datos 1 2024 - ALMIRON PEDRO AUGUSTO, OPTIMIZACION DE BUSQUEDA MEDIANTE INDICES 
use consorcio
--VERIFICAMOS QUE NO EXISTE NINGUN INDEX EN LA TABLA CONSORCIO MAS QUE LA PK QUE SE GENERA POR DEFECTO
execute sp_helpindex 'consorcio'


--activamos estadisticas de tiempo y de lectura 
SET STATISTICS TIME ON;
SET STATISTICS IO ON;




--CONSULTAMOS 
SELECT * FROM provincia
SELECT * FROM localidad
SELECT * FROM consorcio
SELECT * FROM gasto


--creamos algunos index no clustered 
CREATE NONCLUSTERED INDEX IDX_provincia_descripcion ON provincia(descripcion);
CREATE NONCLUSTERED INDEX IDX_localidad_idprovincia_idlocalidad ON localidad(idprovincia, idlocalidad);
CREATE NONCLUSTERED INDEX IDX_consorcio_idprovincia_idlocalidad_idconsorcio ON consorcio(idprovincia, idlocalidad, idconsorcio);
CREATE NONCLUSTERED INDEX IDX_gasto_idprovincia_idlocalidad_idconsorcio_periodo ON gasto(idprovincia, idlocalidad, idconsorcio, periodo);

--ejecutamos los select con los indices no clustered

SELECT descripcion
FROM provincia WITH (INDEX (IDX_provincia_descripcion)) 


SELECT descripcion
FROM localidad WITH (INDEX (IDX_localidad_idprovincia_idlocalidad)) 

--apagar estadisticas
SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;




-- Borrar índices en la tabla 'provincia'
DROP INDEX IF EXISTS IDX_provincia_descripcion ON provincia;

-- Borrar índices en la tabla 'localidad'
DROP INDEX IF EXISTS IDX_localidad_idprovincia_idlocalidad ON localidad;

-- Borrar índices en la tabla 'consorcio'
DROP INDEX IF EXISTS IDX_consorcio_idprovincia_idlocalidad_idconsorcio ON consorcio;

-- Borrar índices en la tabla 'gasto'
DROP INDEX IF EXISTS IDX_gasto_idprovincia_idlocalidad_idconsorcio_periodo ON gasto;



create t
--consulta para comprobar la inteligencia de sql al verificar que necesita indices 
use consorcio

	
	select consorcio.nombre as 'Consorcio', sum (importe) as 'Importe total' from consorcio
	inner join gasto on gasto.idconsorcio = consorcio.idconsorcio and
						gasto.idprovincia = consorcio.idprovincia and
						gasto.idlocalidad = consorcio.idlocalidad
	where idtipogasto = 3 and datepart (yy,fechapago)=2015	
	group by consorcio.nombre
	having sum (gasto.importe)>(
								select avg(importe) from gasto
								inner join consorcio co on co.idconsorcio = gasto.idconsorcio and
													       co.idlocalidad = gasto.idlocalidad and
														   co.idprovincia = gasto.idprovincia 

								where idtipogasto = 3 and datepart (yy,fechapago) = 2015						
	)	



	create table ejemplo (
	
		valor1 varchar(20) not null ,
		valor2 varchar (20)not null ,
		valor3 varchar(20) not null 
	
	)



	insert into ejemplo (valor1,valor2,valor3)values('ejemplo5','ejempl1','ejem1')
	insert into ejemplo (valor1,valor2,valor3)values('ejemplo1234','ejempl1','ejem1')
	insert into ejemplo (valor1,valor2,valor3)values('ejemplo122','ejempl1','ejem1')
	insert into ejemplo (valor1,valor2,valor3)values('ejemplo13123','ejempl1','ejem1')

	alter table ejemplo add constraint pk_ejemplo primary key (valor1)


	drop table ejemplo
	
	execute sp_helpindex 'gasto'	execute sp_helpindex 'consorcio'


DROP INDEX indx_demostracion ON gasto;
DROP INDEX gasto.indx_demostracion;