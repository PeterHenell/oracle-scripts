BEGIN
   summer_reading.set_reload_interval (5);
END;
/

DECLARE
   rec   books%ROWTYPE;
BEGIN
   rec := summer_reading.onebook ('0-596-00180-0');
   p.l (rec.title);
END;
/
