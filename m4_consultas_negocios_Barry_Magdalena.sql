USE Ventas_Tech_DB;
GO
--CONSULTA 1
SELECT
    MONTH (fecha_venta) AS Mes,
    SUM(cantidad * precio_unitario)             AS total_facturado,
    COUNT(*)                                    AS cantidad_pedidos,
    AVG(cantidad * precio_unitario)             AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;



--CONSULTA 2
SELECT TOP 5
ID_Producto,
SUM (cantidad)        AS cantidad_pedidos,
SUM (cantidad * precio_unitario) AS total_generado
FROM ventas
GROUP BY ID_Producto
ORDER BY total_generado DESC;



--CONSULTA 3
SELECT
   id_cliente,
   COUNT(*) AS cantidad_pedidos,
   SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente 
HAVING COUNT(*) > 1 
ORDER BY total_gastado DESC;




-- CONSULTA 4

WITH total_por_producto AS (
    SELECT
        ID_Producto,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY ID_Producto
)
SELECT
    ID_Producto,
    total_facturado,
    CASE 
        WHEN total_facturado > (SELECT AVG  (total_facturado) FROM total_por_producto) 
        THEN 'Por_Encima'
        
        ELSE 'Por_Debajo'

    END AS vs_promedio  
    FROM total_por_producto
    ORDER BY total_facturado DESC;

=========================================================================
--- HALLAZGOS ---
--1) El producto 1 concentra el 56% de la facturacion de marzo ($3600 de $6444).
--    Junto con el producto 3 ($1350) suman casi el 77% del total.
--2)El producto 2  es el que mas unidades vendidas tiene pero su precio unitario es bajo, por lo que su facturacion es baja.
--Los 5 clientes hicieron 2 pedidos cada uno (todos son recurrentes).
--El cliente 1 es el que mas gasto: $2640.
--Solo 2 productos (1 y 3) quedaron por encima del promedio de $1074.

==========================================================================