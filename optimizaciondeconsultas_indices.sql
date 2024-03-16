--proyecto bases de datos 1 2024 - ALMIRON PEDRO AUGUSTO, OPTIMIZACION DE BUSQUEDA MEDIANTE INDICES 
--use consorcio
--VERIFICAMOS QUE NO EXISTE NINGUN INDEX EN LA TABLA CONSORCIO MAS QUE LA PK QUE SE GENERA POR DEFECTO
execute sp_helpindex 'gasto'


--activamos estadisticas de tiempo y de lectura 
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SET NOCOUNT ON; -- Para mejorar el rendimiento al insertar una gran cantidad de registros

--definimos el script que permitira insertar 1 millon de registros en la tabla gasto 



SET NOCOUNT ON; -- Para mejorar el rendimiento al insertar una gran cantidad de registros

DECLARE @TotalRows INT = 1000000; -- Total de registros a insertar
DECLARE @Counter INT = 1;
DECLARE @FechaPago datetime = GETDATE(); -- Fecha de pago constante, se toma la fecha actual
DECLARE @Periodo INT = 1; -- Periodo fijo para todos los registros

WHILE @Counter <= @TotalRows
BEGIN
    INSERT INTO gasto (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
    VALUES (1,
            1,
            1,
            2,
            getdate(),
            1,
            1000); -- Mismo valor para el importe en cada registro
    
    SET @Counter = @Counter + 1;
END;



/*SE INSERTO 1.000.000 DE REGISTROS EN LA TABLA GASTOS, LA CONSULTA TUVO UN COSTE EN TERMINOS DE TIEMPO DE 1 MINUTO 51 SEGUNDOS CON EL SCRIPT ANTERIOR */

--realizamos la busqueda por periodo seleccionando fechade pago y tipo de gasto 
SELECT fechapago, tg.descripcion 
FROM gasto
INNER JOIN tipogasto tg ON gasto.idtipogasto = tg.idtipogasto
WHERE periodo = 2;


--creamos algunos index no clustered en la tabla gasto, para el campo periodo
CREATE NONCLUSTERED INDEX IDX_GASTO_TIPOGASTO ON gasto(periodo);


--ejecutamos los select con los indices no clustered
SELECT fechapago, tg.descripcion 
FROM gasto with(INDEX(IDX_fechapago_idtipogasto))
INNER JOIN tipogasto tg ON gasto.idtipogasto = tg.idtipogasto
WHERE periodo = 2;

--borramos el indice creado anteriormente 
DROP INDEX IF EXISTS "IDX_fechapago_idtipogasto_i" ON gasto;

--ahora creamos un indice compuesto 
CREATE NONCLUSTERED INDEX [IDX_fechapago_idtipogasto] ON [dbo].[gasto] ([fechapago], [idtipogasto]);

SELECT g.fechapago, tg.descripcion 
FROM gasto g WITH(INDEX("IDX_fechapago_idtipogasto"))
INNER JOIN tipogasto tg ON g.idtipogasto = tg.idtipogasto
WHERE g.periodo = 2;

select * from consorcio
--apagar estadisticas
SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;


--comando para verificar los indices existentes en la tabla 'gasto'	

execute sp_helpindex 'gasto'	

DROP INDEX "<IDX_fechapago_idtipogasto>" ON gasto;
DROP INDEX gasto.indx_demostracion;

 /*==================================== V2 4-03-24 ==============================*/
 --1 ) crearemos 3 bases de datos distintas con distintos indices 
 --2 ) procederemos a documentar el rendimiento y la eficiencia con los indices creados anteriormente


 create database prueba1
 use prueba1
 --cargamos el modelo de datos consorcio e insertamos el lote de datos correspondiente 
 
 --insertamos 1.000.000 de registros en la tabla gastos para que tenga sentido los indices 
	DECLARE @TotalRows INT = 1000000; -- Total de registros a insertar
	DECLARE @Counter INT = 1;
	DECLARE @FechaPago datetime = GETDATE(); -- Fecha de pago constante, se toma la fecha actual
	DECLARE @Periodo INT = 1; -- Periodo fijo para todos los registros

	WHILE @Counter <= @TotalRows
	BEGIN
		INSERT INTO gasto (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
		VALUES (1,
				1,
				1,
				CAST(RAND() * 6 AS INT) + 1, -- CORRECCION PROFE CUZZIOL, GENERARA UN NUMERO ALEATORIO ENTERO ENTRE 1 Y 6 
				GETDATE(),
				1,
				1000) -- Mismo valor para el importe en cada registro
		SET @Counter = @Counter + 1;
	END;


	

--la consulta se ejecuto correctamente en un tiempo de 1 minuto 56segs



/*Ahora creamos un indice no cluster para verificar la diferencia de eficiencia con prueba 1*/

USE [prueba2]
GO
CREATE NONCLUSTERED INDEX [IDX_NOCLUSTER_PRUEBA1]
ON [dbo].[gasto] ([periodo])
INCLUDE ([fechapago],[idtipogasto])

sp_helpindex 'gasto' --verificamos que el indice se creo correctamente

/*Realizar una búsqueda por periodo, 
seleccionando los campos: fecha de pago y tipo de gasto (con la descripción correspondiente)*/

SELECT g.fechapago, tg.descripcion FROM gasto g 
inner join tipogasto tg on tg.idtipogasto = g.idtipogasto
where g.periodo = 2





/*======== PRUEBA 2 ===========*/
CREATE DATABASE prueba2
use prueba2 

 --insertamos 1.000.000 de registros en la tabla gastos para que tenga sentido los indices para la prueba 2 
DECLARE @TotalRows INT = 1000000; -- Total de registros a insertar
DECLARE @Counter INT = 1;
DECLARE @FechaPago datetime = GETDATE(); -- Fecha de pago constante, se toma la fecha actual
DECLARE @Periodo INT = 1; -- Periodo fijo para todos los registros

WHILE @Counter <= @TotalRows
BEGIN
    INSERT INTO gasto (idprovincia, idlocalidad, idconsorcio, periodo, fechapago, idtipogasto, importe)
    VALUES (1,
            1,
            1,
            2,
            getdate(),
            1,
            1000); -- Mismo valor para el importe en cada registro
    
    SET @Counter = @Counter + 1;
END;
