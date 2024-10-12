SELECT sor.entity_id as 'IdUbicacionN', 
CASE sor.country_id
WHEN 'BZ' THEN 'Belice'
WHEN 'CR' THEN 'Costa Rica'
WHEN 'SV' THEN 'El Salvador'
WHEN 'GT' THEN 'Guatemala'
WHEN 'HN' THEN 'Honduras'
WHEN 'NI' THEN 'Nicaragua'
WHEN 'PA' THEN 'Panama'
WHEN 'MX' THEN 'Mexico'
ELSE 'Sin especificar'
END AS 'Pais',
sor.city as 'Ciudad',
CONCAT_WS(', ', a.street, a.region) as 'Direccion',
CASE so.order_currency_code
WHEN 'BZD' THEN 'Dolar beliceño'
WHEN 'CRC' THEN 'Colon costarricense'
WHEN 'USD' THEN 'Dolar estadounidense'
WHEN 'GTQ' THEN 'Quetzal'
WHEN 'HNL' THEN 'Lempira hondureño'
WHEN 'NIC' THEN 'Cordoba nicaraguense'
WHEN 'PAB' THEN 'Balboa'
WHEN 'MXN' THEN 'Peso mexicano'
ELSE 'Sin especificar'
END AS 'Moneda'
from sales_order_address sor inner join sales_order so on so.entity_id = sor.parent_id where sor.address_type = 'shipping'