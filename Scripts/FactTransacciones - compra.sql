SELECT ci.magento_product_id as IdProducto, -1 as IdUbicacion, -1 as IdCliente, ci.date as  IdTiempo, 'Compra' as TipoTransaccion, ci.stock_added as Cantidad, 
(SELECT (ROUND(CAST((SELECT value_float FROM ir_property WHERE name='standard_price' and SPLIT_PART(res_id, ',', 2)::INTEGER = ci.product_id) AS NUMERIC),2))) as PrecioUnitario, 
(SELECT (ROUND(CAST((ci.stock_added) * (SELECT value_float FROM ir_property WHERE name='standard_price' and SPLIT_PART(res_id, ',', 2)::INTEGER = ci.product_id) AS NUMERIC),2))) as TotalTransaccion, 
CASE
    WHEN ci.stock_added BETWEEN 0 AND 15 THEN 1
    WHEN ci.stock_added BETWEEN 16 AND 30 THEN 3
    WHEN ci.stock_added BETWEEN 31 AND 50 THEN 5
    WHEN ci.stock_added BETWEEN 51 AND 100 THEN 7
    WHEN ci.stock_added > 100 THEN 10
END as CostoTraslado,
CASE 
    WHEN ci.stock_added BETWEEN 0 AND 10 THEN 5  
    WHEN ci.stock_added BETWEEN 11 AND 20 THEN 10 
    WHEN ci.stock_added BETWEEN 21 AND 50 THEN 15 
    WHEN ci.stock_added BETWEEN 51 AND 100 THEN 25
    WHEN ci.stock_added > 100 THEN 35
END as CostoAlmacen, 
(CASE --Costo traslado
    WHEN ci.stock_added BETWEEN 0 AND 15 THEN 1
    WHEN ci.stock_added BETWEEN 16 AND 30 THEN 3
    WHEN ci.stock_added BETWEEN 31 AND 50 THEN 5
    WHEN ci.stock_added BETWEEN 51 AND 100 THEN 7
    WHEN ci.stock_added > 100 THEN 10
END + 
CASE --Costo almacen
    WHEN ci.stock_added BETWEEN 0 AND 10 THEN 5  
    WHEN ci.stock_added BETWEEN 11 AND 20 THEN 10 
    WHEN ci.stock_added BETWEEN 21 AND 50 THEN 15 
    WHEN ci.stock_added BETWEEN 51 AND 100 THEN 25 
    WHEN ci.stock_added > 100 THEN 35   
    END) as CostoInventario, 
30 AS TiempoEntregaDias, 
CASE
    WHEN ci.stock_added BETWEEN 0 AND 15 THEN 0.15
    WHEN ci.stock_added BETWEEN 16 AND 30 THEN 0.25
    WHEN ci.stock_added BETWEEN 31 AND 50 THEN 0.35
    WHEN ci.stock_added BETWEEN 51 AND 100 THEN 0.50
    WHEN ci.stock_added > 100 THEN 0.60
END as Descuento,
(CASE --cantidad * (Precio unitario - precio unitario*descuento)
    WHEN ci.stock_added BETWEEN 0 AND 15 THEN (ci.stock_added) * ((SELECT ROUND(CAST((SELECT value_float FROM ir_property WHERE name='standard_price' and SPLIT_PART(res_id, ',', 2)::INTEGER = ci.product_id) AS NUMERIC),2)) - (SELECT ROUND(CAST((SELECT value_float FROM ir_property WHERE name='standard_price' and SPLIT_PART(res_id, ',', 2)::INTEGER = ci.product_id) AS NUMERIC),2)) * 0.15)
    WHEN ci.stock_added BETWEEN 16 AND 30 THEN (ci.stock_added) * ((SELECT ROUND(CAST((SELECT value_float FROM ir_property WHERE name='standard_price' and SPLIT_PART(res_id, ',', 2)::INTEGER = ci.product_id) AS NUMERIC),2)) - (SELECT ROUND(CAST((SELECT value_float FROM ir_property WHERE name='standard_price' and SPLIT_PART(res_id, ',', 2)::INTEGER = ci.product_id) AS NUMERIC),2)) * 0.25)
    WHEN ci.stock_added BETWEEN 31 AND 50 THEN (ci.stock_added) * ((SELECT ROUND(CAST((SELECT value_float FROM ir_property WHERE name='standard_price' and SPLIT_PART(res_id, ',', 2)::INTEGER = ci.product_id) AS NUMERIC),2)) - (SELECT ROUND(CAST((SELECT value_float FROM ir_property WHERE name='standard_price' and SPLIT_PART(res_id, ',', 2)::INTEGER = ci.product_id) AS NUMERIC),2)) * 0.35)
    WHEN ci.stock_added BETWEEN 51 AND 100 THEN (ci.stock_added) * ((SELECT ROUND(CAST((SELECT value_float FROM ir_property WHERE name='standard_price' and SPLIT_PART(res_id, ',', 2)::INTEGER = ci.product_id) AS NUMERIC),2)) - (SELECT ROUND(CAST((SELECT value_float FROM ir_property WHERE name='standard_price' and SPLIT_PART(res_id, ',', 2)::INTEGER = ci.product_id) AS NUMERIC),2)) * 0.50)
    WHEN ci.stock_added > 100 THEN (ci.stock_added) * ((SELECT ROUND(CAST((SELECT value_float FROM ir_property WHERE name='standard_price' and SPLIT_PART(res_id, ',', 2)::INTEGER = ci.product_id) AS NUMERIC),2)) - (SELECT ROUND(CAST((SELECT value_float FROM ir_property WHERE name='standard_price' and SPLIT_PART(res_id, ',', 2)::INTEGER = ci.product_id) AS NUMERIC),2)) * 0.60)
END + 
CASE --Costo traslado
    WHEN ci.stock_added BETWEEN 0 AND 15 THEN 1
    WHEN ci.stock_added BETWEEN 16 AND 30 THEN 3
    WHEN ci.stock_added BETWEEN 31 AND 50 THEN 5
    WHEN ci.stock_added BETWEEN 51 AND 100 THEN 7
    WHEN ci.stock_added > 100 THEN 10
END + 
CASE --Costo almacen
    WHEN ci.stock_added BETWEEN 0 AND 10 THEN 5  
    WHEN ci.stock_added BETWEEN 11 AND 20 THEN 10 
    WHEN ci.stock_added BETWEEN 21 AND 50 THEN 15 
    WHEN ci.stock_added BETWEEN 51 AND 100 THEN 25 
    WHEN ci.stock_added > 100 THEN 35       
END) AS CostoTotalTransaccion
FROM compra_inventario ci