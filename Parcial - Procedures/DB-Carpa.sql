-- DROP DATABASE CARPA
CREATE DATABASE CARPA;
USE CARPA;

CREATE TABLE `animales` (
  `nombre` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci NOT NULL,
  `tipo` varchar(9) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci NOT NULL,
  `anhos` tinyint UNSIGNED DEFAULT NULL,
  `peso` float DEFAULT NULL,
  `estatura` float DEFAULT NULL,
  `nombre_atraccion` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci DEFAULT NULL,
  `nombre_pista` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci DEFAULT NULL
) ;


CREATE TABLE `artistas` (
  `nif` char(9) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci NOT NULL,
  `apellidos` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci NOT NULL,
  `nombre` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci NOT NULL,
  `nif_jefe` char(9) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci DEFAULT NULL
) ;

CREATE TABLE `animales_artistas` (
  `nombre_animal` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci NOT NULL,
  `nif_artista` char(9) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;


CREATE TABLE `atracciones` (
  `nombre` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci NOT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `ganancias` decimal(8,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

CREATE TABLE `atracciones_artistas` (
  `nombre_atraccion` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci NOT NULL,
  `nif_artista` char(9) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;

CREATE TABLE `atraccion_dia` (
  `nombre_atraccion` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci NOT NULL,
  `fecha` date NOT NULL,
  `num_espectadores` smallint UNSIGNED DEFAULT NULL,
  `ganancias` decimal(7,2) DEFAULT NULL
) ;


CREATE TABLE `pistas` (
  `nombre` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish2_ci NOT NULL,
  `aforo` smallint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish2_ci;


ALTER TABLE `animales`
  ADD PRIMARY KEY (`nombre`),
  ADD KEY `fk_ANIMALES_ATRACCIONES1_idx` (`nombre_atraccion`),
  ADD KEY `fk_ANIMALES_PISTAS1_idx` (`nombre_pista`);

ALTER TABLE `animales_artistas`
  ADD PRIMARY KEY (`nombre_animal`,`nif_artista`),
  ADD KEY `fk_ANIMALES_has_ARTISTAS_ARTISTAS1_idx` (`nif_artista`),
  ADD KEY `fk_ANIMALES_has_ARTISTAS_ANIMALES1_idx` (`nombre_animal`);


ALTER TABLE `artistas`
  ADD PRIMARY KEY (`nif`),
  ADD KEY `fk_ARTISTAS_JEFEARTISTAS_idx` (`nif_jefe`);


ALTER TABLE `atracciones`
  ADD PRIMARY KEY (`nombre`);

ALTER TABLE `atracciones_artistas`
  ADD PRIMARY KEY (`nombre_atraccion`,`nif_artista`,`fecha_inicio`),
  ADD KEY `fk_ATRACCIONES_has_ARTISTAS_ARTISTAS1_idx` (`nif_artista`),
  ADD KEY `fk_ATRACCIONES_has_ARTISTAS_ATRACCIONES1_idx` (`nombre_atraccion`);


ALTER TABLE `atraccion_dia`
  ADD PRIMARY KEY (`nombre_atraccion`,`fecha`);

ALTER TABLE `pistas`
  ADD PRIMARY KEY (`nombre`);


ALTER TABLE `animales`
  ADD CONSTRAINT `fk_ANIMALES_ATRACCIONES1` FOREIGN KEY (`nombre_atraccion`) REFERENCES `atracciones` (`nombre`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_ANIMALES_PISTAS1` FOREIGN KEY (`nombre_pista`) REFERENCES `pistas` (`nombre`) ON UPDATE CASCADE;


ALTER TABLE `animales_artistas`
  ADD CONSTRAINT `fk_ANIMALES_has_ARTISTAS_ANIMALES1` FOREIGN KEY (`nombre_animal`) REFERENCES `animales` (`nombre`),
  ADD CONSTRAINT `fk_ANIMALES_has_ARTISTAS_ARTISTAS1` FOREIGN KEY (`nif_artista`) REFERENCES `artistas` (`nif`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `artistas`
  ADD CONSTRAINT `fk_ARTISTAS_JEFEARTISTAS` FOREIGN KEY (`nif_jefe`) REFERENCES `artistas` (`nif`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `atracciones_artistas`
  ADD CONSTRAINT `fk_ATRACCIONES_has_ARTISTAS_ARTISTAS1` FOREIGN KEY (`nif_artista`) REFERENCES `artistas` (`nif`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_ATRACCIONES_has_ARTISTAS_ATRACCIONES1` FOREIGN KEY (`nombre_atraccion`) REFERENCES `atracciones` (`nombre`) ON UPDATE CASCADE;


ALTER TABLE `atraccion_dia`
  ADD CONSTRAINT `fk_ATRACCIONDIA_ATRACC` FOREIGN KEY (`nombre_atraccion`) REFERENCES `atracciones` (`nombre`) ON UPDATE CASCADE;

INSERT INTO atracciones
	VALUES
    ("Globos", "2010-04-05", 120000.00),
    ("Salon del terror", "2013-07-15", 150000.00),
    ("Montaña Rusa", "2009-08-08", 186050.00),
    ("Martillo", "2011-12-31", 234670.00),
    ("Catapulta", "2021-11-25", 355000.00),
    ("Tiro al blanco", "2020-01-08", 436500.00),
    ("Camicase", "2016-11-14", 788535.00);
    
INSERT INTO pistas
	VALUES
    ("pista1", 1000),
    ("pista2", 1200),
    ("pista3", 100),
    ("pista4", 300),
    ("pista5", 400),
    ("pista6", 700),
    ("pista7", 900);
    
INSERT INTO animales 
	VALUES
    ("Juan", "Leon", 13, 78, 2, "Martillo", "pista6"),
    ("Rey", "Elefante", 4, 289, 4.3, "Globos", "pista2"),
    ("Princesa", "Leon", 6, 89, 1.6, "Salon del terror", "pista1"),
    ("Veronica", "Jirafa", 9, 113, 5.5, "Montaña rusa", "pista3"),
    ("Yuta", "Oso", 6, 134, 3.4, "Catapulta", "pista7"),
    ("Pepe", "Perro", 4, 40, 0.8, "Tiro al blanco", "pista5"),
    ("Pan", "Perro", 2, 24, 0.7, "Camicase", "pista4");
    
INSERT INTO artistas
	VALUES
	("123456789", "Perez", "Robert", "123456789"),
    ("124565689", "Torres", "Monica", "123456789"),
    ("123476578", "Lara", "Laura", "124565689"),
    ("134545689", "Melendez", "Jose", "124565689"),
    ("125464564", "Sanchez", "Raul", "123476578"),
    ("345656789", "Ruiz", "Ruben", "123476578"),
    ("576556789", "Arteaga", "Maria", "123476578");
    
INSERT INTO animales_artistas
	VALUES
    ("Juan", "123456789"),
    ("Rey", "124565689"), 
    ("Princesa", "123476578"),
    ("Veronica", "134545689"), 
    ("Yuta", "125464564"), 
    ("Pepe", "345656789"),
    ("Pan", "576556789");
    
INSERT INTO atracciones_artistas
	VALUES
    ("Globos", "123456789" , "2010-04-05", "2010-05-05"),
    ("Salon del terror", "124565689", "2013-07-15", "2013-09-15"),
    ("Montaña Rusa", "123476578", "2009-08-08", "2009-10-08"),
    ("Martillo", "134545689", "2011-12-31", "2012-01-30"),
    ("Catapulta", "125464564", "2021-11-25", "2021-12-12"),
    ("Tiro al blanco", "345656789", "2020-01-08", "2020-03-08"),
    ("Camicase", "576556789", "2016-11-14", "2016-12-14");
    
INSERT INTO atraccion_dia
	VALUES
    ("Globos", "2010-04-05", 1000, 12000.00),
    ("Salon del terror", "2013-07-15", 500, 15000.00),
    ("Montaña Rusa", "2009-08-08", 100, 18050.00),
    ("Martillo", "2011-12-31", 600, 23470.00),
    ("Catapulta", "2021-11-25", 600, 35000.00),
    ("Tiro al blanco", "2020-01-08", 300, 43500.00),
    ("Camicase", "2016-11-14", 1000, 78835.00);
    
