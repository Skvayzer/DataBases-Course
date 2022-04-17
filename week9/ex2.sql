CREATE FUNCTION retrievecustomers(starting int, ending int)
RETURNS SETOF customer
LANGUAGE plpgsql
AS $$

BEGIN
   if starting < 0 then
        raise exception 'The start index cannot be negative.';
   end if;
   if ending > 600 then
        raise exception 'The end index cannot be larger than 600.';
   end if;
   if starting > ending then
        raise exception 'The start index cannot be larger than the end index.';
   end if;
   return query select *
   from customer as a
   where address_id between starting and ending
   order by address_id;
END;
$$

select retrievecustomers(10, 40);

