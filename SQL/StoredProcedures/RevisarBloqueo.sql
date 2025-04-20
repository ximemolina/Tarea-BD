CREATE PROCEDURE dbo.RevisarBloqueo(
	@inIpAdress VARCHAR(64)
	,@outResultCode INT OUTPUT)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY

		SET @outResultCode=0; ---C�digo error 0 indica que no hubo error

		---Revisar si hay un login deshabilitado en los ultimos diez minutos
		SELECT COUNT(1)
		FROM 
			dbo.BitacoraEvento AS E
		WHERE
			DATEDIFF(MINUTE, E.PostTime, GETDATE()) < 10---Revisar ultimos diez mins
			AND E.IdTipoEvento = 3 ---Revisar que sea error de login deshabilitado

		RETURN  @outResultCode;

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