/*
Trabajo Práctico Nº 4
DESARROLLO DE APLIC. CON BASES DE DATOS
2022
Alumno: ARIEL MIELE
Legajo: VINF011482
DNI: 34.434.704
*/

/*
OBJETIVO: Aplicar los conceptos teóricos y prácticos relevantes en la conformación de un almacén de datos.
Objetivos específicos para esta actividad:
- Reconocer componentes y características de un almacén de datos. 
- Aplicar los conceptos de un proceso ETL. 
- Implementar un proceso ETL mediante el lenguaje SQL.
*/

/* CONSIGNA:
El objetivo de este trabajo individual consiste en desarrollar un proceso ETL (Extracción, transformación y carga) utilizando lenguaje SQL, 
para completar la base de datos del Datawarehouse de la organización. 

Para ello se deben realizar las siguientes actividades:
1. Crear una base de datos denominada DWPedidos.
2. Crear las siguientes tablas en la base de datos DWPedidos (imágenes en el TP).
3. Cargar las tablas de la base de datos DWPedidos con los datos de la base de datos de PEDIDOS, mediante procedimientos almacenados desarrollados en SQL.
*/

/*
Como estamos usando Oracle SQL y un esquema de Autonomouse Databases Online, 
vamos a trabajar dentro de la misma base de datos anterior (según lo indicado por el profesor en el video explicativo sobre el TP4).
Se mantienen los ejercicios generados durante los Trabajos Prácticos anteriores. Se indica con comentarios el inicio de la resolución del TP4.
La Sección 1 de la resolución del TP4 comienza en la línea 1256.
*/

-- Instrucciones para realizar el DROP de las tablas de la base de datos para comenzar desde 0 la ejecución

DROP TABLE DETALLEPEDIDOS CASCADE CONSTRAINTS;

DROP TABLE CLIENTES CASCADE CONSTRAINTS;

DROP TABLE PROVEEDORES CASCADE CONSTRAINTS;

DROP TABLE VENDEDORES CASCADE CONSTRAINTS;

DROP TABLE PRODUCTOS CASCADE CONSTRAINTS;

DROP TABLE PEDIDOS CASCADE CONSTRAINTS;

-- Inicio de la creación de las tablas en la base de datos

/*
Crea la tabla Clientes
Se agrega el campo DNI para cumplir con unas de las consultas
*/
CREATE TABLE CLIENTES (
    IDCLIENTE INT GENERATED BY DEFAULT AS IDENTITY,
    APELLIDO VARCHAR(50) NOT NULL,
    NOMBRE VARCHAR(50) NOT NULL,
    DNI INT NOT NULL,
    DIRECCION VARCHAR(50) NOT NULL,
    MAIL VARCHAR(50) NOT NULL,
    PRIMARY KEY ( IDCLIENTE )
);

/* Crea la tabla Proveedores */
CREATE TABLE PROVEEDORES (
    IDPROVEEDOR INT GENERATED BY DEFAULT AS IDENTITY,
    NOMBREPROVEEDOR VARCHAR(50) NOT NULL,
    DIRECCION VARCHAR(50) NOT NULL,
    MAIL VARCHAR(50) NOT NULL,
    PRIMARY KEY ( IDPROVEEDOR )
);

/*
Crea la tabla Vendedores
Se agrega por 'default' un 10 a la comisión (10%)
Se agrega el campo DNI para cumplir con unas de las consultas
*/
CREATE TABLE VENDEDORES (
    IDVENDEDOR INT GENERATED BY DEFAULT AS IDENTITY,
    NOMBRE VARCHAR(50) NOT NULL,
    APELLIDO VARCHAR(50) NOT NULL,
    DNI INT NOT NULL,
    MAIL VARCHAR(50) NOT NULL,
    COMISION INT DEFAULT 10,
    PRIMARY KEY ( IDVENDEDOR )
);

/*
Crea la tabla Productos
Se agrega un check para que solo entre 'nacional' o 'importado'
*/
CREATE TABLE PRODUCTOS (
    IDPRODUCTO INT GENERATED BY DEFAULT AS IDENTITY,
    DESCRIPCION VARCHAR(50) NOT NULL,
    PRECIOUNITARIO FLOAT NOT NULL,
    STOCK INT NOT NULL,
    STOCKMINIMO INT NOT NULL,
    STOCKMAXIMO INT NOT NULL,
    IDPROVEEDOR INT,
    ORIGEN VARCHAR(9) NOT NULL,
    PRIMARY KEY ( IDPRODUCTO ),
    CONSTRAINT FK_PRODUCTOPROVEEDOR FOREIGN KEY ( IDPROVEEDOR ) REFERENCES PROVEEDORES ( IDPROVEEDOR ),
    CONSTRAINT CHK_ORIGEN CHECK ( ORIGEN IN ( 'nacional', 'importado' ) )
);

/* Crea la tabla Pedidos */
CREATE TABLE PEDIDOS (
    NUMEROPEDIDO INT GENERATED BY DEFAULT AS IDENTITY,
    IDCLIENTE INT NOT NULL,
    IDVENDEDOR INT NOT NULL,
    FECHA DATE NOT NULL,
    ESTADO VARCHAR(50) NOT NULL,
    PRIMARY KEY ( NUMEROPEDIDO ),
    CONSTRAINT FK_PEDIDOSCLIENTES FOREIGN KEY ( IDCLIENTE ) REFERENCES CLIENTES ( IDCLIENTE ),
    CONSTRAINT FK_PEDIDOSVENDEDORES FOREIGN KEY ( IDVENDEDOR ) REFERENCES VENDEDORES ( IDVENDEDOR )
);

