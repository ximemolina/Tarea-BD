USE mydb;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.TipoEvento)
BEGIN
    INSERT INTO dbo.TipoEvento (Id, Nombre) VALUES
    (1, 'Login'),
    (2, 'Logout'),
    (3, 'Creacion'),
    (4, 'Eliminacion');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Puesto)
BEGIN
    INSERT INTO dbo.Puesto (Id, Nombre, SalarioxHora) VALUES
    (1, 'Administrador', 5000),
    (2, 'Empleado', 3000),
    (3, 'Gerente', 8000);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Usuario)
BEGIN
    INSERT INTO dbo.Usuario (Id, Username, Password) VALUES
    (1, 'admin', '1234'),
    (2, 'user1', '1234');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.TipoMovimiento)
BEGIN
    INSERT INTO dbo.TipoMovimiento (Id, Nombre, TipoAccion) VALUES
    (1, 'Vacaciones otorgadas', 'Credito'),
    (2, 'Vacaciones usadas', 'Debito');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Feriado)
BEGIN
    INSERT INTO dbo.Feriado (Fecha, Descripcion) VALUES
    ('2026-01-01', 'Año Nuevo'),
    ('2026-04-11', 'Juan Santamaria'),
    ('2026-12-25', 'Navidad');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Error)
BEGIN
    INSERT INTO dbo.Error (Codigo, Descripcion) VALUES
    (1, 'Error general'),
    (2, 'Usuario no encontrado'),
    (3, 'Acceso denegado');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Empleado)
BEGIN
    INSERT INTO dbo.Empleado (
        IdPuesto,
        ValorDocumentoIdentidad,
        Nombre,
        FechaContratacion,
        SaldoVacaciones,
        EsActivo
    ) VALUES
    (1, '123456', 'Juan Perez', '2022-01-01', 10, 1),
    (2, '654321', 'Maria Lopez', '2023-05-10', 5, 1);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.Movimiento)
BEGIN
    INSERT INTO dbo.Movimiento (
        IdEmpleado,
        IdTipoMovimiento,
        Fecha,
        Monto,
        NuevoSaldo,
        IdPostByUser,
        PostInIP,
        PostTime
    ) VALUES
    (1, 1, '2026-01-10', 5, 15, 1, '127.0.0.1', GETDATE()),
    (1, 2, '2026-02-01', 2, 13, 1, '127.0.0.1', GETDATE());
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.BitacoraEvento)
BEGIN
    INSERT INTO dbo.BitacoraEvento (
        IdTipoEvento,
        Descripcion,
        IdPostByUser,
        PostInIp
    ) VALUES
    (1, 'Usuario inició sesión', 1, '127.0.0.1'),
    (3, 'Creación de empleado', 1, '127.0.0.1');
END
GO