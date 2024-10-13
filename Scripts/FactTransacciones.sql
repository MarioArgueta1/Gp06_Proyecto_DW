SELECT e.entity_id as 'IdProducto', sor.entity_id as 'IdUbicacion', c.entity_id as 'IdCliente', DATE_FORMAT(so.created_at, '%Y%m%d') as 'IdTiempo', 'Venta' as 'TipoTransaccion', soi.qty_ordered as 'Cantidad', cped.value as 'PrecioUnitario', ((soi.qty_ordered * cped.value) - soi.discount_amount) as 'TotalTransaccion', 
CASE sor.country_id
	WHEN 'BZ' THEN 30  
	WHEN 'CR' THEN 25  
	WHEN 'SV' THEN 5   
	WHEN 'GT' THEN 10  
	WHEN 'HN' THEN 8   
	WHEN 'NI' THEN 20  
	WHEN 'PA' THEN 35  
	WHEN 'MX' THEN 40  
	ELSE 5000000           
END as 'CostoTraslado',
CASE 
    WHEN soi.qty_ordered BETWEEN 0 AND 10 THEN 5  
    WHEN soi.qty_ordered BETWEEN 11 AND 20 THEN 10 
    WHEN soi.qty_ordered BETWEEN 21 AND 50 THEN 15 
    WHEN soi.qty_ordered BETWEEN 51 AND 100 THEN 25 
    WHEN soi.qty_ordered > 100 THEN 35
END as 'CostoAlmacen', 
(CASE 
	WHEN soi.qty_ordered BETWEEN 0 AND 10 THEN 5  
    WHEN soi.qty_ordered BETWEEN 11 AND 20 THEN 10 
    WHEN soi.qty_ordered BETWEEN 21 AND 50 THEN 15 
    WHEN soi.qty_ordered BETWEEN 51 AND 100 THEN 25 
    WHEN soi.qty_ordered > 100 THEN 35
    END + 
CASE sor.country_id
    WHEN 'BZ' THEN 30  
    WHEN 'CR' THEN 25  
    WHEN 'SV' THEN 5   
    WHEN 'GT' THEN 10  
    WHEN 'HN' THEN 8   
    WHEN 'NI' THEN 20  
    WHEN 'PA' THEN 35  
    WHEN 'MX' THEN 40  
    ELSE 5000000           
    END) as 'CostoInventario', 
CASE sor.country_id
    WHEN 'BZ' THEN 15  
    WHEN 'CR' THEN 7   
    WHEN 'SV' THEN 2   
    WHEN 'GT' THEN 10  
    WHEN 'HN' THEN 12  
    WHEN 'NI' THEN 14  
    WHEN 'PA' THEN 20  
    WHEN 'MX' THEN 25  
    ELSE 300000            
END AS 'TiempoEntregaDias', 
soi.discount_amount as 'Descuento',
((soi.qty_ordered * cped.value) - soi.discount_amount) + 
    (CASE 
        WHEN soi.qty_ordered BETWEEN 0 AND 10 THEN 5  
        WHEN soi.qty_ordered BETWEEN 11 AND 20 THEN 10 
        WHEN soi.qty_ordered BETWEEN 21 AND 50 THEN 15 
        WHEN soi.qty_ordered BETWEEN 51 AND 100 THEN 25 
        WHEN soi.qty_ordered > 100 THEN 35
    END + 
    CASE sor.country_id
        WHEN 'BZ' THEN 30  
        WHEN 'CR' THEN 25  
        WHEN 'SV' THEN 5   
        WHEN 'GT' THEN 10  
        WHEN 'HN' THEN 8   
        WHEN 'NI' THEN 20  
        WHEN 'PA' THEN 35  
        WHEN 'MX' THEN 40  
        ELSE 5000000           
    END) AS 'CostoTotalTransaccion'
FROM catalog_product_entity e
INNER JOIN sales_order_item soi on e.entity_id = soi.product_id 
INNER JOIN sales_order so ON so.entity_id = soi.order_id
INNER JOIN sales_order_address sor ON so.entity_id = sor.parent_id
INNER JOIN customer_entity c on so.customer_id = c.entity_id
INNER JOIN catalog_product_entity_decimal as cped on e.entity_id = cped.entity_id
WHERE sor.address_type = 'shipping'