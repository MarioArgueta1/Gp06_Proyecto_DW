CREATE OR REPLACE FUNCTION log_stock_increase_in_quant()
RETURNS TRIGGER AS $$
BEGIN
    IF ((TG_OP = 'INSERT' AND NEW.quantity IS NOT NULL) OR (TG_OP = 'UPDATE' AND NEW.quantity > OLD.quantity)) THEN
        INSERT INTO compra_inventario (product_id, magento_product_id, product_name, product_code, action_type, stock_added, date)
        VALUES (
            NEW.product_id,
            COALESCE((SELECT CAST(magento_id AS INT) FROM product_product WHERE id = NEW.product_id),-1),
            (SELECT name FROM product_template WHERE id = (SELECT product_tmpl_id FROM product_product WHERE id = NEW.product_id)),
            (SELECT default_code FROM product_product WHERE id = NEW.product_id),
            'stock_increase',
            ABS(NEW.quantity - COALESCE(OLD.quantity, 0)),
            TO_CHAR(CURRENT_DATE, 'YYYYMMDD')::INT
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_stock_increase_in_quant
AFTER INSERT OR UPDATE ON stock_quant
FOR EACH ROW
EXECUTE FUNCTION log_stock_increase_in_quant();
