begin
  p.l (plvsubst.string('this %s is', 'abc'));
  p.l (plvsubst.string('this %s is %s %s%s %s    really %s', 
  'abc,def,123,yuy,ll,mm,gg,hh'));
  p.l (plvsubst.string('this XXX is XXX XXXXXX XXX    really XXX', 
  'abc$def$123$yuy','$', 'XXX'));
end;
/  