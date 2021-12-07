-- Procedimientos sin sentencias SQL

-- 1
DELIMITER $$
DROP PROCEDURE IF EXISTS `MENSAJE`$$
CREATE PROCEDURE MENSAJE()
BEGIN
    select "¡Hola Mundo!" Mensaje;
END$$
DELIMITER ;
CALL MENSAJE();

-- 2
DELIMITER $$
DROP PROCEDURE IF EXISTS `comprobarNumero`$$
CREATE PROCEDURE comprobarNumero(num DOUBLE)
BEGIN
	IF num>0 THEN
     SELECT "NÚMERO POSITIVO" MENSAJE;
	ELSEIF num<0 THEN
		SELECT "NÚMERO NEGATIVO" MENSAJE;
	ELSE
		SELECT "NÚMERO CERO" MENSAJE;
	END IF;
END$$
DELIMITER ;
call comprobarNumero(0);

-- 3
DELIMITER $$
DROP PROCEDURE IF EXISTS `comprobarNumeroConSalida`$$
CREATE PROCEDURE comprobarNumeroConSalida(num DOUBLE, OUT salida VARCHAR(200))
BEGIN
	IF num>0 THEN
     set salida =  "NÚMERO POSITIVO";
	ELSEIF num<0 THEN
		set salida = "NÚMERO NEGATIVO";
	ELSE
		set salida = "NÚMERO CERO";
	END IF;
    SELECT salida;
END$$
DELIMITER ;
call comprobarNumeroConSalida(0, @salida);

-- 4
DELIMITER $$
DROP PROCEDURE IF EXISTS `valorNota`$$
CREATE PROCEDURE valorNota(nota DOUBLE)
BEGIN
	IF nota >= 0 and nota < 5 THEN
		SELECT "INSUFICIENTE" VALOR;
	ELSEIF nota >= 5 and nota < 6 THEN
		SELECT "APROBADO" VALOR;
	ELSEIF nota >= 6 and nota < 7 THEN
		SELECT "BIEN" VALOR;
	ELSEIF nota >= 7 and nota < 9 THEN
		SELECT "NOTABLE" VALOR;
	ELSEIF nota >= 9 and nota <=10 THEN
		SELECT "SOBRESALIENTE" VALOR;
	ELSE 
		SELECT "NOTA NO VALIDA" VALOR;
    END IF;
END$$
DELIMITER ;
CALL valorNota(0);

-- 5
DELIMITER $$
DROP PROCEDURE IF EXISTS `valorNotaConSalida`$$
CREATE PROCEDURE valorNotaConSalida(nota NUMERIC, valor VARCHAR(200))
BEGIN
	IF nota >= 0 and nota < 5 THEN
		SET valor = "INSUFICIENTE";
	ELSEIF nota >= 5 and nota < 6 THEN
		SET valor = "APROBADO";
	ELSEIF nota >= 6 and nota < 7 THEN
		SET valor = "BIEN";
	ELSEIF nota >= 7 and nota < 9 THEN
		SET valor = "NOTABLE";
	ELSEIF nota >= 9 and nota <=10 THEN
		SET valor = "SOBRESALIENTE";
	ELSE 
		SET valor = "NOTA NO VALIDA";
    END IF;
    SELECT valor as VALOR;
END$$
DELIMITER ;
CALL valorNotaConSalida(0, @valor);

-- 6
DELIMITER $$
DROP PROCEDURE IF EXISTS `valorNotaConSalidaCaso`$$
CREATE PROCEDURE valorNotaConSalidaCaso(in nota NUMERIC, out valor VARCHAR(200))
BEGIN
	CASE  
		WHEN (nota >= 0 and nota < 5) THEN
			SET valor = 'INSUFICIENTE';
		WHEN (nota >= 5 and nota < 6) THEN
			SET valor = 'APROBADO';
		WHEN (nota >= 6 and nota < 7) THEN
			SET valor = 'BIEN';
		WHEN (nota >= 7 and nota < 9) THEN
			SET valor = 'NOTABLE';
		WHEN (nota >= 9 and nota <= 10) THEN
			SET valor = 'SOBRESALIENTE';
		ELSE 
			SET valor = "NOTA NO VALIDA";
	END CASE;
    SELECT valor as VALOR;
END$$	
DELIMITER ;
CALL valorNotaConSalidaCaso(11, @valor);

-- 7

DELIMITER $$
DROP PROCEDURE IF EXISTS `DiasDeLaSemana` $$
CREATE PROCEDURE DiasDeLaSemana (IN NumeroDia NUMERIC, out Dia VARCHAR(20))
BEGIN
 CASE 
	WHEN NumeroDia = 1 THEN
		SET Dia='Lunes';
    WHEN NumeroDia = 2 THEN
		SET Dia='Martes';
    WHEN NumeroDia = 3 THEN
		SET Dia='Miercoles';
    WHEN NumeroDia = 4 THEN
		SET Dia='Jueves';
    WHEN NumeroDia = 5 THEN
		SET Dia='Viernes';
    WHEN NumeroDia = 6 THEN
		SET Dia='Sabado';
    WHEN NumeroDia = 7 THEN
		SET Dia='Domingo';
 END CASE;
 SELECT Dia;
END$$
DELIMITER ;

CALL DiasDeLaSemana(7,@Dia);
