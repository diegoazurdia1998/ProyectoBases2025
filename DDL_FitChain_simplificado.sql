USE [FitChain]
GO

CREATE TABLE [dbo].[Pais](
    [IDPais] [smallint] NOT NULL,
    [Nombre] [nvarchar](350) NOT NULL,
    CONSTRAINT [PK_Pais] PRIMARY KEY ([IDPais])
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Estado](
    [IDEstado] [smallint] NOT NULL,
    [Nombre] [nvarchar](150) NOT NULL,
    CONSTRAINT [PK_Estado] PRIMARY KEY ([IDEstado])
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Genero](
    [IDGenero] [smallint] NOT NULL,
    [Nombre] [nvarchar](250) NOT NULL,
    CONSTRAINT [PK_Genero] PRIMARY KEY ([IDGenero])
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Unidad_medicion](
    [IDUnidadMedicion] [smallint] NOT NULL,
    [Nombre] [nvarchar](100) NOT NULL,
    [Simbolo] [nvarchar](5) NOT NULL,
    CONSTRAINT [PK_Unidad_medicion] PRIMARY KEY ([IDUnidadMedicion])
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Tipo_Membresia](
    [IDTipo_Membresia] [smallint] NOT NULL,
    [Nombre] [nvarchar](25) NOT NULL,
    CONSTRAINT [PK_TipoMembresia] PRIMARY KEY ([IDTipo_Membresia])
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Ciudad](
    [IDCiudad] [smallint] NOT NULL,
    [Nombre] [nvarchar](350) NOT NULL,
    [IDPais] [smallint] NOT NULL,
    CONSTRAINT [PK_Ciudad] PRIMARY KEY ([IDCiudad])
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Sucursal](
    [IDSucursal] [smallint] NOT NULL,
    [Nombre] [nvarchar](150) NOT NULL,
    [Capacidad] [smallint] NOT NULL,
    [Direccion] [nvarchar](max) NOT NULL,
    [IDCiudad] [smallint] NOT NULL,
    CONSTRAINT [PK_Sucursal] PRIMARY KEY ([IDSucursal])
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[Miembro](
    [IDMiembro] [smallint] NOT NULL,
    [Nombre1] [nvarchar](150) NOT NULL,
    [Nombre2] [nvarchar](150) NULL,
    [Apellido1] [nvarchar](150) NOT NULL,
    [Apellido2] [nvarchar](150) NULL,
    [Identificacion] [nvarchar](13) NULL,
    [Fecha_registro] [date] NOT NULL,
    [Fecha_nacimiento] [date] NOT NULL,
    [IDGenero] [smallint] NULL,
    [Altura] [decimal](5, 2) NOT NULL,
    [Peso_inical] [decimal](5, 2) NOT NULL,
    [Condiciones_medicas] [nvarchar](max) NULL,
    [estaSuspendido] [bit] NOT NULL,
    CONSTRAINT [PK_Miembro] PRIMARY KEY ([IDMiembro])
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[Grupo](
    [IDGrupo] [smallint] NOT NULL,
    [Nombre] [nvarchar](150) NOT NULL,
    [Fecha_creacion] [date] NOT NULL,
    [IDSucursal] [smallint] NOT NULL,
    CONSTRAINT [PK_Grupo] PRIMARY KEY ([IDGrupo])
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Reto](
    [IDReto] [smallint] NOT NULL,
    [Nombre] [nvarchar](150) NOT NULL,
    [Descripcion] [nvarchar](max) NOT NULL,
    [Fecha_inicio] [datetime] NOT NULL,
    [Fecha_fin] [date] NOT NULL,
    [Puntos_aganar] [int] NOT NULL,
    [Meta_cantidad] [decimal](6, 2) NOT NULL,
    [IDUnidadMedicion] [smallint] NOT NULL,
    [IDSucursal] [smallint] NULL,
    [esGrupal] [bit] NOT NULL,
    CONSTRAINT [PK_Reto] PRIMARY KEY ([IDReto])
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[Origen](
    [IDOrigen] [smallint] NOT NULL,
    [Descripcion] [nvarchar](150) NOT NULL,
    [IDReto] [smallint] NULL,
    CONSTRAINT [PK_Origen] PRIMARY KEY ([IDOrigen])
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Miembro_Sucursal](
    [IDMiembro_Sucursal] [smallint] NOT NULL,
    [Fecha_inicio] [date] NOT NULL,
    [Fecha_cancelacion] [date] NULL,
    [esPrincipal] [bit] NOT NULL,
    [IDSucursal] [smallint] NOT NULL,
    [IDMiembro] [smallint] NOT NULL,
    CONSTRAINT [PK_Miembro_Sucursal] PRIMARY KEY ([IDMiembro_Sucursal])
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Membresia](
    [IDMembresia] [smallint] NOT NULL,
    [Fecha_Inicio] [date] NOT NULL,
    [Fecha_fin] [date] NOT NULL,
    [IDMiembro] [smallint] NOT NULL,
    [IDTipo_Membresia] [smallint] NOT NULL,
    CONSTRAINT [PK_Membresia] PRIMARY KEY ([IDMembresia])
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Miembro_Grupo](
    [IDGrupo] [smallint] NOT NULL,
    [IDMiembro] [smallint] NOT NULL,
    [Fecha_entrada] [date] NOT NULL,
    [Fecha_salida] [date] NULL,
    [esLider] [bit] NOT NULL,
    CONSTRAINT [PK_Miembro_Grupo] PRIMARY KEY ([IDGrupo], [IDMiembro])
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Reto_Grupal](
    [IDGrupo] [smallint] NOT NULL,
    [IDReto] [smallint] NOT NULL,
    [Fecha_creacion] [date] NOT NULL,
    [Fecha_completado] [date] NULL,
    [IDEstado] [smallint] NOT NULL,
    CONSTRAINT [PK_RetoGrupal] PRIMARY KEY ([IDGrupo], [IDReto])
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Miembro_reto](
    [IDMiembro] [smallint] NOT NULL,
    [IDReto] [smallint] NOT NULL,
    [Progreso] [decimal](4, 2) NOT NULL,
    [Fecha_inscripcion] [datetime] NOT NULL,
    [Fecha_completado] [datetime] NULL,
    [IDEstado] [smallint] NOT NULL,
    CONSTRAINT [PK_Miembro_reto] PRIMARY KEY ([IDMiembro], [IDReto])
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Punteo](
    [IDPunteo] [smallint] NOT NULL,
    [Cantidad] [int] NOT NULL,
    [Fecha_obtenido] [date] NOT NULL,
    [Fecha_vencido] [date] NULL,
    [IDOrigen] [smallint] NOT NULL,
    [IDMiembro] [smallint] NOT NULL,
    [estaActivo] [bit] NOT NULL,
    CONSTRAINT [PK_Punteo] PRIMARY KEY ([IDPunteo])
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Asistencia](
    [IDAsistencia] [smallint] NOT NULL,
    [IDMiembro_Sucursal] [smallint] NOT NULL,
    [FechaHora_Entrada] [datetime] NOT NULL,
    [FechaHora_Salida] [datetime] NOT NULL,
    [Acceso] [int] NOT NULL,
    CONSTRAINT [PK_Asistencia] PRIMARY KEY ([IDAsistencia])
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Canje](
    [IDCanje] [smallint] NOT NULL,
    [Cantidad] [int] NOT NULL,
    [Fecha_canje] [date] NOT NULL,
    [Descripcion] [nvarchar](max) NOT NULL,
    [IDMiembro_Sucursal] [smallint] NOT NULL,
    CONSTRAINT [PK_Canje] PRIMARY KEY ([IDCanje])
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[Pago](
    [IDPago] [smallint] NOT NULL,
    [Fecha_trasaccion] [date] NOT NULL,
    [Monto_abonado] [decimal](9, 2) NOT NULL,
    [IDMembresia] [smallint] NOT NULL,
    CONSTRAINT [PK_Pago] PRIMARY KEY ([IDPago])
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Sesion_virtual](
    [IDSesion] [smallint] NOT NULL,
    [FechaHora_inicio] [datetime] NOT NULL,
    [Duracion] [decimal](5, 2) NOT NULL,
    [IDMembresia] [smallint] NOT NULL,
    CONSTRAINT [PK_Sesion_virtual] PRIMARY KEY ([IDSesion])
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Asistencia] ADD CONSTRAINT [FK_Asistencia_Miembro_Sucursal] FOREIGN KEY([IDMiembro_Sucursal])
REFERENCES [dbo].[Miembro_Sucursal] ([IDMiembro_Sucursal])
GO

ALTER TABLE [dbo].[Canje] ADD CONSTRAINT [FK_Canje_Miembro_Sucursal] FOREIGN KEY([IDMiembro_Sucursal])
REFERENCES [dbo].[Miembro_Sucursal] ([IDMiembro_Sucursal])
GO

ALTER TABLE [dbo].[Ciudad] ADD CONSTRAINT [FK_Ciudad_Pais] FOREIGN KEY([IDPais])
REFERENCES [dbo].[Pais] ([IDPais])
GO

ALTER TABLE [dbo].[Grupo] ADD CONSTRAINT [FK_Grupo_Sucursal] FOREIGN KEY([IDSucursal])
REFERENCES [dbo].[Sucursal] ([IDSucursal])
GO

ALTER TABLE [dbo].[Membresia] ADD CONSTRAINT [FK_Membresia_Miembro] FOREIGN KEY([IDMiembro])
REFERENCES [dbo].[Miembro] ([IDMiembro])
GO

ALTER TABLE [dbo].[Membresia] ADD CONSTRAINT [FK_Membresia_Tipo_Membresia] FOREIGN KEY([IDTipo_Membresia])
REFERENCES [dbo].[Tipo_Membresia] ([IDTipo_Membresia])
GO

ALTER TABLE [dbo].[Miembro] ADD CONSTRAINT [FK_Miembro_Genero] FOREIGN KEY([IDGenero])
REFERENCES [dbo].[Genero] ([IDGenero])
GO

ALTER TABLE [dbo].[Miembro_Grupo] ADD CONSTRAINT [FK_Miembro_Grupo_Grupo] FOREIGN KEY([IDGrupo])
REFERENCES [dbo].[Grupo] ([IDGrupo])
GO

ALTER TABLE [dbo].[Miembro_Grupo] ADD CONSTRAINT [FK_Miembro_Grupo_Miembro] FOREIGN KEY([IDMiembro])
REFERENCES [dbo].[Miembro] ([IDMiembro])
GO

ALTER TABLE [dbo].[Miembro_reto] ADD CONSTRAINT [FK_Miembro_reto_Estado] FOREIGN KEY([IDEstado])
REFERENCES [dbo].[Estado] ([IDEstado])
GO

ALTER TABLE [dbo].[Miembro_reto] ADD CONSTRAINT [FK_Miembro_reto_Miembro] FOREIGN KEY([IDMiembro])
REFERENCES [dbo].[Miembro] ([IDMiembro])
GO

ALTER TABLE [dbo].[Miembro_reto] ADD CONSTRAINT [FK_Miembro_reto_Reto] FOREIGN KEY([IDReto])
REFERENCES [dbo].[Reto] ([IDReto])
GO

ALTER TABLE [dbo].[Miembro_Sucursal] ADD CONSTRAINT [FK_Miembro_Sucursal_Sucursal] FOREIGN KEY([IDSucursal])
REFERENCES [dbo].[Sucursal] ([IDSucursal])
GO

ALTER TABLE [dbo].[Miembro_Sucursal] ADD CONSTRAINT [FK_Miembro_Sucursal_Miembro] FOREIGN KEY([IDMiembro])
REFERENCES [dbo].[Miembro] ([IDMiembro])
GO

ALTER TABLE [dbo].[Origen] ADD CONSTRAINT [FK_Origen_Reto] FOREIGN KEY([IDReto])
REFERENCES [dbo].[Reto] ([IDReto])
GO

ALTER TABLE [dbo].[Pago] ADD CONSTRAINT [FK_Pago_Membresia] FOREIGN KEY([IDMembresia])
REFERENCES [dbo].[Membresia] ([IDMembresia])
GO

ALTER TABLE [dbo].[Punteo] ADD CONSTRAINT [FK_Punteo_Miembro] FOREIGN KEY([IDMiembro])
REFERENCES [dbo].[Miembro] ([IDMiembro])
GO

ALTER TABLE [dbo].[Punteo] ADD CONSTRAINT [FK_Punteo_Origen] FOREIGN KEY([IDOrigen])
REFERENCES [dbo].[Origen] ([IDOrigen])
GO

ALTER TABLE [dbo].[Reto] ADD CONSTRAINT [FK_Reto_Sucursal] FOREIGN KEY([IDSucursal])
REFERENCES [dbo].[Sucursal] ([IDSucursal])
GO

ALTER TABLE [dbo].[Reto] ADD CONSTRAINT [FK_Reto_Unidad_medicion] FOREIGN KEY([IDUnidadMedicion])
REFERENCES [dbo].[Unidad_medicion] ([IDUnidadMedicion])
GO

ALTER TABLE [dbo].[Reto_Grupal] ADD CONSTRAINT [FK_RetoGrupal_Estado] FOREIGN KEY([IDEstado])
REFERENCES [dbo].[Estado] ([IDEstado])
GO

ALTER TABLE [dbo].[Reto_Grupal] ADD CONSTRAINT [FK_RetoGrupal_Grupo] FOREIGN KEY([IDGrupo])
REFERENCES [dbo].[Grupo] ([IDGrupo])
GO

ALTER TABLE [dbo].[Reto_Grupal] ADD CONSTRAINT [FK_RetoGrupal_Reto] FOREIGN KEY([IDReto])
REFERENCES [dbo].[Reto] ([IDReto])
GO

ALTER TABLE [dbo].[Sesion_virtual] ADD CONSTRAINT [FK_Sesion_virtual_Membresia] FOREIGN KEY([IDMembresia])
REFERENCES [dbo].[Membresia] ([IDMembresia])
GO

ALTER TABLE [dbo].[Sucursal] ADD CONSTRAINT [FK_Sucursal_Ciudad] FOREIGN KEY([IDCiudad])
REFERENCES [dbo].[Ciudad] ([IDCiudad])