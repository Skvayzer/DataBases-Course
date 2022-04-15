CREATE FUNCTION function(address_contains text, city_id_from int, city_id_to int)
RETURNS text
LANGUAGE plpgsql
AS $address$
DECLARE
 address text;
BEGIN
   select count(*)
   into address
   from Dvd
   where city_id between city_id_from and city_id_to AND address LIKE '%' || address_contains || '%';;
   return Car_count;
END;
$$
