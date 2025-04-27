USE [Database]
GO

/****** Object:  StoredProcedure [dbo].[ObtenerDocId]    Script Date: 18/4/2025 20:47:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ObtenerDocId] (
	@inNombre VARCHAR( 64 )
	, @outResultCode INT OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		
		--Obtener valor documento de identidad del empleado
		SELECT 
			E.ValorDocumentoIdentidad AS ValorDocumentoIdentidad
		FROM
			DBO.Empleado AS E
		WHERE
			E.Nombre = @inNombre

		SET @outResultCode = 0; ---C�digo �xito

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


