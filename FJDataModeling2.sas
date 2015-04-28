libname aaron "/sscc/home/r/ras303/sasuser.v94";

PROC FORMAT; 

 VALUE train
 0 = "Test"
 1 = "Train"
;

run;

proc format;
value yesno
  0-<.5 = "no"
  .5-1 = "yes"
;
run;



data aaron.split;
 set aaron.commercial;
 
 train = ranuni(12345) < .5;
 Format train train.;
 
 run;
 
proc freq data=aaron.split;
 table FJ_cust;
 weight train;
 run;
 
/* first logistic with backwards and stepwise */

PROC LOGISTIC DATA=aaron.split descending;

MODEL FJ_Cust = FSAInd RetailerInd Miss_Contact S_Own_Operate  S_Own_Rent  S_Manager  G_Own_Operate  G_Own_Rent  G_Manager Own_Operate   Own_Rent  
Manager  Male  Promotable  Contact_r  Log_income  contact_r_pop  Log_Age   Email  Phone   Cellphone State_IL State_TX State_IA State_MN State_MO 
State_KS State_NE State_OH State_IN State_WI Num_Practice Num_Commn Num_Crop Corn_D Soybeans_D Wheat_D Hay_D Log_TotAcres_Crop Log_AvgAcres_Crop Log_Beets  
Log_Canola  Log_Corn  Log_Soybeans Log_Sorghum   Log_Alfalfa Log_Hay  Log_Cotton  Log_Tobacco  Log_Oats   Log_Rye  Log_Barley   Log_Rice  Log_DryBeans  Log_Sunflowers  
Log_Peanuts  Log_Potatoes   Log_Wheat Miss_Crop  Num_CropPractice  Miss_CropPrac Num_CropPractice 
Num_Stock Log_TotHead_Stock Log_AvgHead_Stock Num_Seed Log_TotAcres_seed Log_AvgAcres_Seed Comm_Farmer / rsquare selection=backward sls=0.05 sle=0.0;

Weight train;

run;

PROC LOGISTIC DATA=aaron.split descending;

MODEL FJ_Cust = FSAInd RetailerInd Miss_Contact S_Own_Operate  S_Own_Rent  S_Manager  G_Own_Operate  G_Own_Rent  G_Manager Own_Operate   Own_Rent  
Manager  Male  Promotable  Contact_r  Log_income  contact_r_pop  Log_Age   Email  Phone   Cellphone State_IL State_TX State_IA State_MN State_MO 
State_KS State_NE State_OH State_IN State_WI Num_Practice Num_Commn Num_Crop Corn_D Soybeans_D Wheat_D Hay_D Log_TotAcres_Crop Log_AvgAcres_Crop Log_Beets  
Log_Canola  Log_Corn  Log_Soybeans Log_Sorghum   Log_Alfalfa Log_Hay  Log_Cotton  Log_Tobacco  Log_Oats   Log_Rye  Log_Barley   Log_Rice  Log_DryBeans  Log_Sunflowers  
Log_Peanuts  Log_Potatoes   Log_Wheat Miss_Crop  Num_CropPractice  Miss_CropPrac Num_CropPractice 
Num_Stock Log_TotHead_Stock Log_AvgHead_Stock Num_Seed Log_TotAcres_seed Log_AvgAcres_Seed Comm_Farmer / rsquare selection=SCORE BEST=1;

Weight train;

run;

/* This model achieved 94% of classification rate, using 315892 cases */

PROC LOGISTIC DATA=aaron.split descending;

MODEL FJ_Cust = S_Own_Rent  Log_income Email State_IN Log_TotAcres_Crop Log_AvgAcres_Crop Log_Corn Log_Hay

/ rsquare;

Weight train;
OUTPUT out = logitout PREDICTED= yhat;
run;

/* GOOD */

PROC LOGISTIC DATA=aaron.split descending;
MODEL FJ_Cust = S_Own_Rent S_Manager Log_income Email State_IA State_OH State_IN Log_TotAcres_Crop Log_AvgAcres_Crop Log_Corn Log_Hay Log_Oats FSAInd  Miss_CropPrac

/ rsquare;

Weight train;
OUTPUT out = logitout PREDICTED= yhat;
run;

PROC LOGISTIC DATA=aaron.split descending;
MODEL FJ_Cust = S_Own_Rent S_Manager Log_income Email State_IA  State_IN Log_TotAcres_Crop Log_AvgAcres_Crop Log_Corn Log_Hay 

