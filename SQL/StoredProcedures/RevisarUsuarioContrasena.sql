CREATE PROCEDURE [dbo].[RevisarUsuarioContrasena](
	@inUsername VARCHAR(64)
	, @inPassword VARCHAR(64)
	, @inIpAdress VARCHAR(64)
	, @outResultCode INT OUTPUT)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		
		DECLARE @IdTipoEvento INT=  1; ---Id tipo de evento de Login Exitoso
		DECLARE @IdPostByUser INT; ---Id Usuario que está realizando el evento
		DECLARE @Descripcion VARCHAR(1024)= ''; ---Descripción de Evento Ocurrido
		DECLARE @CantLogin INT; --Cantidad de logins No Exitosos en la ultima media hora

		SET @outResultCode=0; ---Código error 0 indica que no hubo error
		

		---Revisar que usuario si exista en tabla Usuario
		IF NOT EXISTS ( SELECT 1 FROM dbo.Usuario A WHERE A.Username = @inUsername )
		BEGIN

			SET @IdPostByUser = 0;---Asigna id por default de user "no conocido"

			---Cantidad de Logins No Exitosos que han habido en la ultima media hora
			SET @CantLogin = ( SELECT COUNT(*)
								FROM 
									dbo.BitacoraEvento AS E
								WHERE
									DATEDIFF(MINUTE, E.PostTime, GETDATE()) < 30 ---Revisar ultima media hora
									AND E.IdTipoEvento = 2) ---Revisar que sea error de login
			
			---Revisar que no hayan mas de 5 Logins No Exitosos en la ultima media hora
			IF @CantLogin > 4
			BEGIN
				
				--Caso de que haya mas de 5 Logins No Exitosos (deshabilitar login)

				SET @IdTipoEvento = 3 ; ---Id tipo de evento de Login Deshabilitado

				SET @outResultCode = 50003; ---Login Deshabilitado

				INSERT dbo.BitacoraEvento( 	---Inserción de evento Login Deshabilitado a BitacoraEventos
					IdTipoEvento
					,IdPostByUser
					,Descripcion
					,PostInIp
					,PostTime
				) VALUES (
					@IdTipoEvento
					,@IdPostByUser
					,@Descripcion
					,@inIpAdress
					,GETDATE()
				);

				RETURN  @outResultCode;
			END;

			---Caso de que hayan menos de 5 logins no exitosos
			ELSE 
			BEGIN

				SET @IdTipoEvento = 2; ---Id tipo de evento de Login No Exitoso

				SET @outResultCode = 50001; ---Usuario no existe

				SET @Descripcion = ( 
									'Numero de intento en los ultimos 30mins: ' 
									+ CONVERT( VARCHAR , @CantLogin+1 ) 
									+ '. Codigo de error: ' 
									+ CONVERT( VARCHAR(64) , @outResultCode)); ---Busca y asigna description de error
			
				INSERT dbo.BitacoraEvento( 	---Inserción de evento Login No Exitoso a BitacoraEventos
					IdTipoEvento
					,IdPostByUser
					,Descripcion
					,PostInIp
					,PostTime
				) VALUES (
					@IdTipoEvento
					,@IdPostByUser
					,@Descripcion
					,@inIpAdress
					,GETDATE()
				);

				RETURN  @outResultCode;
			END;

		END;


		---Busca y asigna ID usuario en tabla Usuario
		SET @IdPostByUser = ( SELECT 
									E.Id AS Id
								FROM
									dbo.Usuario AS E
								WHERE 
									E.Username = @inUsername );


		---Revisar que usuario y contrasena coincidan
		IF NOT EXISTS ( SELECT 1 FROM dbo.Usuario A WHERE A.Username = @inUsername AND A.Password = @inPassword )
		BEGIN
			
			---Cantidad de Logins No Exitosos que han habido en la ultima media hora
			SET @CantLogin = ( SELECT COUNT(*)
								FROM 
									dbo.BitacoraEvento AS E
								WHERE
									DATEDIFF(MINUTE, E.PostTime, GETDATE()) < 30 ---Revisar ultima media hora
									AND E.IdTipoEvento = 2) ---Revisar que sea error de login
			
			---Revisar que no hayan mas de 5 Logins No Exitosos en la ultima media hora
			IF @CantLogin > 4
			BEGIN
				
				--Caso de que haya mas de 5 Logins No Exitosos (deshabilitar login)

				SET @IdTipoEvento = 3 ; ---Id tipo de evento de Login Deshabilitado

				SET @outResultCode = 50003; ---Login Deshabilitado

				INSERT dbo.BitacoraEvento( 	---Inserción de evento Login Deshabilitado a BitacoraEventos
					IdTipoEvento
					,IdPostByUser
					,Descripcion
					,PostInIp
					,PostTime
				) VALUES (
					@IdTipoEvento
					,@IdPostByUser
					,@Descripcion
					,@inIpAdress
					,GETDATE()
				);

				RETURN  @outResultCode;
			END;

			---Caso de que hayan menos de 5 logins no exitosos
			ELSE 
			BEGIN

				SET @IdTipoEvento = 2; ---Id tipo de evento de Login No Exitoso

				SET @outResultCode = 50002; ---Contrasena no existe

				SET @Descripcion = ( 
									'Numero de intento en los ultimos 30mins: ' 
									+ CONVERT( VARCHAR , @CantLogin+1 ) 
									+ '. Codigo de error: ' 
									+ CONVERT( VARCHAR(64) , @outResultCode)); ---Busca y asigna description de error
			
				INSERT dbo.BitacoraEvento( 	---Inserción de evento Login No Exitoso a BitacoraEventos
					IdTipoEvento
					,IdPostByUser
					,Descripcion
					,PostInIp
					,PostTime
				) VALUES (
					@IdTipoEvento
					,@IdPostByUser
					,@Descripcion
					,@inIpAdress
					,GETDATE()
				);

				RETURN  @outResultCode;
			END;
		END;

		---Caso de Login Exitoso

		INSERT dbo.BitacoraEvento( 		---Inserción de evento Login Exitoso a BitacoraEventos
			IdTipoEvento
			,IdPostByUser
			,Descripcion
			,PostInIp
			,PostTime
		) VALUES (
			@IdTipoEvento
			,@IdPostByUser
			,@Descripcion
			,@inIpAdress
			,GETDATE()
		);

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