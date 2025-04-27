GO
/****** Object:  StoredProcedure [dbo].[ModificarEmpleado]    Script Date: 4/27/2025 9:57:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ModificarEmpleado] (
	@inNombre VARCHAR( 64 )
	, @inDocumentoIdentidad VARCHAR ( 64 )
	, @inNuevoDI VARCHAR( 64 )
	, @inNuevoNombre VARCHAR( 64 )
	, @inNuevoPuesto VARCHAR( 64 )
	, @inUsername VARCHAR( 64 )
	, @inIpAdress VARCHAR( 64 )
	, @outResultCode INT OUTPUT
)
AS
BEGIN

	SET NOCOUNT ON;
	BEGIN TRY
		DECLARE @IdTipoEvento INT = 8;		--Update exitoso
		DECLARE @IdPostByUser INT;
		DECLARE @Descripcion VARCHAR( 1024 ) = '';
		DECLARE @DescripcionError VARCHAR( 1024 );
		DECLARE @puestoAnterior VARCHAR( 64 );
		DECLARE @idNuevoPuesto INT;
		DECLARE @saldoVacaciones INT;
		DECLARE @nombreValido BIT = 1;			--True
		DECLARE @nombreRepetido BIT = 0;		--False
		DECLARE @documentoIdentidadValido BIT = 1;		--True
		DECLARE @documentoIdentidadRepetido BIT = 0;	--False

		SET @inNuevoNombre = LTRIM( RTRIM( @inNuevoNombre ) );
		SET @inNuevoDI = LTRIM( RTRIM( @inNuevoDI ) );
		SET @IdPostByUser = ( SELECT 
									U.Id AS Id
							  FROM
									dbo.Usuario AS U
							  WHERE
									U.Username = @inUsername );
		SET @puestoAnterior = ( SELECT 
									P.Nombre AS Puesto
								FROM 
									dbo.Puesto AS P
								INNER JOIN	
									dbo.Empleado AS E
								ON 
									E.IdPuesto = P.Id
								WHERE 
									E.Nombre = @inNombre );
		SET @idNuevoPuesto = ( SELECT
									P.Id AS Id
								FROM 
									dbo.Puesto AS P
								WHERE
									P.Nombre = @inNuevoPuesto );

		SET @saldoVacaciones = ( SELECT	
										E.SaldoVacaciones AS Vacaciones
								FROM 
										dbo.Empleado AS E
								WHERE
										E.Nombre = @inNombre );
		SET @Descripcion = ( ' DI anterior: '
							+ CONVERT( VARCHAR( 64 ) , @inDocumentoIdentidad )
							+ ' Nombre anterior: '
							+ CONVERT( VARCHAR( 64 ) , @inNombre )
							+ ' Puesto anterior: '
							+ CONVERT( VARCHAR( 64 ) , @puestoAnterior )
							+ ' Nuevo ID: '
							+ CONVERT( VARCHAR( 64 ) , @inNuevoDI )
							+ ' Nuevo nombre: '
							+ CONVERT( VARCHAR( 64 ) , @inNuevoNombre )
							+ ' Nuevo puesto: '
							+ CONVERT( VARCHAR( 64 ) , @inNuevoPuesto )
							+ ' Saldo vacaciones: '
							+ CONVERT( VARCHAR( 64 ) , @saldoVacaciones ) );
		
		--VALIDAR SI FORMATO NOMBRE ES VALIDO
		IF PATINDEX( '%[^A-Za-z ]%', @inNuevoNombre ) > 0 OR @inNuevoNombre = ''
		BEGIN 
			SET @outResultCode = 50009;		--Nombre no alfabetico
			SET @DescripcionError = ( SELECT
											E.Descripcion AS DescripcionErr
										From
											dbo.Error AS E
										WHERE
											E.Codigo = @outResultCode );
			SET @Descripcion = ( CONVERT( VARCHAR( 64 ) , @outResultCode )
							+ ': '
							+ CONVERT( VARCHAR( 64 ) , @DescripcionError )
							+ ' '
							+ @Descripcion );
			SET @IdTipoEvento = 7;
			SET @nombreValido = 0;
		END;

		--VALIDAR SI NOMBRE EXISTE
		IF @nombreValido = 1 AND 
			EXISTS ( 
				SELECT 1 
				FROM dbo.Empleado AS E 
				WHERE LOWER( E.Nombre ) LIKE LOWER( @inNuevoNombre ) AND
				E.ValorDocumentoIdentidad != @inDocumentoIdentidad)
		BEGIN 
			SET @outResultCode = 50007		--Nombre ya existe
			SET @DescripcionError = ( SELECT
											E.Descripcion AS DescripcionErr
										From
											dbo.Error AS E
										WHERE
											E.Codigo = @outResultCode );
			SET @Descripcion = ( CONVERT( VARCHAR( 64 ) , @outResultCode )
							+ ': '
							+ CONVERT( VARCHAR( 64 ) , @DescripcionError )
							+ ' '
							+ @Descripcion );
			SET @IdTipoEvento = 7;
			SET @nombreRepetido = 1;
		END;

		--VALIDAR SI FORMATO DOCUMENTO IDENTIDAD ES VALIDO
		IF @nombreValido = 1 AND 
			@nombreRepetido = 0 AND
			PATINDEX( '%[^0-9]%', @inNuevoDI ) > 0 OR @inNuevoDI = ''
		BEGIN
			SET @outResultCode = 50010		--Documento de identidad invalido
			SET @DescripcionError = ( SELECT
											E.Descripcion AS DescripcionErr
										From
											dbo.Error AS E
										WHERE
											E.Codigo = @outResultCode );
			SET @Descripcion = ( CONVERT( VARCHAR( 64 ) , @outResultCode )
							+ ': '
							+ CONVERT( VARCHAR( 64 ) , @DescripcionError )
							+ ' '
							+ @Descripcion );
			SET @IdTipoEvento = 7;
			SET @documentoIdentidadValido = 0;
		END;

		--VALIDAR SI DOCUMENTO IDENTIDAD EXISTE
		IF @nombreValido = 1 AND 
			@nombreRepetido = 0 AND
			@documentoIdentidadValido = 1 AND
			EXISTS ( 
				SELECT 1 
				FROM dbo.Empleado AS E 
				WHERE E.ValorDocumentoIdentidad = @inNuevoDI AND
				LOWER( E.Nombre ) NOT LIKE LOWER( @inNombre ) )
		BEGIN
			SET @outResultCode = 50006		--Documento identidad ya existe
			SET @DescripcionError = ( SELECT
											E.Descripcion AS DescripcionErr
										From
											dbo.Error AS E
										WHERE
											E.Codigo = @outResultCode );
			SET @Descripcion = ( CONVERT( VARCHAR( 64 ) , @outResultCode )
							+ ': '
							+ CONVERT( VARCHAR( 64 ) , @DescripcionError )
							+ ' '
							+ @Descripcion );
			SET @IdTipoEvento = 7;
			SET @documentoIdentidadRepetido = 1;
		END;

		
		--INICIO DE TRASACCION
		BEGIN TRANSACTION ActualizarDatos
			IF @nombreValido = 1 AND 
				@nombreRepetido = 0 AND
				@documentoIdentidadValido = 1 AND
				@documentoIdentidadRepetido = 0
			BEGIN 
				UPDATE 
					E
				SET
					E.Nombre = @inNuevoNombre,
					E.ValorDocumentoIdentidad = CONVERT( INT, @inNuevoDI ),
					E.IdPuesto = @idNuevoPuesto
				FROM 
					dbo.Empleado AS E
				WHERE
					E.Nombre = @inNombre

				SET @outResultCode = 0;
			
			END;
		
			---Inserta Evento en BitacoraEvento
			INSERT INTO dbo.BitacoraEvento (
				IdTipoEvento
				, Descripcion
				, IdPostByUser
				, PostInIp
				, PostTime )
			VALUES( 
				@IdTipoEvento
				, @Descripcion 
				, @IdPostByUser 
				, @inIpAdress
				, GETDATE() )

		COMMIT TRANSACTION  ActualizarDatos
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION ActualizarDatos;
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
    SET NOCOUNT OFF;
END