/* Crea la tabla DetallePedidos */
CREATE TABLE DETALLEPEDIDOS (
    NUMEROPEDIDO INT NOT NULL,
    RENGLON INT NOT NULL,
    IDPRODUCTO INT NOT NULL,
    CANTIDAD INT NOT NULL,
    PRECIOUNITARIO FLOAT NOT NULL,
    TOTAL FLOAT NOT NULL,
    PRIMARY KEY ( NUMEROPEDIDO, RENGLON ),
    CONSTRAINT FK_DPEDIDOSPEDIDOS FOREIGN KEY ( NUMEROPEDIDO ) REFERENCES PEDIDOS ( NUMEROPEDIDO ),
    CONSTRAINT FK_DPEDIDOSPRODUCTOS FOREIGN KEY ( IDPRODUCTO ) REFERENCES PRODUCTOS ( IDPRODUCTO )
);

-- Fin de la creación de tablas de la base de datos

-- Inicio del agregado de información a la base de datos

/* Ingresar 5 Clientes */
INSERT INTO CLIENTES (
    APELLIDO,
    NOMBRE,
    DNI,
    DIRECCION,
    MAIL
) VALUES (
    'Perez',
    'Juan',
    '99123123',
    'Av. Siempre Viva 25',
    'juanperez@algo.com'
);

INSERT INTO CLIENTES (
    APELLIDO,
    NOMBRE,
    DNI,
    DIRECCION,
    MAIL
) VALUES (
    'Fernandez',
    'Pedro',
    '88123123',
    'Balcarce 50',
    'fpedro@algo.com'
);

INSERT INTO CLIENTES (
    APELLIDO,
    NOMBRE,
    DNI,
    DIRECCION,
    MAIL
) VALUES (
    'Martinez',
    'Julia',
    '96123123',
    'Uruguay 123',
    'jmartinez@algo.com'
);

INSERT INTO CLIENTES (
    APELLIDO,
    NOMBRE,
    DNI,
    DIRECCION,
    MAIL
) VALUES (
    'Gonzalez',
    'Mario',
    '75123123',
    'Cuchacucha 33',
    'g_mario@algo.com'
);

INSERT INTO CLIENTES (
    APELLIDO,
    NOMBRE,
    DNI,
    DIRECCION,
    MAIL
) VALUES (
    'Gomez',
    'Isidoro',
    '23787844',
    'Gral. Pueyrredon 1789',
    'isidoro@yahoo.com.ar'
);

INSERT INTO CLIENTES (
    APELLIDO,
    NOMBRE,
    DNI,
    DIRECCION,
    MAIL
) VALUES (
    'Lopez',
    'Maria',
    '99321123',
    'Calle SinNombre 443',
    'marialopez@algo.com'
);

/* Ingresar 3 Proveedores */
INSERT INTO PROVEEDORES (
    NOMBREPROVEEDOR,
    DIRECCION,
    MAIL
) VALUES (
    'Casa China',
    'Arribeños 789',
    'pedidos@casachina.com'
);

INSERT INTO PROVEEDORES (
    NOMBREPROVEEDOR,
    DIRECCION,
    MAIL
) VALUES (
    'Metal Todo S.R.L.',
    'Pedro de Mendoza 45',
    'ventas@metaltodo.com'
);

INSERT INTO PROVEEDORES (
    NOMBREPROVEEDOR,
    DIRECCION,
    MAIL
) VALUES (
    'Termos y más',
    'Corrientes 345',
    'pedidos@termosymas.com'
);

/* Ingresar 3 Vendedores */
INSERT INTO VENDEDORES (
    NOMBRE,
    APELLIDO,
    DNI,
    MAIL
) VALUES (
    'Juan',
    'Albarracin',
    '96123123',
    'juan_a@algo.com'
);

INSERT INTO VENDEDORES (
    NOMBRE,
    APELLIDO,
    DNI,
    MAIL
) VALUES (
    'Martin',
    'Mendoza',
    '23787844',
    'mendozamartin@algo.com'
);

INSERT INTO VENDEDORES (
    NOMBRE,
    APELLIDO,
    DNI,
    MAIL
) VALUES (
    'Veronica',
    'Martinez',
    '88123123',
    'vm_89@algo.com'
);

/* Ingresar 10+ productos */
INSERT INTO PRODUCTOS (
    DESCRIPCION,
    PRECIOUNITARIO,
    STOCK,
    STOCKMINIMO,
    STOCKMAXIMO,
    IDPROVEEDOR,
    ORIGEN
) VALUES (
    'Pava Electrica',
    '500.0',
    '12',
    '10',
    '20',
    '3',
    'importado'
);

INSERT INTO PRODUCTOS (
    DESCRIPCION,
    PRECIOUNITARIO,
    STOCK,
    STOCKMINIMO,
    STOCKMAXIMO,
    IDPROVEEDOR,
    ORIGEN
) VALUES (
    'Arrocera',
    '1500.0',
    '15',
    '5',
    '20',
    '1',
    'importado'
);

INSERT INTO PRODUCTOS (
    DESCRIPCION,
    PRECIOUNITARIO,
    STOCK,
    STOCKMINIMO,
    STOCKMAXIMO,
    IDPROVEEDOR,
    ORIGEN
) VALUES (
    'Estufa',
    '2300.0',
    '10',
    '5',
    '25',
    '2',
    'nacional'
);

INSERT INTO PRODUCTOS (
    DESCRIPCION,
    PRECIOUNITARIO,
    STOCK,
    STOCKMINIMO,
    STOCKMAXIMO,
    IDPROVEEDOR,
    ORIGEN
) VALUES (
    'Cocina',
    '32000.0',
    '5',
    '1',
    '10',
    '3',
    'nacional'
);

