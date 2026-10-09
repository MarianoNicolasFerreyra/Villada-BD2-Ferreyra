-- Ejercicio 2: búsqueda por nombre.
SELECT actor_id, first_name, last_name
FROM sakila.actor
WHERE first_name = 'PENELOPE';
-- Búsqueda por nombre: 4 filas, tiempo mostrado 0,002 s.

-- Ejercicio 2: búsqueda por apellido.
SELECT actor_id, first_name, last_name
FROM sakila.actor
WHERE last_name = 'GUINESS';
-- Búsqueda por apellido: 3 filas, tiempo mostrado 0,003 s.

EXPLAIN
SELECT actor_id, first_name, last_name
FROM sakila.actor
WHERE first_name = 'PENELOPE';

EXPLAIN
SELECT actor_id, first_name, last_name
FROM sakila.actor
WHERE last_name = 'GUINESS';

/*
EJERCICIO 2: RESULTADOS Y EXPLICACIÓN

Por nombre: 4 filas, tiempo mostrado 0,002 s.
Por apellido: 3 filas, tiempo mostrado 0,003 s.

La búsqueda por first_name no utiliza índice:
EXPLAIN muestra type = ALL, key = NULL y rows = 200.
Esto indica un recorrido completo de la tabla.

La búsqueda por last_name utiliza idx_actor_last_name:
EXPLAIN muestra type = ref y rows = 3.
El índice permite localizar las coincidencias revisando
menos filas.

Aunque la búsqueda por apellido mostró un tiempo mayor,
los tiempos son muy pequeños y pueden variar entre ejecuciones.
El plan confirma que utiliza el índice.
*/