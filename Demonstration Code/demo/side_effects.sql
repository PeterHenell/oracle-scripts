CREATE OR REPLACE PACKAGE plch_pkg
IS
   c_number   CONSTANT NUMBER := 10;

   PROCEDURE set_favorite_color (color_in IN VARCHAR2);
END;
/

CREATE OR REPLACE PACKAGE BODY plch_pkg
IS
   g_favorite   VARCHAR2 (100);

   PROCEDURE set_favorite_color (color_in IN VARCHAR2)
   IS
   BEGIN
      g_favorite := color_in;
   END;
END;
/