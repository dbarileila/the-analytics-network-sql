--CLASE 1

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

--CLASE 2
--Cuales son los paises donde la empresa tiene tiendas?
select distinct pais from store_master;

--Cuantos productos por subcategoria tiene disponible para la venta?
select count (distinct subcategoria) from product_master;

--Cuales son las ordenes de venta de Argentina de mayor a $100.000?
select orden from order_line_sale 
where venta > 100000;

--Obtener los descuentos otorgados durante Noviembre de 2022 en cada una de las monedas?
select descuento, moneda from order_line_sale  
where fecha between '2022-11-01' and '2022-11-30';

--Obtener los impuestos pagados en Europa durante el 2022.
select 
	sum(impuestos) as total_impuestos_eur
from order_line_sale ols
where moneda = 'EUR'

--En cuantas ordenes se utilizaron creditos?
select count(orden) from order_line_sale
where creditos is not null; 

--Cual es el % de descuentos otorgados (sobre las ventas) por tienda?
select 
	tienda, 
	avg (descuento)  as descuento 
from order_line_sale 
group by tienda; 

--Cual es el inventario promedio por dia que tiene cada tienda?
select 
	tienda,
	avg("final") as inventario_promedio
from inventory 
group by tienda;

--Obtener las ventas netas y el porcentaje de descuento otorgado por producto en Argentina.
select 
	producto, 
	sum(venta) as ventas_netas, 
	avg(descuento) as descuento_otorgado 
from order_line_sale ols 
where moneda = 'ARS'
group by producto; 

/*Las tablas "market_count" y "super_store_count" representan dos sistemas distintos que usa empresa 
 para contar la cantidad de gente que ingresa a tienda, uno para las tiendas de Latinoamerica y otro 
 para Europa. Obtener en una unica tabla, las entradas a tienda de ambos sistemas.*/
select tienda, (cast(cast(fecha as text) as date)), conteo from market_count 
union all
select tienda, cast (fecha as date), conteo from super_store_count; 

--Cuales son los productos disponibles para la venta (activos) de la marca Phillips?
select * from product_master 
where is_active is true 
and nombre like '%Phillips%'

--Obtener el monto vendido por tienda y moneda y ordenarlo de mayor a menor por valor nominal.
select 
	tienda, 
	sum(venta) as monto_vendido 
from order_line_sale  
group by tienda 
order by sum(venta) desc;

/*Cual es el precio promedio de venta de cada producto en las distintas monedas? 
Recorda que los valores de venta, impuesto, descuentos y creditos es por el total de la linea.*/

select 
	producto,
	moneda, 
	avg(venta) as promedio_venta 
from order_line_sale  
group by producto, moneda  

--Cual es la tasa de impuestos que se pago por cada orden de venta?
select * from order_line_sale ols 
select 
	orden,
	((impuestos/venta) * 100) as tasa_de_impuestos
from order_line_sale 
group by orden, (impuestos/venta);

--CLASE 3
/*1)Mostrar nombre y codigo de producto, categoria y color para todos los productos de la marca Philips y 
  Samsung, mostrando la leyenda "Unknown" cuando no hay un color disponible */

select nombre, codigo_producto, categoria, coalesce (nullif(color, ''), 'Unknown') as color
from product_master pm 
where nombre ilike '%PHILIPS%' 
or nombre ilike '%SAMSUNG%'

--2)Calcular las ventas brutas y los impuestos pagados por pais y provincia en la moneda correspondiente.
select 
	sm.pais,
	sm.provincia, 
	ols.moneda,
	sum(venta) as ventas_brutas,
	sum (impuestos) as impuestos 
from order_line_sale ols 
left join store_master sm 
on ols.tienda = sm.codigo_tienda 
group by sm.pais, sm.provincia, ols.moneda 

--3)Calcular las ventas totales por subcategoria de producto para cada moneda ordenados por subcategoria y moneda.
select 
	pm.subcategoria, 
	ols.moneda,
	sum(venta) as ventas_totales
from order_line_sale ols
left join product_master pm 
on ols.producto = pm.codigo_producto 
group by pm.subcategoria, ols.moneda

/*4)Calcular las unidades vendidas por subcategoria de producto y la concatenacion de pais, provincia;
 usar guion como separador y usarla para ordernar el resultado.*/
select 
	pm.subcategoria, 
	count (distinct producto) as unidades_vendidas,
	sm.pais,
	sm.provincia 
from order_line_sale ols 
left join product_master pm 
on ols.producto = pm.codigo_producto 
left join store_master sm 
on ols.tienda = sm.codigo_tienda 
group by pm.subcategoria, sm.pais, sm.provincia 

/*5) Mostrar una vista donde sea vea el nombre de tienda y la cantidad de entradas de personas que hubo desde 
la fecha de apertura para el sistema "super_store".*/
select 
	sm.nombre,
	count(ssc.conteo) as cantidad_entradas_personas
from store_master sm 
left join super_store_count ssc 
on sm.codigo_tienda = ssc.tienda 
group by sm.nombre 

/*6) Cual es el nivel de inventario promedio en cada mes a nivel de codigo de producto y tienda;
  mostrar el resultado con el nombre de la tienda.*/
select 
	sm.nombre, 
	i.sku, 
	avg("final") as promedio_inventario
from inventory i 
left join store_master sm 
on i.tienda = sm.codigo_tienda 
group by sm.nombre, i.sku 

/*7)Calcular la cantidad de unidades vendidas por material. Para los productos que no tengan material usar
 'Unknown', homogeneizar los textos si es necesario.*/
select 
	pm.codigo_producto,
	coalesce (nullif (pm.material, ''), 'Unknown'),
	count(ols.producto) as unidades_vendidas
from order_line_sale ols
left join product_master pm 
on ols.producto = pm.codigo_producto 
where material notnull 
group by pm.codigo_producto, pm.material

--9)Calcular cantidad de ventas totales de la empresa en dolares.
select 	
	ols.moneda,
	sum(ols.venta) as ventas_totales
from order_line_sale ols 
left join monthly_average_fx_rate mafr 
on ols.fecha = mafr.mes 
group by ols.moneda

--11)Calcular la cantidad de items distintos de cada subsubcategoria que se llevan por numero de orden.
select 
	ols.orden,
	count(distinct pm.codigo_producto) as cantidad_items
from product_master pm 
left join order_line_sale ols 
on pm.codigo_producto = ols.producto 
group by ols.orden
