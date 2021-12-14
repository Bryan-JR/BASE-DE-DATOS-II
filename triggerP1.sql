-- Creación de la base de datos Mitest (Se crea en desde postgresSQL)
-- Contiene la tabla alumnos
DROP TABLE IF EXISTS alumnos;
CREATE TABLE alumnos (
  id SERIAL  NOT NULL ,
  nombre VARCHAR(45)   NOT NULL ,
  apellido1 VARCHAR(45)   NOT NULL ,
  apellido2 VARCHAR(45)   NOT NULL ,
  nota REAL   NOT NULL   ,
PRIMARY KEY(id));

-- Trigger 1: trigger_check_nota_before_insert
-- Se crea la función check_nota
CREATE OR REPLACE FUNCTION check_nota() RETURNS TRIGGER
AS
$$
BEGIN
	IF (NEW.nota < 0) THEN
 		NEW.nota = 0;
 	ELSIF (NEW.nota > 10) THEN
 		NEW.nota = 10;
 	END IF;
RETURN NEW;
END;
$$
LANGUAGE plpgsql;
-- Se crea el trigger para el insert
CREATE TRIGGER trigger_check_nota_before_insert
BEFORE INSERT ON alumnos
FOR EACH ROW
EXECUTE PROCEDURE check_nota();

-- Se crea el trigger para el update
CREATE TRIGGER trigger_check_nota_before_update
BEFORE UPDATE ON alumnos
FOR EACH ROW
EXECUTE PROCEDURE check_nota();

-- Se insertan datos de prueba
INSERT INTO alumnos (nombre, apellido1, apellido2, nota)
	VALUES
	('Brayan', 'Jimenez', 'Ruiz', -1),
	('Anuar', 'Gomez', 'Quiroga', 11),
	('Juan', 'Lara', 'Gonzales', 6);

UPDATE alumnos SET nota=12 WHERE id=1;
UPDATE alumnos SET nota=-6 WHERE id=2;	
SELECT * FROM alumnos;
