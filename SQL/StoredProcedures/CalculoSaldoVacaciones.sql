GO
/****** Object:  StoredProcedure [dbo].[CalculoSaldoVacaciones]    Script Date: 4/27/2025 7:31:59 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CalculoSaldoVacaciones] (
	@inFechaContratacion VARCHAR( 64 )
	, @outSaldoVacacion INT OUTPUT
	, @outResultCode INT OUTPUT
)
AS
BEGIN

	SET NOCOUNT ON;
	BEGIN TRY
		DECLARE @FechaConvertida DATE;
		DECLARE @FechaActual DATE = GETDATE();

		SET @FechaConvertida = CONVERT( DATE, @inFechaContratacion, 120 )		--Convierte a formato YYYY-MM-DD
		
		IF @FechaActual IS NOT NULL
		BEGIN
			SET @outSaldoVacacion = DATEDIFF( MONTH, @FechaConvertida, @FechaActual )

			IF DAY( @FechaConvertida ) > DAY( @FechaActual ) AND @outSaldoVacacion > 0
			BEGIN
				SET @outSaldoVacacion = @outSaldoVacacion - 1
			END;
		END;

		ELSE
		BEGIN
			SET @outSaldoVacacion = 0;
		END;

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