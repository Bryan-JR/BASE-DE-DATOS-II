USE CARPA;

-- 1
DELIMITER $$
DROP PROCEDURE IF EXISTS buscarAnimalArtista $$
CREATE PROCEDURE buscarAnimalArtista(ident CHAR(9) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci)
BEGIN
	SELECT * FROM animales 
    WHERE nombre IN (SELECT nombre_animal FROM animales_artistas WHERE nif_artista = ident);
END$$
DELIMITER ;
CALL buscarAnimalArtista("123456789");

-- 2
DELIMITER $$
DROP PROCEDURE IF EXISTS atracciones_getListConAntiguedad$$
CREATE PROCEDURE atraccionesConAntiguedad(antiguedad tinyint)
BEGIN
    SELECT *
    FROM atracciones
    WHERE fecha_inicio BETWEEN DATE_SUB(curdate(), INTERVAL antiguedad YEAR) AND curdate()
    ORDER BY nombre;
END$$
DELIMITER ;
CALL atraccionesConAntiguedad(6);

-- 3
DELIMITER $$
DROP PROCEDURE IF EXISTS aforoPistas$$
CREATE PROCEDURE aforoPistas(
	nombreP VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci,
    OUT aforoP smallint
    )
BEGIN
	SELECT aforo INTO aforoP FROM pistas WHERE nombre = nombreP;
END$$
DELIMITER ;
CALL aforoPistas("pista2", @aforo);
SELECT @aforo;

-- 4
DELIMITER $$
DROP PROCEDURE IF EXISTS animalesConNombreAforo$$
CREATE PROCEDURE animalesConNombreAforo(
	nombreA varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci, 
    OUT cadena varchar(150))		
BEGIN
    DECLARE pesoA float;		
    DECLARE aforoP smallint;
    DECLARE nombreP varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci;
    SELECT nombre_pista, peso INTO nombreP, pesoA FROM animales
    WHERE nombre = nombreA;
    CALL aforoPistas(nombreP,aforoP);
    SET cadena = CONCAT(nombreA,':',pesoA,':',nombreP,':',aforoP);

END$$
DELIMITER ;
CALL animalesConNombreAforo('Rey',@cadena);	
SELECT @cadena;

