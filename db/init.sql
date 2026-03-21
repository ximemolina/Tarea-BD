IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'mydb')
BEGIN
    CREATE DATABASE mydb;
END
GO

USE mydb;
GO

-- =========================
-- CREATE TABLES 
-- =========================

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Feriado' AND xtype='U')
BEGIN
CREATE TABLE dbo.Feriado (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Fecha DATE,
    Descripcion VARCHAR(1024)
);
END
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Error' AND xtype='U')
BEGIN
CREATE TABLE dbo.Error (
    Codigo INT PRIMARY KEY,
    Descripcion VARCHAR(1024)
);
END
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='TipoEvento' AND xtype='U')
BEGIN
CREATE TABLE dbo.TipoEvento (
    Id INT PRIMARY KEY,
    Nombre VARCHAR(64)
);
END
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Puesto' AND xtype='U')
BEGIN
CREATE TABLE dbo.Puesto (
    Id INT PRIMARY KEY,
    Nombre VARCHAR(64),
    SalarioxHora DECIMAL(10,2)
);
END
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Usuario' AND xtype='U')
BEGIN
CREATE TABLE dbo.Usuario (
    Id INT PRIMARY KEY,
    Username VARCHAR(64),
    Password VARCHAR(64)
);
END
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='TipoMovimiento' AND xtype='U')
BEGIN
CREATE TABLE dbo.TipoMovimiento (
    Id INT PRIMARY KEY,
    Nombre VARCHAR(64),
    TipoAccion VARCHAR(20) -- 'Credito' o 'Debito'
);
END
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Empleado' AND xtype='U')
BEGIN
CREATE TABLE dbo.Empleado (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    IdPuesto INT,
    ValorDocumentoIdentidad VARCHAR(64),
    Nombre VARCHAR(64),
    FechaContratacion DATE,
    SaldoVacaciones INT,
    EsActivo BIT,

    CONSTRAINT FK_Empleado_Puesto
        FOREIGN KEY (IdPuesto) REFERENCES dbo.Puesto(Id)
);
END
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Movimiento' AND xtype='U')
BEGIN
CREATE TABLE dbo.Movimiento (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    IdEmpleado INT,
    IdTipoMovimiento INT,
    Fecha DATE,
    Monto INT,
    NuevoSaldo INT,
    IdPostByUser INT,
    PostInIP VARCHAR(64),
    PostTime DATETIME,

    CONSTRAINT FK_Mov_Empleado
        FOREIGN KEY (IdEmpleado) REFERENCES dbo.Empleado(Id),

    CONSTRAINT FK_Mov_TipoMovimiento
        FOREIGN KEY (IdTipoMovimiento) REFERENCES dbo.TipoMovimiento(Id),

    CONSTRAINT FK_Mov_Usuario
        FOREIGN KEY (IdPostByUser) REFERENCES dbo.Usuario(Id)
);
END
GO


IF NOT EXISTS (
    SELECT * 
    FROM sysobjects 
    WHERE name = 'BitacoraEvento' AND xtype = 'U'
)
BEGIN
    CREATE TABLE dbo.BitacoraEvento (
        Id INT IDENTITY(1,1) PRIMARY KEY,

        IdTipoEvento INT NOT NULL,
        Descripcion VARCHAR(1024),
        IdPostByUser INT NOT NULL,
        PostInIp VARCHAR(64),
        PostTime DATETIME DEFAULT GETDATE(),

        CONSTRAINT FK_Bitacora_TipoEvento
            FOREIGN KEY (IdTipoEvento) REFERENCES dbo.TipoEvento(Id),

        CONSTRAINT FK_Bitacora_Usuario
            FOREIGN KEY (IdPostByUser) REFERENCES dbo.Usuario(Id)
    );
END
GO

-- =========================
-- STORED PROCEDURES 
-- =========================

:r /SQL/StoredProcedures/CalculoSaldoVacaciones.sql
:r /SQL/StoredProcedures/EliminarCancelado.sql
:r /SQL/StoredProcedures/InsertarEmpleado.sql
:r /SQL/StoredProcedures/EliminarEmpleado.sql
:r /SQL/StoredProcedures/InsertarMovimiento.sql
:r /SQL/StoredProcedures/ListarEmpleados.sql
:r /SQL/StoredProcedures/ListarEmpleadosId.sql
:r /SQL/StoredProcedures/ListarEmpleadosNombre.sql
:r /SQL/StoredProcedures/ListarMovimientos.sql
:r /SQL/StoredProcedures/ListarPuestos.sql
:r /SQL/StoredProcedures/Logout.sql
:r /SQL/StoredProcedures/ModificarEmpleado.sql
:r /SQL/StoredProcedures/MostrarError.sql
:r /SQL/StoredProcedures/ObtenerDocId.sql
:r /SQL/StoredProcedures/RevisarBloqueo.sql
:r /SQL/StoredProcedures/RevisarUsuarioContrasena.sql