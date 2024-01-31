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



