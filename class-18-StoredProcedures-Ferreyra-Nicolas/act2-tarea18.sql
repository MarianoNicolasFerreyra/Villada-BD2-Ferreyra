SELECT c.first_name, c.last_name
FROM sakila.customer AS c
INNER JOIN sakila.address AS a
    ON a.address_id = c.address_id
INNER JOIN sakila.city AS ci
    ON ci.city_id = a.city_id
INNER JOIN sakila.country AS co
    ON co.country_id = ci.country_id
WHERE co.country = 'Argentina'
ORDER BY c.last_name, c.first_name, c.customer_id;

CREATE PROCEDURE sakila.clientes_por_pais(
    IN p_pais VARCHAR(50),
    OUT p_lista LONGTEXT
)
BEGIN
    DECLARE v_fin BOOLEAN DEFAULT FALSE;
    DECLARE v_nombre VARCHAR(45);
    DECLARE v_apellido VARCHAR(45);

    DECLARE cur_clientes CURSOR FOR
        SELECT c.first_name, c.last_name
        FROM sakila.customer AS c
        INNER JOIN sakila.address AS a
            ON a.address_id = c.address_id
        INNER JOIN sakila.city AS ci
            ON ci.city_id = a.city_id
        INNER JOIN sakila.country AS co
            ON co.country_id = ci.country_id
        WHERE co.country = p_pais
        ORDER BY c.last_name, c.first_name, c.customer_id;

    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET v_fin = TRUE;

    SET p_lista = '';

    OPEN cur_clientes;

    leer_clientes: LOOP
        FETCH cur_clientes INTO v_nombre, v_apellido;

        IF v_fin THEN
            LEAVE leer_clientes;
        END IF;

        IF p_lista = '' THEN
            SET p_lista = CONCAT(v_nombre, ' ', v_apellido);
        ELSE
            SET p_lista = CONCAT(
                p_lista, ';', v_nombre, ' ', v_apellido
            );
        END IF;
    END LOOP leer_clientes;

    CLOSE cur_clientes;
END;

CALL sakila.clientes_por_pais('Argentina', @clientes);
SELECT @clientes AS clientes_de_argentina;

