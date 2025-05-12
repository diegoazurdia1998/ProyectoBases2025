# Guía de Configuración de la Base de Datos FitChain

## Descripción General
Este repositorio contiene todos los scripts SQL necesarios para crear y poblar la base de datos del sistema de gestión de fitness FitChain. La base de datos está diseñada para administrar membresías de gimnasio, asistencia, retos, puntos de recompensa y otras actividades relacionadas con el fitness.

## Requisitos
- Microsoft SQL Server (se recomienda 2019 o más reciente)
- SQL Server Management Studio (SSMS) u otro cliente compatible con SQL Server
- Al menos 100MB de espacio libre en la base de datos

## Pasos de Instalación

### 1. Crear la Base de Datos
Primero, asegúrate de tener los permisos apropiados para crear una nueva base de datos en tu instancia de SQL Server.

```sql
CREATE DATABASE FitChain;
GO
```

### 2. Crear las Tablas de la Base de Datos
Ejecuta el script DDL para crear todas las tablas, restricciones y relaciones necesarias:

```
DDL_FitChainV6.sql
```

Este script creará la estructura completa de la base de datos con todas las tablas y relaciones.

### 3. Poblar la Base de Datos

Los datos deben cargarse en un orden específico para mantener la integridad referencial. Sigue exactamente esta secuencia:

1. `DML_Pais.sql` - Países
2. `DML_Estado.sql` - Estados
3. `DML_Genero.sql` - Géneros
4. `DML_Unidad_medicion.sql` - Unidades de medición
5. `DML_Tipo_Membresia.sql` - Tipos de membresía
6. `DML_Ciudad.sql` - Ciudades (depende de Pais)
7. `DML_Sucursal.sql` - Sucursales (depende de Ciudad)
8. `DML_Miembro.sql` - Miembros (depende de Genero)
9. `DML_Grupo.sql` - Grupos (depende de Sucursal)
10. `DML_Reto.sql` - Retos (depende de Unidad_medicion y Sucursal)
11. `DML_Origen.sql` - Origen (depende de Reto)
12. `DML_Miembro_Sucursal.sql` - Relación Miembro-Sucursal (depende de Miembro y Sucursal)
13. `DML_Membresia.sql` - Membresías (depende de Miembro y Tipo_Membresia)
14. `DML_Miembro_Grupo.sql` - Relación Miembro-Grupo (depende de Miembro y Grupo)
15. `DML_Reto_Grupal.sql` - Retos grupales (depende de Grupo, Reto y Estado)
16. `DML_Miembro_reto.sql` - Retos de miembros (depende de Miembro, Reto y Estado)
17. `DML_Punteo.sql` - Puntos (depende de Origen y Miembro)
18. `DML_Asistencia.sql` - Asistencia (depende de Miembro_Sucursal)
19. `DML_Canje.sql` - Canjes (depende de Miembro_Sucursal)
20. `DML_Pago.sql` - Pagos (depende de Membresia)
21. `DML_Sesion_virtual.sql` - Sesiones virtuales (depende de Membresia)

**Alternativa**: Puedes ejecutar `DML_Completo.sql` que contiene todas las declaraciones de inserción de datos en el orden correcto.

## Resumen del Esquema de la Base de Datos

La base de datos FitChain consta de las siguientes entidades principales:

- **Miembro**: Miembros del gimnasio con información personal
- **Sucursal**: Sucursales/ubicaciones del gimnasio
- **Membresia**: Suscripciones de miembros
- **Reto**: Retos de fitness
- **Grupo**: Grupos de miembros para actividades colaborativas
- **Punteo**: Puntos ganados por los miembros
- **Asistencia**: Registros de asistencia
- **Canje**: Canjes de puntos

La base de datos incluye un sistema de recompensas donde los miembros ganan puntos al completar retos y asistir al gimnasio, que luego pueden canjear por recompensas.

## Solución de Problemas

- **Violaciones de Restricciones**: Si encuentras errores de restricción de clave foránea, asegúrate de seguir el orden exacto para la ejecución de scripts como se indica arriba.
- **Problemas de Permisos**: Asegúrate de que tu inicio de sesión de SQL Server tenga los permisos apropiados para crear objetos de base de datos.
- **Ejecución Múltiple**: Los scripts no son idempotentes. Ejecutarlos varias veces resultará en errores de clave duplicada.

## Recomendaciones de Respaldo

Se recomienda crear una copia de seguridad después de crear y poblar exitosamente la base de datos:

```sql
BACKUP DATABASE FitChain 
TO DISK = 'C:\ruta\al\respaldo\FitChain.bak' 
WITH FORMAT, COMPRESSION, STATS = 10;
```

## Contacto

Para problemas o preguntas sobre la configuración de la base de datos FitChain, contacta a tu administrador de base de datos o al equipo de desarrollo.