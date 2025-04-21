USE [Database]
GO

/****** Object:  StoredProcedure [dbo].[InsertarMovimiento]    Script Date: 21/4/2025 11:59:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[InsertarMovimiento](
	@inNombre VARCHAR( 64 )
	,@inNombreMovimiento VARCHAR( 64 )
	,@inMonto INT
	,@inUsername VARCHAR( 64 )
	,@inIpAdress VARCHAR ( 64 )
	,@outResultCode INT OUTPUT 
)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		
		DECLARE @saldoFinalEmpleado INT = 0; ---Saldo resultante luego de aplicar movimiento
		DECLARE @saldoActualEmpleado INT; ---Saldo que ya tenía el empleado antes de movimiento
		DECLARE @tipoAccion VARCHAR(64); ---Debito o Credito
		DECLARE @descripcion VARCHAR(1024); ---Descripcion para tabla Evento
		DECLARE @descripcionError VARCHAR(1024); ---Descripcion de codigo de error
		DECLARE @valorDocId INT; ---Valor Documento de Identidad del Empleado
		DECLARE @fecha DATE; -- Fecha actual con formato YYYY-MM-DD
		DECLARE @idTipoEvento INT; ---Tipo Evento ocurriendo

		SET @outResultCode = 0; --Código éxito
		SET @idTipoEvento = 14; ---Tipo Evento Insertar Movimiento Exitoso
		
		---Obtener valor DocId del Empleado
		SELECT 
			@valorDocId = E.ValorDocumentoIdentidad,
			@saldoActualEmpleado = E.EsActivo
		FROM 
			dbo.Empleado AS E
		WHERE 
			E.Nombre = @inNombre;

		---Obtener Saldo de empleado con base a su nombre
		SELECT
			@saldoActualEmpleado = E.SaldoVacaciones
		FROM
			dbo.Empleado AS E
		WHERE
			@inNombre = E.Nombre 

		---Obtener el tipo de accion del movimiento
		SELECT 
			@tipoAccion = TM.TipoAccion
		FROM 
			dbo.TipoMovimiento AS TM 
		WHERE 
			@inNombreMovimiento = TM.Nombre

		IF @tipoAccion = 'DEBITO'
		BEGIN

			SET @saldoFinalEmpleado = @saldoActualEmpleado - @inMonto; --- Debito -> resta al saldo

		END;
		ELSE
		BEGIN

			SET @saldoFinalEmpleado = @saldoActualEmpleado + @inMonto;--- Credito -> suma al saldo

		END;

		IF @saldoFinalEmpleado < 0 ---Revisar si saldo de empleado dará negativo
		BEGIN
				
			SET @outResultCode = 50011; --Error : Monto del movimiento rechazado por saldo negativo
			SET @idTipoEvento = 13; ---Tipo Evento Intento Insertar Movimiento Exitoso

			SELECT
				@descripcionError = E.Descripcion
			FROM
				dbo.Error AS E
			WHERE
				@outResultCode = E.Codigo ---Obtener descripcion de error ocurrido
				
			--Setear descripcion para tabla evento
			SET @descripcion =  ( 'Descripcion error: '
								+ CONVERT( VARCHAR(1024) , @descripcionError )
								+ ' Valor Documento de Identidad: '
								+ CONVERT ( VARCHAR(20) , @valorDocId)
								+ ' Nombre: '
								+ CONVERT ( VARCHAR(64) , @inNombre)
								+ ' Saldo Actual: '
								+ CONVERT ( VARCHAR(20) , @saldoActualEmpleado)
								+ ' Nombre de Tipo de Movimiento: '
								+ CONVERT ( VARCHAR(64) , @inNombreMovimiento)
								+ ' Monto: '
								+ CONVERT ( VARCHAR(20) , @inMonto)
								)
				
			--Actualizar bitacoraEvento
			INSERT INTO dbo.BitacoraEvento (
				IdTipoEvento
				,Descripcion
				,IdPostByUser
				,PostInIp
				,PostTime )
			SELECT
				@idTipoEvento
				, @descripcion
				, U.Id 
				, @inIpAdress 
				, GETDATE()
			FROM 
				dbo.Usuario AS U
			WHERE
				U.Username = @inUsername

			END;
		ELSE
		---Caso en que si se pueda aplicar el movimiento sin problemas
		BEGIN

			--Setear descripcion para tabla evento
			SET @descripcion =  (' Valor Documento de Identidad: '
								+ CONVERT ( VARCHAR(20) , @valorDocId)
								+ ' Nombre: '
								+ CONVERT ( VARCHAR(64) , @inNombre)
								+ ' Nuevo Saldo: '
								+ CONVERT ( VARCHAR(20) , @saldoFinalEmpleado)
								+ ' Nombre de Tipo de Movimiento: '
								+ CONVERT ( VARCHAR(64) , @inNombreMovimiento)
								+ ' Monto: '
								+ CONVERT ( VARCHAR(20) , @inMonto)
								)
			
			---Setear fecha actual
			SET @fecha = ( SELECT CONVERT (date, SYSDATETIME()) )

			BEGIN TRANSACTION tInsertarMovimiento

				--Actualizar bitacoraEvento
				INSERT INTO dbo.BitacoraEvento (
					IdTipoEvento
					,Descripcion
					,IdPostByUser
					,PostInIp
					,PostTime )
				SELECT
					@idTipoEvento
					, @descripcion
					, U.Id 
					, @inIpAdress 
					, GETDATE()
				FROM 
					dbo.Usuario AS U
				WHERE
					U.Username = @inUsername

				---Insertar movimiento a tabla de movimientos
				INSERT INTO dbo.Movimiento (
					IdEmpleado
					,IdTipoMovimiento
					, Fecha
					, Monto
					, NuevoSaldo
					, IdPostByUser
					,PostInIp
					, PostTime )
				SELECT
					E.Id
					, TM.Id
					, @fecha
					, @inMonto
					, @saldoFinalEmpleado
					, U.Id
					, @inIpAdress
					, GETDATE()
				FROM
					dbo.Empleado AS E
					,dbo.TipoMovimiento AS TM
					, dbo.Usuario AS U
				WHERE
					@inNombre = E.Nombre
					AND @inNombreMovimiento = TM.Nombre
					AND @inUsername = U.Username

				---Actualizar información de saldo del empleado
				UPDATE dbo.Empleado
				SET 
					SaldoVacaciones = @saldoFinalEmpleado
				WHERE 
					Nombre = @inNombre

			COMMIT TRANSACTION tInsertarMovimiento

		END;

	END TRY
	BEGIN CATCH

		IF @@TRANCOUNT>0
		BEGIN
			ROLLBACK TRANSACTION tInsertarMovimiento;
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

		Set @outResultCode = 50008; --Error en base de datos

	END CATCH

	SET NOCOUNT OFF;
END;
GO


