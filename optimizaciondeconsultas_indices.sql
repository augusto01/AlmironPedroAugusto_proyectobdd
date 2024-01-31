--proyecto bases de datos 1 2024 - ALMIRON PEDRO AUGUSTO, OPTIMIZACION DE BUSQUEDA MEDIANTE INDICES 
use consorcio
--VERIFICAMOS QUE NO EXISTE NINGUN INDEX EN LA TABLA CONSORCIO MAS QUE LA PK QUE SE GENERA POR DEFECTO
execute sp_helpindex 'consorcio'




--creamos un index no clustered para que ordene los registros por apeynom
CREATE NONCLUSTERED INDEX IX_provincia_descripcion ON provincia(descripcion);
CREATE NONCLUSTERED INDEX IX_localidad_idprovincia_idlocalidad ON localidad(idprovincia, idlocalidad);
CREATE NONCLUSTERED INDEX IX_consorcio_idprovincia_idlocalidad_idconsorcio ON consorcio(idprovincia, idlocalidad, idconsorcio);
CREATE NONCLUSTERED INDEX IX_gasto_idprovincia_idlocalidad_idconsorcio_periodo ON gasto(idprovincia, idlocalidad, idconsorcio, periodo);
