@str2list.pkg
@filepath1.pkg

BEGIN
   str2list.trc;
   fileio.setpath ('a;b;c;d;efg;;');
   str2list.showlist ('fileio', 'dirs');
END;
/

@filepath2.pkg

BEGIN
   str2list.trc;
   fileio.setpath ('a;b;c;d;efg;;');
   str2list.showlist ('fileio', 'first', 'next', 'nthval', 'pl');
END;
/
   
