create or replace package val
is
   function val return boolean;
   pragma restrict_references (val, wnds);
end;
/
create or replace package body val
is
   function val return boolean is begin return true; end;
begin
   null;
end;
/
