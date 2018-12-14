create or replace procedure who_called_me( owner      out varchar2,
                         name       out varchar2,
                         lineno     out number,
                         caller_t   out varchar2 )
as
    call_stack  varchar2(4096) default dbms_utility.format_call_stack;
    n           number;
    found_stack BOOLEAN default FALSE;
    line        varchar2(255);
    cnt         number := 0;
begin
--
    loop
        n := instr( call_stack, chr(10) );
        exit when ( cnt = 3 or n is NULL or n = 0 );
--
        line := substr( call_stack, 1, n-1 );
        call_stack := substr( call_stack, n+1 );
--
        if ( NOT found_stack ) then
            if ( line like '%handle%number%name%' ) then
                found_stack := TRUE;
            end if;
        else
            cnt := cnt + 1;
            -- cnt = 1 is ME
            -- cnt = 2 is MY Caller
            -- cnt = 3 is Their Caller
            if ( cnt = 3 ) then
                lineno := to_number(substr( line, 13, 6 ));
                line   := substr( line, 21 );
                if ( line like 'pr%' ) then
                    n := length( 'procedure ' );
                elsif ( line like 'fun%' ) then
                    n := length( 'function ' );
                elsif ( line like 'package body%' ) then
                    n := length( 'package body ' );
                elsif ( line like 'pack%' ) then
                    n := length( 'package ' );
                else
                    n := length( 'anonymous block ' );
                end if;
                caller_t := ltrim(rtrim(upper(substr( line, 1, n-1 ))));
                line := substr( line, n );
                n := instr( line, '.' );
                owner := ltrim(rtrim(substr( line, 1, n-1 )));
                name  := ltrim(rtrim(substr( line, n+1 )));
            end if;
        end if;
    end loop;
end;
/


create or replace function who_am_i return varchar2 
is
	l_owner		varchar2(30);
    l_name      varchar2(30);
    l_lineno    number;
    l_type      varchar2(30);
begin
   who_called_me( l_owner, l_name, l_lineno, l_type );
   return l_owner || '.' || l_name;
end;
/
