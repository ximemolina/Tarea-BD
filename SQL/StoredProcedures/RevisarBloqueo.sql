CREATE PROCEDURE dbo.RevisarBloqueo(
	@inIpAdress VARCHAR(64)
	,@outResultCode INT OUTPUT)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY

		SET @outResultCode=0; ---Código error 0 indica que no hubo error

		---Cantidad de Logins No Exitosos que han habido en la ultima media hora
		SELECT COUNT(*)
		FROM 
			dbo.BitacoraEvento AS E
		WHERE
			DATEDIFF(MINUTE, E.PostTime, GETDATE()) < 30 ---Revisar ultima media hora
			AND E.IdTipoEvento = 2 ---Revisar que sea error de login

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