libname eddata "/sscc/datasets/imc490/farm";

libname aaron "/sscc/home/r/ras303/sasuser.v94";


/* Split Data into Training & Testing Sets */

PROC FORMAT; 

 VALUE train
 0 = "Test"
 1 = "Train"
;

RUN;

data aaron.split;
 set aaron.commercial;
 
 train = ranuni(12345) < .5;
 Format train train.;
 
 run;
 
proc print data=aaron.split (obs=20); run;

/* Multiple Regression on random vars */

proc reg data=aaron.split;

model Log_PF_m = 
ProFarmer_Cst  PF_r Log_PF_f Log_PF_m PF_l classic preferred FSO_Cust FS_r Log_FS_m FS_f FS_l MP FJ1  ProFarmer_Gst
TpenMember AW_Cust AW_Visit AW_Session AW_BnE Log_AW_Time Legacy_R  Moneywise_R  TOA_R  ThirdParty_R  Weekend_R  Cattle_Exchange_R  DTEU_R    BeefToday_R   SilverPop_Num   Log_SilverPop_r   SilverPop_Cst
Subscription_Cust  FarmJournal_Subs   DairyToday_Subs   TopProducer_Subs  ImplementTractor_Subs   BeefToday_Subs   FarmJournal_Paid   DairyToday_Paid   TopProducer_Paid   ImplementTractor_Paid   BeefToday_Paid   PaidSubs_num Subscription_num
CommodityUpdateInd ScheduleID  Promo_FJM  Promo_PHI  Promo_CUI   Spon_CU   Spon_2PIO   Spon_IND   PCS_CU PCS_CP  PCS_AP   PWS_CU  PWS_LS   PWS_WF   Schedule357   Schedule37   Schedule10
Guest_Count  Ser_CornCol  Ser_TProdSem  Ser_PFA  Ser_ProfBrf  Ser_LegWS  EvenSeries_Pop   Corn_T  Eve_CornColCli  Eve_TProdSem  Eve_Soy  Event_Pop  Event_R Event_Cst
CirculationInd   FSAInd  RetailerInd    FJ_Sub FJ_Cust Miss_Contact S_Own_Operate  S_Own_Rent  S_Manager  G_Own_Operate  G_Own_Rent  G_Manager Own_Operate   Own_Rent  Manager  Male  Promotable  Contact_r  Log_income  contact_r_pop  Log_Age   Email  Phone   Cellphone
GPS_D  DTN_D  FnO_D   Internet_D  MarketAdvice_D  Computer_D  Succession_D  NewTech_D   VP_D   Email_D   SellSeed_D   Num_Practice Miss_Practice
NoPromo   NoRent  ByPhone   ByMail  ByHighDate   ByEmail   ByFax  RentEmail ByCellPhone   RentAddress   RentPhone   Num_Commn  Miss_Preference
Num_Crop  Corn_D  Soybeans_D Wheat_D   Hay_D  Miss_Crop
Log_TotAcres_Crop   Log_AvgAcres_Crop   Log_Beets  Log_Canola  Log_Corn  Log_Soybeans Log_Sorghum   Log_Alfalfa Log_Hay  Log_Cotton  Log_Tobacco  Log_Oats   Log_Rye  Log_Barley   Log_Rice  Log_DryBeans  Log_Sunflowers  Log_Peanuts  Log_Potatoes   Log_Wheat
MinNoTillage_D  Irrigation_D  SeedTreatments_D  Fungicides_D  Num_CropPractice  Miss_CropPrac 
Num_Stock  CowCalves_D   Dairy_D  Log_TotHead_Stock  Log_AvgHead_Stock  Log_Hogs   Log_Sows  Log_Dairy  Log_CowCalves  Log_Stockers  Log_FedBeef  Log_Horses  Log_HeifersTotal  Log_M_CowCalves  Log_M_FedBeef  Log_M_Dairy  Log_Beef   Miss_Stock   Miss_MRDS  MRDSLiveStockInd
Num_Seed  Pioneer_D  Dekalb_D  Log_Dekalb  Log_Garst  Log_GoldenHarvest  Log_Mycogen   Log_NK  Log_Pioneer  Log_Other  Log_Becks  Log_Burrus  Log_DairyLand  Log_Doeblers  Log_Hoegenmeyer  Log_NuTech  Log_Terral  Log_Triumph  Log_Wyffels  Log_TotAcres_seed  Log_AvgAcres_Seed   Miss_Seed

 / selection = stepwise;

weight train;             
OUTPUT OUT=regout RESIDUAL=ehat;
RUN;  

/* failed because of too much missing value */

proc reg data=aaron.split;

