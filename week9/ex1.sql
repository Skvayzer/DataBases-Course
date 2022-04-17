CREATE FUNCTION ex1(address_contains text, city_id_from int, city_id_to int)
RETURNS TABLE(
   address varchar(50)
)
LANGUAGE plpgsql
AS $$
DECLARE
 addresses text;
BEGIN
   return query select a.address
   from address as a
   where city_id between city_id_from and city_id_to AND a.address LIKE '%' || address_contains || '%';
END;
$$

--CREATE FUNCTION ex1(address_contains text, city_id_from int, city_id_to int)
--RETURNS text
--LANGUAGE plpgsql
--AS $$
--DECLARE
 --addresses text;
--BEGIN
   --select a.address
   --into addresses
   --from address as a
   --where city_id between city_id_from and city_id_to AND address LIKE '%' || address_contains || '%';
   --return addresses;
--END;
--$$


--select a.address
--into addresses
--from address as a
--where city_id between city_id_from and city_id_to AND address LIKE '%' || address_contains || '%';;
--return addresses;




--select * from address as a where city_id between 400 and 600 AND a.address LIKE '%' || '11' || '%';