/ rsquare;

Weight train;
OUTPUT out = logitout PREDICTED= yhat;
run;


%gains (FJ_Cust,yhat,logitout(where=(train=0)));
%gains20 (FJ_Cust,yhat,logitout(where=(train=0)));


proc sort data=logitout;
  by train;
run;

proc freq data=logitout;
  by train;
  table FJ_Cust * yhat / norow nocol nopercent;
  format Yhat yesno.;
run;

/* LDA (91%) & QDA (91%) */

PROC DISCRIM DATA=aaron.split;
CLASS FJ_Cust;
VAR S_Own_Rent  Log_income Email State_IN Log_TotAcres_Crop Log_AvgAcres_Crop Log_Corn Log_Hay;

Weight train;

PRIORS PROPORTIONAL;

RUN;

PROC DISCRIM DATA=aaron.split pool=no;
CLASS FJ_Cust;
VAR S_Own_Rent S_Manager Log_income Email State_IA State_OH State_IN Log_TotAcres_Crop Log_AvgAcres_Crop Log_Corn Log_Hay Log_Oats FSAInd G_Manager Manager Miss_CropPrac;

Weight train;

PRIORS PROPORTIONAL;

RUN;

/* Cross-selling model */

data aaron.split2;
 set aaron.FJ_cust;
 
 train = ranuni(12345) < .5;
 Format train train.;
 
 run;

proc means data=aaron.split2 n nmiss; run;

proc freq data=aaron.split2 order=freq;
 table ProFarmer_Cst/ nocum; weight train; run;
 
/************************/
 
data aaron.split3;
 set aaron.CandJ;
 
 train = ranuni(12345) < .5;
 Format train train.;
 
 run;
 
proc freq data=aaron.CandJ order=freq;
 table ProFarmer_Cst Event_Cst/ nocum; run;
 
/* Profarmer Propensity and Monetary */

PROC LOGISTIC DATA=aaron.split2 descending;

MODEL ProFarmer_Cst =  FSO_Cust FS_r Log_FS_m FS_f FS_l MP FJ1 ProFarmer_Gst TpenMember AW_Cust AW_Visit AW_Session AW_BnE Log_AW_Time SilverPop_Num   Log_SilverPop_r  SilverPop_Cst Subscription_Cust  FarmJournal_Subs   DairyToday_Subs   
TopProducer_Subs  ImplementTractor_Subs   BeefToday_Subs   FarmJournal_Paid   DairyToday_Paid   TopProducer_Paid   ImplementTractor_Paid   BeefToday_Paid   PaidSubs_num Subscription_num CommodityUpdateInd 
Guest_Count  Ser_CornCol  Ser_TProdSem  Ser_PFA  Ser_ProfBrf  Ser_LegWS  EvenSeries_Pop   Corn_T  Eve_CornColCli  Eve_TProdSem  Eve_Soy  Event_Pop  Event_R Event_Cst
FSAInd RetailerInd Miss_Contact S_Own_Operate  S_Own_Rent  S_Manager  G_Own_Operate  G_Own_Rent  G_Manager Own_Operate   Own_Rent  
Manager  Male  Promotable  Contact_r  Log_income  contact_r_pop  Log_Age   Email  Phone   Cellphone State_IL State_TX State_IA State_MN State_MO 
State_KS State_NE State_OH State_IN State_WI Num_Practice Num_Commn Num_Crop Corn_D Soybeans_D Wheat_D Hay_D Log_TotAcres_Crop Log_AvgAcres_Crop Log_Beets  
Log_Canola  Log_Corn  Log_Soybeans Log_Sorghum   Log_Alfalfa Log_Hay  Log_Cotton  Log_Tobacco  Log_Oats   Log_Rye  Log_Barley   Log_Rice  Log_DryBeans  Log_Sunflowers  
Log_Peanuts  Log_Potatoes   Log_Wheat Miss_Crop  Num_CropPractice  Miss_CropPrac Num_CropPractice 

/ rsquare selection=backward sls=0.001 sle=0.001;

Weight train;

run;

PROC LOGISTIC DATA=aaron.split2 descending;

