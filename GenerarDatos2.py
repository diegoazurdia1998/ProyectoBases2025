import pandas as pd
from faker import Faker
import random
from datetime import datetime, date, timedelta
import os


class FitChainGenerator:
    def __init__(self, output_dir = "scripts_dml/V7"):
        self.fake = Faker('es_ES')
        random.seed(42)  # Para reproducibilidad

        self.output_dir = output_dir  # Nuevo: directorio personalizable
        os.makedirs(self.output_dir, exist_ok=True)  # Crea el directorio si no existe

        # DataFrames para cada tabla (inicializados como None)
        self.genero = None
        self.pais = None
        self.ciudad = None
        self.condicion_medica = None
        self.estado = None
        self.tipo_membresia = None
        self.tipo_acceso = None
        self.unidad_medicion = None
        self.miembro = None
        self.sucursal = None
        self.grupo = None
        self.reto = None
        self.origen = None
        self.membresia = None
        self.miembro_sucursal = None
        self.miembro_acceso = None
        self.asistencia = None
        self.pago = None
        self.pesaje = None
        self.punteo = None
        self.miembro_reto = None
        self.reto_grupal = None
        self.sesion_virtual = None
        self.canje = None
        self.miembro_grupo = None


    def generar_fechas_coherentes(self, fecha_min, fecha_max):
        """Genera fechas aleatorias dentro de un rango, asegurando coherencia."""
        return self.fake.date_between(start_date=fecha_min, end_date=fecha_max)

    def guardar_sql(self, df, table_name):
        """Guarda datos en archivos SQL individuales y consolidado."""
        os.makedirs(self.output_dir, exist_ok=True)
        file_path = os.path.join(
            self.output_dir,
            f"{table_name}.sql"
        )

        # Preparar columnas
        columns = ", ".join(df.columns)
        record_count = len(df)

        # Función para procesar valores
        def procesar_valor(v):
            if pd.isna(v):
                return "NULL"
            elif isinstance(v, bool):
                return "1" if v else "0"
            elif isinstance(v, str):
                return f"'{v.replace("'", "''")}'"
            elif isinstance(v, pd.Timestamp):
                return f"'{v.strftime('%d-%m-%Y')}'"
            elif hasattr(v, 'strftime'):
                return f"'{v.strftime('%d-%m-%Y')}'"
            else:
                return str(v)

        # Archivo individual
        with open(file_path, "w", encoding="utf-8") as f:
            f.write(f"-- Generando {record_count} registros para {table_name}\n")

            # Procesar en lotes de 1000 filas
            batch_size = 1000
            for i in range(0, len(df), batch_size):
                batch = df.iloc[i:i + batch_size]
                values_list = []
                for _, row in batch.iterrows():
                    processed_values = [procesar_valor(v) for v in row]
                    values_list.append(f"({', '.join(processed_values)})")

                f.write(f"INSERT INTO {table_name} ({columns}) VALUES\n")
                f.write(",\n".join(values_list) + ";\n\n")


    def generar_archivo_sql_completo(self):
        full_path = os.path.join(self.output_dir, "FitChain_FullData.sql")
        with open(full_path, "w", encoding="utf-8") as f:
            f.write("-- SCRIPT COMPLETO DE INSERCIÓN DE DATOS FITCHAIN (Nivel 1 → Nivel 2 → Nivel 3)\n")
            f.write("-- Generado automáticamente el: " + datetime.now().strftime("%Y-%m-%d %H:%M:%S") + "\n\n")

            # Función auxiliar para procesar valores
            def procesar_valor(v):
                if pd.isna(v):
                    return "NULL"
                elif isinstance(v, bool):
                    return "1" if v else "0"
                elif isinstance(v, str):
                    return f"'{v.replace("'", "''")}'"
                elif isinstance(v, pd.Timestamp):
                    return f"'{v.strftime('%Y-%m-%d')}'"  # Cambiado a formato YYYY-MM-DD
                elif hasattr(v, 'strftime'):
                    return f"'{v.strftime('%Y-%m-%d')}'"  # Cambiado a formato YYYY-MM-DD
                else:
                    return str(v)

            # Función para escribir datos de una tabla en lotes
            def escribir_tabla(tabla, df):
                record_count = len(df)
                f.write(f"\n-- Datos para {tabla} ({record_count} registros)\n")
                columns = ", ".join(df.columns)

                # Procesar en lotes de 1000 filas
                batch_size = 1000
                for i in range(0, len(df), batch_size):
                    batch = df.iloc[i:i + batch_size]
                    values_list = []
                    for _, row in batch.iterrows():
                        processed_values = [procesar_valor(v) for v in row]
                        values_list.append(f"({', '.join(processed_values)})")

                    f.write(f"INSERT INTO {tabla} ({columns}) VALUES\n")
                    f.write(",\n".join(values_list) + ";\n")

            # --- Nivel 1: Tablas sin dependencias ---
            f.write("\n-- ========== NIVEL 1: DATOS BÁSICOS ==========\n")
            tablas_nivel_1 = [
                "Genero", "Pais", "Ciudad", "Condicion_Medica",
                "Estado", "Tipo_Membresia", "Tipo_Acceso", "Unidad_medicion"
            ]
            for tabla in tablas_nivel_1:
                df = getattr(self, tabla.lower())
                escribir_tabla(tabla, df)

            # --- Nivel 2: Tablas con dependencias del Nivel 1 ---
            f.write("\n-- ========== NIVEL 2: DATOS CON DEPENDENCIAS ==========\n")
            tablas_nivel_2 = [
                "Miembro", "Sucursal", "Grupo", "Reto", "Origen"
            ]
            for tabla in tablas_nivel_2:
                df = getattr(self, tabla.lower())
                escribir_tabla(tabla, df)

            # --- Nivel 3: Tablas transaccionales ---
            f.write("\n-- ========== NIVEL 3: DATOS TRANSACCIONALES ==========\n")
            tablas_nivel_3 = [
                "Membresia", "Miembro_Sucursal", "Miembro_Acceso", "Asistencia",
                "Pago", "Pesaje", "Punteo", "Miembro_reto", "Reto_Grupal",
                "Sesion_virtual", "Canje", "Miembro_Grupo"
            ]
            for tabla in tablas_nivel_3:
                df = getattr(self, tabla.lower())
                escribir_tabla(tabla, df)

            # Resumen total
            total_tables = len(tablas_nivel_1) + len(tablas_nivel_2) + len(tablas_nivel_3)
            f.write(f"\n-- RESUMEN: Se generaron datos para {total_tables} tablas\n")
            f.write("-- FIN DEL SCRIPT\n")

        print("✅ Archivo 'FitChain_FullData.sql' generado con éxito.")

