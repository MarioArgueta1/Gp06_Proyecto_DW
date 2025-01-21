SELECT e.entity_id as 'IdProducto', sor.entity_id as 'IdUbicacion', c.entity_id as 'IdCliente', DATE_FORMAT(so.created_at, '%Y%m%d') as 'IdTiempo', 'Venta' as 'TipoTransaccion', soi.qty_ordered as 'Cantidad', cped.value as 'PrecioUnitario', ((soi.qty_ordered * cped.value) - soi.discount_amount) as 'TotalTransaccion', 
CASE so.total_qty_ordered
    WHEN 1 THEN ABS(so.base_shipping_amount - 1)
    ELSE ABS(((SELECT value FROM core_config_data WHERE path = 'carriers/flatrate/price')*soi.qty_ordered))
END as 'CostoTraslado',
1/(SELECT COUNT(*) FROM sales_order_item soi WHERE soi.order_id = so.entity_id) as 'CostoAlmacen', 
(1/(SELECT COUNT(*) FROM sales_order_item soi WHERE soi.order_id = so.entity_id) + 
CASE so.total_qty_ordered
    WHEN 1 THEN ABS(so.base_shipping_amount - 1)
    ELSE ABS(((SELECT value FROM core_config_data WHERE path = 'carriers/flatrate/price')*soi.qty_ordered))
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
    (1/(SELECT COUNT(*) FROM sales_order_item soi WHERE soi.order_id = so.entity_id) + 
	CASE so.total_qty_ordered
    	WHEN 1 THEN ABS(so.base_shipping_amount - 1)
    	ELSE ABS(((SELECT value FROM core_config_data WHERE path = 'carriers/flatrate/price')*soi.qty_ordered))
	END) AS 'CostoTotalTransaccion'
FROM catalog_product_entity e
INNER JOIN sales_order_item soi on e.entity_id = soi.product_id 
INNER JOIN sales_order so ON so.entity_id = soi.order_id
INNER JOIN sales_order_address sor ON so.entity_id = sor.parent_id
INNER JOIN customer_entity c on so.customer_id = c.entity_id
INNER JOIN catalog_product_entity_decimal as cped on e.entity_id = cped.entity_id
WHERE sor.address_type = 'shipping'