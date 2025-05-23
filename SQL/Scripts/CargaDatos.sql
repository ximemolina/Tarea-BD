USE [Database]
GO
/****** Object:  StoredProcedure [dbo].[CargaDatos]    Script Date: 20/4/2025 15:18:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CargaDatos] (
				@inXmlData NVARCHAR( MAX ) 
				,@outResultCode VARCHAR(1024) OUTPUT )
AS
BEGIN 
	BEGIN TRY
		
		SET @outResultCode = 0; --Codigo éxito

		--SE CONVIERTE EL XML DE TIPO NVARCHAR A TIPO XML
		DECLARE @xml XML
		SET @xml = CAST( @inXmlData AS XML )

		---SE DECLARAN LAS 8 DISTINTAS TABLAS VARIABLES QUE ALMACENARÁN LOS DISTINTOS TIPOS DE NODOS
		DECLARE @tempPuestos table ( Sec INT IDENTITY(1,1)
									,Puestos XML );
		DECLARE @tempTiposEvento table ( Sec INT IDENTITY(1,1)
										,TiposEvento XML );
		DECLARE @tempTiposMovimiento table ( Sec INT IDENTITY(1,1)
											,TiposMovimiento XML );
		DECLARE @tempEmpleados table ( Sec INT IDENTITY(1,1)
										,Empleados XML );
		DECLARE @tempUsuarios table ( Sec INT IDENTITY(1,1)
										,Usuarios XML );
		DECLARE @tempFeriados table( Sec INT IDENTITY(1,1)
									,Feriados XML );
		DECLARE @tempMovimientos table( Sec INT IDENTITY(1,1)
										,Movimientos XML );
		DECLARE @tempError table( Sec INT IDENTITY(1,1)
									,Error XML );

		---DECLARAR VARIABLES A UTILIZAR
		---Variables para iterar
		DECLARE @hi INT				---Iteracion Tabla Feriados
		DECLARE @hi2 INT			---Iteracion Tabla Errores
		DECLARE @hi3 INT			---Iteracion Tabla TipoEvento
		DECLARE @hi4 INT			---Iteracion Tabla Puestos
		DECLARE @hi5 INT			---Iteracion Tabla Usuarios
		DECLARE @hi6 INT			---Iteracion Tabla TipoMovimiento
		DECLARE @hi7 INT			---Iteracion Tabla Empleados
		DECLARE @hi8 INT			---Iteracion Tabla Movimientos
		--Variables para limitar iteracion
		DECLARE @lo INT = 1
		DECLARE @lo2 INT = 1
		DECLARE @lo3 INT = 1
		DECLARE @lo4 INT = 1
		DECLARE @lo5 INT = 1
		DECLARE @lo6 INT = 1
		DECLARE @lo7 INT = 1
		DECLARE @lo8 INT = 1
		--Otras variables
		DECLARE @IdEmpleado INT
		DECLARE @montoMovimiento INT
		DECLARE @tipoAccion VARCHAR(64)
		DECLARE @saldoVacaciones INT
		DECLARE @valorDocId INT

		---INICIAR A CARGAR TODOS LOS NODOS DEL XML CON SUS RESPECTIVAS TABLAS

		----CARGAR NODOS DE PUESTO DESDE EL XML E INSERTARLOS EN CADA FILA DE LA TABLA
		INSERT INTO @tempPuestos ( Puestos )
		SELECT 
			puestos.query( '.' ) AS PuestoXML

		FROM 
			@xml.nodes( 'Datos/Puestos/Puesto' ) AS X( puestos );

		----CARGAR NODOS DE TiposEvento DESDE EL XML E INSERTARLOS EN CADA FILA DE LA TABLA
		INSERT INTO @tempTiposEvento ( tiposevento )  
		SELECT 
			TiposEvento.query( '.' ) AS TiposEventoXML

		FROM 
			@xml.nodes( 'Datos/TiposEvento/TipoEvento' ) AS P( TiposEvento )

		----CARGAR NODOS DE TiposMovimiento DESDE EL XML E INSERTARLOS EN CADA FILA DE LA TABLA
		INSERT INTO @tempTiposMovimiento ( tiposMovimiento )
		SELECT 
			TipoMovimiento.query( '.' ) AS TipoMovimientoXML

		FROM 
			@xml.nodes( 'Datos/TiposMovimientos/TipoMovimiento' ) AS E( TipoMovimiento )

		----CARGAR NODOS DE Empleados DESDE EL XML E INSERTARLOS EN CADA FILA DE LA TABLA
		INSERT INTO @tempEmpleados ( Empleados )
		SELECT 
			Empleado.query( '.' ) AS EmpleadosXML

		FROM 
			@xml.nodes( 'Datos/Empleados/empleado' ) AS N( Empleado )

		----CARGAR NODOS DE Usuarios DESDE EL XML E INSERTARLOS EN CADA FILA DE LA TABLA
		INSERT INTO @tempUsuarios ( Usuarios )
		SELECT 
			Usuarios.query( '.' ) AS UsuariosXML

		FROM 
			@xml.nodes( 'Datos/Usuarios/usuario' ) AS L( Usuarios )

		----CARGAR NODOS DE Feriados DESDE EL XML E INSERTARLOS EN CADA FILA DE LA TABLA
		INSERT INTO @tempFeriados ( Feriados )
		SELECT 
			Feriados.query( '.' ) AS FeriadosXML

		FROM 
			@xml.nodes( 'Datos/Feriados/Feriado' ) AS R( Feriados )
		
		----CARGAR NODOS DE Movimientos DESDE EL XML E INSERTARLOS EN CADA FILA DE LA TABLA
		INSERT INTO @tempMovimientos ( Movimientos )
		SELECT 
			Movimiento.query( '.' ) AS MovimientosXML

		FROM 
			@xml.nodes( 'Datos/Movimientos/movimiento' ) AS X( Movimiento )

		----CARGAR NODOS DE Error DESDE EL XML E INSERTARLOS EN CADA FILA DE LA TABLA
		INSERT INTO @tempError ( Error )
		SELECT 
			Error.query( '.' ) AS MovimientosXML

		FROM 
			@xml.nodes( 'Datos/Error/error' ) AS X( Error )

		--Asignar variables limitantes para iteracion

		SELECT 
			@hi= max(F.Sec) ---Obtener cant. filas a iterar
		FROM 
			@tempFeriados AS F;

		SELECT 
			@hi2= max(E.Sec) ---Obtener cant. filas a iterar
		FROM 
			@tempError AS E;

		SELECT 
			@hi3= max(TE.Sec) ---Obtener cant. filas a iterar
		FROM 
			@tempTiposEvento AS TE;

		SELECT 
			@hi4= max(P.Sec) ---Obtener cant. filas a iterar
		FROM 
			@tempPuestos AS P;

		SELECT 
			@hi5= max(U.Sec) ---Obtener cant. filas a iterar
		FROM 
			@tempUsuarios AS U;

		SELECT 
			@hi6= max(TM.Sec) ---Obtener cant. filas a iterar
		FROM 
			@tempTiposMovimiento AS TM;

		SELECT 
			@hi7= max(E.Sec) ---Obtener cant. filas a iterar
		FROM 
			@tempEmpleados AS E;

		SELECT 
			@hi8= max(M.Sec) ---Obtener cant. filas a iterar
		FROM 
			@tempMovimientos AS M;

		--COMIENZA INSERCIÓN DE DATOS DE TABLAS VARIABLES A TABLAS UTILIZADAS EN TAREA DE MANERA ITERATIVA

		BEGIN TRANSACTION InsertarDatos

			--INSERTA FECHA Y DESCRIPCION DE CADA FERIADO A TABLA FERIADO
			WHILE ( @lo<=@hi )
			BEGIN
				INSERT INTO dbo.Feriado ( Fecha
					, Descripcion )
				SELECT 
					T.Feriados.value( '(/Feriado/@Fecha)[1]', 'VARCHAR(64)' ) AS Fecha,
					T.Feriados.value( '(/Feriado/@Descripcion)[1]', 'VARCHAR(1024)' ) AS Descripcion
				FROM 
					@tempFeriados AS T
				WHERE
					T.Sec = @lo

				SET @lo = @lo + 1
			END;

			--INSERTA CODIGO Y DESCRIPCIÓN DE CADA ERROR EN TABLA ERROR
			WHILE ( @lo2 <= @hi2 )
			BEGIN
				INSERT INTO dbo.Error ( Codigo
					, Descripcion )
				SELECT 
					T.Error.value( '(/error/@Codigo)[1]', 'INT' ),
					T.Error.value( '(/error/@Descripcion)[1]', 'VARCHAR(1024)' )
				FROM 
					@tempError AS T
				WHERE
					T.Sec = @lo2

				SET @lo2 = @lo2 + 1
			END;

			--INSERTA ID Y NOMBRE DE CADA TIPO DE EVENTO A TABLA TIPOEVENTO
			WHILE ( @lo3<=@hi3 )
			BEGIN
				INSERT INTO dbo.TipoEvento ( Id
					, Nombre )
				SELECT 
					T.TiposEvento.value( '(/TipoEvento/@Id)[1]', 'INT' ),
					T.TiposEvento.value( '(/TipoEvento/@Nombre)[1]', 'VARCHAR(64)' )
				FROM 
					@tempTiposEvento AS T
				WHERE
					T.Sec = @lo3

				SET @lo3 = @lo3 +1
			END;

			--INSERTA ID, NOMBRE Y SALARIOXHORA DE CADA PUESTO A TABLA PUESTO
			WHILE ( @lo4 <= @hi4 )
			BEGIN

				INSERT INTO dbo.Puesto ( Id
					, Nombre
					, SalarioxHora )
				SELECT 
					T.Puestos.value( '(/Puesto/@Id)[1]', 'INT' ),
					T.Puestos.value( '(/Puesto/@Nombre)[1]', 'VARCHAR(64)' ),
					T.Puestos.value( '(/Puesto/@SalarioxHora)[1]', 'VARCHAR(64)' )
				FROM 
					@tempPuestos AS T
				WHERE
					T.Sec = @lo4

				SET @lo4 = @lo4 + 1
			END;

			--INSERTA ID , USERNAME Y PASSWORD DE CADA USUARIO A TABLA USUARIO
			WHILE ( @lo5 <= @hi5 )
			BEGIN
				INSERT INTO dbo.Usuario ( Id
					, Username
					, Password )
				SELECT 
					T.Usuarios.value( '(/usuario/@Id)[1]', 'INT' ),
					T.Usuarios.value( '(/usuario/@Nombre)[1]', 'VARCHAR(64)' ),
					T.Usuarios.value( '(/usuario/@Pass)[1]', 'VARCHAR(64)' )
				FROM 
					@tempUsuarios AS T
				WHERE
					T.Sec = @lo5

				SET @lo5 = @lo5 + 1
			END;

			--INSERTA ID, NOMBRE Y TIPOACCION DE CADA MOVIMIENTO A TABLA TIPOMOVIMIENTO
			WHILE ( @lo6 <= @hi6 )
			BEGIN
				INSERT INTO dbo.TipoMovimiento ( Id
					, Nombre
					, TipoAccion )
				SELECT 
					T.TiposMovimiento.value( '(/TipoMovimiento/@Id)[1]', 'INT' ),
					T.TiposMovimiento.value( '(/TipoMovimiento/@Nombre)[1]', 'VARCHAR(64)' ),
					T.TiposMovimiento.value( '(/TipoMovimiento/@TipoAccion)[1]', 'VARCHAR(64)' )
				FROM 
					@tempTiposMovimiento AS T
				WHERE
					T.Sec = @lo6

				SET @lo6 = @lo6 +1 
			END;


			--INSERTA IdPuesto, ValorDocumentoIdentidad,Nombre, FechaContratacion, SaldoVacaciones, EsActivo DE 
			--CADA EMPLEADO A TABLA EMPLEADO
			WHILE ( @lo7 <= @hi7 )
			BEGIN
				INSERT INTO dbo.Empleado ( IdPuesto
					, ValorDocumentoIdentidad
					,Nombre
					, FechaContratacion
					, SaldoVacaciones
					, EsActivo )
				SELECT 
					P.Id AS IdPuesto,
					T.Empleados.value( '(/empleado/@ValorDocumentoIdentidad)[1]', 'VARCHAR(64)' ),
					T.Empleados.value( '(/empleado/@Nombre)[1]', 'VARCHAR(64)' ),
					T.Empleados.value( '(/empleado/@FechaContratacion)[1]', 'date' ) ,
					T.Empleados.value( '(/empleado/@SaldoVacaciones)[1]', 'VARCHAR(64)' ) ,
					T.Empleados.value( '(/empleado/@EsActivo)[1]', 'VARCHAR(64)' )
				FROM 
					@tempEmpleados T
					INNER JOIN dbo.Puesto P
						ON P.Id = T.Empleados.value( '(/empleado/@IdPuesto)[1]', 'INT' )
				WHERE
					T.Sec = @lo7

				SET @idEmpleado = SCOPE_IDENTITY() --Obtener ID de Empleado actual

				---Obtener valorDocId del empleado actual
				SELECT
					@valorDocId = E.ValorDocumentoIdentidad
				FROM
					DBO.Empleado E
				WHERE
					E.Id = @idEmpleado
					
				SET @lo8 = 1--Reiniciar iteracion

				--INSERTA IdPuesto, ValorDocumentoIdentidad,Nombre, FechaContratacion, SaldoVacaciones, EsActivo 
				--DEL EMPLEADO ACTUAL EN EL CICLO
				WHILE ( @lo8 <= @hi8 )
				BEGIN
				
					-- Obtener datos del movimiento actual
					SELECT 
						@montoMovimiento = P.Movimientos.value( '(/movimiento/@Monto)[1]', 'INT' ),
						@tipoAccion = T.TipoAccion
						
					FROM 
						@tempMovimientos P
						INNER JOIN dbo.TipoMovimiento T
							ON T.Id = P.Movimientos.value( '(/movimiento/@IdTipoMovimiento)[1]', 'INT' )
					WHERE 
						P.Sec = @lo8;

					---Revisar que el movimiento actual pertenezca al empleado del ciclo actual
					IF EXISTS (
							SELECT 1
							FROM
								@tempMovimientos M
							WHERE 
								@valorDocId =  M.Movimientos.value( '(/movimiento/@ValorDocId)[1]', 'INT' )
							AND M.Sec = @lo8
						)
					BEGIN
						---Actualizar Saldo del empleado de acuerdo al movimiento
						IF @tipoAccion = 'Credito'
						BEGIN
							UPDATE E
							SET
								E.SaldoVacaciones = E.SaldoVacaciones + @montoMovimiento
							FROM 
								DBO.Empleado AS E
							WHERE
								E.Id = @idEmpleado
						END;
						ELSE
						BEGIN
							UPDATE E
							SET
								E.SaldoVacaciones = E.SaldoVacaciones - @montoMovimiento
							FROM 
								DBO.Empleado AS E
							WHERE
								E.id = @idEmpleado
						END;	
					
						--- Obtener el saldo actualizado
						SELECT 
							@saldoVacaciones = E.SaldoVacaciones
						FROM 
							dbo.Empleado AS E
						WHERE 
							E.Id = @idEmpleado;

						--Insertar Movimiento
						INSERT INTO dbo.Movimiento (
							  IdEmpleado
							, IdTipoMovimiento
							, Fecha
							, Monto
							, NuevoSaldo
							, IdPostByUser
							, PostInIP
							, PostTime )
						SELECT 
							@idEmpleado,
							T.Id,
							P.Movimientos.value( '(/movimiento/@Fecha)[1]', 'DATE' ),
							@montoMovimiento,
							@saldoVacaciones,
							U.Id,
							P.Movimientos.value( '(/movimiento/@PostInIP)[1]', 'VARCHAR(64)' ),
							P.Movimientos.value( '(/movimiento/@PostTime)[1]', 'DATETIME' )
						FROM 
							@tempMovimientos P
							INNER JOIN dbo.TipoMovimiento T
								ON T.Id = P.Movimientos.value( '(/movimiento/@IdTipoMovimiento)[1]', 'INT' )
							INNER JOIN dbo.Usuario U 
								ON U.Username = P.Movimientos.value( '(/movimiento/@PostByUser)[1]', 'VARCHAR(64)' )
						WHERE
							P.Sec = @lo8;
					END;

					SET @lo8 = @lo8 + 1;

				END;

				SET @lo7 = @lo7 +1

			END;

		COMMIT TRANSACTION InsertarDatos


	END TRY
	BEGIN CATCH

		IF @@TRANCOUNT>0
		BEGIN
			ROLLBACK TRANSACTION InsertarDatos;
		END;

		INSERT INTO dbo.DBError VALUES
		(
			SUSER_NAME(),
			ERROR_NUMBER(),
			ERROR_STATE(),
			ERROR_SEVERITY(),
			ERROR_LINE(),
			ERROR_PROCEDURE(),
			ERROR_MESSAGE(),
			GETDATE()
		);
		
		SET @outResultCode = 50008;

	END CATCH

END;
