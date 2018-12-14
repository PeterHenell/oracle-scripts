REM Invoke jpub to generate classes for Account_t object type

CALL setpath.bat

jpub -user=scott/tiger -typefile=myAcct.in -dir=. -mapping=oracle -package=datacraft.bill
