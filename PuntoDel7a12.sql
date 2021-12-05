/** CREACION DE LA BASE DE DATOS PARA EL PUNTO 7 AL 9 **/

DROP SCHEMA IF EXISTS  procedimientos02;
CREATE SCHEMA procedimientos02;
USE procedimientos02;

CREATE TABLE ejercicio (
  numero INT UNSIGNED
  );

INSERT INTO ejercicio(numero)
	VALUES
    (23),
    (12),
    (65),
    (34),
    (76),
    (43),
    (32),
    (07);

/** 7 **/
DELIMITER $$
USE `procedimientos02`$$
DROP PROCEDURE IF EXISTS `calcular_numeros`$$
CREATE PROCEDURE calcular_numeros(IN valor_numero INT UNSIGNED)
BEGIN
	TRUNCATE ejercicio;
    WHILE valor_numero >= 1 DO
		INSERT INTO ejercicio(numero) VALUES (valor_numero);
        SET valor_numero = valor_numero - 1;
    END WHILE;
	SELECT * FROM ejercicio;
END$$
DELIMITER ;
CALL calcular_numeros(10);

/** 8 **/
DELIMITER $$
USE `procedimientos02`$$
DROP PROCEDURE IF EXISTS `calcular_numeros`$$
CREATE PROCEDURE calcular_numeros(IN valor_numero INT UNSIGNED)
BEGIN
	TRUNCATE ejercicio;
    REPEAT
		INSERT INTO ejercicio(numero) VALUES (valor_numero);
        SET valor_numero = valor_numero - 1;
	UNTIL valor_numero < 1
    END REPEAT;
	SELECT * FROM ejercicio;
END$$
DELIMITER ;
CALL calcular_numeros(10);

/** 9 **/
DELIMITER $$
USE `procedimientos02`$$
DROP PROCEDURE IF EXISTS `calcular_numeros`$$
CREATE PROCEDURE calcular_numeros(IN valor_numero INT UNSIGNED)
BEGIN
	TRUNCATE ejercicio;
    bucle: LOOP
		INSERT INTO ejercicio(numero) VALUES (valor_numero);
		IF valor_numero = 1 THEN
			LEAVE bucle;
        END IF;
        SET valor_numero = valor_numero - 1;
    END LOOP bucle;
	SELECT * FROM ejercicio;
END$$
DELIMITER ;
CALL calcular_numeros(10);


/** CREACION DE LA BASE DE DATOS PARA EL PUNTO 10 AL 12 **/

DROP SCHEMA IF EXISTS  procedimientos;
CREATE SCHEMA procedimientos;
USE procedimientos;

CREATE TABLE pares (
  numero INT UNSIGNED
  );
  
  CREATE TABLE impares (
  numero INT UNSIGNED
  );

INSERT INTO pares(numero)
	VALUES
    (24),
    (12),
    (60),
    (32),
    (76),
    (46),
    (04);

INSERT INTO impares(numero)
	VALUES
    (21),
    (13),
    (69),
    (35),
    (77),
    (47),
    (07);
    
/** 10 **/
DELIMITER $$
USE `procedimientos`$$
DROP PROCEDURE IF EXISTS `calcular_pares_impares`$$
CREATE PROCEDURE calcular_pares_impares(IN tope INT UNSIGNED)
BEGIN
	TRUNCATE pares; TRUNCATE impares;
    WHILE tope >= 1 DO
		  IF tope%2 = 0 THEN
			INSERT INTO pares(numero) VALUES (tope);
		  ELSEIF tope%2 = 1 THEN
			INSERT INTO impares(numero) VALUES (tope);
		  END IF;
	  SET tope = tope - 1;
    END WHILE;
    /*SELECT numero FROM pares;
	SELECT numero FROM impares;*/
END$$
DELIMITER ;
CALL calcular_pares_impares(10);
-- Ver tablas
SELECT numero FROM pares;
SELECT numero FROM impares;

/** 11 **/
DELIMITER $$
USE `procedimientos`$$
DROP PROCEDURE IF EXISTS `calcular_pares_impares`$$
CREATE PROCEDURE calcular_pares_impares(IN tope INT UNSIGNED)
BEGIN
	TRUNCATE pares; TRUNCATE impares;
    REPEAT
		  IF tope%2 = 0 THEN
			INSERT INTO pares(numero) VALUES (tope);
		  ELSEIF tope%2 = 1 THEN
			INSERT INTO impares(numero) VALUES (tope);
		  END IF;
	  SET tope = tope - 1;
      UNTIL tope < 1
    END REPEAT;
    /*SELECT numero FROM pares;
	SELECT numero FROM impares;*/
END$$
DELIMITER ;
CALL calcular_pares_impares(10);
-- Ver tablas
SELECT numero FROM pares;
SELECT numero FROM impares;

/** 12 **/
DELIMITER $$
USE `procedimientos`$$
DROP PROCEDURE IF EXISTS `calcular_pares_impares`$$
CREATE PROCEDURE calcular_pares_impares(IN tope INT UNSIGNED)
BEGIN
	TRUNCATE pares; TRUNCATE impares;
    bucle: LOOP
		IF tope%2 = 0 THEN
			INSERT INTO pares(numero) VALUES (tope);
		ELSEIF tope%2 = 1 THEN
			INSERT INTO impares(numero) VALUES (tope);
		END IF;
	IF tope = 1 THEN
		LEAVE bucle;
	END IF;
		SET tope = tope - 1;
    END LOOP bucle;
    /*SELECT numero FROM pares;
	SELECT numero FROM impares;*/
END$$
DELIMITER ;
CALL calcular_pares_impares(10);
-- Ver tablas
SELECT numero FROM pares;
SELECT numero FROM impares;