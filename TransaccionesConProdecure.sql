DROP DATABASE IF EXISTS Cine;
CREATE DATABASE Cine;
USE Cine;

CREATE TABLE cuentas (
  id_cuenta INT UNSIGNED  NOT NULL  ,
  saldo DOUBLE UNSIGNED NOT NULL CHECK(saldo>= 0),
PRIMARY KEY(id_cuenta));

CREATE TABLE entradas (
  id_butaca INT UNSIGNED  NOT NULL  ,
  nif VARCHAR(9)  NOT NULL  ,
  id_cuenta INT UNSIGNED  NOT NULL ,
PRIMARY KEY(id_butaca)  ,
INDEX entradas_FKIndex1(id_cuenta),
  FOREIGN KEY(id_cuenta)
    REFERENCES cuentas(id_cuenta)
      ON DELETE RESTRICT
      ON UPDATE CASCADE);

INSERT INTO cuentas(id_cuenta, saldo) 
	VALUES
    (10, 40),
    (12, 60),
    (14, 50),
    (16, 100),
    (18, 70),
    (20, 150),
    (22, 400),
    (24, 320);
    
DELIMITER $$
USE `Cine`$$
DROP PROCEDURE IF EXISTS `comprar_entrada`$$
CREATE PROCEDURE comprar_entrada(IN nif VARCHAR(9), IN id_cuenta INT UNSIGNED, IN id_butaca INT UNSIGNED, OUT error INT UNSIGNED)
BEGIN
	DECLARE CONTINUE HANDLER FOR 1264, 1062
		BEGIN
		SET error = 1;
        END;
	SET @autocommint = 0;
	-- Inicia la transacción
    START TRANSACTION;
    SET error = 0;
    -- Se cobran 5 euros
	UPDATE cuentas c SET c.saldo = saldo-5
		WHERE c.id_cuenta = id_cuenta;
    -- Se guarda(Inserta cuenta) la compra de la entrada
    INSERT INTO entradas(entradas.id_butaca, entradas.nif, entradas.id_cuenta)
		VALUES (id_butaca, nif, id_cuenta);
	IF error = 0 THEN
		COMMIT;
	ELSE 
		ROLLBACK;
	END IF;
END$$
DELIMITER ;
CALL comprar_entrada('A14',14,19,@error);
SELECT @error "ERROR";
SELECT * FROM cuentas;
SELECT * FROM entradas;


