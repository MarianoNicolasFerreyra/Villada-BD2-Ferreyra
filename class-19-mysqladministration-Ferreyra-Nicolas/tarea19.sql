#1 -- Conexion: root o administrador.
CREATE USER 'data_analyst'@'localhost'
IDENTIFIED BY 'Analyst19_Practica!';	

#2 -- Conexion: root o administrador.
GRANT SELECT, UPDATE, DELETE
ON sakila.*
TO 'data_analyst'@'localhost';

SHOW GRANTS FOR 'data_analyst'@'localhost';

select current_user();

#3 -- Abrir una nueva conexion como data_analyst.
USE sakila;
SELECT CURRENT_USER();

CREATE TABLE prueba_permisos (
    id INT PRIMARY KEY,
    nombre VARCHAR(50)
);

-- Resultado:
-- SQL Error [1142] [42000]: CREATE command denied to user
-- 'data_analyst'@'localhost' for table 'prueba_permisos'.
-- No se creó la tabla porque el usuario no tiene permiso CREATE.

#4 -- Conexion: data_analyst. Ejecutar despues del error del punto 3.
SELECT film_id, title
FROM sakila.film
WHERE film_id = 1;

UPDATE sakila.film
SET title = 'ACADEMY DINOSAUR MODIFICADA'
WHERE film_id = 1;

SELECT film_id, title
FROM sakila.film
WHERE film_id = 1;

#5 -- Cambiar a la conexion de root o administrador.
REVOKE UPDATE
ON sakila.*
FROM 'data_analyst'@'localhost';

SHOW GRANTS FOR 'data_analyst'@'localhost';

#6 -- Cerrar la conexion de data_analyst y volver a conectarse.
USE sakila;
SELECT CURRENT_USER();

UPDATE sakila.film
SET title = 'ACADEMY DINOSAUR MODIFICADA'
WHERE film_id = 1;

-- Resultado obtenido:
-- SQL Error [1142] [42000]: UPDATE command denied to user
-- 'data_analyst'@'localhost' for table 'film'.
-- La actualización fue rechazada porque se revocó el permiso UPDATE.

SELECT film_id, title
FROM sakila.film
WHERE film_id = 1;