model Log_PF_m = 
ProFarmer_Cst  PF_r Log_PF_f  PF_l classic preferred ProFarmer_Gst
TpenMember AW_Cust Legacy_R  Moneywise_R  TOA_R  ThirdParty_R  Weekend_R  Cattle_Exchange_R  DTEU_R    BeefToday_R   SilverPop_Num   Log_SilverPop_r   SilverPop_Cst
Subscription_Cust  FarmJournal_Subs   DairyToday_Subs   TopProducer_Subs  ImplementTractor_Subs   BeefToday_Subs   FarmJournal_Paid   DairyToday_Paid   TopProducer_Paid   ImplementTractor_Paid   BeefToday_Paid   PaidSubs_num Subscription_num
CommodityUpdateInd ScheduleID  Promo_FJM  Promo_PHI  Promo_CUI   Spon_CU   Spon_PIO   Spon_IND   PCS_CU PCS_CP  PCS_AP   PWS_CU  PWS_LS   PWS_WF   Schedule357   Schedule37   Schedule10
Event_Cst
CirculationInd   FSAInd  RetailerInd FJ_Sub FJ_Cust Miss_Contact Own_Operate   Own_Rent  Manager  Male  Promotable  Contact_r  Log_income  contact_r_pop  Log_Age   Email  Phone   Cellphone
GPS_D  DTN_D  FnO_D   Internet_D  MarketAdvice_D  Computer_D  Succession_D  NewTech_D   VP_D   Email_D   SellSeed_D   Num_Practice Miss_Practice
NoPromo   NoRent  ByPhone   ByMail  ByHighDate   ByEmail   ByFax  RentEmail ByCellPhone   RentAddress   RentPhone   Num_Commn  Miss_Preference
Num_Crop  Corn_D  Soybeans_D Wheat_D   Hay_D  Miss_Crop
Log_TotAcres_Crop   Log_AvgAcres_Crop   Log_Beets  Log_Canola  Log_Corn  Log_Soybeans Log_Sorghum   Log_Alfalfa Log_Hay  Log_Cotton  Log_Tobacco  Log_Oats   Log_Rye  Log_Barley   Log_Rice  Log_DryBeans  Log_Sunflowers  Log_Peanuts  Log_Potatoes   Log_Wheat
MinNoTillage_D  Irrigation_D  SeedTreatments_D  Fungicides_D  Num_CropPractice  Miss_CropPrac 
Num_Stock  CowCalves_D   Dairy_D  Log_TotHead_Stock  Log_AvgHead_Stock  Log_Hogs   Log_Sows  Log_Dairy  Log_CowCalves  Log_Stockers  Log_FedBeef  Log_Horses  Log_HeifersTotal  Log_M_CowCalves  Log_M_FedBeef  Log_M_Dairy  Log_Beef   Miss_Stock   Miss_MRDS  MRDSLiveStockInd
Num_Seed  Pioneer_D  Dekalb_D  Log_Dekalb  Log_Garst  Log_GoldenHarvest  Log_Mycogen   Log_NK  Log_Pioneer  Log_Other  Log_Becks  Log_Burrus  Log_DairyLand  Log_Doeblers  Log_Hoegenmeyer  Log_NuTech  Log_Terral  Log_Triumph  Log_Wyffels  Log_TotAcres_seed  Log_AvgAcres_Seed   Miss_Seed

 / selection = stepwise;

weight train;             
OUTPUT OUT=regout RESIDUAL=ehat;
RUN; 

/* success 29 cases used */ 

proc reg data=aaron.split;

model Log_PF_m = 
Log_PF_f   Corn_D  Log_Age  Num_CropPractice  BeefToday_Subs  Log_M_CowCalves  Log_Beef  NoPromo   Promotable   Subscription_Cust  Male  Log_M_Dairy   RentEmail  Num_Commn  
CommodityUpdateInd  Log_Sunflowers  Event_Cst   Log_Wheat  Log_HeifersTotal  BeefToday_R    FnO_D   Succession_D   Num_Crop   FarmJournal_Paid   FJ_Sub  DTEU_R   Computer_D
 / selection = stepwise;

weight train;             
OUTPUT OUT=regout RESIDUAL=ehat;
RUN;

/* 129 cases used. */

proc reg data=aaron.split;

model Log_PF_m = FSO_Cust ProFarmer_Gst TpenMember AW_Cust SilverPop_Cst CommodityUpdateInd Event_Cst CirculationInd   FSAInd  RetailerInd    FJ_Sub FJ_Cust Miss_Contact 
Subscription_Cust  FarmJournal_Subs   DairyToday_Subs   TopProducer_Subs  ImplementTractor_Subs   BeefToday_Subs   FarmJournal_Paid   DairyToday_Paid   TopProducer_Paid   ImplementTractor_Paid   BeefToday_Paid
Own_Operate   Own_Rent  Manager  Male  Promotable  Contact_r  Log_income  contact_r_pop  Log_Age   Email  Phone   Cellphone
Miss_Practice Miss_Preference Miss_Crop Miss_CropPrac Miss_Stock Miss_MRDS MRDSLiveStockInd Miss_Seed

 / selection = stepwise; 

weight train;             
OUTPUT OUT=regout RESIDUAL=ehat;
RUN;

PROC SQL;
SELECT train,
COUNT(ehat) AS n,
SUM(ehat**2) AS SSE, SUM(ehat**2)/COUNT(ehat) AS MSE
FROM regout GROUP BY train;

/* Logistic on Profarmer */

PROC LOGISTIC DATA=aaron.split descending;

