CREATE TABLE  addresses
   (id  NUMBER  NOT NULL PRIMARY KEY
   ,street VARCHAR2(200)
   ,city VARHAR2(200)
   ,state CHAR(2)
   ,ZIP VARCHAR2(20))
/

CREATE VIEW termination_notices
    (customer_id  NUMBER 
    ,termination_reason VARCHAR2(10)
    ,customer_addr_id NUMBER
    ,employer_addr_id NUMBER)
AS
   SELECT ...
/

CREATE OR REPLACE PACKAGE address_info
IS
   /* these are the functions we will call in SQL */
   --
   FUNCTION streetaddr(addr_id_IN IN address.id%TYPE)
      RETURN address.street%TYPE;
   PRAGMA RESTRICT_REFERENCES (streetaddr,WNDS);
   --
   FUNCTION cityaddr(addr_id_IN IN address.id%TYPE)
      RETURN address.city%TYPE;
   PRAGMA RESTRICT_REFERENCES (cityaddr,WNDS);
   --
   FUNCTION stateaddr(addr_id_IN IN address.id%TYPE)
      RETURN address.state%TYPE;
   PRAGMA RESTRICT_REFERENCES (stateaddr,WNDS);
   --
   FUNCTION zipaddr(addr_id_IN IN address.id%TYPE)
      RETURN address.ZIP%TYPE;
   PRAGMA RESTRICT_REFERENCES (zipaddr,WNDS);
   --
END address_info;
/
CREATE OR REPLACE PACKAGE BODY address_info
IS
   /* curr_addr_rec is maintained by load_addr procedure */
   curr_addr_rec   address%ROWTYPE;
   --
   /* procedure to load curr_addr_rec by id            */
   PROCEDURE load_addr(addr_id_IN IN address.id%TYPE)
   IS
   null_addr_rec   address%ROWTYPE; 
   BEGIN
      IF curr_addr_rec.id != addr_id_IN OR curr_addr_rec.id IS NULL
      THEN
         SELECT * 
           INTO curr_addr_rec
           FROM address
          WHERE id = addr_id_IN;
      END IF;
   EXCEPTION 
      WHEN NO_DATA_FOUND THEN curr_addr_rec := null_addr_rec;
   END load_addr;
   --
   /* functions which return components of curr_addr_rec */
   FUNCTION streetaddr(addr_id_IN IN address.id%TYPE)
      RETURN address.street%TYPE
   IS
   BEGIN
      load_addr(addr_id_IN);
      RETURN curr_addr_rec.street;
   END streetaddr;
   --
   FUNCTION cityaddr(addr_id_IN IN address.id%TYPE)
      RETURN address.city%TYPE
   IS
   BEGIN
      load_addr(addr_id_IN);
      RETURN curr_addr_rec.city;
   END cityaddr;
   --
   FUNCTION stateaddr(addr_id_IN IN address.id%TYPE)
      RETURN address.state%TYPE
   IS
   BEGIN
      load_addr(addr_id_IN);
      RETURN curr_addr_rec.state;
   END stateaddr;
   --
   FUNCTION zipaddr(addr_id_IN IN address.id%TYPE)
      RETURN address.ZIP%TYPE
   IS
   BEGIN
      load_addr(addr_id_IN);
      RETURN curr_addr_rec.ZIP;
   END zipaddr;
   --
END address_info;
/

CREATE VIEW termination_notice_mailing
IS
SELECT  customer_id
,DECODE(customer_addr_id,NULL,
                 DECODE(employer_addr_id,NULL,TO_CHAR(NULL)
                           ,address_info.streetaddr(employer_addr_id))
               ,address_info.streetaddr(customer_addr_id) )
        street
,DECODE(customer_addr_id,NULL,
                 DECODE(employer_addr_id,NULL,TO_CHAR(NULL)
                            ,address_info.cityaddr(employer_addr_id))
               ,address_info.cityaddr(customer_addr_id) )
        city
,DECODE(customer_addr_id,NULL,
                 DECODE(employer_addr_id,NULL,TO_CHAR(NULL)
                            ,address_info.stateaddr(employer_addr_id))
               ,address_info.stateaddr(customer_addr_id) )
        state
,DECODE(customer_addr_id,NULL,
                 DECODE(employer_addr_id,NULL,TO_CHAR(NULL)
                            ,address_info.zipaddr(employer_addr_id))
               ,address_info.zipaddr(customer_addr_id) )
        ZIP
 FROM termination_notices;