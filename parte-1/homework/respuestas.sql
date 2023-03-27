--Mostrar todos los productos dentro de la categoria electro junto con todos los detalles.
select * from product_master 
where categoria = 'Electro';

--Cuales son los producto producidos en China?
select * from product_master 
where origen = 'China';

--Mostrar todos los productos de Electro ordenados por nombre.
select * from product_master 
where categoria = 'Electro'
order by nombre;

--Cuales son las TV que se encuentran activas para la venta?
select * from product_master 
where subcategoria = 'TV' and is_active is true;

--Mostrar todas las tiendas de Argentina ordenadas por fecha de apertura de las mas antigua a la mas nueva.
select * from store_master 
where pais = 'Argentina'
order by fecha_apertura;

--Cuales fueron las ultimas 5 ordenes de ventas?
select * from order_line_sale 
order by fecha desc 
limit 5;

--Mostrar los primeros 10 registros de el conteo de trafico por Super store ordenados por fecha.
select * from super_store_count 
order by fecha asc
limit 10;

--Cuales son los producto de electro que no son Soporte de TV ni control remoto.
select * from product_master 
where categoria = 'Electro' and nombre not like  '%Soporte TV%' and nombre not like '%Control Remoto%';

--Mostrar todas las lineas de venta donde el monto sea mayor a $100.000 solo para transacciones en pesos.
select * from order_line_sale 
where venta > 100000 and moneda like '%ARS%';

--Mostrar todas las lineas de ventas de Octubre 2022.
select * from order_line_sale 
where fecha between '2022-10-01' and '2022-10-30';

--Mostrar todos los productos que tengan EAN.
select * from product_master 
where ean is not null;

--Mostrar todas las lineas de venta que que hayan sido vendidas entre 1 de Octubre de 2022 
--y 10 de Noviembre de 2022.
select * from order_line_sale 
where fecha between '2022-10-01' and '2022-11-10';
