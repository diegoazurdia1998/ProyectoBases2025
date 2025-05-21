-- Tablas básicas (Nivel 1)
CREATE TABLE Genero (
    IDGenero smallint PRIMARY KEY,
    Nombre nvarchar(250) NOT NULL
);

CREATE TABLE Pais (
    IDPais smallint PRIMARY KEY,
    Nombre nvarchar(350) NOT NULL
);

CREATE TABLE Ciudad (
    IDCiudad smallint PRIMARY KEY,
    Nombre nvarchar(350) NOT NULL,
    IDPais smallint FOREIGN KEY REFERENCES Pais(IDPais)
);

CREATE TABLE Condicion_Medica (
    IDCondicion smallint PRIMARY KEY,
    Nombre nvarchar(50) NOT NULL,
    Descripcion nvarchar(max) NOT NULL
);

CREATE TABLE Estado (
    IDEstado smallint PRIMARY KEY,
    Nombre nvarchar(150) NOT NULL
);

CREATE TABLE Tipo_Membresia (
    IDTipo_Membresia smallint PRIMARY KEY,
    Nombre nvarchar(25) NOT NULL
);

CREATE TABLE Tipo_Acceso (
    IDTipoAcceso smallint PRIMARY KEY,
    Nombre nvarchar(50) NOT NULL
);

CREATE TABLE Unidad_medicion (
    IDUnidadMedicion smallint PRIMARY KEY,
    Nombre nvarchar(100) NOT NULL,
    Simbolo nvarchar(5) NOT NULL
);

-- Tablas dependientes (Nivel 2)
CREATE TABLE Miembro (
    IDMiembro smallint PRIMARY KEY,
    Nombre1 nvarchar(150) NOT NULL,
    Nombre2 nvarchar(150) NULL,
    Apellido1 nvarchar(150) NOT NULL,
    Apellido2 nvarchar(150) NULL,
    Identificacion nvarchar(13) NOT NULL,
    Fecha_registro date NOT NULL,
    Fecha_nacimiento date NOT NULL,
    IDGenero smallint FOREIGN KEY REFERENCES Genero(IDGenero),
    Altura decimal(5, 2) NOT NULL,
    Peso_inical decimal(5, 2) NOT NULL,
    IDCondicion smallint FOREIGN KEY REFERENCES Condicion_Medica(IDCondicion),
    estaSuspendido bit NOT NULL
);

CREATE TABLE Sucursal (
    IDSucursal smallint PRIMARY KEY,
    Nombre nvarchar(150) NOT NULL,
    Capacidad smallint NOT NULL,
    Direccion nvarchar(max) NOT NULL,
    IDCiudad smallint FOREIGN KEY REFERENCES Ciudad(IDCiudad)
);

CREATE TABLE Grupo (
    IDGrupo smallint PRIMARY KEY,
    Nombre nvarchar(150) NOT NULL,
    Fecha_creacion date NOT NULL
);

CREATE TABLE Reto (
    IDReto smallint PRIMARY KEY,
    Nombre nvarchar(150) NOT NULL,
    Descripcion nvarchar(max) NOT NULL,
    Fecha_inicio datetime NOT NULL,
    Fecha_fin date NULL,
    Puntos_aganar int NOT NULL,
    Meta_cantidad decimal(6, 2) NOT NULL,
    IDUnidadMedicion smallint FOREIGN KEY REFERENCES Unidad_medicion(IDUnidadMedicion),
    IDSucursal smallint FOREIGN KEY REFERENCES Sucursal(IDSucursal),
    esGrupal bit NOT NULL
);

CREATE TABLE Origen (
    IDOrigen smallint PRIMARY KEY,
    Descripcion nvarchar(150) NOT NULL,
    IDReto smallint FOREIGN KEY REFERENCES Reto(IDReto)
);

-- Tablas transaccionales (Nivel 3)
CREATE TABLE Membresia (
    IDMembresia smallint PRIMARY KEY,
    Fecha_Inicio date NOT NULL,
    Fecha_fin date NULL,
    IDMiembro smallint FOREIGN KEY REFERENCES Miembro(IDMiembro),
    IDTipo_Membresia smallint FOREIGN KEY REFERENCES Tipo_Membresia(IDTipo_Membresia)
);

