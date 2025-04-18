---SE DECLARAN LAS 8 DISTINTAS TABLAS VARIABLES QUE ALMACENARÁN LOS DISTINTOS TIPOS DE NODOS
DECLARE @tempPuestos table ( Puestos XML );
DECLARE @tempTiposEvento table ( TiposEvento XML );
DECLARE @tempTiposMovimiento table ( TiposMovimiento XML );
DECLARE @tempEmpleados table ( Empleados XML );
DECLARE @tempUsuarios table ( Usuarios XML );
DECLARE @tempFeriados table( Feriados XML );
DECLARE @tempMovimientos table( Movimientos XML );
DECLARE @tempError table( Error XML );

---INICIAR A CARGAR TODOS LOS NODOS DEL XML CON SUS RESPECTIVAS TABLAS

----CARGAR NODOS DE PUESTO DESDE EL XML E INSERTARLOS EN CADA FILA DE LA TABLA
INSERT INTO @tempPuestos ( Puestos )
SELECT 
	puestos.query( '.' ) AS PuestoXML

FROM (SELECT CAST(XMLFile as xml )
	FROM OPENROWSET(
		BULK 'C:\Users\ximen\OneDrive\Escritorio\datosprueba.xml', SINGLE_BLOB )
		AS T( XMLFile ))
		AS T( XMLFile )
		CROSS APPLY XMLFile.nodes( 'Datos/Puestos/Puesto' ) AS X( puestos );


----CARGAR NODOS DE TiposEvento DESDE EL XML E INSERTARLOS EN CADA FILA DE LA TABLA
INSERT INTO @tempTiposEvento ( tiposevento )  
SELECT 
	TiposEvento.query( '.' ) AS TiposEventoXML

FROM ( SELECT CAST( XMLFile as xml )
	FROM OPENROWSET(
		BULK 'C:\Users\ximen\OneDrive\Escritorio\datosprueba.xml', SINGLE_BLOB )
		AS T( XMLFile ))
		AS T( XMLFile )
		CROSS APPLY XMLFile.nodes( 'Datos/TiposEvento/TipoEvento' ) AS P( TiposEvento )


----CARGAR NODOS DE TiposMovimiento DESDE EL XML E INSERTARLOS EN CADA FILA DE LA TABLA
INSERT INTO @tempTiposMovimiento ( tiposMovimiento )
SELECT 
	TipoMovimiento.query( '.' ) AS TipoMovimientoXML

FROM ( SELECT CAST(XMLFile as xml )
	FROM OPENROWSET(
		BULK 'C:\Users\ximen\OneDrive\Escritorio\datosprueba.xml', SINGLE_BLOB )
		AS T( XMLFile ))
		AS T( XMLFile )
		CROSS APPLY XMLFile.nodes( 'Datos/TiposMovimientos/TipoMovimiento' ) AS E( TipoMovimiento )


----CARGAR NODOS DE Empleados DESDE EL XML E INSERTARLOS EN CADA FILA DE LA TABLA
INSERT INTO @tempEmpleados ( Empleados )
SELECT 
	Empleado.query( '.' ) AS EmpleadosXML

FROM ( SELECT CAST( XMLFile as xml )
	FROM OPENROWSET(
		BULK 'C:\Users\ximen\OneDrive\Escritorio\datosprueba.xml', SINGLE_BLOB)
		AS T( XMLFile ))
		AS T( XMLFile )
		CROSS APPLY XMLFile.nodes( 'Datos/Empleados/empleado' ) AS N( Empleado )


----CARGAR NODOS DE Usuarios DESDE EL XML E INSERTARLOS EN CADA FILA DE LA TABLA
INSERT INTO @tempUsuarios ( Usuarios )
SELECT 
	Usuarios.query( '.' ) AS UsuariosXML

FROM ( SELECT CAST( XMLFile as xml )
	FROM OPENROWSET(
		BULK 'C:\Users\ximen\OneDrive\Escritorio\datosprueba.xml', SINGLE_BLOB )
		AS T( XMLFile ))
		AS T( XMLFile )
		CROSS APPLY XMLFile.nodes( 'Datos/Usuarios/usuario' ) AS L( Usuarios )

----CARGAR NODOS DE Feriados DESDE EL XML E INSERTARLOS EN CADA FILA DE LA TABLA
INSERT INTO @tempFeriados ( Feriados )
SELECT 
	Feriados.query( '.' ) AS FeriadosXML

