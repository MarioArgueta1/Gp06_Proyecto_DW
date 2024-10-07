SELECT 
    DISTINCT(e.entity_id) as Idproducton,
    n.value AS Nombre,
    cv.value as Categoria,
    COALESCE(d.value, 'Sin especificar') AS Descripcion,
    p.value as Preciounitario,
    si.qty as Stock
FROM 
    catalog_product_entity AS e
LEFT JOIN 
    catalog_product_entity_varchar AS n
    ON e.entity_id = n.entity_id
    AND n.attribute_id = 73
LEFT JOIN 
    catalog_product_entity_text AS d
    ON e.entity_id = d.entity_id
    AND d.attribute_id = 75
     INNER JOIN `catalog_product_entity_decimal` as p on e.entity_id = p.entity_id 
INNER JOIN `catalog_category_entity` as c on e.entity_id = c.entity_id 
INNER JOIN `catalog_category_entity_text` as cv on c.attribute_set_id = cv.entity_id 
INNER JOIN `cataloginventory_stock_item` as si on e.entity_id = si.product_id;