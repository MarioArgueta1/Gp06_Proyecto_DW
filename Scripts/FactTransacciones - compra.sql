SELECT ci.magento_product_id as IdProducto, -1 as IdUbicacion, -1 as IdCliente, ci.date as  IdTiempo, 'Compra' as TipoTransaccion, ci.stock_added as Cantidad, 
CASE 
    WHEN ci.stock_added BETWEEN 0 AND 15 THEN (SELECT list_price FROM product_template WHERE id = ci.product_id)
    WHEN ci.stock_added BETWEEN 16 AND 30 THEN (SELECT list_price FROM product_template WHERE id = ci.product_id)
    WHEN ci.stock_added BETWEEN 31 AND 50 THEN (SELECT list_price FROM product_template WHERE id = ci.product_id)
    WHEN ci.stock_added BETWEEN 50 AND 100 THEN (SELECT list_price FROM product_template WHERE id = ci.product_id)
    WHEN ci.stock_added > 100 THEN (SELECT list_price FROM product_template WHERE id = ci.product_id)
END as PrecioUnitario, 
CASE 
    WHEN ci.stock_added BETWEEN 0 AND 15 THEN (ci.stock_added) * (SELECT list_price FROM product_template WHERE id = ci.product_id)
    WHEN ci.stock_added BETWEEN 16 AND 30 THEN (ci.stock_added) * (SELECT list_price FROM product_template WHERE id = ci.product_id)
    WHEN ci.stock_added BETWEEN 31 AND 50 THEN (ci.stock_added) * (SELECT list_price FROM product_template WHERE id = ci.product_id)
    WHEN ci.stock_added BETWEEN 50 AND 100 THEN (ci.stock_added) * (SELECT list_price FROM product_template WHERE id = ci.product_id)
    WHEN ci.stock_added > 100 THEN (ci.stock_added) * (SELECT list_price FROM product_template WHERE id = ci.product_id)
END as TotalTransaccion, 
CASE
    WHEN ci.stock_added BETWEEN 0 AND 15 THEN 1
    WHEN ci.stock_added BETWEEN 16 AND 30 THEN 3
    WHEN ci.stock_added BETWEEN 31 AND 50 THEN 5
    WHEN ci.stock_added BETWEEN 50 AND 100 THEN 7
    WHEN ci.stock_added > 100 THEN 10
END as CostoTraslado,
CASE 
    WHEN ci.stock_added BETWEEN 0 AND 15 THEN 0.25
    WHEN ci.stock_added BETWEEN 16 AND 30 THEN 0.50
    WHEN ci.stock_added BETWEEN 31 AND 50 THEN 0.75
    WHEN ci.stock_added BETWEEN 50 AND 100 THEN 1
    WHEN ci.stock_added > 100 THEN 1.50
END as CostoAlmacen, 
(CASE 
    WHEN ci.stock_added BETWEEN 0 AND 15 THEN 1
    WHEN ci.stock_added BETWEEN 16 AND 30 THEN 3
    WHEN ci.stock_added BETWEEN 31 AND 50 THEN 5
    WHEN ci.stock_added BETWEEN 50 AND 100 THEN 7
    WHEN ci.stock_added > 100 THEN 10
END + 
CASE
    WHEN ci.stock_added BETWEEN 0 AND 15 THEN 0.25
    WHEN ci.stock_added BETWEEN 16 AND 30 THEN 0.50
    WHEN ci.stock_added BETWEEN 31 AND 50 THEN 0.75
    WHEN ci.stock_added BETWEEN 50 AND 100 THEN 1
    WHEN ci.stock_added > 100 THEN 1.50     
    END) as CostoInventario, 
30 AS TiempoEntregaDias, 
CASE
    WHEN ci.stock_added BETWEEN 0 AND 15 THEN 0.15
    WHEN ci.stock_added BETWEEN 16 AND 30 THEN 0.25
    WHEN ci.stock_added BETWEEN 31 AND 50 THEN 0.35
    WHEN ci.stock_added BETWEEN 50 AND 100 THEN 0.50
    WHEN ci.stock_added > 100 THEN 0.60
END as Descuento,
(CASE
    WHEN ci.stock_added BETWEEN 0 AND 15 THEN (ci.stock_added) * (SELECT (list_price - list_price * 0.15) FROM product_template WHERE id = ci.product_id)
    WHEN ci.stock_added BETWEEN 16 AND 30 THEN (ci.stock_added) * (SELECT (list_price - list_price * 0.25) FROM product_template WHERE id = ci.product_id)
    WHEN ci.stock_added BETWEEN 31 AND 50 THEN (ci.stock_added) * (SELECT (list_price - list_price * 0.35) FROM product_template WHERE id = ci.product_id)
    WHEN ci.stock_added BETWEEN 50 AND 100 THEN (ci.stock_added) * (SELECT (list_price - list_price * 0.50) FROM product_template WHERE id = ci.product_id)
    WHEN ci.stock_added > 100 THEN (ci.stock_added) * (SELECT (list_price - list_price * 0.60) FROM product_template WHERE id = ci.product_id) 
END + 
CASE 
    WHEN ci.stock_added BETWEEN 0 AND 15 THEN 1
    WHEN ci.stock_added BETWEEN 16 AND 30 THEN 3
    WHEN ci.stock_added BETWEEN 31 AND 50 THEN 5
    WHEN ci.stock_added BETWEEN 50 AND 100 THEN 7
    WHEN ci.stock_added > 100 THEN 10
END + 
CASE
    WHEN ci.stock_added BETWEEN 0 AND 15 THEN 0.25
    WHEN ci.stock_added BETWEEN 16 AND 30 THEN 0.50
    WHEN ci.stock_added BETWEEN 31 AND 50 THEN 0.75
    WHEN ci.stock_added BETWEEN 50 AND 100 THEN 1
    WHEN ci.stock_added > 100 THEN 1.50     
END) AS CostoTotalTransaccion
FROM compra_inventario ci