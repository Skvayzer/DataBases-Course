do
-- variable declaration section
begin
set transaction ISOLATION LEVEL [configuration];
-- some code
commit;
exception
when [exception_type] then
-- code to be executed when the exception occurs
when [exception_type] then
-- code to be executed when the exception occurs
end$$;