MODEL FJ_Cust = ProFarmer_Cst FSO_Cust ProFarmer_Gst TpenMember AW_Cust Legacy_R  Moneywise_R  TOA_R  ThirdParty_R  Weekend_R  Cattle_Exchange_R  DTEU_R    BeefToday_R   SilverPop_Num   Log_SilverPop_r   SilverPop_Cst
Subscription_Cust PaidSubs_num Subscription_num CommodityUpdateInd Event_Cst CirculationInd FSAInd RetailerInd Miss_Contact 
Own_Operate   Own_Rent  Manager  Male  Promotable  Contact_r  Log_income  contact_r_pop  Log_Age   Email  Phone   Cellphone
Miss_Practice Miss_Preference Miss_Crop Num_Crop  Corn_D  Soybeans_D   Wheat_D   Hay_D Log_TotAcres_Crop   Log_AvgAcres_Crop
Miss_CropPrac Miss_Stock   Miss_MRDS  MRDSLiveStockInd Miss_Seed Num_Stock / RSQUARE;

Weight train;
OUTPUT out = logitout PREDICTED= phat;

run;

/*
proc print data=logitout(obs=10);
run;
*/

proc format;
value yesno
  0-<.5 = "no"
  .5-1 = "yes"
;
run;

proc sort data=logitout;
  by train;
run;

proc freq data=logitout;
  by train;
  table ProFarmer_cst * phat / norow nocol nopercent;
  format phat yesno.;
run;

proc freq data=logitout noprint;
  by train;
  table ProFarmer_cst * phat / norow nocol nopercent out=tmp;
  format phat yesno.;
run;

proc print data=tmp;
run;

/* genmod */

PROC GENMOD DATA=aaron.split DESCENDING;

MODEL ProFarmer_Cst = FSO_Cust ProFarmer_Gst TpenMember AW_Cust Legacy_R  Moneywise_R  TOA_R  ThirdParty_R  Weekend_R  Cattle_Exchange_R  DTEU_R    BeefToday_R   SilverPop_Num   Log_SilverPop_r   SilverPop_Cst
Subscription_Cust PaidSubs_num Subscription_num CommodityUpdateInd Event_Cst CirculationInd FSAInd RetailerInd Miss_Contact 
Own_Operate   Own_Rent  Manager  Male  Promotable  Contact_r  Log_income  contact_r_pop  Log_Age   Email  Phone   Cellphone
Miss_Practice Miss_Preference Miss_Crop Num_Crop  Corn_D  Soybeans_D   Wheat_D   Hay_D Log_TotAcres_Crop   Log_AvgAcres_Crop
Miss_CropPrac Miss_Stock   Miss_MRDS  MRDSLiveStockInd Miss_Seed Num_Stock / DIST=BIN; 

weight train;             
/* OUTPUT OUT=regout RESIDUAL=ehat; */
RUN;  

/* LDA & QDA */

PROC DISCRIM DATA=aaron.split;
CLASS ProFarmer_Cst;
VAR FSO_Cust ProFarmer_Gst TpenMember AW_Cust Legacy_R  Moneywise_R  TOA_R  ThirdParty_R  Weekend_R  Cattle_Exchange_R  DTEU_R    BeefToday_R   SilverPop_Num   Log_SilverPop_r   SilverPop_Cst
Subscription_Cust PaidSubs_num Subscription_num CommodityUpdateInd Event_Cst CirculationInd FSAInd RetailerInd Miss_Contact 
Own_Operate   Own_Rent  Manager  Male  Promotable  Contact_r  Log_income  contact_r_pop  Log_Age   Email  Phone   Cellphone
Miss_Practice Miss_Preference Miss_Crop Num_Crop  Corn_D  Soybeans_D   Wheat_D   Hay_D Log_TotAcres_Crop   Log_AvgAcres_Crop
Miss_CropPrac Miss_Stock   Miss_MRDS  MRDSLiveStockInd Miss_Seed Num_Stock;

Weight train;

PRIORS PROPORTIONAL;

RUN;

PROC DISCRIM DATA=aaron.split pool=no;
CLASS ProFarmer_Cst;
VAR FSO_Cust ProFarmer_Gst TpenMember AW_Cust Legacy_R  Moneywise_R  TOA_R  ThirdParty_R  Weekend_R  Cattle_Exchange_R  DTEU_R    BeefToday_R   SilverPop_Num   Log_SilverPop_r   SilverPop_Cst
Subscription_Cust PaidSubs_num Subscription_num CommodityUpdateInd Event_Cst CirculationInd FSAInd RetailerInd Miss_Contact 
Own_Operate   Own_Rent  Manager  Male  Promotable  Contact_r  Log_income  contact_r_pop  Log_Age   Email  Phone   Cellphone
Miss_Practice Miss_Preference Miss_Crop Num_Crop  Corn_D  Soybeans_D   Wheat_D   Hay_D Log_TotAcres_Crop   Log_AvgAcres_Crop
Miss_CropPrac Miss_Stock   Miss_MRDS  MRDSLiveStockInd Miss_Seed Num_Stock;

PRIORS PROPORTIONAL;

Weight train;

RUN;







