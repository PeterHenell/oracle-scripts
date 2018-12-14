SELECT name, line, text
  FROM USER_SOURCE
 WHERE INSTR (UPPER (text), ' CHAR') > 0;
