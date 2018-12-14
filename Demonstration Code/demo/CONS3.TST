declare
   c plg.plgcons.cons_tabtype;
   cc plg.plgcons.conscol_tabtype;
	r plg.plgcons.conscol_rectype;
	uc plg.plgcons.ident_tabtype;
   k integer;
begin
   plg.plgcons.fortab ('party_relationship', c, cc, uc,
	   constype=>'C', consstatus=>'ENABLED', colsuffix=>'_in');
   if c.count > 0
	then
   for i in 1 .. c.count
	loop
	   p.l(c(i).constraint_name);
	   p.l(c(i).column_count);
	   p.l(c(i).starting_row);
		for j in 1 .. c(i).column_count
		loop
		   r := plg.plgcons.nthcol (cc, i, j);
			p.l ('*** ' || r.column_name);
		end loop;
	end loop;
	else
		p.l ('no constraints');
   end if;
end;
/

