--CLASE 1

--1) Mostrar todos los productos dentro de la categoria electro junto con todos los detalles.
select * from product_master 
where categoria = 'Electro';

--2) Cuales son los producto producidos en China?
select * from product_master 
where origen = 'China';

--3) Mostrar todos los productos de Electro ordenados por nombre.
select * from product_master 
where categoria = 'Electro'
order by nombre;

--4) Cuales son las TV que se encuentran activas para la venta?
select * from product_master 
where subcategoria = 'TV' and is_active is true;

--5) Mostrar todas las tiendas de Argentina ordenadas por fecha de apertura de las mas antigua a la mas nueva.
select * from store_master 
where pais = 'Argentina'
order by fecha_apertura;

--6) Cuales fueron las ultimas 5 ordenes de ventas?
select * from order_line_sale 
order by fecha desc 
limit 5;

--7) Mostrar los primeros 10 registros de el conteo de trafico por Super store ordenados por fecha.
select * from super_store_count 
order by fecha asc
limit 10;

--8) Cuales son los producto de electro que no son Soporte de TV ni control remoto.
select * from product_master 
where categoria = 'Electro' and nombre not like  '%Soporte TV%' and nombre not like '%Control Remoto%';

--9) Mostrar todas las lineas de venta donde el monto sea mayor a $100.000 solo para transacciones en pesos.
select * from order_line_sale 
where venta > 100000 and moneda like '%ARS%';

--10) Mostrar todas las lineas de ventas de Octubre 2022.
select * from order_line_sale 
where fecha between '2022-10-01' and '2022-10-30';

--11) Mostrar todos los productos que tengan EAN.
select * from product_master 
where ean is not null;

--12) Mostrar todas las lineas de venta que que hayan sido vendidas entre 1 de Octubre de 2022 y 10 de Noviembre de 2022.
select * from order_line_sale 
where fecha between '2022-10-01' and '2022-11-10';

--CLASE 2
--1) Cuales son los paises donde la empresa tiene tiendas?
select distinct pais from store_master;

--2) Cuantos productos por subcategoria tiene disponible para la venta?
select count (distinct subcategoria) from product_master;

--3) Cuales son las ordenes de venta de Argentina de mayor a $100.000?
select orden from order_line_sale 
where venta > 100000;

--4) Obtener los descuentos otorgados durante Noviembre de 2022 en cada una de las monedas?
select descuento, moneda from order_line_sale  
where fecha between '2022-11-01' and '2022-11-30';

--5) Obtener los impuestos pagados en Europa durante el 2022.
select 
	sum(impuestos) as total_impuestos_eur
from order_line_sale ols
where moneda = 'EUR'

--6) En cuantas ordenes se utilizaron creditos?
select count(orden) from order_line_sale
where creditos is not null; 

--7) Cual es el % de descuentos otorgados (sobre las ventas) por tienda?
select 
	tienda, 
	avg (descuento)  as descuento 
from order_line_sale 
group by tienda; 

--8) Cual es el inventario promedio por dia que tiene cada tienda?
select 
	tienda,
	avg("final") as inventario_promedio
from inventory 
group by tienda;

--9) Obtener las ventas netas y el porcentaje de descuento otorgado por producto en Argentina.
select 
	producto, 
	sum(venta) as ventas_netas, 
	avg(descuento) as descuento_otorgado 
from order_line_sale ols 
where moneda = 'ARS'
group by producto; 

/*10) Las tablas "market_count" y "super_store_count" representan dos sistemas distintos que usa empresa 
 para contar la cantidad de gente que ingresa a tienda, uno para las tiendas de Latinoamerica y otro 
 para Europa. Obtener en una unica tabla, las entradas a tienda de ambos sistemas.*/
select tienda, (cast(cast(fecha as text) as date)), conteo from market_count 
union all
select tienda, cast (fecha as date), conteo from super_store_count; 

--11) Cuales son los productos disponibles para la venta (activos) de la marca Phillips?
select * from product_master 
where is_active is true 
and nombre like '%Phillips%'

--12) Obtener el monto vendido por tienda y moneda y ordenarlo de mayor a menor por valor nominal.
select 
	tienda, 
	sum(venta) as monto_vendido 
from order_line_sale  
group by tienda 
order by sum(venta) desc;

/*13) Cual es el precio promedio de venta de cada producto en las distintas monedas? 
Recorda que los valores de venta, impuesto, descuentos y creditos es por el total de la linea.*/

select 
	producto,
	moneda, 
	avg(venta) as promedio_venta 
from order_line_sale  
group by producto, moneda  

--14) Cual es la tasa de impuestos que se pago por cada orden de venta?
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

--8) Mostrar la tabla order_line_sales agregando una columna que represente el valor de venta bruta en cada linea convertido a dolares usando
--la tabla de tipo de cambio.
with venta_bruta_usd as (
select 
	producto, 
	extract(month from ols.fecha) as mes,
	sum(round (ols.venta/(case
	when moneda = 'ARS' then mafr.cotizacion_usd_peso
	when moneda = 'URU' then mafr.cotizacion_usd_uru
	when moneda = 'EUR' then mafr.cotizacion_usd_peso
	else 0 end),1)) as venta_bruta_usd
from stg.order_line_sale ols
left join stg.monthly_average_fx_rate mafr 
	on extract(month from mafr.mes) = extract(month from ols.fecha) 
	and extract(year from mafr.mes) = extract(year from ols.fecha) 
	group by 1,2 
)

