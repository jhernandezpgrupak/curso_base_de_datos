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
/*
SELECT UtilidadTotal('2018-01-01','2019-01-31')
*/
/*
CALL CodigosABC('2018-01-01','2019-01-31')
*/
/*
SELECT * FROM (SELECT @ParamProvId:=5 AS id) ProvId, productosproveedor
*/
/*
START TRANSACTION
####
####
ROLLBACK;
####
COMMIT; 
*/
/*
INSERT INTO Productos 
	(Prod_Descripcion, Prod_Propiedades) VALUES('Producto con JSON', 
	'{"propiedades":
		{
			"electrico": true,
			"garantia": true,
			"nuevo":	false,
			"fallas": true	
		}
	}');
*/
/*
SELECT #Verificar la version de mysql v.8 en este caso mariadb 
Prod_Id,
Prod_Descripcion,
Prod_Propiedades->'$.propiedades.electrico' AS Electrico
FROM productos
*/
/*
UPDATE productos 
SET Prod_Propiedades = JSON_REPLACE(Prod_Propiedades,'$.propiedades.electrico','false')
WHERE Prod_Id = 6990
*/
/*
SELECT Prod_Id, Prod_Descripcion FROM
productos WHERE JSON_EXTRACT(Prod_Propiedades,
'$.propiedades.electrico')=FALSE 
*/
/*
UPDATE productos 
SET Prod_Propiedades = JSON_REMOVE(Prod_Propiedades,'$.propiedades.fallas')
WHERE Prod_Id=6990
*/
/*
EXPLAIN SELECT 
pp_pedido_procesado.*,
pp_pedido.*
FROM
	pp_pedido_procesado 
INNER JOIN pp_pedido 
ON  pp_pedido_procesado.pedido_procesado_npedido=pp_pedido.pedido_npedido
WHERE pedido_procesado_status = 1 ORDER BY pedido_procesado_row ASC
*/
#Practicas con la base de datos sakila
/*
SELECT COUNT(*) AS Comedias
FROM film
INNER JOIN film_category ON film_category.film_id = film.film_id
INNER JOIN category ON category.category_id = film_category.category_id
WHERE category.category_id = 5;
*/
/*
SELECT actor.actor_id, first_name, last_name, COUNT(film_actor.actor_id) AS Numero_Peliculas
FROM actor
INNER JOIN film_actor ON film_actor.actor_id = actor.actor_id
GROUP BY film_actor.actor_id
ORDER BY Numero_Peliculas DESC
LIMIT 1
*/
/*
SELECT actor.actor_id, first_name, last_name
FROM actor
INNER JOIN film_actor ON film_actor.actor_id = actor.actor_id
GROUP BY film_actor.actor_id
ORDER BY COUNT(*) DESC
LIMIT 1
*/
/*
SELECT staff.staff_id, first_name, last_name, COUNT(film_actor.actor_id) AS Veces
FROM staff
INNER JOIN rental ON rental.staff_id = staff.staff_id
INNER JOIN inventory ON inventory.film_id = rental.inventory_id
INNER JOIN film ON film.film_id=inventory.film_id
INNER JOIN film_actor ON film_actor.film_id=film.film_id
WHERE film_actor.actor_id=107
GROUP BY staff.staff_id
ORDER BY COUNT(film_actor.actor_id) DESC 
LIMIT 1
*/
/*
SELECT COUNT(film.film_id) AS Numero_Peliculas, customer.customer_id
FROM film
INNER JOIN inventory ON inventory.film_id=film.film_id
INNER JOIN store ON store.store_id=inventory.store_id
INNER JOIN customer ON customer.store_id=store.store_id
WHERE film.rating = 'PG-13' AND inventory.store_id=2 
AND customer.customer_id=(
SELECT customer_id
FROM rental
GROUP BY customer_id
ORDER BY COUNT(*) DESC
LIMIT 1 
)
*/
/*
SELECT COUNT(*) AS Peliculas
FROM film
INNER JOIN inventory ON inventory.film_id = film.film_id
INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
WHERE film.film_id IN (
SELECT film.film_id
FROM film
INNER JOIN inventory ON inventory.film_id = film.film_id
WHERE rating='PG-13' AND inventory.store_id = 2
	) AND rental.customer_id=
			(
SELECT customer_id
FROM rental
GROUP BY customer_id
ORDER BY COUNT(*) DESC
LIMIT 1) AND inventory.store_id=2
*/
















