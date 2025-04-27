GO
/****** Object:  StoredProcedure [dbo].[ListarEmpleadosId]    Script Date: 4/21/2025 11:25:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ListarEmpleadosId] (
	@inId VARCHAR(64)
	, @inUsername VARCHAR( 64 )
	, @inIpAdress VARCHAR( 64 )
	, @outResultCode INT OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		DECLARE @IdTipoEvento INT = 12;		--Consulta por documento identidad
		DECLARE @IdPostByUser INT;
		DECLARE @Descripcion VARCHAR( 1024 );

		SET @IdPostByUser = ( SELECT 
									U.Id AS Id
							  FROM
									dbo.Usuario AS U
							  WHERE
									U.Username = @inUsername );

		SET @Descripcion = ( 'Valor del filtro del documento de identidad: ' 
							+ CONVERT( VARCHAR(64) , @inId ));

		IF PATINDEX('%[^0-9]%', LTRIM(RTRIM(@inId))) > 0 OR LTRIM(RTRIM(@inId)) = ''
		BEGIN
			SET @outResultCode = 50010		--Mal formato de documento de identidad
		END;

		ELSE
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

			---Inserta Evento en BitacoraEvento
			INSERT INTO dbo.BitacoraEvento (
				IdTipoEvento
				,Descripcion
				,IdPostByUser
				,PostInIp
				,PostTime )
			VALUES( 
				@IdTipoEvento
				, @Descripcion 
				, @IdPostByUser 
				,@inIpAdress
				, GETDATE() )

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
