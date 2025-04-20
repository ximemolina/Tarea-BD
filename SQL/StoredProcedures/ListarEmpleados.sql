SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo][ListarEmpleados] (
    @outResultCode INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
	BEGIN TRY
		SELECT
			E.ValorDocumentoIdentidad AS Identificacion
			, E.Nombre AS Nombre
			, E.FechaContratacion AS Ingreso
		FROM 
			dbo.Empleado AS E
		WHERE 
			E.EsActivo = 1		--Filtrar empleados activos
		ORDER BY
			Nombre;
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
		SET @outResultCode = 50008;
	END CATCH
	SET NOCOUNT OFF;
END;
GO