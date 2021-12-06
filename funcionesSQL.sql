/** FUNCIONES CON SENTENCIAS SQL **/

-- Creacion de la base de datos tienda
DROP SCHEMA IF EXISTS tienda;
CREATE SCHEMA tienda DEFAULT CHARACTER SET utf8 ;
USE tienda;

CREATE TABLE IF NOT EXISTS fabricante (
  cod_fabricante VARCHAR(5) NOT NULL,
  nombre VARCHAR(45) NOT NULL,
  PRIMARY KEY (cod_fabricante));

CREATE TABLE IF NOT EXISTS producto (
  cod_producto INT UNSIGNED NOT NULL,
  nombreProducto VARCHAR(45) NOT NULL,
  cantidad INT NOT NULL,
  precio DOUBLE NOT NULL,
  cod_fabricante VARCHAR(5) NOT NULL,
  PRIMARY KEY (cod_producto),
  INDEX fk_producto_fabricante_idx (cod_fabricante ASC) VISIBLE,
  CONSTRAINT fk_producto_fabricante
    FOREIGN KEY (cod_fabricante)
    REFERENCES fabricante (cod_fabricante)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

INSERT INTO fabricante(cod_fabricante, nombre)
	VALUES 
    ('hp-10','HP'),
    ('rz-11','RAZER'),
    ('es-12','EPSON'),
    ('gn-13','GENIUS'),
    ('ln-14','LENOVO'),
    ('au-15','ASUS'),
    ('ts-16','TOSHIBA');

INSERT INTO producto(cod_producto, nombreProducto, cantidad, precio, cod_fabricante) 
VALUES 
(10,'Teclado', 5, 25000, 'rz-11'),
(15,'Mouse', 10, 20000, 'ln-14'),
(20,'Monitor', 20, 256000, 'hp-10'),
(25,'Impresora', 5, 157000, 'es-12'),
(30,'Notebook', 20, 5680000, 'gn-13'),
(35,'Mouse', 30, 45000, 'gn-13'),
(40,'CPU', 40, 3750000, 'rz-11'),
(45,'Micrófono', 15, 37000, 'hp-10'),
(50,'Teclado', 12, 350000, 'gn-13'),
(55,'Micrófono', 8, 480000, 'es-12'),
(60, 'Monitor', 5, 1300000, 'au-15'),
(65, 'Laptop', 4, 2000000, 'ts-16'),
(70, 'CPU', 16, 3000000, 'ln-14');

-- IMPORTANTE ACTIVAR EL SIGUIENTE CODIGO PARA EL FUNCIONAMIENTO DE LAS FUNCIONES (Solo una vez)
SET GLOBAL log_bin_trust_function_creators = 1;
-- 1 
DELIMITER $$
USE `tienda`$$
DROP FUNCTION IF EXISTS `totalProductos`$$
CREATE FUNCTION totalProductos() RETURNS INT
BEGIN
	DECLARE total INT DEFAULT 0;
    SELECT sum(cantidad) INTO total FROM producto;
    RETURN total;
END$$
DELIMITER ;
SELECT totalProductos() "PRODUCTOS TOTALES";

-- 2
DELIMITER $$
USE `tienda`$$
DROP FUNCTION IF EXISTS `medioPrecio`$$
CREATE FUNCTION medioPrecio(fabri VARCHAR(45)) RETURNS DOUBLE
BEGIN
	DECLARE medio DOUBLE DEFAULT 0;
    SELECT avg(precio) INTO medio FROM producto NATURAL JOIN fabricante f
		WHERE f.nombre=fabri;
    RETURN medio;
END$$
DELIMITER ;
SELECT medioPrecio('GENIUS') "PRECIO DEL MEDIO"

-- 3
DELIMITER $$
USE `tienda`$$
DROP FUNCTION IF EXISTS `maximoPrecio`$$
CREATE FUNCTION maximoPrecio(fabri VARCHAR(45)) RETURNS DOUBLE
BEGIN
	DECLARE maximo DOUBLE DEFAULT 0;
    SELECT max(precio) INTO maximo FROM producto NATURAL JOIN fabricante f
		WHERE f.nombre=fabri;
    RETURN maximo;
END$$
DELIMITER ;
SELECT maximoPrecio('GENIUS') "MAXIMO PRECIO"

-- 4
DELIMITER $$
USE `tienda`$$
DROP FUNCTION IF EXISTS `minimoPrecio`$$
CREATE FUNCTION minimoPrecio(fabri VARCHAR(45)) RETURNS DOUBLE
BEGIN
	DECLARE minimo DOUBLE DEFAULT 0;
    SELECT min(precio) INTO minimo FROM producto NATURAL JOIN fabricante f
		WHERE f.nombre=fabri;
    RETURN minimo;
END$$
DELIMITER ;
SELECT minimoPrecio('GENIUS') "MINIMO PRECIO"