INSERT INTO PRODUCTOS (
    DESCRIPCION,
    PRECIOUNITARIO,
    STOCK,
    STOCKMINIMO,
    STOCKMAXIMO,
    IDPROVEEDOR,
    ORIGEN
) VALUES (
    'Heladera',
    '85000.0',
    '3',
    '1',
    '10',
    '3',
    'nacional'
);

INSERT INTO PRODUCTOS (
    DESCRIPCION,
    PRECIOUNITARIO,
    STOCK,
    STOCKMINIMO,
    STOCKMAXIMO,
    IDPROVEEDOR,
    ORIGEN
) VALUES (
    'Micronda',
    '5500.0',
    '10',
    '5',
    '25',
    '2',
    'nacional'
);

INSERT INTO PRODUCTOS (
    DESCRIPCION,
    PRECIOUNITARIO,
    STOCK,
    STOCKMINIMO,
    STOCKMAXIMO,
    IDPROVEEDOR,
    ORIGEN
) VALUES (
    'Mesa',
    '20000.0',
    '10',
    '5',
    '25',
    '1',
    'importado'
);

INSERT INTO PRODUCTOS (
    DESCRIPCION,
    PRECIOUNITARIO,
    STOCK,
    STOCKMINIMO,
    STOCKMAXIMO,
    IDPROVEEDOR,
    ORIGEN
) VALUES (
    'Silla',
    '2300.0',
    '12',
    '8',
    '25',
    '2',
    'nacional'
);

INSERT INTO PRODUCTOS (
    DESCRIPCION,
    PRECIOUNITARIO,
    STOCK,
    STOCKMINIMO,
    STOCKMAXIMO,
    IDPROVEEDOR,
    ORIGEN
) VALUES (
    'Velador',
    '1000.0',
    '20',
    '5',
    '30',
    '2',
    'importado'
);

INSERT INTO PRODUCTOS (
    DESCRIPCION,
    PRECIOUNITARIO,
    STOCK,
    STOCKMINIMO,
    STOCKMAXIMO,
    IDPROVEEDOR,
    ORIGEN
) VALUES (
    'Televisor',
    '5000.0',
    '20',
    '5',
    '30',
    '2',
    'importado'
);

INSERT INTO PRODUCTOS (
    DESCRIPCION,
    PRECIOUNITARIO,
    STOCK,
    STOCKMINIMO,
    STOCKMAXIMO,
    IDPROVEEDOR,
    ORIGEN
) VALUES (
    'Lavarropa',
    '45000.0',
    '8',
    '3',
    '10',
    '3',
    'nacional'
);

/* Ingresar 10 Pedidos */
INSERT INTO PEDIDOS (
    IDCLIENTE,
    IDVENDEDOR,
    FECHA,
    ESTADO
) VALUES (
    '1',
    '1',
    TO_DATE('2022-08-28', 'YYYY-MM-DD'),
    'entregado'
);

INSERT INTO PEDIDOS (
    IDCLIENTE,
    IDVENDEDOR,
    FECHA,
    ESTADO
) VALUES (
    '3',
    '2',
    TO_DATE('2022-08-28', 'YYYY-MM-DD'),
    'entregado'
);

INSERT INTO PEDIDOS (
    IDCLIENTE,
    IDVENDEDOR,
    FECHA,
    ESTADO
) VALUES (
    '3',
    '2',
    TO_DATE('2022-08-29', 'YYYY-MM-DD'),
    'entregado'
);

INSERT INTO PEDIDOS (
    IDCLIENTE,
    IDVENDEDOR,
    FECHA,
    ESTADO
) VALUES (
    '1',
    '1',
    TO_DATE('2022-08-29', 'YYYY-MM-DD'),
    'entregado'
);

INSERT INTO PEDIDOS (
    IDCLIENTE,
    IDVENDEDOR,
    FECHA,
    ESTADO
) VALUES (
    '5',
    '2',
    TO_DATE('2022-08-29', 'YYYY-MM-DD'),
    'entregado'
);

INSERT INTO PEDIDOS (
    IDCLIENTE,
    IDVENDEDOR,
    FECHA,
    ESTADO
) VALUES (
    '1',
    '1',
    TO_DATE('2022-08-30', 'YYYY-MM-DD'),
    'entregado'
);

INSERT INTO PEDIDOS (
    IDCLIENTE,
    IDVENDEDOR,
    FECHA,
    ESTADO
) VALUES (
    '5',
    '3',
    TO_DATE('2022-08-30', 'YYYY-MM-DD'),
    'entregado'
);

INSERT INTO PEDIDOS (
    IDCLIENTE,
    IDVENDEDOR,
    FECHA,
    ESTADO
) VALUES (
    '5',
    '2',
    TO_DATE('2022-08-31', 'YYYY-MM-DD'),
    'entregado'
);

INSERT INTO PEDIDOS (
    IDCLIENTE,
    IDVENDEDOR,
    FECHA,
    ESTADO
) VALUES (
    '1',
    '2',
    TO_DATE('2022-08-31', 'YYYY-MM-DD'),
    'entregado'
);

INSERT INTO PEDIDOS (
    IDCLIENTE,
    IDVENDEDOR,
    FECHA,
    ESTADO
) VALUES (
    '2',
    '3',
    TO_DATE('2022-08-31', 'YYYY-MM-DD'),
    'entregado'
);

/* Ingreso DetallePedidos */
INSERT INTO DETALLEPEDIDOS (
    NUMEROPEDIDO,
    RENGLON,
    IDPRODUCTO,
    CANTIDAD,
    PRECIOUNITARIO,
    TOTAL
) VALUES (
    '1',
    '1',
    '1',
    '2',
    '500',
    '1000'
);

