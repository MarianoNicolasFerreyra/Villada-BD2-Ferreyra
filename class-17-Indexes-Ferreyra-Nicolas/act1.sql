USE sakila;

SELECT VERSION();

SHOW INDEX FROM address;
SHOW INDEX FROM actor;
SHOW INDEX FROM film_text;

SELECT postal_code
FROM sakila.address
WHERE postal_code IS NOT NULL
  AND postal_code <> ''
LIMIT 5;

-- 1
SELECT address_id, address, postal_code
FROM sakila.address
WHERE postal_code IN ('35200', '17886');
-- Consulta 1 sin indice: 2 filas, tiempo mostrado 0,001 s.

--  2
SELECT address_id, address, postal_code
FROM sakila.address
WHERE postal_code NOT IN ('35200', '17886');
-- Consulta 2 sin índice: 601 filas (aunque primero dio 201), tiempo mostrado 0,002 s.

-- 3
SELECT a.address_id, a.address, a.postal_code,
       ci.city, co.country
FROM sakila.address AS a
JOIN sakila.city AS ci ON ci.city_id = a.city_id
JOIN sakila.country AS co ON co.country_id = ci.country_id
WHERE a.postal_code IN ('35200', '17886');
-- Consulta 3 sin índice: 2 filas, tiempo mostrado 0,004 s.

CREATE INDEX idx_address_postal_code
ON sakila.address (postal_code);

-- Consulta 1 con índice.
SELECT address_id, address, postal_code
FROM sakila.address
WHERE postal_code IN ('35200', '17886');
-- Consulta 1 con índice: 2 filas, tiempo mostrado 0,001 s.

-- Consulta 2 con índice.
SELECT address_id, address, postal_code
FROM sakila.address
WHERE postal_code NOT IN ('35200', '17886');
-- Consulta 2 con índice: 601 filas, tiempo mostrado 0,002 s.

-- Consulta 3 con índice: IN con JOIN.
SELECT a.address_id, a.address, a.postal_code,
       ci.city, co.country
FROM sakila.address AS a
JOIN sakila.city AS ci ON ci.city_id = a.city_id
JOIN sakila.country AS co ON co.country_id = ci.country_id
WHERE a.postal_code IN ('35200', '17886');

/*
EJERCICIO 1: RESULTADOS

Consulta       Sin índice    Con índice
IN             0,001 s       0,001 s
NOT IN         0,002 s       0,002 s
IN con JOIN    0,004 s       0,001 s

Las consultas devolvieron las mismas filas antes y después
de crear el índice.

En estas ejecuciones, IN y NOT IN mostraron el mismo tiempo.
La consulta con JOIN mostró un tiempo menor con el índice.

Como la tabla es pequeña y los tiempos son muy bajos, una sola
medición no permite atribuir toda la diferencia al índice:
también pueden influir la caché y las variaciones de ejecución.

NOT IN devuelve 601 filas, casi toda la tabla, por lo que el
índice puede aportar poco beneficio.
*/