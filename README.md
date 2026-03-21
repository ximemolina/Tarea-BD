# Sistema Control de Empleados


Se trata de una aplicación sencilla para hacer CRUD de una tabla de Empleado (como parte de un módulo de control de vacaciones en sistema de recursos humanos), y realizar algunas consultas con filtros por nombre del empleado o valor de documento de identidad, así como el registro de movimientos de vacaciones, etc. La aplicación incluye validación de ingreso de usuarios mediante clave y contraseña, así como un registro en una bitácora de todas las operaciones que un usuario realiza en la BD.

## ⚙️ Requisitos
- Docker
- Docker Compose
- Node.js (solo si se ejecuta fuera de Docker)

## 🐳 Ejecución del Proyecto
### 1. Construir y levantar los contenedores
```bash
docker-compose up --build
```
Esto hará:
- Levantar SQL Server
- Crear la base de datos (init.sql)
- Ejecutar la aplicación Node.js

### 2. Ejecutar los datos iniciales (seed)

Los datos no se cargan automáticamente para evitar duplicados.

Ejecutar:
```bash
docker exec -it sqlserver \
/opt/mssql-tools18/bin/sqlcmd \
-S localhost -U sa -P "TuPasswordSeguro123!" \
-C -i /bd/seed.sql
```
## 🌐 Acceso a la Aplicación

Abrir en el navegador:

http://localhost:3000

## Diagrama de base de datos
```mermaid
erDiagram

    Feriado {
        int Id PK
        date Fecha
        varchar Descripcion
    }

    Error {
        int Codigo PK
        varchar Descripcion
    }

    TipoEvento {
        int Id PK
        varchar Nombre
    }

    Puesto {
        int Id PK
        varchar Nombre
        decimal SalarioxHora
    }

    Usuario {
        int Id PK
        varchar Username
        varchar Password
    }

    TipoMovimiento {
        int Id PK
        varchar Nombre
        varchar TipoAccion
    }

    Empleado {
        int Id PK
        int IdPuesto FK
        varchar ValorDocumentoIdentidad
        varchar Nombre
        date FechaContratacion
        int SaldoVacaciones
        bit EsActivo
    }

    Movimiento {
        int Id PK
        int IdEmpleado FK
        int IdTipoMovimiento FK
        int IdPostByUser FK
        date Fecha
        int Monto
        int NuevoSaldo
        varchar PostInIP
        datetime PostTime
    }

    BitacoraEvento {
        int Id PK
        int IdTipoEvento FK
        int IdPostByUser FK
        varchar Descripcion
        varchar PostInIp
        datetime PostTime
    }

    %% RELACIONES

    Puesto ||--o{ Empleado : tiene
    Empleado ||--o{ Movimiento : genera
    TipoMovimiento ||--o{ Movimiento : clasifica
    Usuario ||--o{ Movimiento : registra

    TipoEvento ||--o{ BitacoraEvento : define
    Usuario ||--o{ BitacoraEvento : registra
