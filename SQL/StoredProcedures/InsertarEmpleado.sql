SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[InsertarEmpleado] (
    @inValorDocumentoIdentidad INT
	, @inNombre VARCHAR( 64 )
	, @inNombrePuesto VARCHAR( 64 )
	, @outResultCode INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
	DECLARE @FechaActual DATE = GETDATE();
	DECLARE @idPuesto INT;

	BEGIN TRY
		SELECT @idPuesto = P.id
		FROM dbo.Puesto AS P
		WHERE P.Nombre = @inNombrePuesto

		IF @idPuesto IS NULL 
		BEGIN
			SET @outResultCode = -1
			PRINT 'No existe puesto';
			RETURN
		END

		INSERT dbo.Empleado (
			IdPuesto
			, ValorDocumentoIdentidad
			, Nombre
			, FechaContratacion
			, EsActivo
		)
		VALUES (
			@idPuesto
			, @inValorDocumentoIdentidad
			, @inNombre
			, @FechaActual
			, 1
		)

		SET @outResultCode = 0
	END TRY

	BEGIN CATCH 
		SET @outResultCode = 50008
	END CATCH
	SET NOCOUNT OFF;
END;