# GENERACION DE DATOS NIVEL 1
    def generar_genero(self):
        self.genero = pd.DataFrame([
            {"IDGenero": 1, "Nombre": "Masculino"},
            {"IDGenero": 2, "Nombre": "Femenino"},
            {"IDGenero": 3, "Nombre": "No binario"},
            {"IDGenero": 4, "Nombre": "Prefiero no especificar"}  # Nuevo género añadido
        ])
        self.guardar_sql(self.genero, "Genero")
        print(f"✅ Tabla 'Genero' generada con {len(self.genero)} registros.")

    def generar_pais(self):
        self.pais = pd.DataFrame([
            {"IDPais": 1, "Nombre": "Guatemala"},  # Código ISO opcional
            {"IDPais": 2, "Nombre": "México"},
            {"IDPais": 3, "Nombre": "Estados Unidos"}
        ])
        self.guardar_sql(self.pais, "Pais")
        print(f"✅ Tabla 'Pais' generada con {len(self.pais)} registros.")


    def generar_ciudad(self):
        ciudades_gt = [
            {"IDCiudad": 1, "Nombre": "Ciudad Zona 16", "IDPais": 1},
            {"IDCiudad": 2, "Nombre": "Quetzaltenango", "IDPais": 1},
            {"IDCiudad": 3, "Nombre": "Antigua Guatemala", "IDPais": 1},
            {"IDCiudad": 4, "Nombre": "Ciudad Zona 15", "IDPais": 1},
            {"IDCiudad": 5, "Nombre": "Ciudad Zona 1", "IDPais": 1},
            {"IDCiudad": 6, "Nombre": "Ciudad Zona 10", "IDPais": 1},
            {"IDCiudad": 7, "Nombre": "Ciudad Zona 2", "IDPais": 1},
            {"IDCiudad": 8, "Nombre": "Ciudad Zona 12", "IDPais": 1}

        ]

        ciudades_mx = [
            {"IDCiudad": 16, "Nombre": "Ciudad de México", "IDPais": 2},
            {"IDCiudad": 17, "Nombre": "Monterrey", "IDPais": 2}
        ]

        ciudades_us = [
            {"IDCiudad": 18, "Nombre": "Miami", "IDPais": 3},
            {"IDCiudad": 19, "Nombre": "Los Ángeles", "IDPais": 3},
            {"IDCiudad": 20, "Nombre": "Nueva York", "IDPais": 3}
        ]

        self.ciudad = pd.DataFrame(ciudades_gt + ciudades_mx + ciudades_us)
        self.guardar_sql(self.ciudad, "Ciudad")
        print(f"✅ Tabla 'Ciudad' generada con {len(self.ciudad)} registros ({len(ciudades_gt)} GT, {len(ciudades_mx)} MX, {len(ciudades_us)} US).")

    def generar_condicion_medica(self):
        self.condicion_medica = pd.DataFrame([
            {"IDCondicion": 1, "Nombre": "Hipertensión", "Descripcion": "Presión arterial alta"},
            {"IDCondicion": 2, "Nombre": "Diabetes", "Descripcion": "Tipo 1 o 2"},
            {"IDCondicion": 3, "Nombre": "Asma", "Descripcion": "Enfermedad respiratoria"},
            {"IDCondicion": 4, "Nombre": "Lesión muscular", "Descripcion": "Esguince o desgarro"}
        ])
        self.guardar_sql(self.condicion_medica, "CondicionMedica")
        print(f"✅ Tabla 'CondicionMedica' generada con {len(self.condicion_medica)} registros.")

    def generar_tipo_membresia(self):
        self.tipo_membresia = pd.DataFrame([
            {
                "IDTipo_Membresia": 1,
                "Nombre": "Básica"
            },
            {
                "IDTipo_Membresia": 2,
                "Nombre": "Premium"
            }
        ])
        self.guardar_sql(self.tipo_membresia, "Tipo_Membresia")
        print(f"✅ Tabla 'Tipo_Membresia' generada con {len(self.tipo_membresia)} registros.")

    def generar_unidad_medicion(self):
        self.unidad_medicion = pd.DataFrame([
            {"IDUnidadMedicion": 1, "Nombre": "Kilómetros", "Simbolo": "km"},
            {"IDUnidadMedicion": 2, "Nombre": "Minutos", "Simbolo": "min"},
            {"IDUnidadMedicion": 3, "Nombre": "Repeticiones", "Simbolo": "rep"},
            {"IDUnidadMedicion": 4, "Nombre": "Calorias", "Simbolo": "cal"}
        ])
        self.guardar_sql(self.unidad_medicion, "Unidad_medicion")
        print(f"✅ Tabla 'Unidad_medicion' generada con {len(self.unidad_medicion)} registros.")

    def generar_tipo_acceso(self):
        self.tipo_acceso = pd.DataFrame([
            {
                "IDTipoAcceso": 1,
                "Nombre": "Huella digital"
            },
            {
                "IDTipoAcceso": 2,
                "Nombre": "Código QR"
            }
        ])
        self.guardar_sql(self.tipo_acceso, "TipoAcceso")
        print(f"✅  Tabla 'TipoAcceso' generada con {len(self.tipo_acceso)} métodos de acceso.")

    def generar_estado(self):
        self.estado = pd.DataFrame([
            {
                "IDEstado": 1,
                "Nombre": "Activo"
            },
            {
                "IDEstado": 2,
                "Nombre": "Completado"
            },
            {
                "IDEstado": 3,
                "Nombre": "Fallido"
            },
            {
                "IDEstado": 4,
                "Nombre": "Suspendido"
            }
        ])
        self.guardar_sql(self.estado, "Estado")
        print(f"✅ Tabla 'Estado' generada con {len(self.estado)} estados posibles.")

    def generar_nivel_1(self):
        self.generar_tipo_membresia()
        self.generar_unidad_medicion()
        self.generar_pais()
        self.generar_ciudad()
        self.generar_genero()
        self.generar_condicion_medica()
        self.generar_tipo_acceso()
        self.generar_estado()
        print("¡Todas las tablas del Nivel 1 generadas con éxito!")