MODEL ProFarmer_Cst =  FSO_Cust FS_r Log_FS_m FS_f FS_l MP FJ1 ProFarmer_Gst TpenMember AW_Cust AW_Visit AW_Session AW_BnE Log_AW_Time SilverPop_Num   Log_SilverPop_r  SilverPop_Cst Subscription_Cust  FarmJournal_Subs   DairyToday_Subs   
TopProducer_Subs  ImplementTractor_Subs   BeefToday_Subs   FarmJournal_Paid   DairyToday_Paid   TopProducer_Paid   ImplementTractor_Paid   BeefToday_Paid   PaidSubs_num Subscription_num CommodityUpdateInd 
Guest_Count  Ser_CornCol  Ser_TProdSem  Ser_PFA  Ser_ProfBrf  Ser_LegWS  EvenSeries_Pop   Corn_T  Eve_CornColCli  Eve_TProdSem  Eve_Soy  Event_Pop  Event_R Event_Cst
FSAInd RetailerInd Miss_Contact S_Own_Operate  S_Own_Rent  S_Manager  G_Own_Operate  G_Own_Rent  G_Manager Own_Operate   Own_Rent  
Manager  Male  Promotable  Contact_r  Log_income  contact_r_pop  Log_Age   Email  Phone   Cellphone State_IL State_TX State_IA State_MN State_MO 
State_KS State_NE State_OH State_IN State_WI Num_Practice Num_Commn Num_Crop Corn_D Soybeans_D Wheat_D Hay_D Log_TotAcres_Crop Log_AvgAcres_Crop Log_Beets  
Log_Canola  Log_Corn  Log_Soybeans Log_Sorghum   Log_Alfalfa Log_Hay  Log_Cotton  Log_Tobacco  Log_Oats   Log_Rye  Log_Barley   Log_Rice  Log_DryBeans  Log_Sunflowers  
Log_Peanuts  Log_Potatoes   Log_Wheat Miss_Crop  Num_CropPractice  Miss_CropPrac Num_CropPractice 

/ rsquare selection=stepwise sls=0.001 sle=0.001;

Weight train;

run;

PROC LOGISTIC DATA=aaron.split2 descending;

MODEL ProFarmer_Cst =  FSO_Cust FS_r Log_FS_m FS_f FS_l MP FJ1 ProFarmer_Gst TpenMember AW_Cust AW_Visit AW_Session AW_BnE Log_AW_Time SilverPop_Num   Log_SilverPop_r  SilverPop_Cst Subscription_Cust  FarmJournal_Subs   DairyToday_Subs   
TopProducer_Subs  ImplementTractor_Subs   BeefToday_Subs   FarmJournal_Paid   DairyToday_Paid   TopProducer_Paid   ImplementTractor_Paid   BeefToday_Paid   PaidSubs_num Subscription_num CommodityUpdateInd 
Guest_Count  Ser_CornCol  Ser_TProdSem  Ser_PFA  Ser_ProfBrf  Ser_LegWS  EvenSeries_Pop   Corn_T  Eve_CornColCli  Eve_TProdSem  Eve_Soy  Event_Pop  Event_R Event_Cst
FSAInd RetailerInd Miss_Contact S_Own_Operate  S_Own_Rent  S_Manager  G_Own_Operate  G_Own_Rent  G_Manager Own_Operate   Own_Rent  
Manager  Male  Promotable  Contact_r  Log_income  contact_r_pop  Log_Age   Email  Phone   Cellphone State_IL State_TX State_IA State_MN State_MO 
State_KS State_NE State_OH State_IN State_WI Num_Practice Num_Commn Num_Crop Corn_D Soybeans_D Wheat_D Hay_D Log_TotAcres_Crop Log_AvgAcres_Crop Log_Beets  
Log_Canola  Log_Corn  Log_Soybeans Log_Sorghum   Log_Alfalfa Log_Hay  Log_Cotton  Log_Tobacco  Log_Oats   Log_Rye  Log_Barley   Log_Rice  Log_DryBeans  Log_Sunflowers  
Log_Peanuts  Log_Potatoes   Log_Wheat Miss_Crop  Num_CropPractice  Miss_CropPrac Num_CropPractice 

/ rsquare selection=score best=1;

Weight train;

run;

/* final logistic */

PROC LOGISTIC DATA=aaron.split2 descending;

