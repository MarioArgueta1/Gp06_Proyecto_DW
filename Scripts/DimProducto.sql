SELECT 
    DISTINCT(e.entity_id) as Idproducton,
    n.value AS Nombre,
    GROUP_CONCAT(DISTINCT cv.value SEPARATOR ', ') as Categoria,
    COALESCE(REPLACE(REPLACE(d.value, '<p>', ''), '</p>', ''),'Sin especificar') AS Descripcion,
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
LEFT JOIN 
    catalog_category_product AS cp
    ON e.entity_id = cp.product_id
LEFT JOIN 
    catalog_category_entity_varchar AS cv
    ON cp.category_id = cv.entity_id
    AND cv.attribute_id = 45
INNER JOIN `cataloginventory_stock_item` as si on e.entity_id = si.product_id
GROUP BY 
    e.entity_id;