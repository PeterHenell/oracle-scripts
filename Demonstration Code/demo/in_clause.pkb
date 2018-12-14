CREATE OR REPLACE PACKAGE BODY in_clause
/*
| Demonstrate various ways to implement a dynamic IN clause
|
|    Author: Steven Feuerstein, steven@stevenfeuerstein.com
|    Copyright 2005
|
| Run the in_clause_setup.sql script to set up the
| necessary database objects.
*/
IS
   FUNCTION nds_list ( list_in IN VARCHAR2 )
      RETURN sys_refcursor
   IS
      retval sys_refcursor;
   BEGIN
      OPEN retval FOR    'SELECT * FROM in_clause_tab WHERE id IN ('
                      || list_in
                      || ')';

      RETURN retval;
   END nds_list;

   FUNCTION nds_bulk_list ( list_in IN VARCHAR2 )
      RETURN in_clause_tab_nt
   IS
      retval in_clause_tab_nt;
   BEGIN
      EXECUTE IMMEDIATE    'SELECT in_clause_ot (id, title, description) FROM in_clause_tab WHERE id IN ('
                        || list_in
                        || ')'
      BULK COLLECT INTO retval;

      RETURN retval;
   END nds_bulk_list;

   FUNCTION nds_bulk_list2 ( list_in IN VARCHAR2 )
      RETURN sys_refcursor
   IS
      retval sys_refcursor;
   BEGIN
      OPEN retval FOR
         SELECT ic.ID, ic.title, ic.description
           FROM TABLE ( nds_bulk_list ( list_in )) ic;

      RETURN retval;
   END nds_bulk_list2;

   FUNCTION dbms_sql_list ( list_in IN VARCHAR2 )
      RETURN in_clause_tab_nt
   IS
      l_query VARCHAR2 ( 32767 )
                               := 'SELECT * FROM in_clause_tab WHERE id IN (';
      l_cur PLS_INTEGER := DBMS_SQL.open_cursor;
      l_feedback PLS_INTEGER;
      l_ids pky_nt := pky_nt ( );
      l_row PLS_INTEGER;
      l_onerow in_clause_tab%ROWTYPE;
      retval in_clause_tab_nt := in_clause_tab_nt ( );

      PROCEDURE string_to_list (
         str                 IN       VARCHAR2
       , list_inout          IN OUT   pky_nt
       , delim               IN       VARCHAR2 DEFAULT ','
       , append_to_list_in   IN       BOOLEAN DEFAULT TRUE
      )
      IS
         l_loc PLS_INTEGER;
         l_row PLS_INTEGER;
         l_startloc PLS_INTEGER := 1;
         l_item VARCHAR2 ( 32767 );
      BEGIN
         IF append_to_list_in
         THEN
            l_row := NVL ( list_inout.LAST, 0 ) + 1;
         ELSE
            list_inout.DELETE;
            l_row := 1;
         END IF;

         IF str IS NOT NULL
         THEN
            LOOP
               l_loc := INSTR ( str, delim, l_startloc );

               IF l_loc = l_startloc
               THEN
                  l_item := NULL;
               ELSIF l_loc = 0
               THEN
                  l_item := SUBSTR ( str, l_startloc );
               ELSE
                  l_item := SUBSTR ( str, l_startloc, l_loc - l_startloc );
               END IF;

               list_inout.EXTEND;
               list_inout ( l_row ) := l_item;

               IF l_loc = 0
               THEN
                  EXIT;
               ELSE
                  l_startloc := l_loc + 1;
                  l_row := l_row + 1;
               END IF;
            END LOOP;
         END IF;
      END string_to_list;
   BEGIN
      -- Parse the delimited list to the collection.
      string_to_list ( list_in, l_ids );
      l_row := l_ids.FIRST;

      -- Build the list of bind variables.
      WHILE ( l_row IS NOT NULL )
      LOOP
         l_query := l_query || ':bv' || l_row || ',';
         l_row := l_ids.NEXT ( l_row );
      END LOOP;

      l_query := RTRIM ( l_query, ',' ) || ')';
      -- Define the columns to be queried.
      DBMS_SQL.parse ( l_cur, l_query, DBMS_SQL.native );
      DBMS_SQL.define_column ( l_cur, 1, 1 );
      DBMS_SQL.define_column ( l_cur, 2, 'a', 100 );
      DBMS_SQL.define_column ( l_cur, 3, 'a', 2000 );
      -- Bind each variable in the provided list.
      l_row := l_ids.FIRST;

      WHILE ( l_row IS NOT NULL )
      LOOP
         DBMS_SQL.bind_variable ( l_cur, ':bv' || l_row, l_ids ( l_row ));
         l_row := l_ids.NEXT ( l_row );
      END LOOP;

      -- Execute and then fetch each row.
      l_feedback := DBMS_SQL.EXECUTE ( l_cur );

      LOOP
         l_feedback := DBMS_SQL.fetch_rows ( l_cur );
         EXIT WHEN l_feedback = 0;
         -- Retrieve individual column values and move them to the nested table.
         DBMS_SQL.column_value ( l_cur, 1, l_onerow.ID );
         DBMS_SQL.column_value ( l_cur, 2, l_onerow.title );
         DBMS_SQL.column_value ( l_cur, 3, l_onerow.description );
         retval.EXTEND;
         retval ( retval.LAST ) :=
            in_clause_ot ( l_onerow.ID, l_onerow.title, l_onerow.description );
      END LOOP;

      DBMS_SQL.close_cursor ( l_cur );
      RETURN retval;
   END dbms_sql_list;

   FUNCTION nested_table_list ( list_in IN pky_nt )
      RETURN sys_refcursor
   IS
      retval sys_refcursor;
   BEGIN
      OPEN retval FOR
         SELECT *
           FROM in_clause_tab
          WHERE ID IN ( SELECT column_value
                         FROM TABLE ( list_in ));

      RETURN retval;
   END nested_table_list;

   FUNCTION nested_table_list2 ( list_in IN pky_nt )
      RETURN sys_refcursor
   IS
      retval sys_refcursor;
   BEGIN
      OPEN retval FOR
         SELECT in_clause_tab.*
           FROM in_clause_tab, ( SELECT column_value
                                  FROM TABLE ( list_in ))
          WHERE in_clause_tab.ID = column_value;

      RETURN retval;
   END nested_table_list2;

   FUNCTION member_of_list ( list_in IN pky_nt )
      RETURN sys_refcursor
   IS
      retval sys_refcursor;
   BEGIN
      OPEN retval FOR
         SELECT *
           FROM in_clause_tab
          WHERE ID MEMBER OF list_in;

      RETURN retval;
   END member_of_list;

   FUNCTION static_in_list ( list_in IN pky_nt )
      RETURN sys_refcursor
   IS
      retval sys_refcursor;
   BEGIN
      OPEN retval FOR
         SELECT *
           FROM in_clause_tab
          WHERE ID IN
                   ( list_in ( 1 )
                   , list_in ( 2 )
                   , list_in ( 3 )
                   , list_in ( 4 )
                   , list_in ( 5 )
                   , list_in ( 6 )
                   , list_in ( 7 )
                   , list_in ( 8 )
                   , list_in ( 9 )
                   , list_in ( 10 )
                   , list_in ( 11 )
                   , list_in ( 12 )
                   , list_in ( 13 )
                   , list_in ( 14 )
                   , list_in ( 15 )
                   , list_in ( 16 )
                   , list_in ( 17 )
                   , list_in ( 18 )
                   , list_in ( 19 )
                   , list_in ( 20 )
                   , list_in ( 21 )
                   , list_in ( 22 )
                   , list_in ( 23 )
                   , list_in ( 24 )
                   , list_in ( 25 )
                   , list_in ( 26 )
                   , list_in ( 27 )
                   , list_in ( 28 )
                   , list_in ( 29 )
                   , list_in ( 30 )
                   , list_in ( 31 )
                   , list_in ( 32 )
                   , list_in ( 33 )
                   , list_in ( 34 )
                   , list_in ( 35 )
                   , list_in ( 36 )
                   , list_in ( 37 )
                   , list_in ( 38 )
                   , list_in ( 39 )
                   , list_in ( 40 )
                   , list_in ( 41 )
                   , list_in ( 42 )
                   , list_in ( 43 )
                   , list_in ( 44 )
                   , list_in ( 45 )
                   , list_in ( 46 )
                   , list_in ( 47 )
                   , list_in ( 48 )
                   , list_in ( 49 )
                   , list_in ( 50 )
                   , list_in ( 51 )
                   , list_in ( 52 )
                   , list_in ( 53 )
                   , list_in ( 54 )
                   , list_in ( 55 )
                   , list_in ( 56 )
                   , list_in ( 57 )
                   , list_in ( 58 )
                   , list_in ( 59 )
                   , list_in ( 60 )
                   , list_in ( 61 )
                   , list_in ( 62 )
                   , list_in ( 63 )
                   , list_in ( 64 )
                   , list_in ( 65 )
                   , list_in ( 66 )
                   , list_in ( 67 )
                   , list_in ( 68 )
                   , list_in ( 69 )
                   , list_in ( 70 )
                   , list_in ( 71 )
                   , list_in ( 72 )
                   , list_in ( 73 )
                   , list_in ( 74 )
                   , list_in ( 75 )
                   , list_in ( 76 )
                   , list_in ( 77 )
                   , list_in ( 78 )
                   , list_in ( 79 )
                   , list_in ( 80 )
                   , list_in ( 81 )
                   , list_in ( 82 )
                   , list_in ( 83 )
                   , list_in ( 84 )
                   , list_in ( 85 )
                   , list_in ( 86 )
                   , list_in ( 87 )
                   , list_in ( 88 )
                   , list_in ( 89 )
                   , list_in ( 90 )
                   , list_in ( 91 )
                   , list_in ( 92 )
                   , list_in ( 93 )
                   , list_in ( 94 )
                   , list_in ( 95 )
                   , list_in ( 96 )
                   , list_in ( 97 )
                   , list_in ( 98 )
                   , list_in ( 99 )
                   , list_in ( 100 )
                   , list_in ( 101 )
                   , list_in ( 102 )
                   , list_in ( 103 )
                   , list_in ( 104 )
                   , list_in ( 105 )
                   , list_in ( 106 )
                   , list_in ( 107 )
                   , list_in ( 108 )
                   , list_in ( 109 )
                   , list_in ( 110 )
                   , list_in ( 111 )
                   , list_in ( 112 )
                   , list_in ( 113 )
                   , list_in ( 114 )
                   , list_in ( 115 )
                   , list_in ( 116 )
                   , list_in ( 117 )
                   , list_in ( 118 )
                   , list_in ( 119 )
                   , list_in ( 120 )
                   , list_in ( 121 )
                   , list_in ( 122 )
                   , list_in ( 123 )
                   , list_in ( 124 )
                   , list_in ( 125 )
                   , list_in ( 126 )
                   , list_in ( 127 )
                   , list_in ( 128 )
                   , list_in ( 129 )
                   , list_in ( 130 )
                   , list_in ( 131 )
                   , list_in ( 132 )
                   , list_in ( 133 )
                   , list_in ( 134 )
                   , list_in ( 135 )
                   , list_in ( 136 )
                   , list_in ( 137 )
                   , list_in ( 138 )
                   , list_in ( 139 )
                   , list_in ( 140 )
                   , list_in ( 141 )
                   , list_in ( 142 )
                   , list_in ( 143 )
                   , list_in ( 144 )
                   , list_in ( 145 )
                   , list_in ( 146 )
                   , list_in ( 147 )
                   , list_in ( 148 )
                   , list_in ( 149 )
                   , list_in ( 150 )
                   , list_in ( 151 )
                   , list_in ( 152 )
                   , list_in ( 153 )
                   , list_in ( 154 )
                   , list_in ( 155 )
                   , list_in ( 156 )
                   , list_in ( 157 )
                   , list_in ( 158 )
                   , list_in ( 159 )
                   , list_in ( 160 )
                   , list_in ( 161 )
                   , list_in ( 162 )
                   , list_in ( 163 )
                   , list_in ( 164 )
                   , list_in ( 165 )
                   , list_in ( 166 )
                   , list_in ( 167 )
                   , list_in ( 168 )
                   , list_in ( 169 )
                   , list_in ( 170 )
                   , list_in ( 171 )
                   , list_in ( 172 )
                   , list_in ( 173 )
                   , list_in ( 174 )
                   , list_in ( 175 )
                   , list_in ( 176 )
                   , list_in ( 177 )
                   , list_in ( 178 )
                   , list_in ( 179 )
                   , list_in ( 180 )
                   , list_in ( 181 )
                   , list_in ( 182 )
                   , list_in ( 183 )
                   , list_in ( 184 )
                   , list_in ( 185 )
                   , list_in ( 186 )
                   , list_in ( 187 )
                   , list_in ( 188 )
                   , list_in ( 189 )
                   , list_in ( 190 )
                   , list_in ( 191 )
                   , list_in ( 192 )
                   , list_in ( 193 )
                   , list_in ( 194 )
                   , list_in ( 195 )
                   , list_in ( 196 )
                   , list_in ( 197 )
                   , list_in ( 198 )
                   , list_in ( 199 )
                   , list_in ( 200 )
                   , list_in ( 201 )
                   , list_in ( 202 )
                   , list_in ( 203 )
                   , list_in ( 204 )
                   , list_in ( 205 )
                   , list_in ( 206 )
                   , list_in ( 207 )
                   , list_in ( 208 )
                   , list_in ( 209 )
                   , list_in ( 210 )
                   , list_in ( 211 )
                   , list_in ( 212 )
                   , list_in ( 213 )
                   , list_in ( 214 )
                   , list_in ( 215 )
                   , list_in ( 216 )
                   , list_in ( 217 )
                   , list_in ( 218 )
                   , list_in ( 219 )
                   , list_in ( 220 )
                   , list_in ( 221 )
                   , list_in ( 222 )
                   , list_in ( 223 )
                   , list_in ( 224 )
                   , list_in ( 225 )
                   , list_in ( 226 )
                   , list_in ( 227 )
                   , list_in ( 228 )
                   , list_in ( 229 )
                   , list_in ( 230 )
                   , list_in ( 231 )
                   , list_in ( 232 )
                   , list_in ( 233 )
                   , list_in ( 234 )
                   , list_in ( 235 )
                   , list_in ( 236 )
                   , list_in ( 237 )
                   , list_in ( 238 )
                   , list_in ( 239 )
                   , list_in ( 240 )
                   , list_in ( 241 )
                   , list_in ( 242 )
                   , list_in ( 243 )
                   , list_in ( 244 )
                   , list_in ( 245 )
                   , list_in ( 246 )
                   , list_in ( 247 )
                   , list_in ( 248 )
                   , list_in ( 249 )
                   , list_in ( 250 )
                   , list_in ( 251 )
                   , list_in ( 252 )
                   , list_in ( 253 )
                   , list_in ( 254 )
                   , list_in ( 255 )
                   , list_in ( 256 )
                   , list_in ( 257 )
                   , list_in ( 258 )
                   , list_in ( 259 )
                   , list_in ( 260 )
                   , list_in ( 261 )
                   , list_in ( 262 )
                   , list_in ( 263 )
                   , list_in ( 264 )
                   , list_in ( 265 )
                   , list_in ( 266 )
                   , list_in ( 267 )
                   , list_in ( 268 )
                   , list_in ( 269 )
                   , list_in ( 270 )
                   , list_in ( 271 )
                   , list_in ( 272 )
                   , list_in ( 273 )
                   , list_in ( 274 )
                   , list_in ( 275 )
                   , list_in ( 276 )
                   , list_in ( 277 )
                   , list_in ( 278 )
                   , list_in ( 279 )
                   , list_in ( 280 )
                   , list_in ( 281 )
                   , list_in ( 282 )
                   , list_in ( 283 )
                   , list_in ( 284 )
                   , list_in ( 285 )
                   , list_in ( 286 )
                   , list_in ( 287 )
                   , list_in ( 288 )
                   , list_in ( 289 )
                   , list_in ( 290 )
                   , list_in ( 291 )
                   , list_in ( 292 )
                   , list_in ( 293 )
                   , list_in ( 294 )
                   , list_in ( 295 )
                   , list_in ( 296 )
                   , list_in ( 297 )
                   , list_in ( 298 )
                   , list_in ( 299 )
                   , list_in ( 300 )
                   , list_in ( 301 )
                   , list_in ( 302 )
                   , list_in ( 303 )
                   , list_in ( 304 )
                   , list_in ( 305 )
                   , list_in ( 306 )
                   , list_in ( 307 )
                   , list_in ( 308 )
                   , list_in ( 309 )
                   , list_in ( 310 )
                   , list_in ( 311 )
                   , list_in ( 312 )
                   , list_in ( 313 )
                   , list_in ( 314 )
                   , list_in ( 315 )
                   , list_in ( 316 )
                   , list_in ( 317 )
                   , list_in ( 318 )
                   , list_in ( 319 )
                   , list_in ( 320 )
                   , list_in ( 321 )
                   , list_in ( 322 )
                   , list_in ( 323 )
                   , list_in ( 324 )
                   , list_in ( 325 )
                   , list_in ( 326 )
                   , list_in ( 327 )
                   , list_in ( 328 )
                   , list_in ( 329 )
                   , list_in ( 330 )
                   , list_in ( 331 )
                   , list_in ( 332 )
                   , list_in ( 333 )
                   , list_in ( 334 )
                   , list_in ( 335 )
                   , list_in ( 336 )
                   , list_in ( 337 )
                   , list_in ( 338 )
                   , list_in ( 339 )
                   , list_in ( 340 )
                   , list_in ( 341 )
                   , list_in ( 342 )
                   , list_in ( 343 )
                   , list_in ( 344 )
                   , list_in ( 345 )
                   , list_in ( 346 )
                   , list_in ( 347 )
                   , list_in ( 348 )
                   , list_in ( 349 )
                   , list_in ( 350 )
                   , list_in ( 351 )
                   , list_in ( 352 )
                   , list_in ( 353 )
                   , list_in ( 354 )
                   , list_in ( 355 )
                   , list_in ( 356 )
                   , list_in ( 357 )
                   , list_in ( 358 )
                   , list_in ( 359 )
                   , list_in ( 360 )
                   , list_in ( 361 )
                   , list_in ( 362 )
                   , list_in ( 363 )
                   , list_in ( 364 )
                   , list_in ( 365 )
                   , list_in ( 366 )
                   , list_in ( 367 )
                   , list_in ( 368 )
                   , list_in ( 369 )
                   , list_in ( 370 )
                   , list_in ( 371 )
                   , list_in ( 372 )
                   , list_in ( 373 )
                   , list_in ( 374 )
                   , list_in ( 375 )
                   , list_in ( 376 )
                   , list_in ( 377 )
                   , list_in ( 378 )
                   , list_in ( 379 )
                   , list_in ( 380 )
                   , list_in ( 381 )
                   , list_in ( 382 )
                   , list_in ( 383 )
                   , list_in ( 384 )
                   , list_in ( 385 )
                   , list_in ( 386 )
                   , list_in ( 387 )
                   , list_in ( 388 )
                   , list_in ( 389 )
                   , list_in ( 390 )
                   , list_in ( 391 )
                   , list_in ( 392 )
                   , list_in ( 393 )
                   , list_in ( 394 )
                   , list_in ( 395 )
                   , list_in ( 396 )
                   , list_in ( 397 )
                   , list_in ( 398 )
                   , list_in ( 399 )
                   , list_in ( 400 )
                   , list_in ( 401 )
                   , list_in ( 402 )
                   , list_in ( 403 )
                   , list_in ( 404 )
                   , list_in ( 405 )
                   , list_in ( 406 )
                   , list_in ( 407 )
                   , list_in ( 408 )
                   , list_in ( 409 )
                   , list_in ( 410 )
                   , list_in ( 411 )
                   , list_in ( 412 )
                   , list_in ( 413 )
                   , list_in ( 414 )
                   , list_in ( 415 )
                   , list_in ( 416 )
                   , list_in ( 417 )
                   , list_in ( 418 )
                   , list_in ( 419 )
                   , list_in ( 420 )
                   , list_in ( 421 )
                   , list_in ( 422 )
                   , list_in ( 423 )
                   , list_in ( 424 )
                   , list_in ( 425 )
                   , list_in ( 426 )
                   , list_in ( 427 )
                   , list_in ( 428 )
                   , list_in ( 429 )
                   , list_in ( 430 )
                   , list_in ( 431 )
                   , list_in ( 432 )
                   , list_in ( 433 )
                   , list_in ( 434 )
                   , list_in ( 435 )
                   , list_in ( 436 )
                   , list_in ( 437 )
                   , list_in ( 438 )
                   , list_in ( 439 )
                   , list_in ( 440 )
                   , list_in ( 441 )
                   , list_in ( 442 )
                   , list_in ( 443 )
                   , list_in ( 444 )
                   , list_in ( 445 )
                   , list_in ( 446 )
                   , list_in ( 447 )
                   , list_in ( 448 )
                   , list_in ( 449 )
                   , list_in ( 450 )
                   , list_in ( 451 )
                   , list_in ( 452 )
                   , list_in ( 453 )
                   , list_in ( 454 )
                   , list_in ( 455 )
                   , list_in ( 456 )
                   , list_in ( 457 )
                   , list_in ( 458 )
                   , list_in ( 459 )
                   , list_in ( 460 )
                   , list_in ( 461 )
                   , list_in ( 462 )
                   , list_in ( 463 )
                   , list_in ( 464 )
                   , list_in ( 465 )
                   , list_in ( 466 )
                   , list_in ( 467 )
                   , list_in ( 468 )
                   , list_in ( 469 )
                   , list_in ( 470 )
                   , list_in ( 471 )
                   , list_in ( 472 )
                   , list_in ( 473 )
                   , list_in ( 474 )
                   , list_in ( 475 )
                   , list_in ( 476 )
                   , list_in ( 477 )
                   , list_in ( 478 )
                   , list_in ( 479 )
                   , list_in ( 480 )
                   , list_in ( 481 )
                   , list_in ( 482 )
                   , list_in ( 483 )
                   , list_in ( 484 )
                   , list_in ( 485 )
                   , list_in ( 486 )
                   , list_in ( 487 )
                   , list_in ( 488 )
                   , list_in ( 489 )
                   , list_in ( 490 )
                   , list_in ( 491 )
                   , list_in ( 492 )
                   , list_in ( 493 )
                   , list_in ( 494 )
                   , list_in ( 495 )
                   , list_in ( 496 )
                   , list_in ( 497 )
                   , list_in ( 498 )
                   , list_in ( 499 )
                   , list_in ( 500 )
                   , list_in ( 501 )
                   , list_in ( 502 )
                   , list_in ( 503 )
                   , list_in ( 504 )
                   , list_in ( 505 )
                   , list_in ( 506 )
                   , list_in ( 507 )
                   , list_in ( 508 )
                   , list_in ( 509 )
                   , list_in ( 510 )
                   , list_in ( 511 )
                   , list_in ( 512 )
                   , list_in ( 513 )
                   , list_in ( 514 )
                   , list_in ( 515 )
                   , list_in ( 516 )
                   , list_in ( 517 )
                   , list_in ( 518 )
                   , list_in ( 519 )
                   , list_in ( 520 )
                   , list_in ( 521 )
                   , list_in ( 522 )
                   , list_in ( 523 )
                   , list_in ( 524 )
                   , list_in ( 525 )
                   , list_in ( 526 )
                   , list_in ( 527 )
                   , list_in ( 528 )
                   , list_in ( 529 )
                   , list_in ( 530 )
                   , list_in ( 531 )
                   , list_in ( 532 )
                   , list_in ( 533 )
                   , list_in ( 534 )
                   , list_in ( 535 )
                   , list_in ( 536 )
                   , list_in ( 537 )
                   , list_in ( 538 )
                   , list_in ( 539 )
                   , list_in ( 540 )
                   , list_in ( 541 )
                   , list_in ( 542 )
                   , list_in ( 543 )
                   , list_in ( 544 )
                   , list_in ( 545 )
                   , list_in ( 546 )
                   , list_in ( 547 )
                   , list_in ( 548 )
                   , list_in ( 549 )
                   , list_in ( 550 )
                   , list_in ( 551 )
                   , list_in ( 552 )
                   , list_in ( 553 )
                   , list_in ( 554 )
                   , list_in ( 555 )
                   , list_in ( 556 )
                   , list_in ( 557 )
                   , list_in ( 558 )
                   , list_in ( 559 )
                   , list_in ( 560 )
                   , list_in ( 561 )
                   , list_in ( 562 )
                   , list_in ( 563 )
                   , list_in ( 564 )
                   , list_in ( 565 )
                   , list_in ( 566 )
                   , list_in ( 567 )
                   , list_in ( 568 )
                   , list_in ( 569 )
                   , list_in ( 570 )
                   , list_in ( 571 )
                   , list_in ( 572 )
                   , list_in ( 573 )
                   , list_in ( 574 )
                   , list_in ( 575 )
                   , list_in ( 576 )
                   , list_in ( 577 )
                   , list_in ( 578 )
                   , list_in ( 579 )
                   , list_in ( 580 )
                   , list_in ( 581 )
                   , list_in ( 582 )
                   , list_in ( 583 )
                   , list_in ( 584 )
                   , list_in ( 585 )
                   , list_in ( 586 )
                   , list_in ( 587 )
                   , list_in ( 588 )
                   , list_in ( 589 )
                   , list_in ( 590 )
                   , list_in ( 591 )
                   , list_in ( 592 )
                   , list_in ( 593 )
                   , list_in ( 594 )
                   , list_in ( 595 )
                   , list_in ( 596 )
                   , list_in ( 597 )
                   , list_in ( 598 )
                   , list_in ( 599 )
                   , list_in ( 600 )
                   , list_in ( 601 )
                   , list_in ( 602 )
                   , list_in ( 603 )
                   , list_in ( 604 )
                   , list_in ( 605 )
                   , list_in ( 606 )
                   , list_in ( 607 )
                   , list_in ( 608 )
                   , list_in ( 609 )
                   , list_in ( 610 )
                   , list_in ( 611 )
                   , list_in ( 612 )
                   , list_in ( 613 )
                   , list_in ( 614 )
                   , list_in ( 615 )
                   , list_in ( 616 )
                   , list_in ( 617 )
                   , list_in ( 618 )
                   , list_in ( 619 )
                   , list_in ( 620 )
                   , list_in ( 621 )
                   , list_in ( 622 )
                   , list_in ( 623 )
                   , list_in ( 624 )
                   , list_in ( 625 )
                   , list_in ( 626 )
                   , list_in ( 627 )
                   , list_in ( 628 )
                   , list_in ( 629 )
                   , list_in ( 630 )
                   , list_in ( 631 )
                   , list_in ( 632 )
                   , list_in ( 633 )
                   , list_in ( 634 )
                   , list_in ( 635 )
                   , list_in ( 636 )
                   , list_in ( 637 )
                   , list_in ( 638 )
                   , list_in ( 639 )
                   , list_in ( 640 )
                   , list_in ( 641 )
                   , list_in ( 642 )
                   , list_in ( 643 )
                   , list_in ( 644 )
                   , list_in ( 645 )
                   , list_in ( 646 )
                   , list_in ( 647 )
                   , list_in ( 648 )
                   , list_in ( 649 )
                   , list_in ( 650 )
                   , list_in ( 651 )
                   , list_in ( 652 )
                   , list_in ( 653 )
                   , list_in ( 654 )
                   , list_in ( 655 )
                   , list_in ( 656 )
                   , list_in ( 657 )
                   , list_in ( 658 )
                   , list_in ( 659 )
                   , list_in ( 660 )
                   , list_in ( 661 )
                   , list_in ( 662 )
                   , list_in ( 663 )
                   , list_in ( 664 )
                   , list_in ( 665 )
                   , list_in ( 666 )
                   , list_in ( 667 )
                   , list_in ( 668 )
                   , list_in ( 669 )
                   , list_in ( 670 )
                   , list_in ( 671 )
                   , list_in ( 672 )
                   , list_in ( 673 )
                   , list_in ( 674 )
                   , list_in ( 675 )
                   , list_in ( 676 )
                   , list_in ( 677 )
                   , list_in ( 678 )
                   , list_in ( 679 )
                   , list_in ( 680 )
                   , list_in ( 681 )
                   , list_in ( 682 )
                   , list_in ( 683 )
                   , list_in ( 684 )
                   , list_in ( 685 )
                   , list_in ( 686 )
                   , list_in ( 687 )
                   , list_in ( 688 )
                   , list_in ( 689 )
                   , list_in ( 690 )
                   , list_in ( 691 )
                   , list_in ( 692 )
                   , list_in ( 693 )
                   , list_in ( 694 )
                   , list_in ( 695 )
                   , list_in ( 696 )
                   , list_in ( 697 )
                   , list_in ( 698 )
                   , list_in ( 699 )
                   , list_in ( 700 )
                   , list_in ( 701 )
                   , list_in ( 702 )
                   , list_in ( 703 )
                   , list_in ( 704 )
                   , list_in ( 705 )
                   , list_in ( 706 )
                   , list_in ( 707 )
                   , list_in ( 708 )
                   , list_in ( 709 )
                   , list_in ( 710 )
                   , list_in ( 711 )
                   , list_in ( 712 )
                   , list_in ( 713 )
                   , list_in ( 714 )
                   , list_in ( 715 )
                   , list_in ( 716 )
                   , list_in ( 717 )
                   , list_in ( 718 )
                   , list_in ( 719 )
                   , list_in ( 720 )
                   , list_in ( 721 )
                   , list_in ( 722 )
                   , list_in ( 723 )
                   , list_in ( 724 )
                   , list_in ( 725 )
                   , list_in ( 726 )
                   , list_in ( 727 )
                   , list_in ( 728 )
                   , list_in ( 729 )
                   , list_in ( 730 )
                   , list_in ( 731 )
                   , list_in ( 732 )
                   , list_in ( 733 )
                   , list_in ( 734 )
                   , list_in ( 735 )
                   , list_in ( 736 )
                   , list_in ( 737 )
                   , list_in ( 738 )
                   , list_in ( 739 )
                   , list_in ( 740 )
                   , list_in ( 741 )
                   , list_in ( 742 )
                   , list_in ( 743 )
                   , list_in ( 744 )
                   , list_in ( 745 )
                   , list_in ( 746 )
                   , list_in ( 747 )
                   , list_in ( 748 )
                   , list_in ( 749 )
                   , list_in ( 750 )
                   , list_in ( 751 )
                   , list_in ( 752 )
                   , list_in ( 753 )
                   , list_in ( 754 )
                   , list_in ( 755 )
                   , list_in ( 756 )
                   , list_in ( 757 )
                   , list_in ( 758 )
                   , list_in ( 759 )
                   , list_in ( 760 )
                   , list_in ( 761 )
                   , list_in ( 762 )
                   , list_in ( 763 )
                   , list_in ( 764 )
                   , list_in ( 765 )
                   , list_in ( 766 )
                   , list_in ( 767 )
                   , list_in ( 768 )
                   , list_in ( 769 )
                   , list_in ( 770 )
                   , list_in ( 771 )
                   , list_in ( 772 )
                   , list_in ( 773 )
                   , list_in ( 774 )
                   , list_in ( 775 )
                   , list_in ( 776 )
                   , list_in ( 777 )
                   , list_in ( 778 )
                   , list_in ( 779 )
                   , list_in ( 780 )
                   , list_in ( 781 )
                   , list_in ( 782 )
                   , list_in ( 783 )
                   , list_in ( 784 )
                   , list_in ( 785 )
                   , list_in ( 786 )
                   , list_in ( 787 )
                   , list_in ( 788 )
                   , list_in ( 789 )
                   , list_in ( 790 )
                   , list_in ( 791 )
                   , list_in ( 792 )
                   , list_in ( 793 )
                   , list_in ( 794 )
                   , list_in ( 795 )
                   , list_in ( 796 )
                   , list_in ( 797 )
                   , list_in ( 798 )
                   , list_in ( 799 )
                   , list_in ( 800 )
                   , list_in ( 801 )
                   , list_in ( 802 )
                   , list_in ( 803 )
                   , list_in ( 804 )
                   , list_in ( 805 )
                   , list_in ( 806 )
                   , list_in ( 807 )
                   , list_in ( 808 )
                   , list_in ( 809 )
                   , list_in ( 810 )
                   , list_in ( 811 )
                   , list_in ( 812 )
                   , list_in ( 813 )
                   , list_in ( 814 )
                   , list_in ( 815 )
                   , list_in ( 816 )
                   , list_in ( 817 )
                   , list_in ( 818 )
                   , list_in ( 819 )
                   , list_in ( 820 )
                   , list_in ( 821 )
                   , list_in ( 822 )
                   , list_in ( 823 )
                   , list_in ( 824 )
                   , list_in ( 825 )
                   , list_in ( 826 )
                   , list_in ( 827 )
                   , list_in ( 828 )
                   , list_in ( 829 )
                   , list_in ( 830 )
                   , list_in ( 831 )
                   , list_in ( 832 )
                   , list_in ( 833 )
                   , list_in ( 834 )
                   , list_in ( 835 )
                   , list_in ( 836 )
                   , list_in ( 837 )
                   , list_in ( 838 )
                   , list_in ( 839 )
                   , list_in ( 840 )
                   , list_in ( 841 )
                   , list_in ( 842 )
                   , list_in ( 843 )
                   , list_in ( 844 )
                   , list_in ( 845 )
                   , list_in ( 846 )
                   , list_in ( 847 )
                   , list_in ( 848 )
                   , list_in ( 849 )
                   , list_in ( 850 )
                   , list_in ( 851 )
                   , list_in ( 852 )
                   , list_in ( 853 )
                   , list_in ( 854 )
                   , list_in ( 855 )
                   , list_in ( 856 )
                   , list_in ( 857 )
                   , list_in ( 858 )
                   , list_in ( 859 )
                   , list_in ( 860 )
                   , list_in ( 861 )
                   , list_in ( 862 )
                   , list_in ( 863 )
                   , list_in ( 864 )
                   , list_in ( 865 )
                   , list_in ( 866 )
                   , list_in ( 867 )
                   , list_in ( 868 )
                   , list_in ( 869 )
                   , list_in ( 870 )
                   , list_in ( 871 )
                   , list_in ( 872 )
                   , list_in ( 873 )
                   , list_in ( 874 )
                   , list_in ( 875 )
                   , list_in ( 876 )
                   , list_in ( 877 )
                   , list_in ( 878 )
                   , list_in ( 879 )
                   , list_in ( 880 )
                   , list_in ( 881 )
                   , list_in ( 882 )
                   , list_in ( 883 )
                   , list_in ( 884 )
                   , list_in ( 885 )
                   , list_in ( 886 )
                   , list_in ( 887 )
                   , list_in ( 888 )
                   , list_in ( 889 )
                   , list_in ( 890 )
                   , list_in ( 891 )
                   , list_in ( 892 )
                   , list_in ( 893 )
                   , list_in ( 894 )
                   , list_in ( 895 )
                   , list_in ( 896 )
                   , list_in ( 897 )
                   , list_in ( 898 )
                   , list_in ( 899 )
                   , list_in ( 900 )
                   , list_in ( 901 )
                   , list_in ( 902 )
                   , list_in ( 903 )
                   , list_in ( 904 )
                   , list_in ( 905 )
                   , list_in ( 906 )
                   , list_in ( 907 )
                   , list_in ( 908 )
                   , list_in ( 909 )
                   , list_in ( 910 )
                   , list_in ( 911 )
                   , list_in ( 912 )
                   , list_in ( 913 )
                   , list_in ( 914 )
                   , list_in ( 915 )
                   , list_in ( 916 )
                   , list_in ( 917 )
                   , list_in ( 918 )
                   , list_in ( 919 )
                   , list_in ( 920 )
                   , list_in ( 921 )
                   , list_in ( 922 )
                   , list_in ( 923 )
                   , list_in ( 924 )
                   , list_in ( 925 )
                   , list_in ( 926 )
                   , list_in ( 927 )
                   , list_in ( 928 )
                   , list_in ( 929 )
                   , list_in ( 930 )
                   , list_in ( 931 )
                   , list_in ( 932 )
                   , list_in ( 933 )
                   , list_in ( 934 )
                   , list_in ( 935 )
                   , list_in ( 936 )
                   , list_in ( 937 )
                   , list_in ( 938 )
                   , list_in ( 939 )
                   , list_in ( 940 )
                   , list_in ( 941 )
                   , list_in ( 942 )
                   , list_in ( 943 )
                   , list_in ( 944 )
                   , list_in ( 945 )
                   , list_in ( 946 )
                   , list_in ( 947 )
                   , list_in ( 948 )
                   , list_in ( 949 )
                   , list_in ( 950 )
                   , list_in ( 951 )
                   , list_in ( 952 )
                   , list_in ( 953 )
                   , list_in ( 954 )
                   , list_in ( 955 )
                   , list_in ( 956 )
                   , list_in ( 957 )
                   , list_in ( 958 )
                   , list_in ( 959 )
                   , list_in ( 960 )
                   , list_in ( 961 )
                   , list_in ( 962 )
                   , list_in ( 963 )
                   , list_in ( 964 )
                   , list_in ( 965 )
                   , list_in ( 966 )
                   , list_in ( 967 )
                   , list_in ( 968 )
                   , list_in ( 969 )
                   , list_in ( 970 )
                   , list_in ( 971 )
                   , list_in ( 972 )
                   , list_in ( 973 )
                   , list_in ( 974 )
                   , list_in ( 975 )
                   , list_in ( 976 )
                   , list_in ( 977 )
                   , list_in ( 978 )
                   , list_in ( 979 )
                   , list_in ( 980 )
                   , list_in ( 981 )
                   , list_in ( 982 )
                   , list_in ( 983 )
                   , list_in ( 984 )
                   , list_in ( 985 )
                   , list_in ( 986 )
                   , list_in ( 987 )
                   , list_in ( 988 )
                   , list_in ( 989 )
                   , list_in ( 990 )
                   , list_in ( 991 )
                   , list_in ( 992 )
                   , list_in ( 993 )
                   , list_in ( 994 )
                   , list_in ( 995 )
                   , list_in ( 996 )
                   , list_in ( 997 )
                   , list_in ( 998 )
                   , list_in ( 999 )
                   , list_in ( 1000 )
                   );

      RETURN retval;
   END static_in_list;

   FUNCTION static_in_list_small ( list_in IN pky_nt )
      RETURN sys_refcursor
   IS
      retval sys_refcursor;
   BEGIN
      OPEN retval FOR
         SELECT *
           FROM in_clause_tab
          WHERE ID IN
                   ( list_in ( 1 )
                   , list_in ( 2 )
                   , list_in ( 3 )
                   , list_in ( 4 )
                   , list_in ( 5 )
                   , list_in ( 6 )
                   , list_in ( 7 )
                   , list_in ( 8 )
                   , list_in ( 9 )
                   , list_in ( 10 )
                   , list_in ( 11 )
                   , list_in ( 12 )
                   , list_in ( 13 )
                   , list_in ( 14 )
                   , list_in ( 15 )
                   , list_in ( 16 )
                   , list_in ( 17 )
                   , list_in ( 18 )
                   , list_in ( 19 )
                   , list_in ( 20 )
                   , list_in ( 21 )
                   , list_in ( 22 )
                   , list_in ( 23 )
                   , list_in ( 24 )
                   , list_in ( 25 )
                   , list_in ( 26 )
                   , list_in ( 27 )
                   , list_in ( 28 )
                   , list_in ( 29 )
                   , list_in ( 30 )
                   , list_in ( 31 )
                   , list_in ( 32 )
                   , list_in ( 33 )
                   , list_in ( 34 )
                   , list_in ( 35 )
                   , list_in ( 36 )
                   , list_in ( 37 )
                   , list_in ( 38 )
                   , list_in ( 39 )
                   , list_in ( 40 )
                   , list_in ( 41 )
                   , list_in ( 42 )
                   , list_in ( 43 )
                   , list_in ( 44 )
                   , list_in ( 45 )
                   , list_in ( 46 )
                   , list_in ( 47 )
                   , list_in ( 48 )
                   , list_in ( 49 )
                   , list_in ( 50 )
                   );

      RETURN retval;
   END static_in_list_small;

   PROCEDURE gen_static_in_query (
      table_in          IN   VARCHAR2
    , array_in          IN   VARCHAR2
    , never_value_in    IN   VARCHAR2 := 'NULL'
    , num_elements_in   IN   PLS_INTEGER := 1000
    , to_file_in        IN   BOOLEAN := FALSE
    , file_in           IN   VARCHAR2 := NULL
    , dir_in            IN   VARCHAR2 := NULL
   )
   IS
      l_pkg_name VARCHAR2 ( 100 ) := table_in || '_ip';
      -- Send output to file or screen?
      l_to_screen BOOLEAN := NVL ( NOT to_file_in, TRUE );
      l_file VARCHAR2 ( 1000 ) := l_pkg_name || '.pkg';

      -- Array of output for package
      TYPE lines_t IS TABLE OF VARCHAR2 ( 1000 )
         INDEX BY BINARY_INTEGER;

      output lines_t;

      PROCEDURE pl ( str IN VARCHAR2 )
      IS
      BEGIN
         output ( NVL ( output.LAST, 0 ) + 1 ) := str;
      END;

      -- Dump to screen or file.
      PROCEDURE dump_output
      IS
      BEGIN
         IF l_to_screen
         THEN
            FOR indx IN output.FIRST .. output.LAST
            LOOP
               DBMS_OUTPUT.put_line ( output ( indx ));
            END LOOP;
         ELSE
            -- Send output to the specified file.
            DECLARE
               fid UTL_FILE.file_type;
            BEGIN
               fid := UTL_FILE.fopen ( dir_in, l_file, 'W' );

               FOR indx IN output.FIRST .. output.LAST
               LOOP
                  UTL_FILE.put_line ( fid, output ( indx ));
               END LOOP;

               UTL_FILE.fclose ( fid );
            EXCEPTION
               WHEN OTHERS
               THEN
                  DBMS_OUTPUT.put_line (    'Failure to write output to '
                                         || dir_in
                                         || '/'
                                         || l_file
                                       );
                  UTL_FILE.fclose ( fid );
            END;
         END IF;
      END dump_output;
   BEGIN
      pl ( 'SELECT * FROM ' || table_in || ' WHERE id IN (' );

      FOR indx IN 1 .. LEAST ( num_elements_in, 1000 )
      LOOP
         IF indx < num_elements_in
         THEN
            pl ( array_in || '(' || indx || '),' );
         ELSE
            pl ( array_in || '(' || indx || '))' );
         END IF;
      END LOOP;

      dump_output;
   END gen_static_in_query;

   PROCEDURE test_varieties (
      iterations_in    IN   PLS_INTEGER DEFAULT 1
    , list_in          IN   VARCHAR2 DEFAULT '1,3'
    , show_timing_in   IN   BOOLEAN DEFAULT FALSE
    , show_data_in     IN   BOOLEAN DEFAULT FALSE
   )
   IS
      l_start_time PLS_INTEGER;

      PROCEDURE start_timing
      IS
      BEGIN
         l_start_time := DBMS_UTILITY.get_cpu_time;
      END start_timing;

      PROCEDURE show_elapsed
      IS
      BEGIN
         DBMS_OUTPUT.put_line (    '  Elapsed CPU time: '
                                || TO_CHAR (   DBMS_UTILITY.get_cpu_time
                                             - l_start_time
                                           )
                              );
      END show_elapsed;

      PROCEDURE init_test ( str_in IN VARCHAR2 )
      IS
      BEGIN
         IF show_timing_in
         THEN
            start_timing;
         END IF;

         DBMS_OUTPUT.put_line ( str_in );
      END init_test;

      PROCEDURE finish_test
      IS
      BEGIN
         IF show_timing_in
         THEN
            show_elapsed;
         END IF;
      END finish_test;

      PROCEDURE test_nds_list
      IS
         l_cv sys_refcursor;
         l_one in_clause_tab%ROWTYPE;
      BEGIN
         init_test ( 'Output from NDS_LIST' );

         FOR indx IN 1 .. iterations_in
         LOOP
            l_cv := nds_list ( list_in );

            LOOP
               FETCH l_cv
                INTO l_one;

               EXIT WHEN l_cv%NOTFOUND;

               IF indx = 1 AND show_data_in
               THEN
                  DBMS_OUTPUT.put_line ( '  ' || l_one.title );
               END IF;
            END LOOP;

            CLOSE l_cv;
         END LOOP;

         finish_test;
      END test_nds_list;

      PROCEDURE test_nds_bulk_list
      IS
         l_array in_clause_tab_nt;
         l_row PLS_INTEGER;
      BEGIN
         init_test ( 'Output from NDS_BULK_LIST' );

         FOR indx IN 1 .. iterations_in
         LOOP
            l_array := nds_bulk_list ( list_in );
            l_row := l_array.FIRST;

            WHILE ( l_row IS NOT NULL )
            LOOP
               IF indx = 1 AND show_data_in
               THEN
                  DBMS_OUTPUT.put_line ( '  ' || l_array ( l_row ).title );
               END IF;

               l_row := l_array.NEXT ( l_row );
            END LOOP;
         END LOOP;

         finish_test;
      END test_nds_bulk_list;

      PROCEDURE test_nds_bulk_list2
      IS
         l_cv sys_refcursor;
         l_one in_clause_tab%ROWTYPE;
      BEGIN
         init_test ( 'Output from NDS_BULK_LIST2' );

         FOR indx IN 1 .. iterations_in
         LOOP
            l_cv := nds_bulk_list2 ( list_in );

            LOOP
               FETCH l_cv
                INTO l_one;

               EXIT WHEN l_cv%NOTFOUND;

               IF indx = 1 AND show_data_in
               THEN
                  DBMS_OUTPUT.put_line ( '  ' || l_one.title );
               END IF;
            END LOOP;

            CLOSE l_cv;
         END LOOP;

         finish_test;
      END test_nds_bulk_list2;

      PROCEDURE test_dbms_sql_list
      IS
         l_array in_clause_tab_nt;
         l_row PLS_INTEGER;
      BEGIN
         init_test ( 'Output from DBMS_SQL_LIST' );

         FOR indx IN 1 .. iterations_in
         LOOP
            l_array := dbms_sql_list ( list_in );
            l_row := l_array.FIRST;

            WHILE ( l_row IS NOT NULL )
            LOOP
               IF indx = 1 AND show_data_in
               THEN
                  DBMS_OUTPUT.put_line ( '  ' || l_array ( l_row ).title );
               END IF;

               l_row := l_array.NEXT ( l_row );
            END LOOP;
         END LOOP;

         finish_test;
      END test_dbms_sql_list;

      PROCEDURE test_nested_table_list
      IS
         l_list pky_nt := pky_nt ( 1, 3 );
         l_cv sys_refcursor;
         l_one in_clause_tab%ROWTYPE;
      BEGIN
         init_test ( 'Output from NESTED_TABLE_LIST' );

         FOR indx IN 1 .. iterations_in
         LOOP
            l_cv := nested_table_list ( l_list );

            LOOP
               FETCH l_cv
                INTO l_one;

               EXIT WHEN l_cv%NOTFOUND;

               IF indx = 1 AND show_data_in
               THEN
                  DBMS_OUTPUT.put_line ( '  ' || l_one.title );
               END IF;
            END LOOP;

            CLOSE l_cv;
         END LOOP;

         finish_test;
      END test_nested_table_list;

      PROCEDURE test_nested_table_list2
      IS
         l_list pky_nt := pky_nt ( 1, 3 );
         l_cv sys_refcursor;
         l_one in_clause_tab%ROWTYPE;
      BEGIN
         init_test ( 'Output from NESTED_TABLE_LIST - Join' );

         FOR indx IN 1 .. iterations_in
         LOOP
            l_cv := nested_table_list2 ( l_list );

            LOOP
               FETCH l_cv
                INTO l_one;

               EXIT WHEN l_cv%NOTFOUND;

               IF indx = 1 AND show_data_in
               THEN
                  DBMS_OUTPUT.put_line ( '  ' || l_one.title );
               END IF;
            END LOOP;

            CLOSE l_cv;
         END LOOP;

         finish_test;
      END test_nested_table_list2;

      PROCEDURE test_member_of_list
      IS
         l_list pky_nt := pky_nt ( 1, 3 );
         l_cv sys_refcursor;
         l_one in_clause_tab%ROWTYPE;
      BEGIN
         init_test ( 'Output from MEMBER_OF_LIST' );

         FOR indx IN 1 .. iterations_in
         LOOP
            l_cv := member_of_list ( l_list );

            LOOP
               FETCH l_cv
                INTO l_one;

               EXIT WHEN l_cv%NOTFOUND;

               IF indx = 1 AND show_data_in
               THEN
                  DBMS_OUTPUT.put_line ( '  ' || l_one.title );
               END IF;
            END LOOP;

            CLOSE l_cv;
         END LOOP;

         finish_test;
      END test_member_of_list;

      PROCEDURE test_static_in_list
      IS
         l_list pky_nt := pky_nt ( );
         l_cv sys_refcursor;
         l_one in_clause_tab%ROWTYPE;
      BEGIN
         init_test ( 'Output from STATIC_IN_LIST' );
         l_list.EXTEND ( 1000 );
         l_list ( 1 ) := 1;
         l_list ( 2 ) := 3;

         FOR indx IN 1 .. iterations_in
         LOOP
            l_cv := static_in_list ( l_list );

            LOOP
               FETCH l_cv
                INTO l_one;

               EXIT WHEN l_cv%NOTFOUND;

               IF indx = 1 AND show_data_in
               THEN
                  DBMS_OUTPUT.put_line ( '  ' || l_one.title );
               END IF;
            END LOOP;

            CLOSE l_cv;
         END LOOP;

         finish_test;
         --
         init_test ( 'Output from STATIC_IN_LIST_SMALL(50)' );
         l_list.EXTEND ( 50 );
         l_list ( 1 ) := 1;
         l_list ( 2 ) := 3;

         FOR indx IN 1 .. iterations_in
         LOOP
            l_cv := static_in_list ( l_list );

            LOOP
               FETCH l_cv
                INTO l_one;

               EXIT WHEN l_cv%NOTFOUND;

               IF indx = 1 AND show_data_in
               THEN
                  DBMS_OUTPUT.put_line ( '  ' || l_one.title );
               END IF;
            END LOOP;

            CLOSE l_cv;
         END LOOP;

         finish_test;
      END test_static_in_list;
   BEGIN
      test_nds_list;
      test_nds_bulk_list;
      test_nds_bulk_list2;
      test_dbms_sql_list;
      test_nested_table_list;
      test_nested_table_list2;
      test_member_of_list;
      test_static_in_list;
   END test_varieties;
