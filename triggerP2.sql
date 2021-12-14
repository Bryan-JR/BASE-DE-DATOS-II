-- Se crea en la base de datos la tabla alumnos y las tablas de los log
DROP TABLE IF EXISTS log_cambios_email;
DROP TABLE IF EXISTS log_alumnos_eliminados;
DROP TABLE IF EXISTS alumnos;

CREATE TABLE alumnos (
  id SERIAL  NOT NULL ,
  nombre VARCHAR(45)   NOT NULL ,
  apellido1 VARCHAR(45)   NOT NULL ,
  apellido2 VARCHAR(45)   NOT NULL ,
  email VARCHAR(100)   NOT NULL   ,
PRIMARY KEY(id));

CREATE TABLE log_cambios_email  (
  id SERIAL  NOT NULL ,
  id_alumno INTEGER   NOT NULL ,
  fecha_hora TIMESTAMP   NOT NULL ,
  old_email VARCHAR(100)   NOT NULL ,
  new_email VARCHAR(100)   NOT NULL   ,
PRIMARY KEY(id)  ,
  FOREIGN KEY(id_alumno)
    REFERENCES alumnos(id)
      ON DELETE RESTRICT
      ON UPDATE CASCADE);

CREATE TABLE log_alumnos_eliminados (
  id SERIAL  NOT NULL ,
  id_alumno INTEGER   NOT NULL ,
  fecha_hora TIMESTAMP    ,
  nombre VARCHAR(45)    ,
  apellido1 VARCHAR(45)    ,
  apellido2 VARCHAR(45)    ,
  email VARCHAR(100)      ,
PRIMARY KEY(id)  ,
  FOREIGN KEY(id_alumno)
    REFERENCES alumnos(id)
      ON DELETE RESTRICT
      ON UPDATE CASCADE);

-- EJERCICIO 2: 
-- Se crea el procedimiento para crear un email

CREATE OR REPLACE FUNCTION crear_email(nombre VARCHAR(45),apellido1 VARCHAR(45),apellido2 VARCHAR(45),dominio VARCHAR(45))
RETURNS VARCHAR(100)
AS
$$
DECLARE
nom VARCHAR(1);
ape1 VARCHAR(3);
ape2 VARCHAR(3);
email VARCHAR(100);
BEGIN
	nom = substr(nombre, 1, 1);
	ape1 = substr(apellido1, 1, 3);
	ape2 = substr(apellido2, 1, 3);
	email = concat(nom,ape1,ape2,'@',dominio);
	RETURN email;
END
$$
LANGUAGE plpgsql;

-- Se crea la función para el trigger
CREATE OR REPLACE FUNCTION aplicar_email() RETURNS TRIGGER
AS
$$
BEGIN
	IF NEW.email IS null THEN
		NEW.email = crear_email(NEW.nombre, NEW.apellido1, NEW.apellido2, 'gmail.com');
	END IF;
	RETURN NEW;
END
$$
LANGUAGE plpgsql;

-- SE CREA EL TRIGGER trigger_crear_email_before_insert

CREATE TRIGGER trigger_crear_email_before_insert
BEFORE INSERT ON alumnos
FOR EACH ROW
EXECUTE FUNCTION aplicar_email();

INSERT INTO alumnos (nombre, apellido1, apellido2, email)
	VALUES
	('Brayan', 'Jimenez', 'Ruiz', null),
	('Anuar', 'Gomez', 'Quiroga', 'AnuarGomez@gmail.com'),
	('Juan', 'Lara', 'Gonzales', null);

SELECT * FROM alumnos;

-- EJERCICIO 3:
CREATE OR REPLACE FUNCTION ingresar_log_update() RETURNS TRIGGER
AS
$$
BEGIN
	IF (OLD.email <> NEW.email) THEN
	INSERT INTO log_cambios_email (id_alumno, fecha_hora, old_email, new_email)
		VALUES
		(OLD.id, NOW(), OLD.email, NEW.email);
	END IF;
	RETURN NULL;
END
$$
LANGUAGE plpgsql;

CREATE TRIGGER trigger_guardar_email_after_update
AFTER UPDATE ON alumnos
FOR EACH ROW
EXECUTE FUNCTION ingresar_log_update();

UPDATE alumnos SET email = 'brayanjiru14@gmail.com' WHERE id=1;
UPDATE alumnos SET email = 'juanLara12@gmail.com' WHERE id=3;

SELECT * FROM log_cambios_email;
