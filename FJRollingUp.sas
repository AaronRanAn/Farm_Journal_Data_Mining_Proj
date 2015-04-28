libname eddata "/sscc/datasets/imc490/farm";

libname aaron "/sscc/home/r/ras303/sasuser.v94";

/* Profarmer Order */

proc contents data=aaron.Profarmerorder;
proc print data=aaron.Profarmerorder (obs=200);
proc means data=aaron.Profarmerorder;
run;

/* Profarmer Order Product */

proc contents data=aaron.profarmerorderproduct;
proc print data=aaron.profarmerorderproduct (obs=200);
proc means data=aaron.profarmerorderproduct;
run;

/* What did they order? */

proc freq data=aaron.profarmerorderproduct order=freq;
	table productname / nocum;
	run;
	
/* Rollup Product -> Order */

proc sort data=aaron.profarmerorderproduct out=profarmerorderproduct; by OrderID; 

proc print data=profarmerorderproduct (obs=100); run;

data aaron.PFProd_roll;
 set profarmerorderproduct;
 by OrderID;
 
  if productname="Classic" then Classic=1; else Classic=0;
  if productname="Preferred" then Preferred=1; else Preferred=0;
 
 retain Classic_f Preferred_f;
 
 if First.OrderID then do;
 Classic_f= 0;
 Preferred_f = 0;
 end;
 
 Classic_f= Classic_f + Classic;
 Preferred_f = Preferred_f + Preferred;
 
  if Last.OrderID;
  Keep OrderID Classic_f Preferred_f;
  
 run;
  
Proc print data=aaron.PFProd_roll (obs=500); run;

/* Merge back to Profarmer Order */

proc sort data=aaron.PFProd_roll out=PFProd_roll; by OrderID; run;
/* proc print data=PFProd_roll (obs=20);run; */

proc sort data=aaron.profarmerorder out=profarmerorder; by OrderID; run;
/* proc print data=profarmerorder (obs=20);run; */

data aaron.PFord_merge;
 merge profarmerorder (in=a) PFProd_roll (in=b);
 by OrderID;
 if a;
 keep ID OrderID OrderDate TotalPaid Classic_f Preferred_f;
 run;
 
proc print data=aaron.PFord_merge (obs=20);run; 

/* Roll up to Cust lvl */

proc sort data=aaron.PFord_merge out=aaron.PFord_merge; by ID; run;

/* proc print data=aaron.PFord_merge (obs=200);run; */
/* proc means data=aaron.PFord_merge n nmiss; run; */
/* proc contents data=aaron.PFord_merge; run; */

data aaron.PFord_merge; /* extra the date out of datetime */
 set aaron.PFord_merge;
 OrdDate = datepart(orderdate);
 
 format orddate mmddyy10.;
 
 keep ID OrdDate TotalPaid Classic_f preferred_f;
 run;
 
/* proc print date=aaron.PFord_merge (obs=20); run; */
/* proc means data=aaron.PFord_merge; run; */

data aaron.PFCust;
 set aaron.PFord_merge;
 by ID;
 
 PF_Cust = 1;
 
 retain PF_r PF_f PF_m PF_l classic preferred;
 
 If first.ID then do;
 PF_r= .;
 PF_l= 9999999;
 PF_f= 0;
 PF_m= 0;
 classic= 0;
 preferred =0;

 End;
 
 diff= 20061 - OrdDate;
 IF PF_r=. OR diff<PF_r THEN PF_r=diff;
 IF PF_l=9999999 or diff>PF_l then PF_l=diff;
 
 PF_f = PF_f + 1;
 PF_m = PF_m + TotalPaid;
 classic = classic + classic_f;
 preferred = preferred + preferred_f;
 
 If last.ID;
 Keep ID PF_r PF_f PF_m PF_l classic preferred PF_Cust;
 
run;

data aaron.PFCust;
 set aaron.PFCust;
 
 if classic = . then classic = 0;
 if preferred = . then preferred = 0;
 
 run;
 