CREATE TABLE Miembro_Sucursal (
    IDMiembro_Sucursal smallint PRIMARY KEY,
    Fecha_inicio date NOT NULL,
    Fecha_cancelacion date NULL,
    esPrincipal bit NOT NULL,
    IDSucursal smallint FOREIGN KEY REFERENCES Sucursal(IDSucursal),
    IDMiembro smallint FOREIGN KEY REFERENCES Miembro(IDMiembro)
);

CREATE TABLE Miembro_Acceso (
    IDAcceso smallint PRIMARY KEY,
    InformacionEncriptada nvarchar(max) NOT NULL,
    IDTipoAcceso smallint FOREIGN KEY REFERENCES Tipo_Acceso(IDTipoAcceso),
    IDMiembro smallint FOREIGN KEY REFERENCES Miembro(IDMiembro)
);

CREATE TABLE Asistencia (
    IDAsistencia int PRIMARY KEY,
    IDMiembro_Sucursal smallint FOREIGN KEY REFERENCES Miembro_Sucursal(IDMiembro_Sucursal),
    FechaHora_Entrada datetime NOT NULL,
    FechaHora_Salida datetime NOT NULL,
    IDAcceso smallint FOREIGN KEY REFERENCES Miembro_Acceso(IDAcceso)
);

CREATE TABLE Pago (
    IDPago smallint PRIMARY KEY,
    Fecha_trasaccion date NOT NULL,
    Monto_abonado decimal(9, 2) NOT NULL,
    IDMembresia smallint FOREIGN KEY REFERENCES Membresia(IDMembresia)
);

CREATE TABLE Pesaje (
    IDPesaje smallint PRIMARY KEY,
    Cantidad decimal(5, 2) NOT NULL,
    Fecha date NOT NULL,
    IDMiembro smallint FOREIGN KEY REFERENCES Miembro(IDMiembro)
);

CREATE TABLE Punteo (
    IDPunteo smallint PRIMARY KEY,
    Cantidad int NOT NULL,
    Fecha_obtenido date NOT NULL,
    Fecha_vencido date NULL,
    IDOrigen smallint FOREIGN KEY REFERENCES Origen(IDOrigen),
    IDMiembro smallint FOREIGN KEY REFERENCES Miembro(IDMiembro),
    estaActivo bit NOT NULL
);

CREATE TABLE Miembro_reto (
    IDMiembro smallint FOREIGN KEY REFERENCES Miembro(IDMiembro),
    IDReto smallint FOREIGN KEY REFERENCES Reto(IDReto),
    Progreso decimal(4, 2) NOT NULL,
    Fecha_inscripcion datetime NOT NULL,
    Fecha_completado datetime NULL,
    IDEstado smallint FOREIGN KEY REFERENCES Estado(IDEstado),
    PRIMARY KEY (IDMiembro, IDReto)
);

CREATE TABLE Reto_Grupal (
    IDGrupo smallint FOREIGN KEY REFERENCES Grupo(IDGrupo),
    IDReto smallint FOREIGN KEY REFERENCES Reto(IDReto),
    Fecha_creacion date NOT NULL,
    Fecha_completado date NULL,
    IDEstado smallint FOREIGN KEY REFERENCES Estado(IDEstado),
    PRIMARY KEY (IDGrupo, IDReto)
);

CREATE TABLE Sesion_virtual (
    IDSesion smallint PRIMARY KEY,
    FechaHora_inicio datetime NOT NULL,
    Duracion decimal(5, 2) NOT NULL,
    IDMembresia smallint FOREIGN KEY REFERENCES Membresia(IDMembresia)
);

CREATE TABLE Canje (
    IDCanje smallint PRIMARY KEY,
    Cantidad int NOT NULL,
    Fecha_canje date NOT NULL,
    Descripcion nvarchar(max) NOT NULL,
    IDMiembro_Sucursal smallint FOREIGN KEY REFERENCES Miembro_Sucursal(IDMiembro_Sucursal)
);

CREATE TABLE Miembro_Grupo (
    IDGrupo smallint FOREIGN KEY REFERENCES Grupo(IDGrupo),
    IDMiembro smallint FOREIGN KEY REFERENCES Miembro(IDMiembro),
    Fecha_entrada date NOT NULL,
    Fecha_salida date NULL,
    esLider bit NOT NULL,
    PRIMARY KEY (IDGrupo, IDMiembro)
);