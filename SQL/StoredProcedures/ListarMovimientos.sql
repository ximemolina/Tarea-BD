CREATE PROCEDURE ListarMovimientos (
	@inNombre VARCHAR(64)
	,@outResultCode INT OUTPUT
)
AS
BEGIN
	
	SET NOCOUNT ON;

	BEGIN TRY
		
		---Obtener información del empleado
		SELECT
			E.ValorDocumentoIdentidad AS ValorDocumentoIdentidad
			, E.Nombre as Nombre
			, E.SaldoVacaciones AS SaldoVacaciones
		FROM
			dbo.Empleado AS E
		WHERE
			E.Nombre = @inNombre

		---Listar movimientos del empleado en orden descendente de fecha
		SELECT
			M.Fecha AS Fecha
			, TM.Nombre AS Nombre
			, M.Monto AS Monto
			, M.NuevoSaldo AS NuevoSaldo
			, U.Username AS Username
			, M.PostInIp AS PostInIp
			, M.PostTime AS PostTime
		FROM
			dbo.Movimiento AS M
			INNER JOIN dbo.TipoMovimiento AS TM
			ON 
				TM.Id = M.IdTipoMovimiento
			INNER JOIN dbo.Usuario AS U
			ON 
				M.IdPostByUser = U.Id
			INNER JOIN dbo.Empleado AS E
			ON
				M.IdEmpleado = E.Id
		WHERE
			@inNombre = E.Nombre

		ORDER BY
			PostTime DESC

		SET @outResultCode = 0; --Código éxito

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