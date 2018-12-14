Topic: 
     subtract 2 dates and show diff in time format (10 of 10), Read 10 times  
 Conf: 
     Oracle8 and PL/SQL8 
 From: 
     James Padfield 
 Date: 
     Thursday, June 08, 2000 05:25 AM 


No problem.

I have often reduced IF..THEN logic such as you have used..

IF p_subtractor > p_subtracted_from THEN 
v_date_diff := p_subtractor - p_subtracted_from; 
ELSE
v_date_diff := p_subtracted_from - p_subtractor; 
END IF;

to either of the following...

v_date_diff := GREATEST(p_subtracted_from, p_subtractor) - LEAST(p_subtracted_from, p_subtractor); 

v_date_diff := ABS(p_subtracted_from - p_subtractor);

Having just tested this out however, I was surprised to see that the GREATEST/LEAST version takes more than twice
as long to execute, while the ABS version takes over four times as as long!

Padders