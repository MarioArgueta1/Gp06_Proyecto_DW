SELECT DISTINCT c.entity_id AS 'IdClienteN', 
CONCAT_WS(' ', c.firstname, c.middlename, c.lastname) AS Nombre,
CONCAT_WS(', ', a.street, a.region) AS 'Direccion',
a.city AS 'Ciudad',
CASE
    WHEN a.country_id = 'BZ' THEN 'Belice'
    WHEN a.country_id = 'CR' THEN 'Costa Rica'
    WHEN a.country_id = 'SV' THEN 'El Salvador'
    WHEN a.country_id = 'GT' THEN 'Guatemala'
    WHEN a.country_id = 'HN' THEN 'Honduras'
    WHEN a.country_id = 'NI' THEN 'Nicaragua'
    WHEN a.country_id = 'PA' THEN 'Panama'
    WHEN a.country_id = 'US' THEN 'Estados Unidos'
    ELSE 'Sin Especificar' 
END AS 'Pais',
c.email AS 'email', 
COALESCE(c.dob, 'Sin especificar') AS 'FechaDeNacimiento',
CASE 
    WHEN c.gender = 1 THEN 'Masculino'
    WHEN c.gender = 2 THEN 'Femenino'
    ELSE 'No definido'
END AS 'Genero'
FROM customer_entity AS c
INNER JOIN sales_order AS s ON s.customer_id = c.entity_id
INNER JOIN customer_address_entity AS a ON a.entity_id = c.default_billing
WHERE s.status NOT IN ('canceled')
