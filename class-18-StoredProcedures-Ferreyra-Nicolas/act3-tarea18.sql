SHOW CREATE FUNCTION sakila.inventory_in_stock;


SELECT ROUTINE_NAME, ROUTINE_TYPE
FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA = 'sakila'
ORDER BY ROUTINE_TYPE, ROUTINE_NAME;

SHOW CREATE PROCEDURE sakila.film_in_stock;

CREATE FUNCTION sakila.inventory_in_stock(
    p_inventory_id INT
)
RETURNS BOOLEAN
NOT DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_pendientes INT DEFAULT 0;

    SELECT COUNT(*)
    INTO v_pendientes
    FROM sakila.rental
    WHERE inventory_id = p_inventory_id
      AND return_date IS NULL;

    RETURN v_pendientes = 0;
END;

SELECT
    inventory_id,
    sakila.inventory_in_stock(inventory_id) AS disponible
FROM sakila.inventory
WHERE film_id = 1
  AND store_id = 1;

CALL sakila.film_in_stock(1, 1, @cantidad);

SELECT @cantidad AS copias_disponibles;

CREATE PROCEDURE sakila.film_in_stock(
    IN p_film_id INT,
    IN p_store_id INT,
    OUT p_film_count INT
)
READS SQL DATA
BEGIN
    SELECT inventory_id
    FROM inventory
    WHERE film_id = p_film_id
      AND store_id = p_store_id
      AND inventory_in_stock(inventory_id);

    SELECT COUNT(*)
    INTO p_film_count
    FROM inventory
    WHERE film_id = p_film_id
      AND store_id = p_store_id
      AND inventory_in_stock(inventory_id);
END;

-- En esta instalación faltaba inventory_in_stock.
-- Para ejecutar los ejemplos se creó una versión simplificada
-- que comprueba si la copia tiene alquileres sin devolver.
-- El procedimiento film_in_stock ya existía en la base.

-- inventory_in_stock:
-- Recibe el ID de una copia y verifica sus alquileres.
-- En la versión simplificada que agregamos, cuenta los alquileres
-- cuya return_date es NULL (todavía no fueron devueltos).
-- Devuelve 1 si no hay alquileres pendientes y 0 si hay alguno.

-- film_in_stock:
-- Recibe el ID de una película y el ID de una tienda.
-- El primer SELECT muestra los IDs de las copias disponibles,
-- usando inventory_in_stock para comprobar cada copia.
-- El segundo SELECT cuenta esas copias y guarda el resultado
-- en el parámetro OUT p_film_count.

-- Ejemplo comprobado:
-- CALL sakila.film_in_stock(1, 1, @cantidad);
-- Devuelve los inventory_id: 1, 2, 3 y 4.
-- SELECT @cantidad;
-- Devuelve 4.