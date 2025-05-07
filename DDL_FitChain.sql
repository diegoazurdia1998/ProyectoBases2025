USE [FitChain]
GO
/****** Object:  Table [dbo].[Asistencia]    Script Date: 7/05/2025 11:39:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Asistencia](
	[IDAsistencia] [smallint] NOT NULL,
	[IDMiembro_Sucursal] [smallint] NOT NULL,
	[FechaHora_Entrada] [datetime] NOT NULL,
	[FechaHora_Salida] [datetime] NOT NULL,
	[Acceso] [int] NOT NULL,
 CONSTRAINT [PK_Asistencia] PRIMARY KEY CLUSTERED 
(
	[IDAsistencia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ciudad]    Script Date: 7/05/2025 11:39:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ciudad](
	[IDCiudad] [smallint] NOT NULL,
	[Nombre] [nvarchar](350) NOT NULL,
	[IDPais] [smallint] NOT NULL,
 CONSTRAINT [PK_Ciudad] PRIMARY KEY CLUSTERED 
(
	[IDCiudad] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Estado]    Script Date: 7/05/2025 11:39:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Estado](
	[IDEstado] [smallint] NOT NULL,
	[Nombre] [nvarchar](150) NOT NULL,
 CONSTRAINT [PK_Estado] PRIMARY KEY CLUSTERED 
(
	[IDEstado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Genero]    Script Date: 7/05/2025 11:39:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Genero](
	[IDGenero] [smallint] NOT NULL,
	[Nombre] [nvarchar](250) NOT NULL,
 CONSTRAINT [PK_Genero] PRIMARY KEY CLUSTERED 
(
	[IDGenero] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Grupo]    Script Date: 7/05/2025 11:39:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Grupo](
	[IDGrupo] [smallint] NOT NULL,
	[Nombre] [nvarchar](150) NOT NULL,
	[Fecha_creacion] [date] NOT NULL,
 CONSTRAINT [PK_Grupo] PRIMARY KEY CLUSTERED 
(
	[IDGrupo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Membresia]    Script Date: 7/05/2025 11:39:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Membresia](
	[IDMembresia] [smallint] NOT NULL,
	[Fecha_Inicio] [date] NOT NULL,
	[Fecha_fin] [date] NOT NULL,
	[IDMiembro] [smallint] NOT NULL,
	[IDTipo_Membresia] [smallint] NOT NULL,
 CONSTRAINT [PK_Membresia] PRIMARY KEY CLUSTERED 
(
	[IDMembresia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Metodo_Acceso]    Script Date: 7/05/2025 11:39:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Metodo_Acceso](
	[IDMetodo_Acceso] [nchar](10) NULL,
	[Nombre] [nchar](10) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Miembro]    Script Date: 7/05/2025 11:39:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
 CONSTRAINT [PK_Ususario] PRIMARY KEY CLUSTERED 
(
	[IDMiembro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Miembro_Grupo]    Script Date: 7/05/2025 11:39:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Miembro_Grupo](
	[IDGrupo] [smallint] NOT NULL,
	[IDMiembro] [smallint] NOT NULL,
	[Fecha_entrada] [date] NOT NULL,
	[Fecha_salida] [date] NULL,
	[esLider] [bit] NOT NULL,
 CONSTRAINT [PK_Miembro_Grupo] PRIMARY KEY CLUSTERED 
(
	[IDGrupo] ASC,
	[IDMiembro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Miembro_reto]    Script Date: 7/05/2025 11:39:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Miembro_reto](
	[IDMiembro] [smallint] NOT NULL,
	[IDReto] [smallint] NOT NULL,
	[Progreso] [decimal](4, 2) NOT NULL,
	[Fecha_inscripcion] [datetime] NOT NULL,
	[Fecha_completado] [datetime] NULL,
	[IDEstado] [smallint] NOT NULL,
 CONSTRAINT [PK_Miembro_reto] PRIMARY KEY CLUSTERED 
(
	[IDMiembro] ASC,
	[IDReto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Miembro_Sucursal]    Script Date: 7/05/2025 11:39:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Miembro_Sucursal](
	[IDMiembro_Sucursal] [smallint] NOT NULL,
	[Fecha_inicio] [date] NOT NULL,
	[Fecha_cancelacion] [date] NULL,
	[esPrincipal] [bit] NOT NULL,
	[IDSucursal] [smallint] NOT NULL,
	[IDMiembro] [smallint] NOT NULL,
 CONSTRAINT [PK_Memebresia] PRIMARY KEY CLUSTERED 
(
	[IDMiembro_Sucursal] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Origen]    Script Date: 7/05/2025 11:39:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Origen](
	[IDOrigen] [smallint] NOT NULL,
	[Descripcion] [nvarchar](150) NOT NULL,
	[IDReto] [smallint] NULL,
 CONSTRAINT [PK_Origen] PRIMARY KEY CLUSTERED 
(
	[IDOrigen] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Pago]    Script Date: 7/05/2025 11:39:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pago](
	[IDPago] [smallint] NOT NULL,
	[Fecha_trasaccion] [date] NOT NULL,
	[Monto_abonado] [decimal](9, 2) NOT NULL,
	[IDMembresia] [smallint] NOT NULL,
 CONSTRAINT [PK_Pago] PRIMARY KEY CLUSTERED 
(
	[IDPago] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Pais]    Script Date: 7/05/2025 11:39:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pais](
	[IDPais] [smallint] NOT NULL,
	[Nombre] [nvarchar](350) NOT NULL,
 CONSTRAINT [PK_Pais] PRIMARY KEY CLUSTERED 
(
	[IDPais] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Punteo]    Script Date: 7/05/2025 11:39:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Punteo](
	[IDPunteo] [smallint] NOT NULL,
	[Cantidad] [int] NOT NULL,
	[Fecha_obtenido] [date] NOT NULL,
	[Fecha_vencido] [date] NULL,
	[IDOrigen] [smallint] NOT NULL,
	[IDMiembro] [smallint] NOT NULL,
	[estaActivo] [bit] NOT NULL,
 CONSTRAINT [PK_Punteo] PRIMARY KEY CLUSTERED 
(
	[IDPunteo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reto]    Script Date: 7/05/2025 11:39:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
 CONSTRAINT [PK_Reto] PRIMARY KEY CLUSTERED 
(
	[IDReto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reto_Grupal]    Script Date: 7/05/2025 11:39:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reto_Grupal](
	[IDGrupo] [smallint] NOT NULL,
	[IDReto] [smallint] NOT NULL,
	[Fecha_creacion] [date] NOT NULL,
	[Fecha_completado] [date] NULL,
	[IDEstado] [smallint] NOT NULL,
 CONSTRAINT [PK_RetoGrupal] PRIMARY KEY CLUSTERED 
(
	[IDGrupo] ASC,
	[IDReto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sucursal]    Script Date: 7/05/2025 11:39:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sucursal](
	[IDSucursal] [smallint] NOT NULL,
	[Nombre] [nvarchar](150) NOT NULL,
	[Capacidad] [smallint] NOT NULL,
	[Direccion] [nvarchar](max) NOT NULL,
	[IDCiudad] [smallint] NOT NULL,
 CONSTRAINT [PK_Sucursal] PRIMARY KEY CLUSTERED 
(
	[IDSucursal] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tipo_Membresia]    Script Date: 7/05/2025 11:39:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tipo_Membresia](
	[IDTipo_Membresia] [smallint] NOT NULL,
	[Nombre] [nvarchar](25) NOT NULL,
 CONSTRAINT [PK_TipoMembresia] PRIMARY KEY CLUSTERED 
(
	[IDTipo_Membresia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Unidad_medicion]    Script Date: 7/05/2025 11:39:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Unidad_medicion](
	[IDUnidadMedicion] [smallint] NOT NULL,
	[Nombre] [nvarchar](100) NOT NULL,
	[Simbolo] [nvarchar](5) NOT NULL,
 CONSTRAINT [PK_Unidad_medicion] PRIMARY KEY CLUSTERED 
(
	[IDUnidadMedicion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Asistencia]  WITH CHECK ADD  CONSTRAINT [FK_Asistencia_Miembro_Sucursal] FOREIGN KEY([IDMiembro_Sucursal])
REFERENCES [dbo].[Miembro_Sucursal] ([IDMiembro_Sucursal])
GO
ALTER TABLE [dbo].[Asistencia] CHECK CONSTRAINT [FK_Asistencia_Miembro_Sucursal]
GO
ALTER TABLE [dbo].[Ciudad]  WITH NOCHECK ADD  CONSTRAINT [FK_Ciudad_Pais] FOREIGN KEY([IDPais])
REFERENCES [dbo].[Pais] ([IDPais])
GO
ALTER TABLE [dbo].[Ciudad] NOCHECK CONSTRAINT [FK_Ciudad_Pais]
GO
ALTER TABLE [dbo].[Membresia]  WITH CHECK ADD  CONSTRAINT [FK_Membresia_Miembro] FOREIGN KEY([IDMiembro])
REFERENCES [dbo].[Miembro] ([IDMiembro])
GO
ALTER TABLE [dbo].[Membresia] CHECK CONSTRAINT [FK_Membresia_Miembro]
GO
ALTER TABLE [dbo].[Membresia]  WITH CHECK ADD  CONSTRAINT [FK_Membresia_Tipo_Membresia] FOREIGN KEY([IDTipo_Membresia])
REFERENCES [dbo].[Tipo_Membresia] ([IDTipo_Membresia])
GO
ALTER TABLE [dbo].[Membresia] CHECK CONSTRAINT [FK_Membresia_Tipo_Membresia]
GO
ALTER TABLE [dbo].[Miembro]  WITH NOCHECK ADD  CONSTRAINT [FK_Miembro_Genero] FOREIGN KEY([IDGenero])
REFERENCES [dbo].[Genero] ([IDGenero])
GO
ALTER TABLE [dbo].[Miembro] NOCHECK CONSTRAINT [FK_Miembro_Genero]
GO
ALTER TABLE [dbo].[Miembro_Grupo]  WITH NOCHECK ADD  CONSTRAINT [FK_Miembro_Grupo_Grupo] FOREIGN KEY([IDGrupo])
REFERENCES [dbo].[Grupo] ([IDGrupo])
GO
ALTER TABLE [dbo].[Miembro_Grupo] NOCHECK CONSTRAINT [FK_Miembro_Grupo_Grupo]
GO
ALTER TABLE [dbo].[Miembro_Grupo]  WITH NOCHECK ADD  CONSTRAINT [FK_Miembro_Grupo_Miembro] FOREIGN KEY([IDMiembro])
REFERENCES [dbo].[Miembro] ([IDMiembro])
GO
ALTER TABLE [dbo].[Miembro_Grupo] NOCHECK CONSTRAINT [FK_Miembro_Grupo_Miembro]
GO
ALTER TABLE [dbo].[Miembro_reto]  WITH NOCHECK ADD  CONSTRAINT [FK_Miembro_reto_Estado] FOREIGN KEY([IDEstado])
REFERENCES [dbo].[Estado] ([IDEstado])
GO
ALTER TABLE [dbo].[Miembro_reto] NOCHECK CONSTRAINT [FK_Miembro_reto_Estado]
GO
ALTER TABLE [dbo].[Miembro_reto]  WITH NOCHECK ADD  CONSTRAINT [FK_Miembro_reto_Miembro] FOREIGN KEY([IDMiembro])
REFERENCES [dbo].[Miembro] ([IDMiembro])
GO
ALTER TABLE [dbo].[Miembro_reto] NOCHECK CONSTRAINT [FK_Miembro_reto_Miembro]
GO
ALTER TABLE [dbo].[Miembro_reto]  WITH NOCHECK ADD  CONSTRAINT [FK_Miembro_reto_Reto] FOREIGN KEY([IDReto])
REFERENCES [dbo].[Reto] ([IDReto])
GO
ALTER TABLE [dbo].[Miembro_reto] NOCHECK CONSTRAINT [FK_Miembro_reto_Reto]
GO
ALTER TABLE [dbo].[Miembro_Sucursal]  WITH NOCHECK ADD  CONSTRAINT [FK_Memebresia_Sucursal] FOREIGN KEY([IDSucursal])
REFERENCES [dbo].[Sucursal] ([IDSucursal])
GO
ALTER TABLE [dbo].[Miembro_Sucursal] NOCHECK CONSTRAINT [FK_Memebresia_Sucursal]
GO
ALTER TABLE [dbo].[Miembro_Sucursal]  WITH NOCHECK ADD  CONSTRAINT [FK_Memebresia_Ususario] FOREIGN KEY([IDMiembro])
REFERENCES [dbo].[Miembro] ([IDMiembro])
GO
ALTER TABLE [dbo].[Miembro_Sucursal] NOCHECK CONSTRAINT [FK_Memebresia_Ususario]
GO
ALTER TABLE [dbo].[Origen]  WITH NOCHECK ADD  CONSTRAINT [FK_Origen_Reto] FOREIGN KEY([IDReto])
REFERENCES [dbo].[Reto] ([IDReto])
GO
ALTER TABLE [dbo].[Origen] NOCHECK CONSTRAINT [FK_Origen_Reto]
GO
ALTER TABLE [dbo].[Pago]  WITH CHECK ADD  CONSTRAINT [FK_Pago_Membresia] FOREIGN KEY([IDMembresia])
REFERENCES [dbo].[Membresia] ([IDMembresia])
GO
ALTER TABLE [dbo].[Pago] CHECK CONSTRAINT [FK_Pago_Membresia]
GO
ALTER TABLE [dbo].[Punteo]  WITH NOCHECK ADD  CONSTRAINT [FK_Punteo_Miembro] FOREIGN KEY([IDMiembro])
REFERENCES [dbo].[Miembro] ([IDMiembro])
GO
ALTER TABLE [dbo].[Punteo] NOCHECK CONSTRAINT [FK_Punteo_Miembro]
GO
ALTER TABLE [dbo].[Punteo]  WITH NOCHECK ADD  CONSTRAINT [FK_Punteo_Origen] FOREIGN KEY([IDOrigen])
REFERENCES [dbo].[Origen] ([IDOrigen])
GO
ALTER TABLE [dbo].[Punteo] NOCHECK CONSTRAINT [FK_Punteo_Origen]
GO
ALTER TABLE [dbo].[Reto]  WITH NOCHECK ADD  CONSTRAINT [FK_Reto_Sucursal] FOREIGN KEY([IDSucursal])
REFERENCES [dbo].[Sucursal] ([IDSucursal])
GO
ALTER TABLE [dbo].[Reto] NOCHECK CONSTRAINT [FK_Reto_Sucursal]
GO
ALTER TABLE [dbo].[Reto]  WITH NOCHECK ADD  CONSTRAINT [FK_Reto_Unidad_medicion] FOREIGN KEY([IDUnidadMedicion])
REFERENCES [dbo].[Unidad_medicion] ([IDUnidadMedicion])
GO
ALTER TABLE [dbo].[Reto] NOCHECK CONSTRAINT [FK_Reto_Unidad_medicion]
GO
ALTER TABLE [dbo].[Reto_Grupal]  WITH NOCHECK ADD  CONSTRAINT [FK_RetoGrupal_Estado] FOREIGN KEY([IDEstado])
REFERENCES [dbo].[Estado] ([IDEstado])
GO
ALTER TABLE [dbo].[Reto_Grupal] NOCHECK CONSTRAINT [FK_RetoGrupal_Estado]
GO
ALTER TABLE [dbo].[Reto_Grupal]  WITH NOCHECK ADD  CONSTRAINT [FK_RetoGrupal_Grupo] FOREIGN KEY([IDGrupo])
REFERENCES [dbo].[Grupo] ([IDGrupo])
GO
ALTER TABLE [dbo].[Reto_Grupal] NOCHECK CONSTRAINT [FK_RetoGrupal_Grupo]
GO
ALTER TABLE [dbo].[Reto_Grupal]  WITH NOCHECK ADD  CONSTRAINT [FK_RetoGrupal_Reto] FOREIGN KEY([IDReto])
REFERENCES [dbo].[Reto] ([IDReto])
GO
ALTER TABLE [dbo].[Reto_Grupal] NOCHECK CONSTRAINT [FK_RetoGrupal_Reto]
GO
ALTER TABLE [dbo].[Sucursal]  WITH NOCHECK ADD  CONSTRAINT [FK_Sucursal_Ciudad] FOREIGN KEY([IDCiudad])
REFERENCES [dbo].[Ciudad] ([IDCiudad])
GO
ALTER TABLE [dbo].[Sucursal] NOCHECK CONSTRAINT [FK_Sucursal_Ciudad]
GO