/* Example of results of testing:

11.2

Output from NDS_LIST
  Elapsed CPU time: 200
Output from NDS_BULK_LIST
  Elapsed CPU time: 217
Output from NDS_BULK_LIST2
  Elapsed CPU time: 233
Output from DBMS_SQL_LIST
  Elapsed CPU time: 223
Output from NESTED_TABLE_LIST
  Elapsed CPU time: 186
Output from NESTED_TABLE_LIST - Join
  Elapsed CPU time: 181
Output from MEMBER_OF_LIST
  Elapsed CPU time: 879
Output from STATIC_IN_LIST
  Elapsed CPU time: 284
Output from STATIC_IN_LIST_SMALL(50)
  Elapsed CPU time: 250
  

10gR1

Output from NDS_LIST
  Elapsed CPU time: 254
Output from NDS_BULK_LIST
  Elapsed CPU time: 220
Output from NDS_BULK_LIST2
  Elapsed CPU time: 269
Output from DBMS_SQL_LIST
  Elapsed CPU time: 269
Output from NESTED_TABLE_LIST
  Elapsed CPU time: 315
Output from MEMBER_OF_LIST
  Elapsed CPU time: 1066
Output from STATIC_IN_LIST
  Elapsed CPU time: 421

10gR2 - 1000 iterations, short list

Output from NDS_LIST
  Elapsed CPU time: 259
Output from NDS_BULK_LIST
  Elapsed CPU time: 217
Output from NDS_BULK_LIST2
  Elapsed CPU time: 277
Output from DBMS_SQL_LIST
  Elapsed CPU time: 251
Output from NESTED_TABLE_LIST
  Elapsed CPU time: 337
Output from NESTED_TABLE_LIST - Join
  Elapsed CPU time: 331
Output from NESTED_TABLE_LIST w/o CAST
  Elapsed CPU time: 323
Output from MEMBER_OF_LIST
  Elapsed CPU time: 1062
Output from STATIC_IN_LIST
  Elapsed CPU time: 367
Output from STATIC_IN_LIST_SMALL(50)
  Elapsed CPU time: 367
  
10gR2 - 10000 iterations, longer list

Output from NDS_LIST
  Elapsed CPU time: 314
Output from NDS_BULK_LIST
  Elapsed CPU time: 272
Output from NDS_BULK_LIST2
  Elapsed CPU time: 357
Output from DBMS_SQL_LIST
  Elapsed CPU time: 485
Output from NESTED_TABLE_LIST
  Elapsed CPU time: 369
Output from NESTED_TABLE_LIST - Join
  Elapsed CPU time: 363
Output from NESTED_TABLE_LIST w/o CAST
  Elapsed CPU time: 331
Output from MEMBER_OF_LIST
  Elapsed CPU time: 1054
Output from STATIC_IN_LIST
  Elapsed CPU time: 374
Output from STATIC_IN_LIST_SMALL(50)
  Elapsed CPU time: 381
    
10gR2 - 10000 iterations

Output from NDS_LIST
  Elapsed CPU time: 2700
Output from NDS_BULK_LIST
  Elapsed CPU time: 2203
Output from NDS_BULK_LIST2
  Elapsed CPU time: 2902
Output from DBMS_SQL_LIST
  Elapsed CPU time: 2523
Output from NESTED_TABLE_LIST
  Elapsed CPU time: 3387
Output from NESTED_TABLE_LIST - Join
  Elapsed CPU time: 3333
Output from NESTED_TABLE_LIST w/o CAST
  Elapsed CPU time: 3482
Output from MEMBER_OF_LIST
  Elapsed CPU time: 11141
Output from STATIC_IN_LIST
  Elapsed CPU time: 4012
Output from STATIC_IN_LIST_SMALL(50)
  Elapsed CPU time: 4413
*/
END in_clause;
/