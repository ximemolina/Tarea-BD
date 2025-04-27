SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[InsertarEmpleado] (
    @inValorDocumentoIdentidad VARCHAR( 64 )
	, @inNombre VARCHAR( 64 )
	, @inNombrePuesto VARCHAR( 64 )
	, @inFechaContratacion VARCHAR( 64 )
	, @inSaldoVacaciones INT
	, @inUsername VARCHAR( 64 )
	, @inIpAdress VARCHAR( 64 )
	, @outResultCode INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRY
		DECLARE @idPuesto INT;
		DECLARE @IdTipoEvento INT = 6; ---Insercion exitosa
		DECLARE @IdPostByUser INT; ---Id Usuario que está realizando el evento
		DECLARE @Descripcion VARCHAR( 1024 ); ---Descripción de Evento Ocurrido
		DECLARE @DescripcionError VARCHAR( 1024 );
		DECLARE @nombreValido BIT = 1;			--True
		DECLARE @nombreRepetido BIT = 0;		--False
		DECLARE @documentoIdentidadValido BIT = 1;		--True
		DECLARE @documentoIdentidadRepetido BIT = 0;	--False

		SET @idPuesto = ( SELECT
								P.Id as Id
							FROM
								dbo.Puesto AS P
							WHERE
								LOWER( P.Nombre ) = LOWER( @inNombrePuesto ) );
		SET @IdPostByUser = ( SELECT 
									E.Id AS Id
								FROM
									dbo.Usuario AS E
								WHERE 
									E.Username = @inUsername );
		SET @Descripcion = ( 'Documento identidad: '
							+ CONVERT( VARCHAR(64) , @inValorDocumentoIdentidad )
							+ ' Nombre: '
							+ CONVERT( VARCHAR(64) , @inNombre )
							+ ' Puesto: '
							+ CONVERT( VARCHAR(64) , @inNombrePuesto ) 
							+ ' Fecha ingreso: '
							+ CONVERT( VARCHAR(64) , @inFechaContratacion ));
		
		--VALIDAR SI FORMATO NOMBRE ES VALIDO
		IF PATINDEX( '%[^A-Za-z ]%', @inNombre ) > 0 OR @inNombre = ''
		BEGIN 
			SET @outResultCode = 50009;		--Nombre no alfabetico
			SET @nombreValido = 0;
		END;

		--VALIDAR SI NOMBRE EXISTE
		IF @nombreValido = 1 AND 
			EXISTS ( 
				SELECT 1 
				FROM dbo.Empleado AS E 
				WHERE LOWER( E.Nombre ) LIKE LOWER( @inNombre ) )
		BEGIN 
			SET @outResultCode = 50005		--Nombre ya existe
			SET @nombreRepetido = 1;
		END;

		--VALIDAR SI FORMATO DOCUMENTO IDENTIDAD ES VALIDO
		IF @nombreValido = 1 AND 
			@nombreRepetido = 0 AND
			PATINDEX( '%[^0-9]%', @inValorDocumentoIdentidad ) > 0 OR 
					@inValorDocumentoIdentidad = '' 
		BEGIN
			SET @outResultCode = 50010		--Documento de identidad invalido
			SET @documentoIdentidadValido = 0;
		END;

		--VALIDAR SI DOCUMENTO IDENTIDAD EXISTE
		IF @nombreValido = 1 AND 
			@nombreRepetido = 0 AND
			@documentoIdentidadValido = 1 AND
			EXISTS ( 
				SELECT 1 
				FROM dbo.Empleado AS E 
				WHERE E.ValorDocumentoIdentidad = @inValorDocumentoIdentidad )
		BEGIN
			SET @outResultCode = 50004		--Documento identidad ya existe
			SET @documentoIdentidadRepetido = 1;
		END;

		--INSERCION DEL EMPLEADO
		BEGIN TRANSACTION InsertarEmpleado
			IF @nombreValido = 1 AND 
				@nombreRepetido = 0 AND
				@documentoIdentidadValido = 1 AND
				@documentoIdentidadRepetido = 0
			BEGIN
				INSERT dbo.Empleado (
					IdPuesto
					, ValorDocumentoIdentidad
					, Nombre
					, FechaContratacion
					, SaldoVacaciones
					, EsActivo
				)
				VALUES (
					@idPuesto
					, CAST( @inValorDocumentoIdentidad AS INT )
					, @inNombre
					, CONVERT( DATE, @inFechaContratacion, 120 )
					, @inSaldoVacaciones
					, 1
				);

				SET @outResultCode = 0;
			END;
			
			ELSE
			BEGIN
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
				SET @IdTipoEvento = 5;
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

		COMMIT TRANSACTION InsertarEmpleado
	END TRY

	BEGIN CATCH 
		IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION InsertarEmpleado;
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
END;