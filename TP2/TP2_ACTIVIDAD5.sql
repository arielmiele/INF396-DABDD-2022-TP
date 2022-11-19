-- Actividad 5
-- Crear un Procedimiento almacenado que permita actualizar el precio de los artículos de un determinado origen en un determinado porcentaje.
CREATE OR REPLACE PROCEDURE ACTUALIZAR_PRECIO_ARTICULOS ( ORIGEN_ARTICULO VARCHAR, PORCENTAJE NUMBER )

IS
    -- PRECIO_ACTUAL NUMBER; -- Registra el precio actual del artículo
    EXISTE_ARTICULO NUMBER := 0; -- Si 0 el artículo no existe, Mayor que 0 el artículo existe
    ORIGEN_NO_ID EXCEPTION;
BEGIN
    SELECT COUNT(ORIGEN) INTO EXISTE_ARTICULO FROM PRODUCTOS WHERE ORIGEN = ORIGEN_ARTICULO; -- Busca el tipo de origen del artículo en la tabla
    IF (EXISTE_ARTICULO = 0) THEN
        RAISE ORIGEN_NO_ID; -- Si el origen no existe muestra el mensaje
    ELSE
        UPDATE PRODUCTOS SET PRECIOUNITARIO = (PRECIOUNITARIO+((PRECIOUNITARIO * PORCENTAJE)/100)) WHERE ORIGEN = ORIGEN_ARTICULO; -- Actualiza los valores unitarios para los articulos del origen especificado
    END IF;

EXCEPTION
    WHEN ORIGEN_NO_ID THEN
        DBMS_OUTPUT.PUT_LINE('NO EXISTE EL ORIGEN, la actualización no se puede realizar');
END;
