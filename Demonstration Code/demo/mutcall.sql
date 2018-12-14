create or replace package pack1
is
   procedure a;
end;
/
create or replace package pack2
is
   procedure b;
end;
/
create or replace package body pack1
is
   procedure a is begin pack2.b; end;
end;
/
create or replace package body pack2
is
   procedure b is begin pack1.a; end;
end;
/