MODEL ProFarmer_Cst =  Log_FS_m ProFarmer_Gst SilverPop_Num Log_SilverPop_r SilverPop_Cst   TopProducer_Subs  FarmJournal_Paid CommodityUpdateInd Event_R Event_Cst FSAInd G_Own_Operate Own_Operate Own_Rent 
Manager Male Promotable Contact_r Log_income contact_r_pop Log_Age Email Cellphone State_IL State_TX State_IA State_MN State_MO State_KS State_NE State_OH State_IN State_WI Num_Practice Num_Commn Num_Crop Corn_D Hay_D 
Log_AvgAcres_Crop Log_Corn Log_Soybeans Log_Alfalfa Log_Cotton Log_Tobacco Log_Rice Log_Wheat Num_CropPractice Subscription_num Log_Sorghum 

/ rsquare;

Weight train;
OUTPUT out = logitout PREDICTED= phat;
run;

%gains (ProFarmer_Cst,phat,logitout(where=(train=0)));
%gains20 (ProFarmer_Cst,phat,logitout(where=(train=0)));

proc sort data=logitout;
  by train;
run;

proc freq data=logitout;
  by train;
  table ProFarmer_Cst * phat / norow nocol nopercent;
  format phat yesno.;
run;


PROC DISCRIM DATA=aaron.split2;
CLASS ProFarmer_Cst;
VAR Log_FS_m ProFarmer_Gst SilverPop_Num Log_SilverPop_r SilverPop_Cst   TopProducer_Subs  FarmJournal_Paid CommodityUpdateInd Event_R Event_Cst FSAInd G_Own_Operate Own_Operate Own_Rent 
Manager Male Promotable Contact_r Log_income contact_r_pop Log_Age Email Cellphone State_IL State_TX State_IA State_MN State_MO State_KS State_NE State_OH State_IN State_WI Num_Practice Num_Commn Num_Crop Corn_D Hay_D 
Log_AvgAcres_Crop Log_Corn Log_Soybeans Log_Alfalfa Log_Cotton Log_Tobacco Log_Rice Log_Wheat Num_CropPractice Subscription_num Log_Sorghum;

Weight train;

PRIORS PROPORTIONAL;

RUN;

PROC DISCRIM DATA=aaron.split2 pool=no;
CLASS ProFarmer_Cst;
VAR Log_FS_m ProFarmer_Gst SilverPop_Num Log_SilverPop_r SilverPop_Cst   TopProducer_Subs  FarmJournal_Paid CommodityUpdateInd Event_R Event_Cst FSAInd G_Own_Operate Own_Operate Own_Rent 
Manager Male Promotable Contact_r Log_income contact_r_pop Log_Age Email Cellphone State_IL State_TX State_IA State_MN State_MO State_KS State_NE State_OH State_IN State_WI Num_Practice Num_Commn Num_Crop Corn_D Hay_D 
Log_AvgAcres_Crop Log_Corn Log_Soybeans Log_Alfalfa Log_Cotton Log_Tobacco Log_Rice Log_Wheat Num_CropPractice Subscription_num Log_Sorghum;

Weight train;

PRIORS PROPORTIONAL;

RUN;

/* profarmer customer spend */


PROC reg DATA=aaron.split2 ;

MODEL Log_PF_m =  FSO_Cust FS_r Log_FS_m FS_f FS_l MP FJ1 ProFarmer_Gst TpenMember AW_Cust AW_Visit AW_Session AW_BnE Log_AW_Time SilverPop_Num   Log_SilverPop_r  SilverPop_Cst Subscription_Cust  FarmJournal_Subs   DairyToday_Subs   
TopProducer_Subs  ImplementTractor_Subs   BeefToday_Subs   FarmJournal_Paid   DairyToday_Paid   TopProducer_Paid   ImplementTractor_Paid   BeefToday_Paid   PaidSubs_num Subscription_num CommodityUpdateInd 
Guest_Count  Ser_CornCol  Ser_TProdSem  Ser_PFA  Ser_ProfBrf  Ser_LegWS  EvenSeries_Pop   Corn_T  Eve_CornColCli  Eve_TProdSem  Eve_Soy  Event_Pop  Event_R Event_Cst
FSAInd RetailerInd Miss_Contact S_Own_Operate  S_Own_Rent  S_Manager  G_Own_Operate  G_Own_Rent  G_Manager Own_Operate   Own_Rent  
Manager  Male  Promotable  Contact_r  Log_income  contact_r_pop  Log_Age   Email  Phone   Cellphone State_IL State_TX State_IA State_MN State_MO 
State_KS State_NE State_OH State_IN State_WI Num_Practice Num_Commn Num_Crop Corn_D Soybeans_D Wheat_D Hay_D Log_TotAcres_Crop Log_AvgAcres_Crop Log_Beets  
Log_Canola  Log_Corn  Log_Soybeans Log_Sorghum   Log_Alfalfa Log_Hay  Log_Cotton  Log_Tobacco  Log_Oats   Log_Rye  Log_Barley   Log_Rice  Log_DryBeans  Log_Sunflowers  
Log_Peanuts  Log_Potatoes   Log_Wheat Miss_Crop  Num_CropPractice  Miss_CropPrac  

