USE [Database]
GO
/****** Object:  StoredProcedure [dbo].[ListarEmpleadosNombre]    Script Date: 4/21/2025 10:29:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ListarEmpleadosNombre] ( 
	@inNombre VARCHAR( 64 )
	, @inUsername VARCHAR( 64 )
	, @inIpAdress VARCHAR( 64 )
	, @outResultCode INT OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		DECLARE @IdTipoEvento INT = 11;		--Consulta por nombre
		DECLARE @IdPostByUser INT;
		DECLARE @Descripcion VARCHAR( 1024 );

		SET @inNombre = LTRIM(RTRIM(@inNombre));

		SET @IdPostByUser = ( SELECT 
									U.Id AS Id
							  FROM
									dbo.Usuario AS U
							  WHERE
									U.Username = @inUsername );

		SET @Descripcion = ( 'Valor del filtro del nombre: ' 
							+ CONVERT( VARCHAR(64) , @inNombre ));

		IF PATINDEX( '%[^A-Za-z ]%', @inNombre ) > 0 OR LTRIM(RTRIM(@inNombre)) = ''
		BEGIN 
			SET @outResultCode = 50009;		--Nombre no alfabetico
		END;
		
		ELSE
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

			---Inserta Evento en BitacoraEvento
			INSERT INTO dbo.BitacoraEvento (
				IdTipoEvento
				, Descripcion
				, IdPostByUser
				, PostInIp
				, PostTime )
			VALUES( 
				@IdTipoEvento
				, @Descripcion 
				, @IdPostByUser 
				, @inIpAdress
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