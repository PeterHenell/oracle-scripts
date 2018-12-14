create or replace view pmem as
 select b.value
 from   sys.v_$session a, sys.v_$sesstat b, sys.v_$statname c
 where	c.name = 'session pga memory'
 and    a.audsid = userenv ('sessionid')
 and    b.sid = a.sid
 and    c.statistic# = b.statistic# ;

declare
 type taint is table of pls_integer index by binary_integer ;
 arr 	taint ;
 idx  	pls_integer ;
 l_mul	pls_integer ;
 l_basemem	pls_integer ;
 --
 procedure show_stat (iwhere in varchar2) as
 --
 cursor c_stat is
 select value
 from   pmem ;
 --
 pga_mem			pls_integer ;
 --
 begin
  open c_stat ;
  fetch c_stat into pga_mem ;
  close c_stat ;
  if l_basemem is null then
   l_basemem := pga_mem ;
  end if ;
  dbms_output.put_line (iwhere || ' : ' || pga_mem || ' (+' || (pga_mem - l_basemem) || ' bytes)') ;
 end ;
begin
 dbms_session.free_unused_user_memory ;
 show_stat ('Program start') ;
 for i in 0 .. 6 loop
  l_mul := 10 ** i ;
  for j in 1 .. 1000 loop
   arr (j * l_mul) := 10 ;
  end loop ;
  show_stat ('Every ' || l_mul) ;
  arr.delete ;
  dbms_session.free_unused_user_memory ;
 end loop ;
end ;
/
