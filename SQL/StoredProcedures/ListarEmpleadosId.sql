USE [Database]
GO
/****** Object:  StoredProcedure [dbo].[ListarEmpleadosId]    Script Date: 4/21/2025 11:25:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ListarEmpleadosId] (
	@inId VARCHAR(64)
	, @outResultCode INT OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		
		BEGIN 
			SELECT 
				E.ValorDocumentoIdentidad AS Identificacion
				, E.Nombre AS Nombre
				, E.FechaContratacion AS Ingreso
			FROM
				dbo.Empleado AS E
			WHERE
				CAST(E.ValorDocumentoIdentidad AS VARCHAR) LIKE ('%' + @inId + '%') AND E.EsActivo = 1
			ORDER BY
				Nombre
			SET @outResultCode = 0;			--Hay registros
		END;

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
		SET @outResultCode = 50008;
	END CATCH
	SET NOCOUNT OFF;
END