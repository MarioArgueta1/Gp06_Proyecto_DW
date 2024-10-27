CREATE TABLE compra_inventario (
    id SERIAL PRIMARY KEY,
    product_id INT NOT NULL,
	magento_product_id INT,
    product_name VARCHAR,
    product_code VARCHAR,
    date INT,
    action_type VARCHAR(20), -- 'creation' o 'stock_increase'
    stock_added FLOAT DEFAULT 0
)