/  selection=stepwise sls=0.01 sle=0.01;

Weight train;

run;

/* T1 */

PROC reg DATA=aaron.split2 ;

MODEL Log_PF_m =  ProFarmer_Gst Event_R Log_FS_m FSAInd Log_Hay AW_Cust TopProducer_Subs DairyToday_Subs G_Manager FSO_Cust  State_IA Wheat_D State_IL 
State_MO State_OH State_IN Log_Corn State_TX State_KS  Ser_LegWS TpenMember FJ1 G_Own_Operate Own_Operate AW_BnE EvenSeries_Pop Ser_CornCol Log_Cotton 
Log_Soybeans Log_Age Log_Barley Log_Sunflowers Num_Crop BeefToday_Subs S_Manager Log_Beets Log_Alfalfa Log_DryBeans Eve_TProdSem Ser_TProdSem
 FS_l FS_r SilverPop_Num Num_CropPractice SilverPop_Cst Subscription_Cust CirculationInd;

Weight train;
OUTPUT out = regout PREDICTED= yhat;

run;

%gains (PF_m,yhat,regout(where=(train=0)));

/* T2 */

PROC reg DATA=aaron.split2 ;

MODEL Log_PF_m =  ProFarmer_Gst Event_R Log_FS_m FSAInd Log_Hay AW_Cust TopProducer_Subs DairyToday_Subs G_Manager FSO_Cust State_WI State_IA State_MN 
Wheat_D State_IL State_MO State_NE State_OH State_IN Log_Corn State_TX State_KS Log_income Ser_LegWS TpenMember FJ1 G_Own_Operate Own_Operate AW_BnE 
EvenSeries_Pop Ser_CornCol Log_Cotton Log_Soybeans Log_Age Log_Barley Log_Sunflowers Log_Wheat Num_Crop BeefToday_Subs S_Manager Log_Beets Log_Rice 
Log_Tobacco Log_Alfalfa Log_DryBeans Eve_TProdSem Ser_TProdSem FS_l FS_r SilverPop_Num Num_CropPractice;

Weight train;
OUTPUT out = regout PREDICTED= yhat;

run;

%gains (PF_m,yhat,regout(where=(train=0)));

/* T3 take this, use this for 2 steps */

PROC GLMSELECT DATA=aaron.split2;

MODEL Log_PF_m =  ProFarmer_Gst Event_R Log_FS_m Log_Hay AW_Cust G_Manager FSO_Cust  Wheat_D Log_Corn State_TX State_KS Log_income Ser_LegWS TpenMember FJ1 G_Own_Operate Own_Operate AW_BnE 
EvenSeries_Pop Ser_CornCol Log_Cotton Log_Soybeans Log_Age Num_Crop BeefToday_Subs S_Manager Log_Beets Log_Rice 
Log_Tobacco Log_Alfalfa Log_DryBeans Eve_TProdSem Ser_TProdSem FS_l FS_r SilverPop_Num Num_CropPractice

/ SELECTION=LASSO;

Weight train;
OUTPUT out = regout PREDICTED= yhat;

RUN;


%gains (PF_m,yhat,regout(where=(train=0)));
%gains100 (PF_m,yhat,regout(where=(train=0)));

/* T4 */

PROC GLMSELECT DATA=aaron.split2;

MODEL Log_PF_m =  

ProFarmer_Cst FSO_Cust ProFarmer_Gst TpenMember AW_Cust SilverPop_Cst SilverPop_Num Log_SilverPop_r Subscription_Cust Subscription_num PaidSubs_num
CommodityUpdateInd Event_Cst Event_R CirculationInd State_IL State_TX State_IA State_MN Num_Practice Miss_Practice Miss_Preference 
Num_Crop Log_AvgAcres_Crop Num_CropPractice Num_Stock Log_TotHead_Stock Log_AvgHead_Stock Log_TotAcres_seed  Log_AvgAcres_Seed Num_Seed