proc print data=aaron.PFCust (obs=20); run;
proc contents data=aaron.PFord_merge; run;
proc means data=aaron.PFCust; run;

/* Roll up FSO to Cust lvl */

/*
proc contents data=aaron.FSO;
proc print data=aaron.FSO (obs=500);
proc means data=aaron.FSO n nmiss;
run;

proc freq data=aaron.FSO order=freq;
	table ProductReference / nocum;
	run;
*/

/* Fix date and add popular product */

data FSO_fix;
 set aaron.FSO;
 
 if ID = . then delete;
 
 Orderdate = datepart(OrderItemCreateDate);
 if ProductReference ="Machinery Pete's 2014 Classic Tractor Price Guide" then MP_f=1; else MP_f=0;
 if ProductReference ="Farm Journal Magazine 1-Year Subscription" then FJ1_f=1; else FJ1_f=0;
 
 keep ID OrderTotal Orderdate PhoneInd EmailInd MP_f FJ1_f;
 format Orderdate mmddyy10.;
 
 run;


proc print data=FSO_fix (obs=30);run;
proc means data=FSO_fix;run;
proc contents data=FSO_fix;run;


data aaron.FSOCust;
 set FSO_fix;
 by ID;

 FSO_Cust = 1;
 EmailInd_FSO = EmailInd;
 PhoneInd_FSO = PhoneInd;
 
 retain FS_r FS_f FS_m FS_l MP FJ1;
 
 If first.ID then do;
 FS_r= .;
 FS_l= 999999;
 FS_f= 0;
 FS_m= 0;
 MP= 0;
 FJ1 =0;

 End;
 
 diff= 19975 - Orderdate;
 IF FS_r=. OR diff<FS_r THEN FS_r=diff;
 IF FS_l=999999 or FS_l<diff then FS_l=diff;
 
 FS_f = FS_f + 1;
 FS_m = FS_m + OrderTotal;
 MP = MP + MP_f;
 FJ1 = FJ1 + FJ1_f;
 
 If last.ID;
 Keep ID FS_r FS_f FS_m FS_l MP FJ1 EmailInd_FSO PhoneInd_FSO FSO_Cust;
 
 run;

 proc print data=aaron.FSOCust (obs=30);run;
 proc means data=aaron.FSOCust;run;
 proc contents data=aaron.FSOCust;run;


/* Roll Up Agweb Traffic to Cust Level */

proc contents data=aaron.ADWEB;
proc print data=aaron.ADWEB (obs=100);
proc means data=aaron.ADWEB;
run;

PROC SGPLOT DATA=aaron.ADWEB; HISTOGRAM __Exit;
RUN;

PROC SGPLOT DATA=aaron.ADWEB; HISTOGRAM Bounce_Rate;
RUN;

data test1;
 set aaron.ADWEB;
 
  AW_BE = Bounce_Rate + __Exit;
 
 run;

proc print data=test1 (obs=20);run;

data aaron.ADWEB;
 set test1;
 by FRID;
 
 AW_Cust = 1;

 retain AW_Visit AW_Session AW_Time AW_BnE2 AW_BnE;
 
 If first.FRID then do;
 AW_Visit = 0;
 AW_Session = 0;
 AW_Time = 0;
 AW_BnE2 = 0; AW_BnE = 0;
 End;
 
 AW_Visit = AW_Visit + 1;
 AW_Session = AW_Session + Unique_Pageviews;
 AW_Time = AW_time + Avg__Time_on_Page;
 AW_BnE2 = AW_BnE2 + AW_BE;
 AW_BnE = AW_BnE2/AW_Visit;
 
 If last.FRID;
 Keep FRID AW_Visit AW_Session AW_Time AW_Cust AW_BnE;
 Rename FRID = ID;
 
run;

proc print data=aaron.ADWEB(obs=20);run;