INSERT INTO DETALLEPEDIDOS (
    NUMEROPEDIDO,
    RENGLON,
    IDPRODUCTO,
    CANTIDAD,
    PRECIOUNITARIO,
    TOTAL
) VALUES (
    '1',
    '2',
    '2',
    '1',
    '1500',
    '1500'
);

INSERT INTO DETALLEPEDIDOS (
    NUMEROPEDIDO,
    RENGLON,
    IDPRODUCTO,
    CANTIDAD,
    PRECIOUNITARIO,
    TOTAL
) VALUES (
    '1',
    '3',
    '3',
    '3',
    '2300',
    '6900'
);

INSERT INTO DETALLEPEDIDOS (
    NUMEROPEDIDO,
    RENGLON,
    IDPRODUCTO,
    CANTIDAD,
    PRECIOUNITARIO,
    TOTAL
) VALUES (
    '2',
    '1',
    '3',
    '8',
    '2300',
    '18400'
);

INSERT INTO DETALLEPEDIDOS (
    NUMEROPEDIDO,
    RENGLON,
    IDPRODUCTO,
    CANTIDAD,
    PRECIOUNITARIO,
    TOTAL
) VALUES (
    '2',
    '2',
    '4',
    '2',
    '32000',
    '64000'
);

INSERT INTO DETALLEPEDIDOS (
    NUMEROPEDIDO,
    RENGLON,
    IDPRODUCTO,
    CANTIDAD,
    PRECIOUNITARIO,
    TOTAL
) VALUES (
    '2',
    '3',
    '5',
    '1',
    '85000',
    '85000'
);

INSERT INTO DETALLEPEDIDOS (
    NUMEROPEDIDO,
    RENGLON,
    IDPRODUCTO,
    CANTIDAD,
    PRECIOUNITARIO,
    TOTAL
) VALUES (
    '3',
    '1',
    '6',
    '6',
    '5500',
    '33000'
);

INSERT INTO DETALLEPEDIDOS (
    NUMEROPEDIDO,
    RENGLON,
    IDPRODUCTO,
    CANTIDAD,
    PRECIOUNITARIO,
    TOTAL
) VALUES (
    '3',
    '2',
    '7',
    '2',
    '20000',
    '40000'
);

INSERT INTO DETALLEPEDIDOS (
    NUMEROPEDIDO,
    RENGLON,
    IDPRODUCTO,
    CANTIDAD,
    PRECIOUNITARIO,
    TOTAL
) VALUES (
    '3',
    '3',
    '8',
    '4',
    '2300',
    '9200'
);

INSERT INTO DETALLEPEDIDOS (
    NUMEROPEDIDO,
    RENGLON,
    IDPRODUCTO,
    CANTIDAD,
    PRECIOUNITARIO,
    TOTAL
) VALUES (
    '4',
    '1',
    '9',
    '5',
    '1000',
    '5000'
);

INSERT INTO DETALLEPEDIDOS (
    NUMEROPEDIDO,
    RENGLON,
    IDPRODUCTO,
    CANTIDAD,
    PRECIOUNITARIO,
    TOTAL
) VALUES (
    '4',
    '2',
    '10',
    '1',
    '45000',
    '45000'
);

INSERT INTO DETALLEPEDIDOS (
    NUMEROPEDIDO,
    RENGLON,
    IDPRODUCTO,
    CANTIDAD,
    PRECIOUNITARIO,
    TOTAL
) VALUES (
    '5',
    '1',
    '1',
    '2',
    '500',
    '1000'
);

INSERT INTO DETALLEPEDIDOS (
    NUMEROPEDIDO,
    RENGLON,
    IDPRODUCTO,
    CANTIDAD,
    PRECIOUNITARIO,
    TOTAL
) VALUES (
    '5',
    '2',
    '2',
    '1',
    '1500',
    '1500'
);

INSERT INTO DETALLEPEDIDOS (
    NUMEROPEDIDO,
    RENGLON,
    IDPRODUCTO,
    CANTIDAD,
    PRECIOUNITARIO,
    TOTAL
) VALUES (
    '6',
    '1',
    '3',
    '3',
    '2300',
    '6900'
);

INSERT INTO DETALLEPEDIDOS (
    NUMEROPEDIDO,
    RENGLON,
    IDPRODUCTO,
    CANTIDAD,
    PRECIOUNITARIO,
    TOTAL
) VALUES (
    '7',
    '1',
    '3',
    '8',
    '2300',
    '18400'
);

INSERT INTO DETALLEPEDIDOS (
    NUMEROPEDIDO,
    RENGLON,
    IDPRODUCTO,
    CANTIDAD,
    PRECIOUNITARIO,
    TOTAL
) VALUES (
    '7',
    '2',
    '4',
    '2',
    '32000',
    '64000'
);

INSERT INTO DETALLEPEDIDOS (
    NUMEROPEDIDO,
    RENGLON,
    IDPRODUCTO,
    CANTIDAD,
    PRECIOUNITARIO,
    TOTAL
) VALUES (
    '7',
    '3',
    '5',
    '1',
    '85000',
    '85000'
);

INSERT INTO DETALLEPEDIDOS (
    NUMEROPEDIDO,
    RENGLON,
    IDPRODUCTO,
    CANTIDAD,
    PRECIOUNITARIO,
    TOTAL
) VALUES (
    '8',
    '1',
    '6',
    '6',
    '5500',
    '33000'
);

INSERT INTO DETALLEPEDIDOS (
    NUMEROPEDIDO,
    RENGLON,
    IDPRODUCTO,
    CANTIDAD,
    PRECIOUNITARIO,
    TOTAL
) VALUES (
    '8',
    '2',
    '7',
    '2',
    '20000',
    '40000'
);

