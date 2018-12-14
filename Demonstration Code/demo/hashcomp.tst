BEGIN
    p.l (dbms_utility.get_hash_value ('steven', 2, 10000));
    p.l (dbms_utility.get_hash_value ('Steven', 2, 10000));
    p.l (dbms_utility.get_hash_value ('steven', 2, 4));
    p.l (dbms_utility.get_hash_value ('Steven', 2, 4));
    p.l (dbms_utility.get_hash_value ('Veva', 2, 4));
    p.l (dbms_utility.get_hash_value ('veva', 2, 4));
    
    p.l (hash.val ('steven'));
    p.l (hash.val ('Steven'));
    p.l (hash.val ('Veva')); 
    p.l (hash.val ('veva')); 

END;
/