-- 5
DELIMITER $$
DROP PROCEDURE IF EXISTS incrementarAforo$$
CREATE PROCEDURE incrementarAforo(
	nombreP VARCHAR(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci,
    INOUT aforoTotal smallint
    )
BEGIN
	UPDATE pistas SET aforo = aforo+aforoTotal WHERE nombre = nombreP;
	SELECT aforo INTO aforoTotal FROM pistas WHERE nombre = nombreP;
END$$
DELIMITER ;
SET @aforo = 100;
CALL incrementarAforo("pista2", @aforo);
SELECT @aforo;

-- 6
DELIMITER $$
DROP PROCEDURE IF EXISTS animalesIncrementaAforo$$
CREATE PROCEDURE animalesIncrementaAforo(
	INOUT nombreA varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci,
	INOUT aforoP SMALLINT
)		
BEGIN
    DECLARE nombreP varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci;
    SELECT nombre_pista INTO nombreP FROM ANIMALES WHERE nombre = nombreA;
   CALL incrementarAforo(nombreP, aforoP);
END$$
DELIMITER ;
SET @nombre = 'Rey';
SET @aforo = 200;
CALL animalesIncrementaAforo(@nombre,@aforo);	
SELECT @nombre,@aforo;

-- TRIGGERS
USE CARPA;
 CREATE TABLE ESTADISTICA (
 `id` int(11) NOT NULL AUTO_INCREMENT,
 `tipo` varchar(100) NOT NULL,
 `valor` int NOT NULL,
PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

INSERT INTO `ESTADISTICA` (`tipo`, `valor`) VALUES ('pistas', '0');
INSERT INTO `ESTADISTICA` (`tipo`, `valor`) VALUES ('animales', '0');
-- ALTA
DELIMITER $$
DROP TRIGGER IF EXISTS sumarPistas$$
CREATE TRIGGER sumarPistas BEFORE INSERT ON PISTAS FOR EACH ROW
 BEGIN
	UPDATE ESTADISTICA SET valor = valor+1 WHERE id=1;
END $$
DELIMITER ;
DELIMITER $$
DROP TRIGGER IF EXISTS sumarAnimales$$
CREATE TRIGGER sumarAnimales BEFORE INSERT ON animales FOR EACH ROW
 BEGIN
	UPDATE ESTADISTICA SET valor = valor+1 WHERE id=2;
END $$
DELIMITER ;

-- BAJA
DELIMITER $$
DROP TRIGGER IF EXISTS restarPistas$$
CREATE TRIGGER restarPistas AFTER DELETE ON PISTAS FOR EACH ROW
 BEGIN
	UPDATE ESTADISTICA SET valor = valor-1 WHERE id=1;
END $$
DELIMITER ;
DELIMITER $$
DROP TRIGGER IF EXISTS restarAnimales$$
CREATE TRIGGER restarAnimales AFTER DELETE ON animales FOR EACH ROW
 BEGIN
	UPDATE ESTADISTICA SET valor = valor-1 WHERE id=2;
END $$
DELIMITER ;

INSERT INTO pistas
	VALUES
    ("pista8", 150),
    ("pista9", 200),
    ("pista10", 3000);

INSERT INTO animales 
	VALUES
    ("Pedro", "Leon", 13, 78, 2, "Martillo", "pista8"),
    ("Principe", "Elefante", 4, 289, 4.3, "Globos", "pista9"),
    ("Lion", "Leon", 6, 89, 1.6, "Salon del terror", "pista10");

DELETE FROM animales WHERE nombre = "Principe";
DELETE FROM pistas WHERE nombre = "pista9";

SELECT * FROM ESTADISTICA;

-- PUNTO 3
CREATE DATABASE HOSPITAL;
USE HOSPITAL;

CREATE TABLE persona(
	id int not null auto_increment,
    nombre varchar(50) not null,
	peso float not null,
    estado varchar(40),
    primary key(id)
);

DELIMITER $$
DROP PROCEDURE IF EXISTS registrarPersona$$
CREATE PROCEDURE registrarPersona(id int,nombreIngreso VARCHAR(50), pesoIngreso float)
BEGIN
	IF pesoIngreso < 50 THEN
		INSERT INTO persona VALUES (id, nombreIngreso, pesoIngreso, "no admitido");
	ELSEIF pesoIngreso > 50 THEN
		INSERT INTO persona VALUES (id, nombreIngreso, pesoIngreso, "admitido");
	END IF;
END$$
DELIMITER ;
CALL registrarPersona(1, "Juan", 40);
CALL registrarPersona(2, "Maria", 49);
CALL registrarPersona(3, "Laura", 42);
CALL registrarPersona(4, "Roberto", 36);
CALL registrarPersona(5, "Manuel", 70);
CALL registrarPersona(6, "Josefa", 67.8);
CALL registrarPersona(7, "Monica", 66.8);
SELECT * FROM persona;

-- PUNTO 4
CREATE DATABASE TIENDA;
USE TIENDA;

CREATE TABLE clientes(
	cedula INTEGER not null,
    nombre varchar(50) not null,
    apellido varchar(50) not null,
    primary key(cedula)
);

DELIMITER $$
DROP PROCEDURE IF EXISTS registrarCliente$$
CREATE PROCEDURE registrarCliente(cedula INTEGER, nombreC VARCHAR(50), apellidoC VARCHAR(50))
BEGIN
	INSERT INTO clientes VALUES (cedula, nombreC, apellidoC);
END$$
DELIMITER ;
CALL registrarCliente(12346, "Pedro", "Romero");
CALL registrarCliente(65435, "Fabian", "Hernandez");
CALL registrarCliente(455673, "Maria", "Martinez");
SELECT * FROM clientes;

DELIMITER $$
DROP PROCEDURE IF EXISTS actualizarNombre$$
CREATE PROCEDURE actualizarNombre(cedulaC INTEGER, nombreC VARCHAR(50))
BEGIN
	UPDATE clientes SET nombre = nombreC WHERE cedula = cedulaC;
END$$
DELIMITER ;

CALL actualizarNombre(12346, "Monica");
CALL actualizarNombre(65435, "Felipe");
CALL actualizarNombre(455673, "Luz");
select * from clientes;

DELIMITER $$
DROP PROCEDURE IF EXISTS eliminarCliente$$
CREATE PROCEDURE eliminarCliente(cedulaC INTEGER)
BEGIN
	DELETE FROM clientes WHERE cedula = cedulaC;
END$$
DELIMITER ;

CALL eliminarCliente(12346);
SELECT * FROM clientes;


-- PUNTO 5
CREATE DATABASE EMPRESA;
USE EMPRESA;

CREATE TABLE empleado(
	cedula INTEGER not null,
    nombre varchar(50) not null,
    salario_basico numeric not null,
    subsidio numeric not null,
    salud numeric not null,
    pension numeric not null,
    bono numeric not null,
    salario_integral numeric not null,
    primary key(cedula)
);

-- Se usa para habilitar las funciones
SET GLOBAL log_bin_trust_function_creators = 1;
DELIMITER $$
DROP FUNCTION IF EXISTS Subsidio$$
CREATE FUNCTION Subsidio(salario NUMERIC) RETURNS NUMERIC
BEGIN
    RETURN salario * 0.07;
END$$
DELIMITER ;

DELIMITER $$
DROP FUNCTION IF EXISTS Salud$$
CREATE FUNCTION Salud(salario NUMERIC) RETURNS NUMERIC
BEGIN
    RETURN salario * 0.04;
END$$
DELIMITER ;

DELIMITER $$
DROP FUNCTION IF EXISTS Pension$$
CREATE FUNCTION Pension(salario NUMERIC) RETURNS NUMERIC
BEGIN
    RETURN salario * 0.04;
END$$
DELIMITER ;

DELIMITER $$
DROP FUNCTION IF EXISTS Bono$$
CREATE FUNCTION Bono(salario NUMERIC) RETURNS NUMERIC
BEGIN
    RETURN salario * 0.08;
END$$
DELIMITER ;

DELIMITER $$
DROP FUNCTION IF EXISTS Total$$
CREATE FUNCTION Total(salario NUMERIC) RETURNS NUMERIC
BEGIN
    RETURN salario - Salud(salario) - Pension(salario) + Bono(salario) + Subsidio(salario);
END$$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS registrarEmpleado$$
CREATE PROCEDURE registrarEmpleado(cc INTEGER, nom varchar(50), salario numeric)
BEGIN
	INSERT INTO empleado VALUES (cc, nom, salario, Subsidio(salario), Salud(salario),Pension(salario), Bono(salario), Total(salario));
END$$
DELIMITER ;

CALL registrarEmpleado(134545, "Fabian", 3000000);
CALL registrarEmpleado(564564, "Monica", 5600000);
CALL registrarEmpleado(345344, "Leopoldo", 7650000);
CALL registrarEmpleado(342454, "Benito", 2440000);
CALL registrarEmpleado(6456457, "Carlos", 1200000);
CALL registrarEmpleado(5645645, "Vanesa", 5600000);
CALL registrarEmpleado(9789789, "Andrea", 900000);
SELECT * FROM empleado;