INSERT INTO DETALLEPEDIDOS (
    NUMEROPEDIDO,
    RENGLON,
    IDPRODUCTO,
    CANTIDAD,
    PRECIOUNITARIO,
    TOTAL
) VALUES (
    '9',
    '1',
    '8',
    '4',
    '2300',
    '9200'
);

INSERT INTO DETALLEPEDIDOS (
    NUMEROPEDIDO,
    RENGLON,
    IDPRODUCTO,
    CANTIDAD,
    PRECIOUNITARIO,
    TOTAL
) VALUES (
    '10',
    '1',
    '9',
    '5',
    '1000',
    '5000'
);

INSERT INTO DETALLEPEDIDOS (
    NUMEROPEDIDO,
    RENGLON,
    IDPRODUCTO,
    CANTIDAD,
    PRECIOUNITARIO,
    TOTAL
) VALUES (
    '10',
    '2',
    '10',
    '1',
    '45000',
    '45000'
);

-- Fin del agregado de información a la base de datos

-- Resolución TP2

-- Actividad 1
-- Crear un bloque PL SQL que permita, mediante una transacción, realizar el registro de un pedido con su detalle (renglones).
-- El proceso debe contemplar la actualización del stock de los productos pedidos. En caso de producirse un error, la transacción debe ser cancelada.

DECLARE
 -- Cómo este no es un procedimiento almacenado se definen los valores de los parámetros como sigue:
    PEDIDO_ID         NUMBER; -- Utilizado para identificar el número de pedido creado
    PRODUCTO_ID       NUMBER := 1; -- Utilizado para identificar el ID del producto para el cual se crea un renglón en el pedido. Stock inicial = 12
    PRODUCTOBUSCADO   NUMBER := 0; -- Utilizado para la búsqueda del producto en la tabla. Inicializado en 0.
    PRODUCTO_CANTIDAD NUMBER := 1; -- Utilizado para identificar la cantidad de producto que se requiere en el renglón del pedido. Es posible crear el pedido, la cantidad del pedido es menor al stock.
 -- PRODUCTO_CANTIDAD := 13; -- No es posible crear el pedido, dado que el stock actual es 12 unidades
    STOCK_ACTUAL      NUMBER; -- Utilizado para identificar el stock actual del producto
    CLIENTE_ID        NUMBER := 1; -- Utilizado para identificar el ID del cliente para el que se solicita el pedido. Es pobile crear el pedido, el cliente existe .
 -- CLIENTE_ID := 7; -- No es posible crear el pedido, el cliente no existe
    CLIENTEBUSCADO    NUMBER; -- Utilizado para guardar el cliente buscado en la tabla
    PROVEEDOR_ID      NUMBER := 1; -- Utilizado para identificar el ID del proveedor para el que se solicita el pedido. Es posible crear el pedido, el proveedor existe.
 -- PROVEEDOR_ID := 5; -- No es posible crear el pedido, el proveedor no existe
    PROVEEDORBUSCADO  NUMBER; -- Utilizado para guardar el proveedor buscado en la tabla
    FECHA_PEDIDO      DATE := TO_DATE('2022-09-28', 'YYYY-MM-DD'); -- Fecha del pedido
    ESTADO_PEDIDO     VARCHAR(50) := 'entregado'; -- Estado del pedido
    PUNITARIO         NUMBER; -- Precio unitario del producto
    PTOTAL            NUMBER; -- Precio total del pedido
    NUEVOSTOCK        NUMBER; -- Utilizado para calcular el nuevo stock
    PRODUCTO_NO_ID EXCEPTION; -- Excepción utilizada cuando se identifica que no existe el producto que se desea crear
    SIN_STOCK EXCEPTION; -- Excepción utilizada cuando se identifica que no existe stock para la creación del pedido
    CLIENTE_NO_ID EXCEPTION; -- Excepción utilizada cuando se identifica que el cliente no existe en el sistema
    PROVEEDOR_NO_ID EXCEPTION; -- Excepción utilizada cuando se identifica que el proveedor no existe en el sistema
