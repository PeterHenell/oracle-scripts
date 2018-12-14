CREATE TABLE envReport (
   reportID NUMBER,
   source VARCHAR2(1000));

CREATE TABLE violations (
   reportID NUMBER,
   reportedOn DATE,
   reportedBy VARCHAR2(100),
   incident VARCHAR2(4000));

CREATE TABLE nextSteps (
   reportID NUMBER,
   actionType VARCHAR2(100),
   action VARCHAR2(4000));
