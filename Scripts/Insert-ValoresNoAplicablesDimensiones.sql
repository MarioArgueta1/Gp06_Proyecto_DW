SET IDENTITY_INSERT DIMCLIENTE ON
INSERT INTO DIMCLIENTE (IDCLIENTE,IDCLIENTEN,NOMBRE,DIRECCION,CIUDAD,PAIS,EMAIL,FECHADENACIMIENTO,GENERO) VALUES(-1,-1,'No aplica','No aplica','No aplica','No aplica','No aplica',GETDATE(),'No aplica')
SET IDENTITY_INSERT DIMCLIENTE OFF

SET IDENTITY_INSERT DIMPRODUCTO ON
INSERT INTO DIMPRODUCTO (IDPRODUCTO,IDPRODUCTON,NOMBRE,CATEGORIA,DESCRIPCION,PRECIOUNITARIO,STOCK) VALUES(-1,-1,'No aplica','No aplica','No aplica',0.00,0)
SET IDENTITY_INSERT DIMPRODUCTO OFF

SET IDENTITY_INSERT DIMUBICACION ON
INSERT INTO DIMUBICACION (IDUBICACION,IDUBICACIONN,PAIS,CIUDAD,DIRECCION,MONEDA) VALUES(-1,-1,'No aplica','No aplica','No aplica','No aplica')
SET IDENTITY_INSERT DIMUBICACION OFF