BEGIN
 -- Identificamos si el producto existe dentro de la listas de productos
    SELECT
        COUNT(IDPRODUCTO) INTO PRODUCTOBUSCADO
    FROM
        PRODUCTOS
    WHERE
        IDPRODUCTO = PRODUCTO_ID; -- Busca el ID del producto en la tabla PRODUCTOS
    SELECT
        STOCK INTO STOCK_ACTUAL
    FROM
        PRODUCTOS
    WHERE
        IDPRODUCTO = PRODUCTO_ID; -- Busca la cantidad disponible del producto
    SELECT
        COUNT(IDCLIENTE) INTO CLIENTEBUSCADO
    FROM
        CLIENTES
    WHERE
        IDCLIENTE = CLIENTE_ID; -- Busca el ID del cliente en la tabla CLIENTES
    SELECT
        COUNT(IDPROVEEDOR) INTO PROVEEDORBUSCADO
    FROM
        PROVEEDORES
    WHERE
        IDPROVEEDOR = PROVEEDOR_ID; -- Busca el ID del proveedor en la tabla PROVEEDORES
    IF (PRODUCTOBUSCADO = 0) THEN
        RAISE PRODUCTO_NO_ID; -- No se encontró el producto
    ELSIF (PRODUCTO_CANTIDAD > STOCK_ACTUAL) THEN
        RAISE SIN_STOCK; -- No hay stock suficiente del producto solicitado
    ELSIF (CLIENTEBUSCADO = 0) THEN
        RAISE CLIENTE_NO_ID; -- No existe el ID del cliente
    ELSIF (PROVEEDORBUSCADO = 0) THEN
        RAISE PROVEEDOR_NO_ID; -- No existe el ID del proveedor
    ELSE
        DBMS_OUTPUT.PUT_LINE('GENERANDO PEDIDO. Stock actual del producto '
            || PRODUCTO_ID
            || ': '
            || STOCK_ACTUAL);
 -- Comienza creación del pedido en tabla PEDIDOS
        INSERT INTO PEDIDOS (
            IDCLIENTE,
            IDVENDEDOR,
            FECHA,
            ESTADO
        ) VALUES (
            CLIENTE_ID,
            PROVEEDOR_ID,
            FECHA_PEDIDO,
            ESTADO_PEDIDO
        ) RETURNING NUMEROPEDIDO INTO PEDIDO_ID;
        DBMS_OUTPUT.PUT_LINE('PEDIDO GENERADO. Numero de pedido: '
            || PEDIDO_ID);
 -- Finaliza creación del pedido en tabla PEDIDOS
 -- Comienza creación del detalle del pedido en DETALLEPEDIDOS
        SELECT
            PRECIOUNITARIO INTO PUNITARIO
        FROM
            PRODUCTOS
        WHERE
            IDPRODUCTO = PRODUCTO_ID; -- Obtención del precio unitario del producto
        PTOTAL := PRODUCTO_CANTIDAD * PUNITARIO; -- Cálculo del precio total según cantidad de producto y precio unitario
        INSERT INTO DETALLEPEDIDOS (
            NUMEROPEDIDO,
            RENGLON,
            IDPRODUCTO,
            CANTIDAD,
            PRECIOUNITARIO,
            TOTAL
        ) VALUES (
            PEDIDO_ID,
            '1',
            PRODUCTO_ID,
            PRODUCTO_CANTIDAD,
            PUNITARIO,
            PTOTAL
        );
        DBMS_OUTPUT.PUT_LINE('DETALLE DEL PEDIDO GENERADO. Renglon 1. Producto: '
            || PRODUCTO_ID
            || ' | Cantidad:'
            || PRODUCTO_CANTIDAD
            || ' - Precio Unitario: '
            || PUNITARIO
            || ' - Precio Total:'
            || PTOTAL);
 -- Finaliza creación del detalle del pedido en DETALLEPEDIDOS
 -- Comienza actualización del stock del producto en PRODUCTOS
        NUEVOSTOCK := STOCK_ACTUAL - PRODUCTO_CANTIDAD; -- Se actualiza el stock restándole la cantidad del producto pedido
        UPDATE PRODUCTOS
        SET
            STOCK = NUEVOSTOCK
        WHERE
            IDPRODUCTO = PRODUCTO_ID;
 -- Finaliza actualización del stock del producto en PRODUCTOS
        DBMS_OUTPUT.PUT_LINE('PEDIDO GENERADO. Nuevo stock del producto '
            || PRODUCTO_ID
            || ': '
            || NUEVOSTOCK);
    END IF;
EXCEPTION
    WHEN PRODUCTO_NO_ID THEN
        DBMS_OUTPUT.PUT_LINE('PRODUCTO NO ENCONTRADO, no se puede generar el pedido');
    WHEN SIN_STOCK THEN
        DBMS_OUTPUT.PUT_LINE('EL PRODUCTO NO POSEE STOCK SUFICIENTE, no se puede generar el pedido');
    WHEN CLIENTE_NO_ID THEN
        DBMS_OUTPUT.PUT_LINE('NO EXISTE EL CLIENTE, no se puede generar el pedido');
    WHEN PROVEEDOR_NO_ID THEN
        DBMS_OUTPUT.PUT_LINE('NO EXISTE EL PROVEEDOR, no se puede generar el pedido');
END;

