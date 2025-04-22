USE [Database]
GO
/****** Object:  StoredProcedure [dbo].[ListarEmpleadosNombre]    Script Date: 4/21/2025 10:29:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ListarEmpleadosNombre] ( 
	@inNombre VARCHAR(64)
	, @outResultCode INT OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN 
			SELECT 
				E.Id AS Identificacion
				, E.Nombre AS Nombre
				, E.FechaContratacion AS Ingreso
			FROM
				dbo.Empleado AS E
			WHERE
				LOWER(E.Nombre) LIKE LOWER('%' + @inNombre + '%') AND E.EsActivo = 1
			ORDER BY
				Nombre
			SET @outResultCode = 0;			
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