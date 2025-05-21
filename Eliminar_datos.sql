-- Script de limpieza para la base de datos FitChain
-- Elimina todos los datos en orden inverso a las dependencias (Nivel 3 → Nivel 2 → Nivel 1)
-- Generado el: SELECT CONVERT(VARCHAR, GETDATE(), 105) + ' ' + CONVERT(VARCHAR, GETDATE(), 108)

BEGIN TRY
    BEGIN TRANSACTION;
    
    -- ========== NIVEL 3: TABLAS TRANSACCIONALES ==========
    PRINT 'Eliminando datos de tablas transaccionales (Nivel 3)...';
    
    DELETE FROM Miembro_Grupo;
    PRINT '  - Datos de Miembro_Grupo eliminados';
    
    DELETE FROM Canje;
    PRINT '  - Datos de Canje eliminados';
    
    DELETE FROM Sesion_virtual;
    PRINT '  - Datos de Sesion_virtual eliminados';
    
    DELETE FROM Reto_Grupal;
    PRINT '  - Datos de Reto_Grupal eliminados';
    
    DELETE FROM Miembro_reto;
    PRINT '  - Datos de Miembro_reto eliminados';
    
    DELETE FROM Punteo;
    PRINT '  - Datos de Punteo eliminados';
    
    DELETE FROM Pesaje;
    PRINT '  - Datos de Pesaje eliminados';
    
    DELETE FROM Pago;
    PRINT '  - Datos de Pago eliminados';
    
    DELETE FROM Asistencia;
    PRINT '  - Datos de Asistencia eliminados';
    
    DELETE FROM Miembro_Acceso;
    PRINT '  - Datos de Miembro_Acceso eliminados';
    
    DELETE FROM Miembro_Sucursal;
    PRINT '  - Datos de Miembro_Sucursal eliminados';
    
    DELETE FROM Membresia;
    PRINT '  - Datos de Membresia eliminados';
    
    -- ========== NIVEL 2: TABLAS CON DEPENDENCIAS ==========
    PRINT 'Eliminando datos de tablas con dependencias (Nivel 2)...';
    
    DELETE FROM Miembro;
    PRINT '  - Datos de Miembro eliminados';
    
    DELETE FROM Sucursal;
    PRINT '  - Datos de Sucursal eliminados';
    
    DELETE FROM Grupo;
    PRINT '  - Datos de Grupo eliminados';
    
    DELETE FROM Reto;
    PRINT '  - Datos de Reto eliminados';
    
    DELETE FROM Origen;
    PRINT '  - Datos de Origen eliminados';
    
    -- ========== NIVEL 1: TABLAS BÁSICAS ==========
    PRINT 'Eliminando datos de tablas básicas (Nivel 1)...';
    
    DELETE FROM Genero;
    PRINT '  - Datos de Genero eliminados';
    
    DELETE FROM Pais;
    PRINT '  - Datos de Pais eliminados';
    
    DELETE FROM Ciudad;
    PRINT '  - Datos de Ciudad eliminados';
    
    DELETE FROM Condicion_Medica;
    PRINT '  - Datos de Condicion_Medica eliminados';
    
    DELETE FROM Estado;
    PRINT '  - Datos de Estado eliminados';
    
    DELETE FROM Tipo_Membresia;
    PRINT '  - Datos de Tipo_Membresia eliminados';
    
    DELETE FROM Tipo_Acceso;
    PRINT '  - Datos de Tipo_Acceso eliminados';
    
    DELETE FROM Unidad_medicion;
    PRINT '  - Datos de Unidad_medicion eliminados';
    
    COMMIT TRANSACTION;
    PRINT '¡Todos los datos han sido eliminados exitosamente!';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    
    PRINT 'Error durante la eliminación de datos:';
    PRINT '  Mensaje: ' + ERROR_MESSAGE();
    PRINT '  Línea: ' + CAST(ERROR_LINE() AS VARCHAR);
    PRINT '  Procedimiento: ' + COALESCE(ERROR_PROCEDURE(), 'N/A');
END CATCH;