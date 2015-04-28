libname eddata "/sscc/datasets/imc490/farm";
libname aaron "/sscc/home/r/ras303/sasuser.v94";

/* 1. reread contactinfo by enlarging guessingrows */

proc import datafile="/sscc/datasets/imc490/farm/FarmReachContactInfo.txt" DBMS=TAB OUT=contactinfo;
 DATAROW = 2; GUESSINGROWS = 500;
 run;
 
proc sort data=contactinfo out=aaron.contactinfo; by id; run;

 /* detect if dupkey problem exists */
 /*
proc print data=aaron.contactinfo (obs=200);
 where id  gt 10000000;
 run; 
 */

proc contents data=aaron.contactinfo;run;
proc print data=aaron.contactinfo (obs=20);run;
proc means data=aaron.contactinfo;run;

/* 2. reread contact practice by enlarging guessingrows */

proc import datafile="/sscc/datasets/imc490/farm/FarmReachContactPractice.txt" DBMS=TAB REPLACE OUT=contactpractice;
 DATAROW = 2; GUESSINGROWS = 100;
 run;

/*
proc print data=contactpractice (obs=20);run;
proc contents data=contactpractice; run;
*/

proc sort data=contactpractice out=aaron.contactpractice; by id; run;
proc print data=aaron.contactpractice (obs=20);run;
proc contents data=aaron.contactpractice; run;

/* 3. reread crop practice by enlarging guessingrows */

proc import datafile="/sscc/datasets/imc490/farm/FarmReachCropPractice.txt" DBMS=TAB REPLACE OUT=CropPractice;
 DATAROW = 2; GUESSINGROWS = 100;
 run;

proc sort data=CropPractice out=aaron.CropPractice; by id; run;
proc print data=aaron.CropPractice (obs=20); run;
proc contents data=aaron.CropPractice; run;