select 
	*,
	venta_bruta_usd
from stg.order_line_sale ols 
left join venta_bruta_usd vbu
on ols.producto = vbu.producto

--9)Calcular cantidad de ventas totales de la empresa en dolares.
select 	
	ols.moneda,
	sum(ols.venta) as ventas_totales
from order_line_sale ols 
left join monthly_average_fx_rate mafr 
on ols.fecha = mafr.mes 
group by ols.moneda

--10)Mostrar en la tabla de ventas el margen de venta por cada linea. Siendo margen = (venta - promociones) - costo expresado en dolares.

--11)Calcular la cantidad de items distintos de cada subsubcategoria que se llevan por numero de orden.
select 
	ols.orden,
	count(distinct pm.codigo_producto) as cantidad_items
from product_master pm 
left join order_line_sale ols 
on pm.codigo_producto = ols.producto 
group by ols.orden

--Clase 4
/*1- Crear un backup de la tabla product_master. Utilizar un esquema llamada "bkp" y agregar un prefijo al nombre de la tabla 
 con la fecha del backup en forma de numero entero.*/
create schema bkp;

select *, current_date as backup_date 
into bkp.product_master_bkp_19042023
from stg.product_master pm;

/*2- Hacer un update a la nueva tabla (creada en el punto anterior) de product_master agregando la leyenda "N/A" para los 
 valores null de material y color. Pueden utilizarse dos sentencias.*/
update bkp.product_master_bkp_19042023 set material = 'N/A' , color  = 'N/A' 
where material = '' or color = '' 

/*3- Hacer un update a la tabla del punto anterior, actualizando la columa "is_active", desactivando todos los productos 
 en la subsubcategoria "Control Remoto". */
update bkp.product_master_bkp set is_active = false  
where subsubcategoria = 'Control remoto' 

select * from bkp.product_master_bkp
/*4- Agregar una nueva columna a la tabla anterior llamada "is_local" indicando los productos producidos en Argentina y 
 fuera de Argentina. */
alter table bkp.product_master_bkp add is_local boolean; 

update bkp.product_master_bkp set is_local = true  
where origen = 'Argentina';

update bkp.product_master_bkp set is_local = false  
where origen != 'Argentina';
/*5- Agregar una nueva columna a la tabla de ventas llamada "line_key" que resulte ser la concatenacion de el numero de
orden y el codigo de producto.*/
alter table order_line_sale add line_key varchar(20);
update order_line_sale set line_key = concat(orden, producto);  

--6- Eliminar todos los valores de la tabla "order_line_sale" para el POS 1.
update order_line_sale set pos = null 
where pos = 1; 

/*7) Crear una tabla llamada "employees" (por el momento vacia) que tenga un id (creado de forma incremental), nombre,
 apellido, fecha de entrada, fecha salida, telefono, pais, provincia, codigo_tienda, posicion. 
 Decidir cual es el tipo de dato mas acorde.*/
create table employees
(
	id SERIAL PRIMARY KEY,
	nombre varchar(20),
	apellido varchar(20),
	fecha_de_entrada date,
	fecha_de_salida date,
	telefono varchar(20),
	pais varchar(20),
	provincia varchar(20),
	codigo_tienda int,
	posicion varchar(20)
	
)
--8- Insertar nuevos valores a la tabla "employees" para los siguientes 4 empleados:
	--Juan Perez, 2022-01-01, telefono +541113869867, Argentina, Santa Fe, tienda 2, Vendedor.
	--Catalina Garcia, 2022-03-01, Argentina, Buenos Aires, tienda 2, Representante Comercial
	--Ana Valdez, desde 2020-02-21 hasta 2022-03-01, España, Madrid, tienda 8, Jefe Logistica
	--Fernando Moralez, 2022-04-04, España, Valencia, tienda 9, Vendedor.
insert into stg.employees values (1, 'Juan', 'Perez', '01-01-2022', null, +541113869867, 'Argentina', 'Santa Fe', 2, 'Vendedor' );
insert into stg.employees values (2, 'Catalina', 'Garcia', '2022-03-01', null, null, 'Argentina', 'Buenos Aires', 2, 'Representante Comercial');
insert into stg.employees values (3, 'Ana', 'Valdez', '2020-02-21 ', '2022-03-01', null, 'España', 'Madrid', 8, 'Jefe Logistica');
insert into stg.employees values (4, 'Fernando', 'Moralez', '2022-04-04', null, null, 'España', 'Valencia', 9, 'Vendedor');

/* 9- Crear un backup de la tabla "cost" agregandole una columna que se llame "last_updated_ts" que sea el momento exacto 
en el cual estemos realizando el backup en formato datetime. */
select *, current_date as last_updated_ts
into bkp.cost_19042023 
from stg."cost" c;

--10 -El cambio en la tabla "order_line_sale" en el punto 6 fue un error y debemos volver la tabla a su estado original, como lo harias?
update stg.order_line_sale set pos = 1 
where pos isnull; 