# GENERACION DE DATOS NIVEL 2

    def generar_miembro(self):
        miembros = []
        for id_miembro in range(1, 101):  # 100 miembros
            # Obtener género aleatorio
            genero = random.choice(self.genero["IDGenero"])
            nombre1 = self.fake.first_name_male() if genero == 1 else self.fake.first_name_female() if genero == 2 else self.fake.first_name()

            # Identificación según país (ej: Guatemala = 13 dígitos)
            pais_id = random.choice([1, 2, 3])  # 1: GT, 2: MX, 3: US
            identificacion = (
                self.fake.unique.numerify("#############") if pais_id == 1  # GT
                else self.fake.unique.numerify("############") if pais_id == 2  # MX (RFC)
                else self.fake.unique.numerify("###########")  # US (SSN)
            )

            # Fechas coherentes
            fecha_nacimiento = self.generar_fechas_coherentes(
                fecha_min=datetime.now() - timedelta(days=70 * 365),
                fecha_max=datetime.now() - timedelta(days=18 * 365)
            )
            fecha_registro = self.generar_fechas_coherentes(
                fecha_min=datetime(2022, 1, 1),  # FitChain inició en 2022
                fecha_max=datetime.now()
            )

            # Condición médica (40% de probabilidad)
            tiene_condicion = random.random() < 0.4
            id_condicion = random.choice(self.condicion_medica["IDCondicion"]) if tiene_condicion else None

            miembros.append({
                "IDMiembro": id_miembro,
                "Nombre1": nombre1,
                "Nombre2": self.fake.first_name() if random.random() < 0.3 else None,  # 30% con segundo nombre
                "Apellido1": self.fake.last_name(),
                "Apellido2": self.fake.last_name() if random.random() < 0.5 else None,  # 50% con segundo apellido
                "Identificacion": identificacion,
                "Fecha_registro": fecha_registro,
                "Fecha_nacimiento": fecha_nacimiento,
                "IDGenero": genero,
                "Altura": round(random.uniform(1.48, 2.10), 2),
                "IDCondicion": id_condicion,
                "estaSuspendido": 0  # Inicialmente todos activos
            })

        self.miembro = pd.DataFrame(miembros)
        self.guardar_sql(self.miembro, "Miembro")
        print(f"✅ Tabla 'Miembro' generada con {len(self.miembro)} registros (40% con condiciones médicas).")

    def generar_sucursal(self):
        sucursales = []
        # Sucursales en Guatemala (15)
        ciudades_gt = self.ciudad[self.ciudad["IDPais"] == 1]["IDCiudad"].tolist()
        count_ciudades_gt = len(ciudades_gt)
        for i in range(1, count_ciudades_gt):
            ciudad_id = ciudades_gt[i - 1]
            sucursales.append({
                "IDSucursal": i,
                "Nombre": f"FitChain {i} {self.ciudad[self.ciudad['IDCiudad'] == ciudad_id]['Nombre'].values[0]}",
                "Capacidad": random.randint(300, 500),
                "Direccion": self.fake.address().replace("\n", ", "),
                "IDCiudad": ciudad_id
            })

        # Sucursales en el extranjero (5)
        ciudades_ext = self.ciudad[self.ciudad["IDPais"] != 1]["IDCiudad"].tolist()
        for i in range(len(self.ciudad), len(self.ciudad) + 5):
            ciudad_id = random.choice(ciudades_ext)
            sucursales.append({
                "IDSucursal": i,
                "Nombre": f"FitChain {self.ciudad[self.ciudad['IDCiudad'] == ciudad_id]['Nombre'].values[0]}",
                "Capacidad": random.randint(300, 500),
                "Direccion": self.fake.address().replace("\n", ", "),
                "IDCiudad": ciudad_id
            })

        self.sucursal = pd.DataFrame(sucursales)
        self.guardar_sql(self.sucursal, "Sucursal")
        print(f"✅ Tabla 'Sucursal' generada con {len(self.sucursal)} registros (15 GT, 5 extranjeras).")

    def generar_grupo(self):
        grupos = []
        for id_grupo in range(1, 21):  # 20 grupos
            grupos.append({
                "IDGrupo": id_grupo,
                "Nombre": f"{self.fake.word().capitalize()} {random.choice(['Fit', 'Elite', 'Pro', 'Super'])}",
                "Fecha_creacion": self.generar_fechas_coherentes(
                    fecha_min=datetime(2022, 1, 1),
                    fecha_max=datetime.now() - timedelta(days=30)
                )
            })

        self.grupo = pd.DataFrame(grupos)
        self.guardar_sql(self.grupo, "Grupo")
        print(f"✅ Tabla 'Grupo' generada con {len(self.grupo)} registros.")

    def generar_reto(self):
        retos = []
        # Mapeo de unidades desde la tabla Unidad_medicion (ej: {1: "km", 2: "min", 3: "rep"})
        unidades = dict(zip(self.unidad_medicion["IDUnidadMedicion"], self.unidad_medicion["Simbolo"]))

        for id_reto in range(1, 31):  # 30 retos
            es_grupal = random.random() < 0.3  # 30% grupales
            es_global = random.random() < 0.5  # 50% globales
            id_unidad = random.choice(self.unidad_medicion["IDUnidadMedicion"].tolist())
            unidad = unidades[id_unidad]

            # Definir meta según unidad y tipo de reto
            if unidad == "km":
                meta = random.randint(50, 1000) if es_grupal else random.randint(5, 50)
            elif unidad == "min":
                meta = random.randint(200, 1000) if es_grupal else random.randint(30, 120)
            elif unidad == "cal":
                meta = random.randint(1050, 3000) if es_grupal else random.randint(240, 480)
            else:  # "rep" (repeticiones)
                meta = random.randint(500, 2000) if es_grupal else random.randint(12, 150)

            # Asignar puntos: meta * factor aleatorio (1, 3, 5)
            factor_puntos = random.choice([1, 3, 5])
            puntos = meta * factor_puntos

            # Descripción detallada
            descripcion = (
                f"Reto {'grupal ' if es_grupal else 'individual '}"
                f"de {meta} {unidad}. ¡Gana {puntos} puntos!"
            )

            # Nombre del reto (ej: "Reto Cardio Mayo 2024")
            nombre_reto = (
                f"Reto {random.choice(['Cardio', 'Pesas', 'Resistencia'])} "
                f"{self.fake.month_name()} {random.randint(2023, 2024)}"
            )

            retos.append({
                "IDReto": id_reto,
                "Nombre": nombre_reto,
                "Descripcion": descripcion,
                "Fecha_inicio": self.generar_fechas_coherentes(datetime.now() - timedelta(days=180), datetime.now()),
                "Fecha_fin": self.generar_fechas_coherentes(datetime.now(), datetime.now() + timedelta(days=30)),
                "Puntos_aganar": puntos,
                "Meta_cantidad": meta,
                "IDUnidadMedicion": id_unidad,
                "IDSucursal": None if es_global else random.choice(self.sucursal["IDSucursal"].tolist()),
                "esGrupal": es_grupal
            })

        self.reto = pd.DataFrame(retos)
        self.guardar_sql(self.reto, "Reto")
        print(f"✅ Tabla 'Reto' generada con {len(self.reto)} registros.")

    def generar_origen(self):
        origenes = []

        # Origen por asistencia (ID 1)
        origenes.append({
            "IDOrigen": 1,
            "Descripcion": "Asistencia mensual",
            "IDReto": None
        })

        i = 1
        for reto in self.reto.to_dict("records"):
            i = i + 1
            origenes.append({
                "IDOrigen": i,
                "Descripcion": f"Reto {reto['Nombre']}",
                "IDReto": reto["IDReto"]
            })

        self.origen = pd.DataFrame(origenes)
        self.guardar_sql(self.origen, "Origen")
        print(f"✅ Tabla 'Origen' generada con {len(self.origen)} registros.")

    def generar_nivel_2(self):
        self.generar_miembro()
        self.generar_sucursal()
        self.generar_grupo()
        self.generar_reto()
        self.generar_origen()
        print("¡Todas las tablas del Nivel 2 generadas con éxito!")
