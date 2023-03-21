###Ejercicios###
/*SELECT Ventas_Fecha,Ventas_NroFactura,Ventas_Total
FROM ventas
*/
/*
SELECT VD_ProdId, VD_Cantidad,VD_Precio
FROM ventas_detalle
WHERE VD_Precio>0 
*/
/*
SELECT Ventas_Fecha, sum(Ventas_Total) as Total_Ventas
FROM ventas
GROUP BY Ventas_Fecha
*/
/*
SELECT YEAR(Ventas_Fecha) AS anio, MONTH(Ventas_Fecha) AS mes, SUM(Ventas_Total) AS Ventas_Totales
FROM ventas
GROUP BY anio, mes
*/
/*
SELECT Prod_Id, Prod_Descripcion
FROM productos
WHERE Prod_ProvId=62
*/
/*
SELECT VD_ProdId AS producto, 
	SUM((VD_Precio*VD_Cantidad)) AS Total_Vendidos
FROM ventas_detalle
GROUP BY producto ORDER BY producto DESC
*/
/*
SELECT 
Ventas_Fecha, 
Ventas_NroFactura, 
Cli_Id, 
Ventas_Total
Cli_RazonSocial FROM ventas
INNER JOIN clientes ON cli_id = Ventas_CliId
*/
/*
SELECT 
Ventas_Fecha,
Ventas_NroFactura,
Prod_Id,
Prod_Descripcion,
Prov_Id,
Prov_Nombre,
VD_Cantidad,
VD_Precio,
(VD_Cantidad * VD_Precio) AS PrecioUnitarioyParcial
FROM ventas
INNER JOIN ventas_detalle ON VD_VentasId = Ventas_Id
INNER JOIN productos ON Prod_Id = VD_ProdId
INNER JOIN proveedores ON Prov_Id = Prod_Id
*/
/*
SELECT 
Prod_Id,
Prod_Descripcion,
Ventas_Fecha,
sum(VD_Cantidad) AS Cantidades_Vendidas
FROM productos 
INNER JOIN ventas_detalle ON VD_ProdId = Prod_Id
INNER JOIN ventas ON Ventas_Id = VD_VentasId
WHERE Ventas_Fecha BETWEEN '2018-01-14' AND '2018-01-16'
GROUP BY Prod_Id 	
*/
/*
SELECT sum(VD_Cantidad) FROM ventas_detalle 
INNER JOIN ventas ON Ventas_Id = VD_VentasId
WHERE Ventas_Fecha BETWEEN '2018-01-14' AND '2018-01-16'
AND  VD_ProdId = 36
*/
/*
SELECT *
FROM productos
WHERE Prod_Descripcion LIKE 'SUBTERRANEO%'
*/
/*
SELECT 
Prod_Id,
Prod_Descripcion,
Prov_Nombre
FROM productos
INNER JOIN proveedores ON Prov_Id = Prod_ProvId
WHERE CONCAT(Prod_Descripcion,Prov_Nombre, Prod_Color) LIKE '%FERRO%' 
*/
/*
SELECT 
Prod_Id,
Prod_Descripcion
FROM productos
WHERE  Prod_Descripcion LIKE '%CINTA%' 
AND Prod_Id IN (SELECT VD_ProdId FROM ventas_detalle)
*/
/*
SELECT 
COUNT(DISTINCT(VD_ProdId)) AS CantidadProductos
FROM productos
INNER JOIN ventas_detalle ON VD_ProdId=Prod_Id
*/
/*
SELECT SUM((VD_Cantidad * VD_Precio)) AS TotalVendido
FROM ventas_detalle
INNER JOIN productos ON Prod_Id = VD_ProdId
INNER JOIN ventas ON Ventas_Id = VD_VentasId
WHERE (Ventas_Fecha BETWEEN '2018-01-02' AND '2018-01-10') 
AND (Prod_ProvId BETWEEN 2 AND 100)
*/
/*
SELECT Ventas_NroFactura, MAX(Ventas_Total) AS Maximo_Totales
FROM ventas
INNER JOIN ventas_detalle ON VD_VentasId=Ventas_Id
WHERE VD_ProdId = 656
*/
###Exportar consulta###
/*
SELECT 
Prod_Id,
Prod_Descripcion,
Prod_Color,
Prod_Status,
Prod_Precio,
Prov_Id,
Prov_Nombre
FROM productos
INNER JOIN proveedores ON Prod_ProvId = Prov_Id
*/
/*
SELECT Ventas_Fecha AS Fecha1, ADDDATE(Ventas_Fecha,30) AS Fecha2
FROM ventas
*/
/*
SELECT Prod_Descripcion, AES_ENCRYPT(Prod_Descripcion,'Alb3rt0*') AS DecripEncrypt
FROM productos
*/
/*
SELECT Prod_Descripcion, AES_DECRYPT(AES_ENCRYPT(Prod_Descripcion,'Alb3rt0*'),'Alb3rt0*') AS DecripEncrypt
FROM productos
*/
/*
SELECT UNCOMPRESS(COMPRESS(Prod_Descripcion)) AS Comprimido
FROM productos
*/
/*
SELECT CONCAT_WS('*', Prod_Descripcion,Prod_Color,Prod_Precio) AS TextoConcatenado
FROM productos
*/
/*
SELECT CONVERT("08:25:00,", TIME) AS hora, Prod_Id
FROM productos 
*/
/*
SELECT DATEDIFF(Ventas_Fecha,NOW()) AS Diferiencia 
FROM ventas
*/
/*
SELECT DATE_FORMAT(Ventas_Fecha, 'Año %Y y mes %m') AS Fecha 
FROM ventas
*/
/*CALL InsertaAlumno(7,'Tomas');*/
/*
CALL MaximaVenta()
*/
/*
SELECT GananciaVentas(2018,1)
*/