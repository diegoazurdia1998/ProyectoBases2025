  USE FitChain
  GO
  
  -- Eliminar tablas si existen (orden inverso por dependencias)
    IF OBJECT_ID('dbo.Punteo', 'U') IS NOT NULL DROP TABLE dbo.Punteo;
    IF OBJECT_ID('dbo.Origen', 'U') IS NOT NULL DROP TABLE dbo.Origen;
    IF OBJECT_ID('dbo.Pago', 'U') IS NOT NULL DROP TABLE dbo.Pago;
    IF OBJECT_ID('dbo.Asistencia', 'U') IS NOT NULL DROP TABLE dbo.Asistencia;
    IF OBJECT_ID('dbo.Miembro_reto', 'U') IS NOT NULL DROP TABLE dbo.Miembro_reto;
    IF OBJECT_ID('dbo.RetoGrupal', 'U') IS NOT NULL DROP TABLE dbo.RetoGrupal;
    IF OBJECT_ID('dbo.Miembro_Grupo', 'U') IS NOT NULL DROP TABLE dbo.Miembro_Grupo;
    IF OBJECT_ID('dbo.Membresia', 'U') IS NOT NULL DROP TABLE dbo.Membresia;
    IF OBJECT_ID('dbo.Reto', 'U') IS NOT NULL DROP TABLE dbo.Reto;
    IF OBJECT_ID('dbo.Miembro', 'U') IS NOT NULL DROP TABLE dbo.Miembro;
    IF OBJECT_ID('dbo.Grupo', 'U') IS NOT NULL DROP TABLE dbo.Grupo;
    IF OBJECT_ID('dbo.Sucursal', 'U') IS NOT NULL DROP TABLE dbo.Sucursal;
    IF OBJECT_ID('dbo.Ciudad', 'U') IS NOT NULL DROP TABLE dbo.Ciudad;
    IF OBJECT_ID('dbo.Pais', 'U') IS NOT NULL DROP TABLE dbo.Pais;
    IF OBJECT_ID('dbo.Unidad_medicion', 'U') IS NOT NULL DROP TABLE dbo.Unidad_medicion;
    IF OBJECT_ID('dbo.TipoMembresia', 'U') IS NOT NULL DROP TABLE dbo.TipoMembresia;
    IF OBJECT_ID('dbo.Estado', 'U') IS NOT NULL DROP TABLE dbo.Estado;
    IF OBJECT_ID('dbo.Genero', 'U') IS NOT NULL DROP TABLE dbo.Genero;

    -- Crear tablas (orden correcto por dependencias)
    CREATE TABLE dbo.Genero (
        IDGenero SMALLINT PRIMARY KEY,
        Nombre NVARCHAR(250) NOT NULL
    );

    CREATE TABLE dbo.TipoMembresia (
        IDTipoMembresia SMALLINT PRIMARY KEY,
        Nombre NVARCHAR(25) NOT NULL
    );

    CREATE TABLE dbo.Estado (
        IDEstado SMALLINT PRIMARY KEY,
        Nombre NVARCHAR(150) NOT NULL
    );

    CREATE TABLE dbo.Unidad_medicion (
        IDUnidadMedicion SMALLINT PRIMARY KEY,
        Nombre NVARCHAR(100) NOT NULL,
        Simbolo NVARCHAR(5) NOT NULL
    );

    CREATE TABLE dbo.Pais (
        IDPais SMALLINT PRIMARY KEY,
        Nombre NVARCHAR(350) NOT NULL
    );

    CREATE TABLE dbo.Ciudad (
        IDCiudad SMALLINT PRIMARY KEY,
        Nombre NVARCHAR(350) NOT NULL,
        IDPais SMALLINT NOT NULL,
        FOREIGN KEY (IDPais) REFERENCES dbo.Pais(IDPais)
    );

    CREATE TABLE dbo.Sucursal (
        IDSucursal SMALLINT PRIMARY KEY,
        Nombre NVARCHAR(150) NOT NULL,
        Capacidad SMALLINT NOT NULL,
        Direccion NVARCHAR(MAX) NOT NULL,
        IDCiudad SMALLINT NOT NULL,
        FOREIGN KEY (IDCiudad) REFERENCES dbo.Ciudad(IDCiudad)
    );

    CREATE TABLE dbo.Miembro (
        IDMiembro SMALLINT PRIMARY KEY,
        Nombre1 NVARCHAR(150) NOT NULL,
        Nombre2 NVARCHAR(150) NULL,
        Apellido1 NVARCHAR(150) NOT NULL,
        Apellido2 NVARCHAR(150) NULL,
        Identificacion NVARCHAR(13) NULL,
        Fecha_registro DATE NOT NULL,
        Fecha_nacimiento DATE NOT NULL,
        IDGenero SMALLINT NULL,
        Altura DECIMAL(5, 2) NOT NULL,
        Peso_inical DECIMAL(5, 2) NOT NULL,
        Condiciones_medicas NVARCHAR(MAX) NULL,
        IDTipoMembresia SMALLINT NOT NULL,
        estaSuspendido BIT NOT NULL,
        FOREIGN KEY (IDGenero) REFERENCES dbo.Genero(IDGenero),
        FOREIGN KEY (IDTipoMembresia) REFERENCES dbo.TipoMembresia(IDTipoMembresia)
    );

    CREATE TABLE dbo.Grupo (
        IDGrupo SMALLINT PRIMARY KEY,
        Nombre NVARCHAR(150) NOT NULL,
        Fecha_creacion DATE NOT NULL
    );

    CREATE TABLE dbo.Reto (
        IDReto SMALLINT PRIMARY KEY,
        Nombre NVARCHAR(150) NOT NULL,
        Descripcion NVARCHAR(MAX) NOT NULL,
        Fecha_inicio DATETIME NOT NULL,
        Fecha_fin DATE NOT NULL,
        Puntos_aganar INT NOT NULL,
        Meta_cantidad DECIMAL(6, 2) NOT NULL,
        IDUnidadMedicion SMALLINT NOT NULL,
        IDSucursal SMALLINT NULL,
        FOREIGN KEY (IDUnidadMedicion) REFERENCES dbo.Unidad_medicion(IDUnidadMedicion),
        FOREIGN KEY (IDSucursal) REFERENCES dbo.Sucursal(IDSucursal)
    );

    CREATE TABLE dbo.Membresia (
        IDMembresia SMALLINT PRIMARY KEY,
        Fecha_inicio DATE NOT NULL,
        Fecha_cancelacion DATE NULL,
        esPrincipal BIT NOT NULL,
        IDSucursal SMALLINT NOT NULL,
        IDMiembro SMALLINT NOT NULL,
        FOREIGN KEY (IDSucursal) REFERENCES dbo.Sucursal(IDSucursal),
        FOREIGN KEY (IDMiembro) REFERENCES dbo.Miembro(IDMiembro)
    );

    CREATE TABLE dbo.Miembro_Grupo (
        IDGrupo SMALLINT NOT NULL,
        IDMiembro SMALLINT NOT NULL,
        Fecha_entrada DATE NOT NULL,
        Fecha_salida DATE NULL,
        esLider BIT NOT NULL,
        PRIMARY KEY (IDGrupo, IDMiembro),
        FOREIGN KEY (IDGrupo) REFERENCES dbo.Grupo(IDGrupo),
        FOREIGN KEY (IDMiembro) REFERENCES dbo.Miembro(IDMiembro)
    );

    CREATE TABLE dbo.RetoGrupal (
        IDGrupo SMALLINT NOT NULL,
        IDReto SMALLINT NOT NULL,
        Fecha_creacion DATE NOT NULL,
        Fecha_completado DATE NULL,
        IDEstado SMALLINT NOT NULL,
        PRIMARY KEY (IDGrupo, IDReto),
        FOREIGN KEY (IDGrupo) REFERENCES dbo.Grupo(IDGrupo),
        FOREIGN KEY (IDReto) REFERENCES dbo.Reto(IDReto),
        FOREIGN KEY (IDEstado) REFERENCES dbo.Estado(IDEstado)
    );

    CREATE TABLE dbo.Miembro_reto (
        IDMiembro SMALLINT NOT NULL,
        IDReto SMALLINT NOT NULL,
        Progreso DECIMAL(4, 2) NOT NULL,
        Fecha_inscripcion DATETIME NOT NULL,
        Fecha_completado DATETIME NULL,
        IDEstado SMALLINT NOT NULL,
        PRIMARY KEY (IDMiembro, IDReto),
        FOREIGN KEY (IDMiembro) REFERENCES dbo.Miembro(IDMiembro),
        FOREIGN KEY (IDReto) REFERENCES dbo.Reto(IDReto),
        FOREIGN KEY (IDEstado) REFERENCES dbo.Estado(IDEstado)
    );

    CREATE TABLE dbo.Asistencia (
        IDAsistencia SMALLINT PRIMARY KEY,
        IDMiembro SMALLINT NOT NULL,
        IDSucursal SMALLINT NOT NULL,
        FechaHora_Entrada DATETIME NOT NULL,
        FechaHora_Salida DATETIME NOT NULL,
        Acceso INT NOT NULL,
        FOREIGN KEY (IDMiembro) REFERENCES dbo.Miembro(IDMiembro),
        FOREIGN KEY (IDSucursal) REFERENCES dbo.Sucursal(IDSucursal)
    );

    CREATE TABLE dbo.Origen (
        IDOrigen SMALLINT PRIMARY KEY,
        Descripcion NVARCHAR(150) NOT NULL,
        IDReto SMALLINT NULL,
        FOREIGN KEY (IDReto) REFERENCES dbo.Reto(IDReto)
    );

    CREATE TABLE dbo.Punteo (
        IDPunteo SMALLINT PRIMARY KEY,
        Cantidad SMALLINT NOT NULL,
        Fecha_obtenido DATE NOT NULL,
        Fecha_vencido DATE NULL,
        IDOrigen SMALLINT NOT NULL,
        IDMiembro SMALLINT NOT NULL,
        FOREIGN KEY (IDOrigen) REFERENCES dbo.Origen(IDOrigen),
        FOREIGN KEY (IDMiembro) REFERENCES dbo.Miembro(IDMiembro)
    );

    CREATE TABLE dbo.Pago (
        IDPago SMALLINT PRIMARY KEY,
        Fecha_trasaccion DATE NOT NULL,
        Monto_abonado DECIMAL(9, 2) NOT NULL,
        IDMiembro SMALLINT NOT NULL,
        FOREIGN KEY (IDMiembro) REFERENCES dbo.Miembro(IDMiembro)
    );