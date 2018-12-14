BEGIN
   p.l (ltrim ('abcabcbadef', 'abc'));
   p.l (lstrip3 ('abcabcbadef', 'abc', 2));
END;
/   
