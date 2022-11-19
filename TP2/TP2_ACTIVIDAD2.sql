-- Actividad 2
-- Crear un procedimiento almacenado que permita anular un pedido confirmado. El proceso de anulación debe actualizar los stocks de los artículos del pedido.

CREATE OR REPLACE PROCEDURE ANULAR_PEDIDO (
    ID_PEDIDO NUMBER
) IS
    STOCK_ACTUAL    NUMBER; -- Almacena el stock actual del producto
    CANTIDAD_PEDIDO NUMBER; -- ALmacena la cantidad pedida del producto
    NUEVO_STOCK     NUMBER; -- Se guardará el resultado de la cantidad pedida del producto
    PRODID          NUMBER; -- ID del producto proveniente del pedido
    EXISTE_PEDIDO   NUMBER := 0; -- Variable utilizada para estudiar la existencia del pedido
    RENGLON1        NUMBER; -- Identificación para el recorrido de los renglones
    PEDIDO_NO_ID    EXCEPTION;

BEGIN
    SELECT COUNT(NUMEROPEDIDO) INTO EXISTE_PEDIDO FROM PEDIDOS WHERE NUMEROPEDIDO = ID_PEDIDO; -- Busca el pedido en la tabla
    IF (EXISTE_PEDIDO = 0) THEN
        RAISE PEDIDO_NO_ID; -- Si el pedido no existe muestra el mensaje
    ELSE
        -- Si el pedido existe procede con la anulación
        FOR NUMEROPEDIDO IN (SELECT * FROM DETALLEPEDIDOS WHERE NUMEROPEDIDO = ID_PEDIDO) 
            LOOP
                SELECT * INTO RENGLON1 FROM (SELECT RENGLON FROM DETALLEPEDIDOS WHERE NUMEROPEDIDO = ID_PEDIDO) resultSet WHERE ROWNUM = 1; -- Buscamos la primer línea de la subtabla del detalle del pedido, obtenemos el número de renglon
                SELECT * INTO PRODID FROM (SELECT IDPRODUCTO FROM DETALLEPEDIDOS WHERE NUMEROPEDIDO = ID_PEDIDO AND RENGLON = RENGLON1) resultSET WHERE ROWNUM = 1; -- Guardo el ID del producto asociado al renglon
                SELECT * INTO CANTIDAD_PEDIDO FROM (SELECT CANTIDAD FROM DETALLEPEDIDOS WHERE NUMEROPEDIDO = ID_PEDIDO AND RENGLON = RENGLON1) resultSET WHERE ROWNUM = 1; -- Guardamos la cantidad de producto asociado al renglon
                SELECT STOCK INTO STOCK_ACTUAL FROM PRODUCTOS WHERE IDPRODUCTO = PRODID; -- Buscamos la cantidad actual del producto según el ID
                DELETE FROM DETALLEPEDIDOS WHERE NUMEROPEDIDO = ID_PEDIDO AND RENGLON = RENGLON1; -- Borramos el detalle del pedido
                NUEVO_STOCK := STOCK_ACTUAL + CANTIDAD_PEDIDO; -- Calculamos el valor del nuevo stock, sumándole la cantidad del pedido anulado
                UPDATE PRODUCTOS SET STOCK = NUEVO_STOCK WHERE IDPRODUCTO = PRODID; -- Actualizamos el valor del stock con el nuevo valor
            END LOOP;
        
        DELETE FROM PEDIDOS WHERE NUMEROPEDIDO = ID_PEDIDO; -- Elimina el pedido

        DBMS_OUTPUT.PUT_LINE('PEDIDO ANULADO');
    END IF;

EXCEPTION
    WHEN PEDIDO_NO_ID THEN
        DBMS_OUTPUT.PUT_LINE('NO EXISTE EL PEDIDO, no puede ser eliminado');
END;

-- EXECUTE ANULAR_PEDIDO(7);