FROM ( SELECT CAST(XMLFile as xml )
	FROM OPENROWSET(
		BULK 'C:\Users\ximen\OneDrive\Escritorio\datosprueba.xml', SINGLE_BLOB )
		AS T( XMLFile ))
		AS T( XMLFile )
		CROSS APPLY XMLFile.nodes( 'Datos/Feriados/Feriado' ) AS R( Feriados )


----CARGAR NODOS DE Movimientos DESDE EL XML E INSERTARLOS EN CADA FILA DE LA TABLA
INSERT INTO @tempMovimientos ( Movimientos )
SELECT 
	Movimiento.query( '.' ) AS MovimientosXML

FROM ( SELECT CAST( XMLFile as xml )
	FROM OPENROWSET(
		BULK 'C:\Users\ximen\OneDrive\Escritorio\datosprueba.xml', SINGLE_BLOB )
		AS T( XMLFile ))
		AS T( XMLFile )
		CROSS APPLY XMLFile.nodes( 'Datos/Movimientos/movimiento' ) AS X( Movimiento )

----CARGAR NODOS DE Error DESDE EL XML E INSERTARLOS EN CADA FILA DE LA TABLA
INSERT INTO @tempError ( Error )
SELECT 
	Error.query( '.' ) AS MovimientosXML

FROM ( SELECT CAST( XMLFile as xml )
	FROM OPENROWSET(
		BULK 'C:\Users\ximen\OneDrive\Escritorio\datosprueba.xml', SINGLE_BLOB )
		AS T( XMLFile ))
		AS T( XMLFile )
		CROSS APPLY XMLFile.nodes( 'Datos/Error/error' ) AS X( Error )

--REVISION DE INSERCIÓN CORRECTA A CADA TABLA VARIABLE
--SELECT * FROM @tempPuestos
--SELECT * FROM  @tempTiposEvento
--SELECT * FROM @tempTiposMovimiento
--SELECT * FROM @tempEmpleados
--SELECT * FROM @tempUsuarios
--SELECT * FROM @tempFeriados
--SELECT * FROM @tempMovimientos
--SELECT * FROM @tempError

--COMIENZA INSERCIÓN DE DATOS DE TABLAS VARIABLES A TABLAS UTILIZADAS EN TAREA

