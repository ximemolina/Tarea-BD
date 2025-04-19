USE [Database]
GO

/****** Object:  StoredProcedure [dbo].[EliminarCancelado]    Script Date: 18/4/2025 21:42:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[EliminarCancelado] (
				@inNombre VARCHAR( 64 )
				,@inUsername VARCHAR( 64 )
				,@inIpAdress VARCHAR( 64 )
				,@outResultCode INT OUTPUT 
)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		
		DECLARE @IdTipoEvento INT = 9; ---Id TipoEvento Intento de Borrado
		DECLARE @DocIdentidad INT;
		DECLARE @NombrePuesto VARCHAR( 64 );
		DECLARE @SaldoVacaciones INT;
		DECLARE @IdPuesto INT;
		DECLARE @Descripcion VARCHAR( 1024 );
		DECLARE @IdPostByUser INT;

		---Buscar documento de identidad del empleado con base a su nombre
		SET @DocIdentidad = ( SELECT
									E.ValorDocumentoIdentidad AS ValorDocumentoIdentidad
								FROM
									dbo.Empleado AS E
								WHERE
									E.Nombre = @inNombre )

		---Obtener saldo de vacaciones por medio de nombre de empleado
		SET @SaldoVacaciones= ( SELECT
									E.SaldoVacaciones AS SaldoVacaciones
								FROM
									dbo.Empleado AS E
								WHERE
									E.Nombre = @inNombre )

		---Obtener id del puesto del empleado para utilizarlo para obtener el nombre de este
		SET @IdPuesto = ( SELECT
								E.IdPuesto AS IdPuesto
							FROM
								dbo.Empleado AS E
							WHERE
								E.Nombre = @inNombre )

		---Obtener nombre del puesto
		SET @NombrePuesto = ( SELECT
									P.Nombre AS Nombre
								FROM
									Puesto AS P
								WHERE
									P.Id = @IdPuesto )

		SET @Descripcion = ( 'Valor Documento de Identidad: ' 
							+ CONVERT( VARCHAR , @DocIdentidad ) 
							+ '. Nombre del Empleado: ' 
							+ CONVERT( VARCHAR(64) , @inNombre ) 
							+ '. Nombre del Puesto: ' 
							+ CONVERT( VARCHAR(64) , @NombrePuesto ) 
							+ '. Saldo de Vacaciones: '
							+ CONVERT( VARCHAR(64) , @SaldoVacaciones ) ); ---Busca y asigna description de evento

		---Obtener ID del user que está realizando la accion
		SET @IdPostByUser = ( SELECT 
									U.Id AS Id
								FROM 
									dbo.Usuario U
								WHERE
									U.Username = @inUsername )

		---Inserta Evento de Intento de Borrado en BitacoraEvento
		INSERT INTO dbo.BitacoraEvento (
			IdTipoEvento
			,Descripcion
			,IdPostByUser
			,PostInIp
			,PostTime )
		VALUES( 
			@IdTipoEvento
			, @Descripcion 
			, @IdPostByUser 
			,@inIpAdress
			, GETDATE() )

		SET @outResultCode = 0;

	END TRY
	BEGIN CATCH

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


