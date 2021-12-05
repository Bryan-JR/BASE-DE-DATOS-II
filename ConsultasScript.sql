-- 1 --  
SELECT nombre_cliente, limite_credito FROM cliente NATURAL JOIN 
(SELECT max(limite_credito) maximo FROM cliente)al1 WHERE limite_credito=maximo;
-- 2 --
SELECT nombre, precio_venta FROM producto NATURAL JOIN 
(SELECT max(precio_venta) maximo FROM producto)al1 WHERE precio_venta=maximo;
-- 3 --
SELECT nombre FROM producto NATURAL JOIN (SELECT codigo_producto, sum(cantidad) suma FROM detalle_pedido group by codigo_producto
having sum(cantidad) = (SELECT max(suma) FROM (SELECT sum(cantidad) suma FROM detalle_pedido group by codigo_producto)al1))al2;
-- 4 --
SELECT nombre_cliente, limite_credito, total FROM cliente NATURAL JOIN pago WHERE limite_credito>total;
-- 5 --
SELECT codigo_producto, nombre, cantidad_en_stock FROM producto NATURAL JOIN (SELECT max(cantidad_en_stock) cantidad_en_stock FROM producto)al1;
-- 6 --
SELECT codigo_producto, nombre, cantidad_en_stock FROM producto NATURAL JOIN (SELECT min(cantidad_en_stock) cantidad_en_stock FROM producto)al1;
-- 7 --
SELECT nombre, apellido1, email FROM empleado NATURAL JOIN (SELECT codigo_empleado AS jefe FROM empleado WHERE nombre='Alberto' and apellido1='Soria')al1 WHERE codigo_jefe=jefe;
-- 8 --
SELECT nombre_cliente from cliente where limite_credito = ANY (SELECT max(limite_credito) FROM cliente);
-- 9 --
SELECT nombre from producto WHERE precio_venta = ALL (SELECT max(precio_venta) FROM producto);
-- 10 --
SELECT codigo_producto, nombre FROM producto WHERE cantidad_en_stock = ANY (SELECT min(cantidad_en_stock) as cantidad_en_stock FROM producto);
-- 11 --
SELECT nombre, apellido1, puesto FROM empleado WHERE codigo_empleado NOT IN (SELECT codigo_empleado_rep_ventas FROM cliente GROUP BY codigo_empleado_rep_ventas);
-- 12 --
SELECT nombre_cliente FROM  cliente WHERE codigo_cliente NOT IN (SELECT codigo_cliente FROM pago GROUP BY codigo_cliente);
-- 13 --
SELECT nombre_cliente FROM  cliente WHERE codigo_cliente IN (SELECT codigo_cliente FROM pago GROUP BY codigo_cliente); 
-- 14 --
SELECT nombre FROM producto WHERE codigo_producto NOT IN (SELECT codigo_producto FROM detalle_pedido GROUP BY codigo_producto);
-- 15 --
SELECT nombre, apellido1, apellido2, puesto, telefono FROM empleado INNER JOIN oficina 
ON empleado.codigo_oficina=oficina.codigo_oficina WHERE codigo_empleado NOT IN (SELECT codigo_empleado_rep_ventas FROM cliente GROUP BY codigo_empleado_rep_ventas);
-- 16 --
SELECT codigo_oficina FROM oficina WHERE codigo_oficina NOT IN (SELECT codigo_oficina FROM empleado WHERE codigo_empleado IN (select codigo_empleado_rep_ventas FROM cliente WHERE codigo_cliente IN (SELECT codigo_cliente FROM pedido WHERE codigo_pedido IN 
(SELECT codigo_pedido FROM detalle_pedido WHERE codigo_producto IN (SELECT codigo_producto FROM PRODUCTO WHERE gama='Frutales'))))); 
-- 17 --
SELECT nombre_cliente FROM cliente WHERE codigo_cliente IN (SELECT codigo_cliente FROM pedido WHERE codigo_cliente NOT IN (SELECT codigo_cliente FROM pago));
-- 18 --
SELECT cliente.nombre_cliente FROM cliente WHERE NOT EXISTS (SELECT pago.codigo_cliente FROM pago WHERE pago.codigo_cliente=cliente.codigo_cliente);
-- 19 --
SELECT cliente.nombre_cliente FROM cliente WHERE EXISTS (SELECT pago.codigo_cliente FROM pago WHERE pago.codigo_cliente=cliente.codigo_cliente); 
-- 20 --
SELECT producto.nombre FROM producto WHERE NOT EXISTS (SELECT detalle_pedido.codigo_producto FROM detalle_pedido WHERE detalle_pedido.codigo_producto=producto.codigo_producto);
-- 21 --
SELECT producto.nombre FROM producto WHERE EXISTS (SELECT detalle_pedido.codigo_producto FROM detalle_pedido WHERE detalle_pedido.codigo_producto=producto.codigo_producto);
-- 22 --
SELECT nombre_cliente, (SELECT count(codigo_cliente) FROM pedido WHERE cliente.codigo_cliente=pedido.codigo_cliente) "Pedidos hechos" FROM  cliente;
-- 23 --
SELECT nombre_cliente, (SELECT sum(total) FROM pago WHERE cliente.codigo_cliente=pago.codigo_cliente) "Total pagado" FROM cliente;
-- 24 --
SELECT nombre_cliente FROM cliente NATURAL JOIN (SELECT codigo_cliente FROM PEDIDO WHERE extract(YEAR FROM fecha_pedido) = 2008)alias1 GROUP BY nombre_cliente ORDER BY nombre_cliente;
-- 25 --
SELECT nombre_cliente, 
(SELECT nombre FROM empleado WHERE empleado.codigo_empleado=cliente.codigo_empleado_rep_ventas) "Nombre representante",
(SELECT apellido1 FROM empleado WHERE empleado.codigo_empleado=cliente.codigo_empleado_rep_ventas) "Apellido representante",
(SELECT telefono FROM oficina NATURAL JOIN empleado WHERE codigo_empleado=cliente.codigo_empleado_rep_ventas) Telefono
FROM cliente WHERE cliente.codigo_cliente NOT IN (SELECT pago.codigo_cliente FROM pago);
-- 26 --
SELECT nombre_cliente, 
(SELECT nombre FROM empleado WHERE empleado.codigo_empleado=cliente.codigo_empleado_rep_ventas) "Nombre representante",
(SELECT apellido1 FROM empleado WHERE empleado.codigo_empleado=cliente.codigo_empleado_rep_ventas) "Apellido representante",
(SELECT ciudad FROM oficina NATURAL JOIN empleado WHERE codigo_empleado=cliente.codigo_empleado_rep_ventas) Telefono
FROM cliente;
-- 27 --
SELECT nombre, apellido1, apellido2, puesto, 
(SELECT telefono FROM oficina WHERE empleado.codigo_oficina=oficina.codigo_oficina) Telefono 
FROM empleado WHERE empleado.codigo_empleado NOT IN (SELECT codigo_empleado_rep_ventas FROM cliente);
-- 28 --
SELECT ciudad, (SELECT count(codigo_oficina) FROM empleado WHERE empleado.codigo_oficina=oficina.codigo_oficina) "Cantidad empleados" FROM oficina;