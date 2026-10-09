-- Ejercicio 3: buscar texto con LIKE.
SELECT film_id, title, description
FROM sakila.film
WHERE description LIKE '%Drama%'
ORDER BY film_id;
-- LIKE: 106 filas, tiempo mostrado 0,004 s.

CREATE FULLTEXT INDEX idx_film_text_description
ON sakila.film_text (description);

-- Ejercicio 3: buscar texto con FULLTEXT.
SELECT film_id, title, description,
       MATCH(description)
       AGAINST('Drama' IN NATURAL LANGUAGE MODE) AS relevancia
FROM sakila.film_text
WHERE MATCH(description)
      AGAINST('Drama' IN NATURAL LANGUAGE MODE)
ORDER BY relevancia DESC, film_id;

SELECT COUNT(*) AS cantidad_film_text
FROM sakila.film_text;

INSERT INTO sakila.film_text (film_id, title, description)
SELECT film_id, title, description
FROM sakila.film;

SELECT film_id, title, description,
       MATCH(description)
       AGAINST('Drama' IN NATURAL LANGUAGE MODE) AS relevancia
FROM sakila.film_text
WHERE MATCH(description)
      AGAINST('Drama' IN NATURAL LANGUAGE MODE)
ORDER BY relevancia DESC, film_id;

/*
EJERCICIO 3: RESULTADOS Y EXPLICACIÓN

LIKE: 106 filas, tiempo mostrado 0,004 s.
FULLTEXT: 106 filas, tiempo mostrado 0,001 s.

Inicialmente film_text estaba vacía. Se cargaron los 1000
registros de film para poder realizar la comparación.

Ambas búsquedas devolvieron 106 filas para el término Drama.

LIKE '%Drama%' busca una secuencia de caracteres dentro
de la descripción, incluso como parte de una palabra.

MATCH ... AGAINST busca palabras mediante el índice FULLTEXT
y permite calcular la relevancia de las coincidencias.
La consulta ordena los resultados por esa relevancia.

En esta ejecución FULLTEXT mostró un tiempo menor.
Una sola medición con tiempos tan pequeños no permite
concluir que siempre será más rápido.

Aunque aquí coincida la cantidad de resultados, ambos métodos
pueden devolver resultados distintos con otros términos.
*/