-- Actividad 2
-- Crear un procedimiento almacenado que permita anular un pedido confirmado. El proceso de anulación debe actualizar los stocks de los artículos del pedido.
CREATE OR REPLACE PROCEDURE ANULAR_PEDIDO ( ID_PEDIDO NUMBER ) 
IS 
    STOCK_ACTUAL NUMBER; -- Almacena el stock actual del producto
    CANTIDAD_PEDIDO NUMBER; -- ALmacena la cantidad pedida del producto
    NUEVO_STOCK NUMBER; -- Se guardará el resultado de la cantidad pedida del producto
    PRODID NUMBER; -- ID del producto proveniente del pedido
    EXISTE_PEDIDO NUMBER := 0; -- Variable utilizada para estudiar la existencia del pedido
    RENGLON1 NUMBER; -- Identificación para el recorrido de los renglones
    PEDIDO_NO_ID EXCEPTION;
        BEGIN
        SELECT
            COUNT(NUMEROPEDIDO) INTO EXISTE_PEDIDO
        FROM
            PEDIDOS
        WHERE
            NUMEROPEDIDO = ID_PEDIDO; -- Busca el pedido en la tabla
        IF (EXISTE_PEDIDO = 0) THEN
            RAISE PEDIDO_NO_ID; -- Si el pedido no existe muestra el mensaje
        ELSE
 -- Si el pedido existe procede con la anulación
            FOR NUMEROPEDIDO IN (
                SELECT
                    *
                FROM
                    DETALLEPEDIDOS
                WHERE
                    NUMEROPEDIDO = ID_PEDIDO
            ) LOOP
                SELECT
                    * INTO RENGLON1
                FROM
                    (
                        SELECT
                            RENGLON
                        FROM
                            DETALLEPEDIDOS
                        WHERE
                            NUMEROPEDIDO = ID_PEDIDO
                    ) RESULTSET
                WHERE
                    ROWNUM = 1; -- Buscamos la primer línea de la subtabla del detalle del pedido, obtenemos el número de renglon
                SELECT
                    * INTO PRODID
                FROM
                    (
                        SELECT
                            IDPRODUCTO
                        FROM
                            DETALLEPEDIDOS
                        WHERE
                            NUMEROPEDIDO = ID_PEDIDO
                            AND RENGLON = RENGLON1
                    ) RESULTSET
                WHERE
                    ROWNUM = 1; -- Guardo el ID del producto asociado al renglon
                SELECT
                    * INTO CANTIDAD_PEDIDO
                FROM
                    (
                        SELECT
                            CANTIDAD
                        FROM
                            DETALLEPEDIDOS
                        WHERE
                            NUMEROPEDIDO = ID_PEDIDO
                            AND RENGLON = RENGLON1
                    ) RESULTSET
                WHERE
                    ROWNUM = 1; -- Guardamos la cantidad de producto asociado al renglon
                SELECT
                    STOCK INTO STOCK_ACTUAL
                FROM
                    PRODUCTOS
                WHERE
                    IDPRODUCTO = PRODID; -- Buscamos la cantidad actual del producto según el ID
                DELETE FROM DETALLEPEDIDOS
                WHERE
                    NUMEROPEDIDO = ID_PEDIDO
                    AND RENGLON = RENGLON1; -- Borramos el detalle del pedido
                NUEVO_STOCK := STOCK_ACTUAL + CANTIDAD_PEDIDO; -- Calculamos el valor del nuevo stock, sumándole la cantidad del pedido anulado
                UPDATE PRODUCTOS
                SET
                    STOCK = NUEVO_STOCK
                WHERE
                    IDPRODUCTO = PRODID; -- Actualizamos el valor del stock con el nuevo valor
            END LOOP;
            DELETE FROM PEDIDOS
            WHERE
                NUMEROPEDIDO = ID_PEDIDO; -- Elimina el pedido
            DBMS_OUTPUT.PUT_LINE('PEDIDO ANULADO');
        END IF;
        EXCEPTION
    WHEN PEDIDO_NO_ID THEN
        DBMS_OUTPUT.PUT_LINE('NO EXISTE EL PEDIDO, no puede ser eliminado');
END;
 -- EXECUTE ANULAR_PEDIDO(7);
 -- Actividad 3
 -- Crear una tabla denominada Log (idlog, numeroPedido,FechaAnulacion).
CREATE TABLE LOG ( IDLOG INT GENERATED BY DEFAULT AS IDENTITY, NUMEROPEDIDO INT NOT NULL, FECHAANULACION DATE NOT NULL, PRIMARY KEY ( IDLOG ) );
 -- Actividad 4
 -- Crear un trigger que permita, al momento de anularse un pedido, registrar en la tabla Log, el número de pedido anulado y la fecha de anulación.
CREATE OR REPLACE TRIGGER REGISTRO_LOG_ANULACION AFTER
DELETE ON PEDIDOS REFERENCING OLD AS O NEW AS N FOR EACH ROW BEGIN INSERT INTO LOG (NUMEROPEDIDO,
FECHAANULACION) VALUES (:O.NUMEROPEDIDO,
SYSDATE); -- Ingresa el valor eliminado de numero de pedido y la fecha en la que se realiza la inserción dentro de la tabla LOG
END;
 -- Actividad 5
 -- Crear un Procedimiento almacenado que permita actualizar el precio de los artículos de un determinado origen en un determinado porcentaje.
CREATE OR REPLACE PROCEDURE ACTUALIZAR_PRECIO_ARTICULOS ( ORIGEN_ARTICULO VARCHAR, PORCENTAJE NUMBER ) IS EXISTE_ARTICULO NUMBER := 0; -- Si 0 el artículo no existe, Mayor que 0 el artículo existe
ORIGEN_NO_ID
EXCEPTION;
        BEGIN
        SELECT
            COUNT(ORIGEN) INTO EXISTE_ARTICULO
        FROM
            PRODUCTOS
        WHERE
            ORIGEN = ORIGEN_ARTICULO; -- Busca el tipo de origen del artículo en la tabla
        IF (EXISTE_ARTICULO = 0) THEN
            RAISE ORIGEN_NO_ID; -- Si el origen no existe muestra el mensaje
        ELSE
            UPDATE PRODUCTOS
            SET
                PRECIOUNITARIO = (
                    PRECIOUNITARIO+((PRECIOUNITARIO * PORCENTAJE)/100)
                )
            WHERE
                ORIGEN = ORIGEN_ARTICULO; -- Actualiza los valores unitarios para los articulos del origen especificado
        END IF;
        EXCEPTION
    WHEN ORIGEN_NO_ID THEN
        DBMS_OUTPUT.PUT_LINE('NO EXISTE EL ORIGEN, la actualización no se puede realizar');
END;

-- FIN Resolución TP2

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

-- INICIO Resolución TP4

-- Instrucciones para realizar el DROP de las tablas de la base de datos para comenzar desde 0 la ejecución

DROP TABLE DIMFECHAS CASCADE CONSTRAINTS;

DROP TABLE DIMPRODUCTOS CASCADE CONSTRAINTS;

DROP TABLE DIMCLIENTES CASCADE CONSTRAINTS;

DROP TABLE FACTPEDIDOS CASCADE CONSTRAINTS;

----------------------
-- INICIO SECCION 1 --
----------------------

-- Inicio de la creación de tablas en el Data Warehouse

-- Creación de la tabla DIMFECHAS
CREATE TABLE DIMFECHAS (
    ID_FEC INT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
    FECHA DATE,
    DIA INT,
    MES INT,
    ANIO INT,
    PRIMARY KEY (ID_FEC)
);