/ SELECTION=LASSO;

Weight train;
OUTPUT out = regout PREDICTED= yhat;

%gains (PF_m,yhat,regout(where=(train=0)));
%gains20 (PF_m,yhat,regout(where=(train=0)));

RUN;

/* Event Classifier */

PROC LOGISTIC DATA=aaron.split2 descending;

MODEL Event_Cst =  FSO_Cust FS_r Log_FS_m FS_f FS_l MP FJ1 ProFarmer_Gst TpenMember AW_Cust AW_Visit AW_Session AW_BnE Log_AW_Time SilverPop_Num   Log_SilverPop_r  SilverPop_Cst Subscription_Cust  FarmJournal_Subs   DairyToday_Subs   
TopProducer_Subs  ImplementTractor_Subs   BeefToday_Subs   FarmJournal_Paid   DairyToday_Paid   TopProducer_Paid   ImplementTractor_Paid   BeefToday_Paid   PaidSubs_num Subscription_num CommodityUpdateInd 
ProFarmer_Cst PF_r Log_PF_f Log_PF_m PF_l classic preferred
FSAInd RetailerInd Miss_Contact S_Own_Operate  S_Own_Rent  S_Manager  G_Own_Operate  G_Own_Rent  G_Manager Own_Operate   Own_Rent  
Manager  Male  Promotable  Contact_r  Log_income  contact_r_pop  Log_Age   Email  Phone   Cellphone State_IL State_TX State_IA State_MN State_MO 
State_KS State_NE State_OH State_IN State_WI Num_Practice Num_Commn Num_Crop Corn_D Soybeans_D Wheat_D Hay_D Log_TotAcres_Crop Log_AvgAcres_Crop Log_Beets  
Log_Canola  Log_Corn  Log_Soybeans Log_Sorghum   Log_Alfalfa Log_Hay  Log_Cotton  Log_Tobacco  Log_Oats   Log_Rye  Log_Barley   Log_Rice  Log_DryBeans  Log_Sunflowers  
Log_Peanuts  Log_Potatoes   Log_Wheat Miss_Crop  Num_CropPractice  Miss_CropPrac Num_CropPractice 

/ rsquare selection=stepwise sls=0.001 sle=0.001;

Weight train;

run;

PROC LOGISTIC DATA=aaron.split2 descending;

MODEL Event_Cst =  FSO_Cust FS_r Log_FS_m FS_f FS_l MP FJ1 ProFarmer_Gst TpenMember AW_Cust AW_Visit AW_Session AW_BnE Log_AW_Time SilverPop_Num   Log_SilverPop_r  SilverPop_Cst Subscription_Cust  FarmJournal_Subs   DairyToday_Subs   
TopProducer_Subs  ImplementTractor_Subs   BeefToday_Subs   FarmJournal_Paid   DairyToday_Paid   TopProducer_Paid   ImplementTractor_Paid   BeefToday_Paid   PaidSubs_num Subscription_num CommodityUpdateInd 
ProFarmer_Cst PF_r Log_PF_f Log_PF_m PF_l classic preferred
FSAInd RetailerInd Miss_Contact S_Own_Operate  S_Own_Rent  S_Manager  G_Own_Operate  G_Own_Rent  G_Manager Own_Operate   Own_Rent  
Manager  Male  Promotable  Contact_r  Log_income  contact_r_pop  Log_Age   Email  Phone   Cellphone State_IL State_TX State_IA State_MN State_MO 
State_KS State_NE State_OH State_IN State_WI Num_Practice Num_Commn Num_Crop Corn_D Soybeans_D Wheat_D Hay_D Log_TotAcres_Crop Log_AvgAcres_Crop Log_Beets  
Log_Canola  Log_Corn  Log_Soybeans Log_Sorghum   Log_Alfalfa Log_Hay  Log_Cotton  Log_Tobacco  Log_Oats   Log_Rye  Log_Barley   Log_Rice  Log_DryBeans  Log_Sunflowers  
Log_Peanuts  Log_Potatoes   Log_Wheat Miss_Crop  Num_CropPractice  Miss_CropPrac Num_CropPractice 