#
    def generar_membresia(self):
        membresias = []
        for miembro in self.miembro.to_dict("records"):
            fecha_inicio = self.generar_fechas_coherentes(
                fecha_min=miembro["Fecha_registro"],
                fecha_max=datetime.now() - timedelta(days=2)
            )
            membresias.append({
                "IDMembresia": miembro["IDMiembro"],  # Mismo ID para simplificar
                "Fecha_Inicio": fecha_inicio,
                "Fecha_fin": random.choices([None, fecha_inicio + timedelta(days=365)], weights=[99, 1])[0],
                "IDMiembro": miembro["IDMiembro"],
                "IDTipo_Membresia": random.choices([1, 2], weights=[70, 30])[0]  # 70% Básica, 30% Premium
            })

        self.membresia = pd.DataFrame(membresias)
        self.guardar_sql(self.membresia, "Membresia")
        print("✅ Tabla 'Membresia' generada (30% Premium).")

    def generar_miembro_sucursal(self):
        registros = []
        for miembro in self.miembro.to_dict("records"):
            num_sucursales = random.choices([1, 2, 3], weights=[60, 30, 10])[0]
            sucursales = random.sample(self.sucursal["IDSucursal"].tolist(), num_sucursales)

            for i, sucursal_id in enumerate(sucursales):
                registros.append({
                    "IDMiembro_Sucursal": len(registros) + 1,
                    "Fecha_inicio": self.generar_fechas_coherentes(
                        fecha_min=miembro["Fecha_registro"],
                        fecha_max=datetime.now()
                    ),
                    "Fecha_cancelacion": None if random.random() < 0.9 else self.generar_fechas_coherentes(
                        datetime.now() - timedelta(days=365*2),
                        datetime.now()# 10% canceladas
                    ),
                    "esPrincipal": (i == 0),  # Primera sucursal es principal
                    "IDSucursal": sucursal_id,
                    "IDMiembro": miembro["IDMiembro"]
                })

        self.miembro_sucursal = pd.DataFrame(registros)
        self.guardar_sql(self.miembro_sucursal, "Miembro_Sucursal")
        print("✅ Tabla 'Miembro_Sucursal' generada (1-3 sucursales por miembro).")

    def generar_miembro_acceso(self):
        accesos = []
        for miembro in self.miembro.to_dict("records"):
            accesos.append({
                "IDAcceso": miembro["IDMiembro"],  # Mismo ID para simplificar
                "InformacionEncriptada": self.fake.uuid4(),
                "IDTipoAcceso": random.choice(self.tipo_acceso["IDTipoAcceso"].tolist()),
                "IDMiembro": miembro["IDMiembro"]
            })

        self.miembro_acceso = pd.DataFrame(accesos)
        self.guardar_sql(self.miembro_acceso, "MiembroAcceso")
        print("✅ Tabla 'MiembroAcceso' generada (1 acceso por miembro).")

    def generar_asistencia(self):
        asistencias = []
        for ms in self.miembro_sucursal.to_dict("records"):
            # Convertir Fecha_inicio a datetime si es necesario
            fecha_inicio = ms["Fecha_inicio"]
            if isinstance(fecha_inicio, date):  # Usamos date directamente
                fecha_inicio = datetime.combine(fecha_inicio, datetime.min.time())

            # Cálculo de meses en el sistema
            meses_en_sistema = max(1, (datetime.now() - fecha_inicio).days // 30)
            num_asistencias = random.randint(2 * meses_en_sistema, 10 * meses_en_sistema)

            for _ in range(num_asistencias):
                fecha = self.generar_fechas_coherentes(fecha_inicio, datetime.now())
                entrada = datetime.combine(fecha.date(), self.fake.time_object()) if isinstance(fecha,
                                                                                                datetime) else datetime.combine(
                    fecha, self.fake.time_object())
                salida = entrada + timedelta(minutes=random.randint(30, 120))

                asistencias.append({
                    "IDAsistencia": len(asistencias) + 1,
                    "IDMiembro_Sucursal": ms["IDMiembro_Sucursal"],
                    "FechaHora_Entrada": entrada,
                    "FechaHora_Salida": salida,
                    "IDAcceso": ms["IDMiembro"]
                })

        self.asistencia = pd.DataFrame(asistencias)
        self.guardar_sql(self.asistencia, "Asistencia")
        print(f"✅ Tabla 'Asistencia' generada ({len(asistencias)} registros).")

    def generar_pago(self):
        pagos = []
        miembros_suspendidos = set()

        for membresia in self.membresia.to_dict("records"):
            # Asegurarnos que Fecha_fin no sea None
            if  membresia["Fecha_fin"] is not None and membresia["Fecha_fin"] < datetime.now():
                continue  # Saltar membresías sin fecha fin válida

            fecha_actual = membresia["Fecha_Inicio"]
            fecha_limite = datetime.now().date()

            while fecha_actual <= fecha_limite:
                # 90% de probabilidad de pago en primeros 10 días
                if random.random() < 0.9:
                    fecha_pago = fecha_actual.replace(day=random.randint(1, 10))
                    pagos.append({
                        "IDPago": len(pagos) + 1,
                        "Fecha_trasaccion": fecha_pago,
                        "Monto_abonado": 200 if membresia["IDTipo_Membresia"] == 1 else 400,
                        "IDMembresia": membresia["IDMembresia"]
                    })
                else:
                    if fecha_actual >= datetime.now().date() - timedelta(days=30):
                        miembros_suspendidos.add(membresia["IDMiembro"])

                # Avanzar al siguiente mes
                try:
                    fecha_actual = (fecha_actual + timedelta(days=32)).replace(day=1)
                except ValueError:
                    break

        # Actualizar miembros suspendidos
        if miembros_suspendidos:
            self.miembro.loc[self.miembro["IDMiembro"].isin(miembros_suspendidos), "estaSuspendido"] = 1
            self.guardar_sql(self.miembro, "Miembro")

        self.pago = pd.DataFrame(pagos)
        self.guardar_sql(self.pago, "Pago")
        print(f"✅ Tabla 'Pago' generada ({len(pagos)} registros). {len(miembros_suspendidos)} miembros suspendidos.")

    def generar_pesaje(self):
        pesajes = []
        for miembro in self.miembro.to_dict("records"):
            num_pesajes = random.randint(20, 30)
            peso_inicial = random.randint(130, 190)
            for _ in range(num_pesajes):
                pesajes.append({
                    "IDPesaje": len(pesajes) + 1,
                    "Cantidad": round(peso_inicial * random.uniform(0.75, 1.45), 2),  # Variación
                    "Fecha": self.generar_fechas_coherentes(
                        fecha_min=miembro["Fecha_registro"],
                        fecha_max=datetime.now()
                    ),
                    "IDMiembro": miembro["IDMiembro"]
                })

        self.pesaje = pd.DataFrame(pesajes)
        self.guardar_sql(self.pesaje, "Pesaje")
        print(f"✅ Tabla 'Pesaje' generada ({len(pesajes)} registros).")

    def generar_miembro_reto(self):
        miembros_retos = []
        for reto in self.reto.to_dict("records"):
            participantes = random.sample(self.miembro["IDMiembro"].tolist(), random.randint(1, 40))
            for id_miembro in participantes:
                progreso = round(random.uniform(0, 10), 2) * 10

                if progreso > 90:
                    progreso = 100

                completado = (progreso == 100)

                miembros_retos.append({
                    "IDMiembro": id_miembro,
                    "IDReto": reto["IDReto"],
                    "Progreso": progreso,
                    "Fecha_inscripcion": reto["Fecha_inicio"],
                    "Fecha_completado": reto["Fecha_fin"] if completado else None,
                    "IDEstado": 2 if completado else 1  # 2=Completado, 1=Activo
                })

        self.miembro_reto = pd.DataFrame(miembros_retos)
        self.guardar_sql(self.miembro_reto, "Miembro_reto")
        print(f"✅ Tabla 'Miembro_reto' generada ({len(miembros_retos)} registros).")

    def generar_punteo(self):
        punteos = []

        # Puntos por retos completados
        retos_completados = self.miembro_reto[self.miembro_reto["Progreso"] == 100]

        for _, reto_completado in retos_completados.iterrows():
            reto = self.reto[self.reto["IDReto"] == reto_completado["IDReto"]].iloc[0]
            punteos.append({
                "IDPunteo": len(punteos) + 1,
                "Cantidad": reto["Puntos_aganar"],
                "Fecha_obtenido": reto_completado["Fecha_completado"],
                "Fecha_vencido": reto_completado["Fecha_completado"] + timedelta(days=365),
                "IDOrigen": reto["IDReto"] + 1,
                "IDMiembro": reto_completado["IDMiembro"],
                "estaActivo": 1
            })

        # Puntos por asistencia (8+ visitas/mes)
        for id_miembro in self.miembro["IDMiembro"]:
            # Usar .copy() para evitar el warning
            asistencias_miembro = self.asistencia[
                self.asistencia["IDMiembro_Sucursal"].isin(
                    self.miembro_sucursal[self.miembro_sucursal["IDMiembro"] == id_miembro]["IDMiembro_Sucursal"]
                )
            ].copy()  # <--- Aquí está el cambio clave

            if not asistencias_miembro.empty:
                # Usar .loc para asignación segura
                asistencias_miembro.loc[:, "Mes"] = asistencias_miembro["FechaHora_Entrada"].dt.to_period("M")
                conteo_mensual = asistencias_miembro.groupby("Mes").size()

                for mes, count in conteo_mensual.items():
                    if count >= 8:
                        punteos.append({
                            "IDPunteo": len(punteos) + 1,
                            "Cantidad": 100,
                            "Fecha_obtenido": mes.to_timestamp() + timedelta(days=1),
                            "Fecha_vencido": mes.to_timestamp() + timedelta(days=365),
                            "IDOrigen": 1,
                            "IDMiembro": id_miembro,
                            "estaActivo": 1
                        })

        self.punteo = pd.DataFrame(punteos)
        self.guardar_sql(self.punteo, "Punteo")
        print(f"✅ Tabla 'Punteo' generada ({len(punteos)} registros).")

    def generar_reto_grupal(self):
        retos_grupales = []
        hoy = datetime.now().date()

        # Convertir Fecha_creacion a date si es necesario
        grupos_activos = self.grupo.copy()
        grupos_activos["Fecha_creacion"] = pd.to_datetime(grupos_activos["Fecha_creacion"]).dt.date
        grupos_activos = grupos_activos[grupos_activos["Fecha_creacion"] <= hoy]

        for reto in self.reto[self.reto["esGrupal"] == 1].to_dict("records"):
            if len(grupos_activos) == 0:
                continue

            grupo_id = random.choice(grupos_activos["IDGrupo"].tolist())

            # Manejar fecha_fin (ya debería ser date)
            fecha_fin = reto["Fecha_fin"]
            if isinstance(fecha_fin, datetime):
                fecha_fin = fecha_fin.date()

            fecha_completado = fecha_fin if random.random() < 0.5 else None
            estado = 2 if fecha_completado else 1

            retos_grupales.append({
                "IDGrupo": grupo_id,
                "IDReto": reto["IDReto"],
                "Fecha_creacion": reto["Fecha_inicio"].date() if isinstance(reto["Fecha_inicio"], datetime) else reto[
                    "Fecha_inicio"],
                "Fecha_completado": fecha_completado,
                "IDEstado": estado
            })

        self.reto_grupal = pd.DataFrame(retos_grupales)
        self.guardar_sql(self.reto_grupal, "Reto_Grupal")
        print(f"✅ Tabla 'Reto_Grupal' generada ({len(retos_grupales)} registros).")

    def generar_sesion_virtual(self):
        sesiones = []
        for membresia in self.membresia[self.membresia["IDTipo_Membresia"] == 2].to_dict("records"):  # Solo Premium
            num_sesiones = random.randint(0, 22)
            for _ in range(num_sesiones):
                sesiones.append({
                    "IDSesion": len(sesiones) + 1,
                    "FechaHora_inicio": self.generar_fechas_coherentes(
                        fecha_min=membresia["Fecha_Inicio"],
                        fecha_max=datetime.now()
                    ),
                    "Duracion": round(random.uniform(30, 120), 2),
                    "IDMembresia": membresia["IDMembresia"]
                })

        self.sesion_virtual = pd.DataFrame(sesiones)
        self.guardar_sql(self.sesion_virtual, "Sesion_virtual")
        print(f"✅ Tabla 'Sesion_virtual' generada ({len(sesiones)} registros, solo Premium).")

    def generar_canje(self):
        canjes = []
        for ms in self.miembro_sucursal.to_dict("records"):
            if random.random() < 0.4:  # 40% de miembros hacen canjes
                # Calcular puntos disponibles del miembro (no expirados y no canjeados)
                puntos_disponibles = self.punteo[
                    (self.punteo["IDMiembro"] == ms["IDMiembro"]) &
                    (self.punteo["estaActivo"] == 1) &
                    (self.punteo["Fecha_vencido"] >= datetime.today().date().fromtimestamp())
                    ]["Cantidad"].sum()

                if puntos_disponibles > 100:  # Mínimo 100 puntos para canjear
                    cantidad_canje = random.randint(100, min(500, puntos_disponibles))
                    canjes.append({
                        "IDCanje": len(canjes) + 1,
                        "Cantidad": cantidad_canje,
                        "Fecha_canje": self.generar_fechas_coherentes(
                            fecha_min=ms["Fecha_inicio"],
                            fecha_max=datetime.now()
                        ),
                        "Descripcion": f"Canje en {self.sucursal[self.sucursal['IDSucursal'] == ms['IDSucursal']]['Nombre'].values[0]}",
                        "IDMiembro_Sucursal": ms["IDMiembro_Sucursal"]
                    })

        self.canje = pd.DataFrame(canjes)
        self.guardar_sql(self.canje, "Canje")
        print(f"✅ Tabla 'Canje' generada ({len(canjes)} registros).")

    def generar_miembro_grupo(self):
        miembros_grupos = []
        grupos = self.grupo.to_dict("records")

        for grupo in grupos:
            miembros_grupo = random.sample(self.miembro["IDMiembro"].tolist(), random.randint(1, 20))
            lider_asignado = False

            for i, id_miembro in enumerate(miembros_grupo):
                # Obtener fecha de registro y asegurar que sea datetime
                fecha_registro = self.miembro[self.miembro["IDMiembro"] == id_miembro]["Fecha_registro"].iloc[0]
                if isinstance(fecha_registro, date):
                    fecha_registro = datetime.combine(fecha_registro, datetime.min.time())

                fecha_entrada = self.generar_fechas_coherentes(
                    fecha_min=datetime(2022, 1, 1),
                    fecha_max=datetime.now() - timedelta(days=30)
                )

                # Verificar si puede ser líder (3+ meses en el sistema)
                puede_ser_lider = (datetime.now() - fecha_registro) >= timedelta(days=90)

                es_lider = (not lider_asignado and puede_ser_lider and random.random() < 0.5)
                if es_lider:
                    lider_asignado = True

                miembros_grupos.append({
                    "IDGrupo": grupo["IDGrupo"],
                    "IDMiembro": id_miembro,
                    "Fecha_entrada": fecha_entrada,
                    "Fecha_salida": None if random.random() < 0.8 else self.generar_fechas_coherentes(fecha_entrada,
                                                                                                      datetime.now()),
                    "esLider": es_lider
                })

        self.miembro_grupo = pd.DataFrame(miembros_grupos)
        self.guardar_sql(self.miembro_grupo, "Miembro_Grupo")
        print(f"✅ Tabla 'Miembro_Grupo' generada ({len(miembros_grupos)} registros).")

    def generar_nivel_3(self):
        self.generar_membresia()
        self.generar_miembro_sucursal()
        self.generar_miembro_acceso()
        self.generar_asistencia()
        self.generar_pago()
        self.generar_pesaje()
        self.generar_miembro_reto()
        self.generar_punteo()
        self.generar_reto_grupal()
        self.generar_sesion_virtual()
        self.generar_canje()
        self.generar_miembro_grupo()
        print("¡Todas las tablas del Nivel 3 generadas con éxito!")



if __name__ == "__main__":
    generador = FitChainGenerator()

    # Limpiar archivo consolidado si existe
    with open("FitChain_AllData.sql", "w", encoding="utf-8") as f:
        f.write("-- DATOS GENERADOS PARA FITCHAIN (Nivel 1 → Nivel 2 → Nivel 3)\n\n")

    # Generar datos en orden
    generador.generar_nivel_1()
    generador.generar_nivel_2()
    generador.generar_nivel_3()

    generador.generar_archivo_sql_completo()

    print("- Individuales: /sql_individual/*.sql")
    print("- Consolidado: FitChain_AllData.sql")