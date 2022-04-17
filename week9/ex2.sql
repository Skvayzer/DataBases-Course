CREATE FUNCTION retrievecustomers(starting int, ending int)
RETURNS SETOF customer
LANGUAGE plpgsql
AS $$

BEGIN
   return query select *
   from customer as a
   where address_id between starting and ending
   order by address_id;
END;
$$

select retrievecustomers(10, 40);