BEGIN TRY

	--INSERTA ID, NOMBRE Y SALARIOXHORA DE CADA PUESTO A TABLA PUESTO
	INSERT INTO dbo.Puesto ( Id, Nombre, SalarioxHora )
	SELECT 
		T.Puestos.value( '(/Puesto/@Id)[1]', 'INT' ) AS Id,
		T.Puestos.value( '(/Puesto/@Nombre)[1]', 'VARCHAR(64)' ) AS Nombre,
		T.Puestos.value( '(/Puesto/@SalarioxHora)[1]', 'VARCHAR(64)' ) AS SalarioxHora
	FROM 
		@tempPuestos AS T


	--INSERTA ID Y NOMBRE DE CADA TIPO DE EVENTO A TABLA TIPOEVENTO
	INSERT INTO dbo.TipoEvento ( Id, Nombre )
	SELECT 
		T.TiposEvento.value( '(/TipoEvento/@Id)[1]', 'INT' ) AS Id,
		T.TiposEvento.value( '(/TipoEvento/@Nombre)[1]', 'VARCHAR(64)' ) AS Nombre
	FROM 
		@tempTiposEvento AS T


	--INSERTA ID, NOMBRE Y TIPOACCION DE CADA MOVIMIENTO A TABLA TIPOMOVIMIENTO
	INSERT INTO dbo.TipoMovimiento ( Id, Nombre, TipoAccion )
	SELECT 
		T.TiposMovimiento.value( '(/TipoMovimiento/@Id)[1]', 'INT' ) AS Id,
		T.TiposMovimiento.value( '(/TipoMovimiento/@Nombre)[1]', 'VARCHAR(64)' ) AS Nombre,
		T.TiposMovimiento.value( '(/TipoMovimiento/@TipoAccion)[1]', 'VARCHAR(64)' ) AS TipoAccion
	FROM 
		@tempTiposMovimiento AS T


	--INSERTA IdPuesto, ValorDocumentoIdentidad,Nombre, FechaContratacion, SaldoVacaciones, EsActivo DE 
	--CADA EMPLEADO A TABLA EMPLEADO
	INSERT INTO dbo.Empleado ( IdPuesto, ValorDocumentoIdentidad,Nombre, FechaContratacion, SaldoVacaciones, EsActivo )
	SELECT 
		P.Id AS IdPuesto,
		T.Empleados.value( '(/empleado/@ValorDocumentoIdentidad)[1]', 'VARCHAR(64)' ) AS ValorDocumentoIdentidad,
		T.Empleados.value( '(/empleado/@Nombre)[1]', 'VARCHAR(64)' ) AS Nombre,
		T.Empleados.value( '(/empleado/@FechaContratacion)[1]', 'date' ) AS FechaContratacion,
		T.Empleados.value( '(/empleado/@SaldoVacaciones)[1]', 'VARCHAR(64)' ) AS SaldoVacaciones,
		T.Empleados.value( '(/empleado/@EsActivo)[1]', 'VARCHAR(64)' ) AS EsActivo
	FROM 
		@tempEmpleados T
		INNER JOIN dbo.Puesto P
			ON P.Id = T.Empleados.value( '(/empleado/@IdPuesto)[1]', 'INT' )

	--INSERTA ID , USERNAME Y PASSWORD DE CADA USUARIO A TABLA USUARIO
	INSERT INTO dbo.Usuario ( Id, Username, Password )
	SELECT 
		T.Usuarios.value( '(/usuario/@Id)[1]', 'INT' ) AS Id,
		T.Usuarios.value( '(/usuario/@Nombre)[1]', 'VARCHAR(64)' ) AS Nombre,
		T.Usuarios.value( '(/usuario/@Pass)[1]', 'VARCHAR(64)' ) AS Pass
	FROM 
		@tempUsuarios AS T


	--INSERTA FECHA Y DESCRIPCION DE CADA FERIADO A TABLA FERIADO
	INSERT INTO dbo.Feriado ( Fecha, Descripcion )
	SELECT 
		T.Feriados.value( '(/Feriado/@Fecha)[1]', 'VARCHAR(64)' ) AS Fecha,
		T.Feriados.value( '(/Feriado/@Descripcion)[1]', 'VARCHAR(1024)' ) AS Descripcion
	FROM 
		@tempFeriados AS T


	--INSERTA IdPuesto, ValorDocumentoIdentidad,Nombre, FechaContratacion, SaldoVacaciones, EsActivo 
	--DE CADA EMPLEADO A TABLA EMPLEADO
	INSERT INTO dbo.Movimiento (IdEmpleado, IdTipoMovimiento, Fecha, Monto, NuevoSaldo, IdPostByUser, PostInIP, PostTime)
	SELECT 
		E.Id AS IdEmpleado,
		T.Id AS IdTipoMovimiento,
		P.Movimientos.value('(/movimiento/@Fecha)[1]', 'DATE') AS Fecha,
		P.Movimientos.value('(/movimiento/@Monto)[1]', 'INT') AS Monto,
		CASE 
			WHEN T.TipoAccion = 'Credito' THEN E.SaldoVacaciones + P.Movimientos.value('(/movimiento/@Monto)[1]', 'INT')
			WHEN T.TipoAccion = 'Debito'  THEN E.SaldoVacaciones - P.Movimientos.value('(/movimiento/@Monto)[1]', 'INT')
		END AS NuevoSaldo,
		U.Id AS IdPostByUser,
		P.Movimientos.value('(/movimiento/@PostInIP)[1]', 'VARCHAR(64)') AS PostInIP,
		P.Movimientos.value('(/movimiento/@PostTime)[1]', 'DATETIME') AS PostTime
	FROM 
		@tempMovimientos P
		INNER JOIN dbo.Empleado E 
			ON E.ValorDocumentoIdentidad = P.Movimientos.value('(/movimiento/@ValorDocId)[1]', 'INT')
		INNER JOIN dbo.TipoMovimiento T
			ON T.Id = P.Movimientos.value('(/movimiento/@IdTipoMovimiento)[1]', 'INT')
		INNER JOIN dbo.Usuario U 
			ON U.Username = P.Movimientos.value('(/movimiento/@PostByUser)[1]', 'VARCHAR(64)');


	--INSERTA CODIGO Y DESCRIPCIÓN DE CADA ERROR EN TABLA ERROR
	INSERT INTO dbo.Error ( Codigo, Descripcion )
	SELECT 
		T.Error.value( '(/error/@Codigo)[1]', 'INT' ) AS Codigo,
		T.Error.value( '(/error/@Descripcion)[1]', 'VARCHAR(64)' ) AS Descripcion
	FROM 
		@tempError AS T



END TRY
BEGIN CATCH
    SELECT 
        ERROR_MESSAGE() AS ErrorMessage,
        ERROR_LINE() AS ErrorLine,
        ERROR_NUMBER() AS ErrorNumber;
END CATCH