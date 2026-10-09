use sakila;

SELECT COUNT(*) AS cantidad_copias
FROM inventory
WHERE film_id = 1
  AND store_id = 1;
-- 4

-- ACTIVIDAD 1: cantidad de copias de una película en una tienda

CREATE FUNCTION contar_copias(
    p_film_id INT,
    p_titulo VARCHAR(128),
    p_store_id INT
)
RETURNS INT
NOT DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_cantidad INT DEFAULT 0;

    SELECT COUNT(*)
    INTO v_cantidad
    FROM inventory AS i
    INNER JOIN film AS f
        ON f.film_id = i.film_id
    WHERE i.store_id = p_store_id
      AND (
          (p_film_id IS NOT NULL AND f.film_id = p_film_id)
          OR
          (p_film_id IS NULL AND f.title = p_titulo)
      );

    RETURN v_cantidad;
END;

-- Buscar por ID
SELECT sakila.contar_copias(1, NULL, 1) AS copias_por_id;

-- Buscar por título
SELECT sakila.contar_copias(
    NULL, 'ACADEMY DINOSAUR', 1
) AS copias_por_titulo;