/ rsquare selection=backward sls=0.001 sle=0.001;

Weight train;

run;

/* Final Run */

PROC LOGISTIC DATA=aaron.split2 descending;

MODEL Event_Cst = 

AW_Cust SilverPop_Num Log_SilverPop_r  BeefToday_Subs   CommodityUpdateInd ProFarmer_Cst PF_r FSAInd contact_r_pop Log_Age Email State_TX State_IA State_KS 
State_NE Num_Practice Soybeans_D Hay_D Log_AvgAcres_Crop Log_Corn Log_Barley Log_Wheat Log_income State_IL State_MN State_IN 

/ rsquare;

Weight train;
OUTPUT out = logitout PREDICTED= yhat;
run;

%gains (Event_Cst,yhat,logitout(where=(train=0)));
%gains20 (Event_Cst,yhat,logitout(where=(train=0)));

proc sort data=logitout;
  by train;
run;

proc freq data=logitout;
  by train;
  table Event_Cst * yhat / norow nocol nopercent;
  format yhat yesno.;
run;

/* Subscription Classifier */

PROC LOGISTIC DATA=aaron.split2 descending;

MODEL Subscription_Cust =  FSO_Cust FS_r Log_FS_m FS_f FS_l MP FJ1 ProFarmer_Gst TpenMember AW_Cust AW_Visit AW_Session AW_BnE Log_AW_Time SilverPop_Num   Log_SilverPop_r  SilverPop_Cst  CommodityUpdateInd 
ProFarmer_Cst PF_r Log_PF_f Log_PF_m PF_l classic preferred
Guest_Count  Ser_CornCol  Ser_TProdSem  Ser_PFA  Ser_ProfBrf  Ser_LegWS  EvenSeries_Pop   Corn_T  Eve_CornColCli  Eve_TProdSem  Eve_Soy  Event_Pop  Event_R Event_Cst
FSAInd RetailerInd Miss_Contact S_Own_Operate  S_Own_Rent  S_Manager  G_Own_Operate  G_Own_Rent  G_Manager Own_Operate   Own_Rent  
Manager  Male  Promotable  Contact_r  Log_income  contact_r_pop  Log_Age   Email  Phone   Cellphone State_IL State_TX State_IA State_MN State_MO 
State_KS State_NE State_OH State_IN State_WI Num_Practice Num_Commn Num_Crop Corn_D Soybeans_D Wheat_D Hay_D Log_TotAcres_Crop Log_AvgAcres_Crop Log_Beets  
Log_Canola  Log_Corn  Log_Soybeans Log_Sorghum   Log_Alfalfa Log_Hay  Log_Cotton  Log_Tobacco  Log_Oats   Log_Rye  Log_Barley   Log_Rice  Log_DryBeans  Log_Sunflowers  
Log_Peanuts  Log_Potatoes   Log_Wheat Miss_Crop  Num_CropPractice  Miss_CropPrac Num_CropPractice 

/ rsquare selection=stepwise sls=0.001 sle=0.001;

Weight train;

run;

PROC LOGISTIC DATA=aaron.split2 descending;

MODEL Subscription_Cust = 

SilverPop_Num CommodityUpdateInd FSAInd S_Own_Operate S_Own_Rent G_Own_Operate G_Own_Rent G_Manager Own_Rent Manager Promotable Contact_r Log_income contact_r_pop Email Phone 
Cellphone State_NE State_IN State_WI Num_Practice Num_Commn Num_Crop Corn_D Soybeans_D Wheat_D Hay_D Log_TotAcres_Crop Log_AvgAcres_Crop Log_Beets Log_Canola Log_Corn Log_Soybeans Log_Sorghum Log_Alfalfa 
Log_Hay Log_Cotton Log_Tobacco Log_Oats Log_Rye Log_Barley Log_Rice Log_DryBeans Log_Sunflowers Log_Peanuts Log_Potatoes Log_Wheat Num_CropPractice

/ rsquare;

Weight train;
OUTPUT out = logitout PREDICTED= yhat;
run;

%gains (Subscription_Cust,yhat,logitout(where=(train=0)));
%gains20 (Subscription_Cust,yhat,logitout(where=(train=0)));

proc sort data=logitout;
  by train;
run;

proc freq data=logitout;
  by train;
  table Subscription_Cust * yhat / norow nocol nopercent;
  format yhat yesno.;
run;


