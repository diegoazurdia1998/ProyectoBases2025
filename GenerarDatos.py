import random
from datetime import datetime, timedelta, date
from faker import Faker
from collections import defaultdict

class FitChainDataGenerator:
    def __init__(self, num_miembros=750, num_sucursales=15, num_grupos=15, num_retos=20, fecha_actual=None):
        """
        Inicializa el generador de datos para FitChain

        Args:
            num_miembros (int): Número de miembros a generar
            num_sucursales (int): Número de sucursales a generar
            num_grupos (int): Número de grupos a generar
            num_retos (int): Número de retos a generar
            fecha_actual (datetime): Fecha de referencia para la generación de datos (default: 3/5/2025)
        """
        # Configuración inicial
        self.fake = Faker('es_ES')
        self.fecha_actual = fecha_actual if fecha_actual else datetime(2025, 5, 3)
        self.fecha_inicio = self.fecha_actual - timedelta(days=365 * 2)  # 2 años de datos

        # Parámetros de generación
        self.num_miembros = num_miembros
        self.num_sucursales = num_sucursales
        self.num_grupos = num_grupos
        self.num_retos = num_retos

        # Atributos para almacenar los datos generados
        self.genero = []
        self.tipo_membresia = []
        self.estado = []
        self.unidad_medicion = []
        self.pais = []
        self.ciudad = []
        self.sucursal = []
        self.miembro = []
        self.grupo = []
        self.reto = []
        self.membresia = []
        self.miembro_grupo = []
        self.reto_grupal = []
        self.miembro_reto = []
        self.asistencia = []
        self.origen = []
        self.punteo = []
        self.pago = []

        # Configurar semillas para reproducibilidad
        self._configurar_semillas()

        # Generar todos los datos
        self.generar_datos()

    def _configurar_semillas(self):
        """Configura semillas para reproducibilidad"""
        random.seed(42)
        Faker.seed(42)

    def _random_date(self, start, end):
        """Genera una fecha aleatoria entre start y end"""
        return start + timedelta(days=random.randint(0, (end - start).days))

    def _random_time(self):
        """Genera horas aleatorias de entrada y salida"""
        entrada = timedelta(hours=random.randint(6, 12), minutes=random.randint(0, 59))
        salida = entrada + timedelta(hours=random.randint(1, 4), minutes=random.randint(0, 59))
        return entrada, salida

    def _obtener_sucursales_miembro(self, id_miembro):
        """Obtiene todas las sucursales a las que pertenece un miembro"""
        return [m['IDSucursal'] for m in self.membresia
                if m['IDMiembro'] == id_miembro and
                (m['Fecha_cancelacion'] is None or m['Fecha_cancelacion'] > self.fecha_actual)]

    def _es_miembro_valido_para_reto(self, id_miembro, id_reto):
        """
        Verifica si un miembro puede participar en un reto basado en sus sucursales

        Args:
            id_miembro (int): ID del miembro
            id_reto (int): ID del reto

        Returns:
            bool: True si el miembro puede participar, False si no
        """
        # Obtener el reto
        reto = next(r for r in self.reto if r['IDReto'] == id_reto)

        # Si el reto es global (sin sucursal), cualquier miembro puede participar
        if reto['IDSucursal'] is None:
            return True

        # Obtener las sucursales del miembro
        sucursales_miembro = self._obtener_sucursales_miembro(id_miembro)

        # Verificar si el miembro tiene membresía en la sucursal del reto
        return reto['IDSucursal'] in sucursales_miembro

    def _generar_datos_referencia(self):
        """Genera datos para tablas de referencia"""
        # Géneros
        self.genero = [
            {"IDGenero": 1, "Nombre": "Masculino"},
            {"IDGenero": 2, "Nombre": "Femenino"},
            {"IDGenero": 3, "Nombre": "Otro"}
        ]

        # Tipos de membresía
        self.tipo_membresia = [
            {"IDTipoMembresia": 1, "Nombre": "Básica"},
            {"IDTipoMembresia": 2, "Nombre": "Premium"}
        ]

        # Estados
        self.estado = [
            {"IDEstado": 1, "Nombre": "Activo"},
            {"IDEstado": 2, "Nombre": "Completado"},
            {"IDEstado": 3, "Nombre": "Fallido"},
            {"IDEstado": 4, "Nombre": "En progreso"}
        ]

        # Unidades de medición
        self.unidad_medicion = [
            {"IDUnidadMedicion": 1, "Nombre": "Kilómetros", "Simbolo": "km"},
            {"IDUnidadMedicion": 2, "Nombre": "Metros", "Simbolo": "m"},
            {"IDUnidadMedicion": 3, "Nombre": "Minutos", "Simbolo": "min"},
            {"IDUnidadMedicion": 4, "Nombre": "Horas", "Simbolo": "h"},
            {"IDUnidadMedicion": 5, "Nombre": "Repeticiones", "Simbolo": "rep"},
            {"IDUnidadMedicion": 6, "Nombre": "Kilogramos", "Simbolo": "kg"},
            {"IDUnidadMedicion": 7, "Nombre": "Calorias", "Simbolo": "cal"}
        ]

        # Países
        self.pais = [
            {"IDPais": 1, "Nombre": "Guatemala"},
            {"IDPais": 2, "Nombre": "México"},
            {"IDPais": 3, "Nombre": "Estados Unidos"}
        ]

        # Ciudades
        self.ciudad = [
            {"IDCiudad": 1, "Nombre": "Ciudad de Guatemala", "IDPais": 1},
            {"IDCiudad": 2, "Nombre": "Xela", "IDPais": 1},
            {"IDCiudad": 3, "Nombre": "Ciudad de México", "IDPais": 2},
            {"IDCiudad": 4, "Nombre": "Guadalajara", "IDPais": 2},
            {"IDCiudad": 5, "Nombre": "Miami", "IDPais": 3},
            {"IDCiudad": 6, "Nombre": "Nueva York", "IDPais": 3}
        ]

    # Generación de datos principales
    def _generar_sucursales(self):
        """Genera datos para sucursales"""
        self.sucursales = []
        for i in range(1, self.num_sucursales + 1):
            ciudad = random.choice(self.ciudad)
            self.sucursales.append({
                "IDSucursal": i,
                "Nombre": f"FitChain {ciudad['Nombre']}",
                "Capacidad": random.randint(50, 200),
                "Direccion": self.fake.address(),
                "IDCiudad": ciudad["IDCiudad"]
            })

    def _generar_miembros(self):
        """Genera datos para miembros"""
        self.miembros = []
        for i in range(1, self.num_miembros + 1):
            fecha_nac = self._random_date(datetime(1970, 1, 1), datetime(2005, 12, 31))
            fecha_reg = self._random_date(fecha_nac + timedelta(days=365 * 18),
                                          self.fecha_actual - timedelta(days=30))

            self.miembros.append({
                "IDMiembro": i,
                "Nombre1": self.fake.first_name(),
                "Nombre2": self.fake.first_name() if random.random() > 0.3 else None,
                "Apellido1": self.fake.last_name(),
                "Apellido2": self.fake.last_name() if random.random() > 0.3 else None,
                "Identificacion": self.fake.unique.bothify('###########'),
                "Fecha_registro": fecha_reg,
                "Fecha_nacimiento": fecha_nac,
                "IDGenero": random.choice(self.genero)["IDGenero"],
                "Altura": round(random.uniform(1.50, 2.00), 2),
                "Peso_inical": round(random.uniform(50.0, 120.0), 2),
                "Condiciones_medicas": self.fake.text() if random.random() > 0.7 else None,
                "estaSuspendido": random.random() > 0.9
            })

    def _generar_grupos(self):
        """Genera datos para grupos"""
        self.grupos = []
        for i in range(1, self.num_grupos + 1):
            self.grupos.append({
                "IDGrupo": i,
                "Nombre": f"Grupo {self.fake.word().capitalize()}",
                "Fecha_creacion": self._random_date(self.fecha_inicio, self.fecha_actual)
            })

    def _generar_retos(self):
        """Genera datos para retos"""
        self.retos = []
        for i in range(1, self.num_retos + 1):
            fecha_inicio = self._random_date(self.fecha_inicio, self.fecha_actual - timedelta(days=30))
            fecha_fin = fecha_inicio + timedelta(days=random.randint(7, 90))
            sucursal = random.choice(self.sucursales) if random.random() > 0.3 else None

            self.retos.append({
                "IDReto": i,
                "Nombre": f"Reto {self.fake.word().capitalize()}",
                "Descripcion": self.fake.text(),
                "Fecha_inicio": fecha_inicio,
                "Fecha_fin": fecha_fin,
                "Puntos_aganar": random.randint(100, 1000),
                "Meta_cantidad": round(random.uniform(5.0, 100.0), 2),
                "IDUnidadMedicion": random.choice(self.unidad_medicion)["IDUnidadMedicion"],
                "IDSucursal": sucursal["IDSucursal"] if sucursal else None,
                "esGrupal": random.random() > 0.7  # 70% de probabilidad de ser grupal
            })

    # Generación de datos relacionales
    def _generar_membresias(self):
        """Genera datos para membresías (ahora separado de Miembro_Sucursal)"""
        self.membresias = []
        id_membresia = 1
        for miembro in self.miembros:
            num_membresias = random.randint(1, 2)  # 1-2 membresías por miembro
            tipos = random.sample(self.tipo_membresia, num_membresias)

            for tipo in tipos:
                fecha_inicio = self._random_date(miembro["Fecha_registro"], self.fecha_actual)
                fecha_fin = fecha_inicio + timedelta(days=365)  # 1 año de duración

                self.membresias.append({
                    "IDMembresia": id_membresia,
                    "Fecha_Inicio": fecha_inicio,
                    "Fecha_fin": fecha_fin,
                    "IDMiembro": miembro["IDMiembro"],
                    "IDTipo_Membresia": tipo["IDTipo_Membresia"]
                })
                id_membresia += 1

    def _generar_miembro_sucursal(self):
        """Genera la relación Miembro-Sucursal (antes parte de Membresía)"""
        self.miembro_sucursal = []
        id_miembro_sucursal = 1

        for miembro in self.miembros:
            num_sucursales = random.randint(1, 3)
            sucursales = random.sample(self.sucursales, num_sucursales)

            for i, sucursal in enumerate(sucursales):
                fecha_inicio = self._random_date(miembro["Fecha_registro"], self.fecha_actual)
                fecha_cancel = None
                if random.random() > 0.7:  # 30% de probabilidad de cancelación
                    fecha_cancel = self._random_date(fecha_inicio, self.fecha_actual)

                self.miembro_sucursal.append({
                    "IDMiembro_Sucursal": id_miembro_sucursal,
                    "Fecha_inicio": fecha_inicio,
                    "Fecha_cancelacion": fecha_cancel,
                    "esPrincipal": i == 0,  # La primera es principal
                    "IDSucursal": sucursal["IDSucursal"],
                    "IDMiembro": miembro["IDMiembro"]
                })
                id_miembro_sucursal += 1

    def _generar_miembro_grupo(self):
        """Genera datos para relación miembro-grupo"""
        self.miembro_grupo = []
        for grupo in self.grupos:
            num_miembros = random.randint(5, 20)
            miembros_grupo = random.sample(self.miembros, min(num_miembros, len(self.miembros)))

            for i, miembro in enumerate(miembros_grupo):
                fecha_entrada = self._random_date(grupo["Fecha_creacion"], self.fecha_actual)
                fecha_salida = None
                if random.random() > 0.7:
                    fecha_salida = self._random_date(fecha_entrada, self.fecha_actual)

                self.miembro_grupo.append({
                    "IDGrupo": grupo["IDGrupo"],
                    "IDMiembro": miembro["IDMiembro"],
                    "Fecha_entrada": fecha_entrada,
                    "Fecha_salida": fecha_salida,
                    "esLider": i == 0  # El primero es líder
                })

    def _generar_reto_grupal(self):
        """Genera datos para retos grupales"""
        self.reto_grupal = []
        for grupo in self.grupos:
            # Solo asignar retos grupales a algunos grupos
            if random.random() > 0.5:  # 50% de probabilidad
                retos_grupales = [r for r in self.retos if r['esGrupal']]
                if retos_grupales:
                    reto = random.choice(retos_grupales)
                    fecha_creacion = self._random_date(reto["Fecha_inicio"], min(reto["Fecha_fin"], self.fecha_actual))
                    fecha_completado = None
                    estado = random.choice([e for e in self.estado if e["Nombre"] in ["Activo", "Completado"]])

                    if estado["Nombre"] == "Completado":
                        fecha_completado = self._random_date(fecha_creacion, min(reto["Fecha_fin"], self.fecha_actual))

                    self.reto_grupal.append({
                        "IDGrupo": grupo["IDGrupo"],
                        "IDReto": reto["IDReto"],
                        "Fecha_creacion": fecha_creacion,
                        "Fecha_completado": fecha_completado,
                        "IDEstado": estado["IDEstado"]
                    })

    def _generar_miembro_reto(self):
        """Genera datos para relación miembro-reto con validación de sucursal"""
        self.miembro_reto = []
        for reto in self.retos:
            # Determinar cuántos participantes tendrá este reto
            num_participantes = random.randint(5, len(self.miembros))

            # Filtrar miembros elegibles para este reto
            if reto['IDSucursal'] is None:
                # Reto global - todos los miembros son elegibles
                miembros_elegibles = self.miembros
            else:
                # Reto de sucursal específica - solo miembros de esa sucursal
                miembros_elegibles = [
                    m for m in self.miembros
                    if self._es_miembro_valido_para_reto(m['IDMiembro'], reto['IDReto'])
                ]

            # Seleccionar participantes aleatorios entre los elegibles
            participantes = random.sample(miembros_elegibles, min(num_participantes, len(miembros_elegibles)))

            for miembro in participantes:
                fecha_inscripcion = self._random_date(reto["Fecha_inicio"], min(reto["Fecha_fin"], self.fecha_actual))
                fecha_completado = None
                progreso = round(random.uniform(0.0, 1.0), 2)
                estado = random.choice(self.estado)

                if estado["Nombre"] == "Completado":
                    fecha_completado = self._random_date(fecha_inscripcion, min(reto["Fecha_fin"], self.fecha_actual))
                    progreso = 1.0
                elif estado["Nombre"] == "En progreso":
                    progreso = round(random.uniform(0.1, 0.99), 2)

                self.miembro_reto.append({
                    "IDMiembro": miembro["IDMiembro"],
                    "IDReto": reto["IDReto"],
                    "Progreso": progreso,
                    "Fecha_inscripcion": fecha_inscripcion,
                    "Fecha_completado": fecha_completado,
                    "IDEstado": estado["IDEstado"]
                })

    def _generar_asistencias(self):
        """Genera asistencias proporcionales al tiempo en FitChain"""
        self.asistencias = []
        id_asistencia = 1

        for ms in self.miembro_sucursal:
            if ms['Fecha_cancelacion'] is None or ms['Fecha_cancelacion'] > self.fecha_actual:
                # Calcular asistencias esperadas basadas en tiempo de membresía
                dias_membresia = (self.fecha_actual - ms['Fecha_inicio']).days
                asistencias_esperadas = max(1, int(dias_membresia * random.uniform(0.1, 0.3)))  # 10-30% de los días

                # Generar fechas de asistencia distribuidas
                for _ in range(asistencias_esperadas):
                    fecha = self._random_date(ms['Fecha_inicio'], self.fecha_actual)
                    entrada, salida = self._random_time()
                    fecha_entrada = datetime.combine(fecha, datetime.min.time()) + entrada
                    fecha_salida = datetime.combine(fecha, datetime.min.time()) + salida

                    self.asistencias.append({
                        "IDAsistencia": id_asistencia,
                        "IDMiembro_Sucursal": ms["IDMiembro_Sucursal"],
                        "IDSucursal": ms["IDSucursal"],
                        "FechaHora_Entrada": fecha_entrada,
                        "FechaHora_Salida": fecha_salida,
                        "Acceso": random.randint(1, 3)
                    })
                    id_asistencia += 1

    def _generar_origenes(self):
        """Genera orígenes de puntos por retos (simplificado)"""
        self.origenes = []
        id_origen = 1

        # Orígenes solo por retos (eliminado el de asistencias según nuevo DDL)
        for reto in self.retos:
            self.origenes.append({
                "IDOrigen": id_origen,
                "Descripcion": f"Reto {reto['Nombre']}",
                "IDReto": reto["IDReto"]
            })
            id_origen += 1
        self.origenes.append({
            "IDOrigen": id_origen,
            "Descripcion": f"Asistencia",
            "IDReto": None
        })

    def _generar_punteos(self):
        """Genera punteos basados en retos completados"""
        self.punteos = []
        id_punteo = 1

        for origen in [o for o in self.origenes if o['IDReto'] is not None]:
            reto = next(r for r in self.retos if r['IDReto'] == origen['IDReto'])
            participantes = [mr for mr in self.miembro_reto
                             if mr['IDReto'] == reto['IDReto'] and mr['IDEstado'] == 2]  # Completado

            for participante in participantes:
                self.punteos.append({
                    "IDPunteo": id_punteo,
                    "Cantidad": reto["Puntos_aganar"],
                    "Fecha_obtenido": participante["Fecha_completado"].date(),
                    "Fecha_vencido": participante["Fecha_completado"].date() + timedelta(days=90),
                    "IDOrigen": origen["IDOrigen"],
                    "IDMiembro": participante["IDMiembro"]
                })
                id_punteo += 1

    def _generar_pagos(self):
        """Genera pagos mensuales en los primeros 10 días de cada mes"""
        self.pagos = []
        id_pago = 1

        for miembro in self.miembros:
            # Calcular meses de membresía
            fecha_inicio = miembro["Fecha_registro"]
            fecha_fin = self.fecha_actual

            current_date = fecha_inicio.replace(day=1)
            while current_date <= fecha_fin:
                if current_date >= fecha_inicio:
                    dia_pago = random.randint(1, 10)
                    fecha_pago = current_date.replace(day=dia_pago)

                    if fecha_pago > fecha_fin:
                        break

                    monto = round(random.uniform(20.0, 100.0), 2)
                    self.pagos.append({
                        "IDPago": id_pago,
                        "Fecha_trasaccion": fecha_pago,
                        "Monto_abonado": monto,
                        "IDMiembro": miembro["IDMiembro"]
                    })
                    id_pago += 1

                # Avanzar al siguiente mes
                if current_date.month == 12:
                    current_date = current_date.replace(year=current_date.year + 1, month=1)
                else:
                    current_date = current_date.replace(month=current_date.month + 1)

    # Método principal para generar todos los datos
    def generar_datos(self):
        """Genera todos los datos para la base de datos FitChain"""
        # Generar datos de referencia
        self._generar_datos_referencia()

        # Generar datos principales
        self._generar_sucursales()
        self._generar_miembros()
        self._generar_grupos()
        self._generar_retos()

        # Generar datos relacionales
        self._generar_membresias()
        self._generar_miembro_sucursal()
        self._generar_miembro_grupo()
        self._generar_reto_grupal()
        self._generar_miembro_reto()
        self._generar_asistencias()
        self._generar_origenes()
        self._generar_punteos()
        self._generar_pagos()

    def generar_dml_por_tabla(self, directorio=''):
        """
        Genera archivos DML individuales para cada tabla en el directorio especificado

        Args:
            directorio (str): Directorio donde guardar los archivos (opcional)
        """
        import os

        # Crear directorio si no existe
        if directorio and not os.path.exists(directorio):
            os.makedirs(directorio)

        # Orden de inserción basado en dependencias
        orden_tablas = [
            'Genero',
            'Tipo_Membresia',
            'Estado',
            'Unidad_medicion',
            'Pais',
            'Ciudad',
            'Sucursal',
            'Miembro',
            'Grupo',
            'Reto',
            'Membresia',
            'Miembro_Grupo',
            'Reto_Grupal',
            'Miembro_reto',
            'Asistencia',
            'Origen',
            'Punteo',
            'Pago'
        ]

        # Mapeo de nombres de atributos
        mapeo_atributos = {
            'Miembro_Grupo': 'miembro_grupo',
            'Reto_Grupal': 'reto_grupal',
            'Miembro_reto': 'miembro_reto'
        }

        # Generar archivos individuales
        for tabla in orden_tablas:
            # Obtener los datos de la tabla
            atributo = mapeo_atributos.get(tabla, tabla.lower())
            datos = getattr(self, atributo, [])

            if not datos:
                continue

            nombre_archivo = os.path.join(directorio, f'DML_{tabla}.sql')
            self._generar_archivo_dml(tabla, datos, nombre_archivo)

        print(f"Archivos DML individuales generados en: {directorio if directorio else 'directorio actual'}")

    def generar_dml_completo(self, archivo_salida='DML_Completo.sql'):
        """
        Genera un archivo DML completo con todas las tablas

        Args:
            archivo_salida (str): Nombre del archivo de salida (opcional)
        """
        # Orden de inserción basado en dependencias
        orden_tablas = [
            'Genero',
            'Tipo_Membresia',
            'Estado',
            'Unidad_medicion',
            'Pais',
            'Ciudad',
            'Sucursal',
            'Miembro',
            'Grupo',
            'Reto',
            'Membresia',
            'Miembro_Grupo',
            'Reto_Grupal',
            'Miembro_reto',
            'Asistencia',
            'Origen',
            'Punteo',
            'Pago'
        ]

        # Mapeo de nombres de atributos
        mapeo_atributos = {
            'Miembro_Grupo': 'miembro_grupo',
            'Reto_Grupal': 'reto_grupal',
            'Miembro_reto': 'miembro_reto'
        }

        with open(archivo_salida, 'w', encoding='utf-8') as f:
            # Escribir encabezado
            f.write(f"-- Script DML completo generado automáticamente para FitChain\n")
            f.write(f"-- Fecha de generación: {datetime.now()}\n")
            f.write(f"-- Total de tablas: {len(orden_tablas)}\n\n")


            # Generar INSERTs para cada tabla
            for tabla in orden_tablas:
                atributo = mapeo_atributos.get(tabla, tabla.lower())
                datos = getattr(self, atributo, [])

                if not datos:
                    continue

                f.write(f"-- {len(datos)} registros para la tabla {tabla}\n")
                self._escribir_inserts(f, tabla, datos)

        print(f"Script DML completo generado en: {archivo_salida}")

    def _generar_archivo_dml(self, tabla, datos, nombre_archivo):
        """Genera un archivo DML individual para una tabla específica"""
        with open(nombre_archivo, 'w', encoding='utf-8') as f:
            # Escribir encabezado
            f.write(f"-- Script DML para la tabla {tabla}\n")
            f.write(f"-- Fecha de generación: {datetime.now()}\n")
            f.write(f"-- Total de registros: {len(datos)}\n\n")

            # Escribir los INSERTs
            self._escribir_inserts(f, tabla, datos)


    def _escribir_inserts(self, file_obj, tabla, datos):
        """Escribe las sentencias INSERT para una tabla en el file_obj dado"""
        if not datos:
            return

        # Obtener nombres de columnas
        columnas = list(datos[0].keys())

        # Construir la parte de columnas
        columns_sql = ', '.join(columnas)
        file_obj.write(f"INSERT INTO dbo.{tabla} ({columns_sql}) VALUES\n")

        # Generar los valores en lotes de 1000
        batch_size = 1000
        for i in range(0, len(datos), batch_size):
            batch = datos[i:i + batch_size]

            # Construir los valores
            values = []
            for registro in batch:
                val = ', '.join(self._formatear_valor_sql(registro[col]) for col in columnas)
                values.append(f"  ({val})")

            if i > 0:
                file_obj.write(f"INSERT INTO dbo.{tabla} ({columns_sql}) VALUES\n")

            file_obj.write(',\n'.join(values))
            file_obj.write(';\n\n')

    def _formatear_valor_sql(self, valor):
        """Formatea un valor para ser usado en SQL"""
        if valor is None:
            return 'NULL'
        elif isinstance(valor, str):
            return f"'{valor.replace("'", "''")}'"
        elif isinstance(valor, (datetime, date)):
            return f"'{valor}'"
        elif isinstance(valor, bool):
            return '1' if valor else '0'
        elif isinstance(valor, (int, float)):
            return str(valor)
        else:
            return f"'{str(valor)}'"



if __name__ == "__main__":
    # Crear generador de datos
    generador = FitChainDataGenerator(
        num_miembros=100,
        num_sucursales=8,
        num_grupos=15,
        num_retos=20,
        fecha_actual=datetime(2025, 5, 3)
    )

    # Generar scripts individuales por tabla
    generador.generar_dml_por_tabla('scripts_dml')

    # Generar script completo
    generador.generar_dml_completo('scripts_dml/DML_Completo.sql')