-- Creación de la tabla DIMPRODUCTOS
CREATE TABLE DIMPRODUCTOS (
    ID_PRO INT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
    IDPRODUCTO INT,
    DESCRIPCION VARCHAR (50),
    NOMBREPROVEEDOR VARCHAR (50),
    PRIMARY KEY (ID_PRO)
);

-- Creación de la tabla DIMCLIENTES
CREATE TABLE DIMCLIENTES (
    ID_CLI INT GENERATED BY DEFAULT AS IDENTITY NOT NULL,
    IDCLIENTE INT,
    NOMBRE VARCHAR (50),
    PRIMARY KEY (ID_CLI)
);

-- Creación de la tabla FACTPEDIDOS
CREATE TABLE FACTPEDIDOS (
    ID_CLI INT NOT NULL,
    ID_PRO INT NOT NULL,
    ID_FEC INT NOT NULL,
    CANTIDAD INT NOT NULL,
    TOTAL INT NOT NULL,
    CONSTRAINT FK_FACTCLIENTES FOREIGN KEY (ID_CLI) REFERENCES DIMCLIENTES (ID_CLI),
    CONSTRAINT FK_FACTPRODUCTOS FOREIGN KEY (ID_PRO) REFERENCES DIMPRODUCTOS (ID_PRO),
    CONSTRAINT FK_FACTFECHAS FOREIGN KEY (ID_FEC) REFERENCES DIMFECHAS (ID_FEC)
);

-- Fin de la creación de tablas para el Data Warehouse

-------------------
-- FIN SECCION 1 --
-------------------

-- Comienzo de los DROP para los Procedimientos almacenados

DROP PROCEDURE CARGAR_FECHAS;

DROP PROCEDURE CARGAR_PRODUCTOS;

DROP PROCEDURE CARGAR_CLIENTES;

DROP PROCEDURE FACTURAR_PEDIDOS;

-- Fin de los DROP para los Procedimientos Almacenados

----------------------
-- INICIO SECCION 2 --
----------------------

-- Inicio de la creación de los procedimientos almacenados para la carga de datos

-- Procedimiento almacenado que permite cargar fechas
CREATE OR REPLACE PROCEDURE CARGAR_FECHAS
IS
BEGIN
    INSERT INTO DIMFECHAS 
        (FECHA, DIA, MES, ANIO)
    SELECT DISTINCT
        FECHA, 
        EXTRACT (DAY FROM FECHA) AS DIA, 
        EXTRACT (MONTH FROM FECHA) AS MES, 
        EXTRACT (YEAR FROM FECHA) AS ANIO
    FROM PEDIDOS
    EXCEPTION;
END;

-- Ejecuta el procedimiento almacenado
EXECUTE CARGAR_FECHAS; 

-- Lee el contenido de la tabla DIMFECHAS
SELECT * FROM DIMFECHAS; 

-- Procedimiento almacenado que permite cargar productos
CREATE OR REPLACE PROCEDURE CARGAR_PRODUCTOS
IS
BEGIN
    INSERT INTO DIMPRODUCTOS 
        (IDPRODUCTO, DESCRIPCION, NOMBREPROVEEDOR)
    SELECT 
        IDPRODUCTO, 
        DESCRIPCION,
        NOMBREPROVEEDOR
    FROM PRODUCTOS 
    INNER JOIN PROVEEDORES
    ON PRODUCTOS.IDPROVEEDOR = PROVEEDORES.IDPROVEEDOR;
END;

-- Ejecuta el procedimiento almacenado
EXECUTE CARGAR_PRODUCTOS; 

-- Lee el contenido de la tabla DIMPRODUCTOS
SELECT * FROM DIMPRODUCTOS;

-- Procedimiento almacenado que permite cargar clientes
CREATE OR REPLACE PROCEDURE CARGAR_CLIENTES
IS
BEGIN
    INSERT INTO DIMCLIENTES 
        (IDCLIENTE, NOMBRE)
    SELECT 
        IDCLIENTE, 
        CONCAT(CONCAT(APELLIDO, ', '), NOMBRE) AS NOMBRE
    FROM CLIENTES
    EXCEPTION;
END;

-- Ejecuta el procedimiento almacenado
EXECUTE CARGAR_CLIENTES;

SELECT * FROM DIMCLIENTES;

-- Procedimiento almacenado que permite cargar pedidos
CREATE OR REPLACE PROCEDURE FACTURAR_PEDIDOS
IS
BEGIN
    INSERT INTO FACTPEDIDOS 
        (ID_CLI, ID_PRO, ID_FEC, CANTIDAD, TOTAL)
    SELECT 
    (SELECT ID_CLI FROM DIMCLIENTES WHERE IDCLIENTE = PEDIDOS.IDCLIENTE) AS ID_CLI,
    (SELECT ID_PRO FROM DIMPRODUCTOS WHERE IDPRODUCTO = DETALLEPEDIDOS.IDPRODUCTO) AS ID_PRO,
    (SELECT ID_FEC FROM DIMFECHAS WHERE FECHA = PEDIDOS.FECHA) AS ID_FEC,
    DETALLEPEDIDOS.CANTIDAD,
    DETALLEPEDIDOS.TOTAL
    FROM DETALLEPEDIDOS INNER JOIN PEDIDOS ON DETALLEPEDIDOS.NUMEROPEDIDO = PEDIDOS.NUMEROPEDIDO;
END;

-- Ejecuta el procedimiento almacenado
EXECUTE FACTURAR_PEDIDOS;

-- Muestra la tabla FACTPEDIDOS
SELECT * FROM FACTPEDIDOS;

-- Fin de la creación de los procedimientos almacenados para la carga de datos

-------------------
-- FIN SECCION 2 --
-------------------

-- FIN de la resolución del TP4