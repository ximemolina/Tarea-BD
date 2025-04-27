CREATE PROCEDURE dbo.Logout(
	@inUsername VARCHAR( 64 )
	, @inIpAdress VARCHAR( 64 )
	, @inNombreEvento VARCHAR( 64 )
	, @outResultCode INT OUTPUT)
AS
BEGIN
	
	SET NOCOUNT ON;

	BEGIN TRY
		
		SET @outResultCode = 0; ---C�digo �xito

		INSERT INTO dbo.BitacoraEvento( ---Actualizar bitacora evento con info de Logout
			IdTipoEvento
			,IdPostByUser
			,Descripcion
			,PostInIp
			,PostTime )
		SELECT
			TE.Id
			, U.Id
			, ''
			, @inIpAdress
			, GETDATE()
		FROM
			dbo.TipoEvento AS TE
			,dbo.Usuario AS U
		WHERE
			@inNombreEvento = TE.Nombre
			AND @inUsername = U.Username
	
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