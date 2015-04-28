libname eddata "/sscc/datasets/imc490/farm";

libname aaron "/sscc/home/r/ras303/sasuser.v94";

/* Merge the contact files */

data contact_merge;
 merge contactinfo_f aaron.ContactPractice aaron.contactpreference;
 by id;
 
 run;

/*

proc print data=contact_merge (obs=100);run;
proc contents data=contact_merge (obs=100); run;
proc means data=contact_merge (obs=100); run;

proc means data=contact_merge n nmiss; run;

*/

/* Merge the crops + stock files */

data commodity_merge;
 merge contact_merge crop aaron.CropPractice stock seed;
 by id;
 
 run;
 
/*

proc print data=commodity_merge (obs=100);run;
proc contents data=commodity_merge (obs=100); run;
proc means data=commodity_merge (obs=100); run;

proc means data=commodity_merge n nmiss; run;

*/


/* Merge the subscription files */

data subscription_merge;
 merge commodity_merge SilverPop aaron.Subscription aaron.CommodityUpdate aaron.EventF;
 by id;
 
 run;

/*

proc print data=subscription_merge (obs=100);run;
proc contents data=subscription_merge (obs=100); run;
proc means data=subscription_merge (obs=100); run;

proc means data=subscription_merge n nmiss; run;

*/

/* Merge the subscription files */

data response_merge;
 merge PFCust FSOCust aaron.PFGuest aaron.TPENCSO ADWEB;
 by id;
 run;
 
/*

proc print data=response_merge (obs=100);run;
proc contents data=response_merge (obs=100); run;
proc means data=response_merge (obs=100); run;

proc means data=response_merge n nmiss; run;

*/

/* final merge */

data final_merge;
 merge response_merge subscription_merge;
 run;
 
proc sort data=final_merge out=aaron.final_merge nodupkey; 
 by id;
 run; 
 
proc print data=aaron.final_merge (obs=10);
proc contents data=aaron.final_merge; run;
proc means data=aaron.final_merge;run;
proc means data=aaron.final_merge n nmiss;run;


/* Printing the dupkeys */

proc freq data=final_merge noprint;
   tables ID / out=dup_no(keep=ID Count where=(Count gt 1));
run;

proc print data=dup_no; run;

proc print data=final_merge;
 where id = 64619 or id = 1263718 or id = 3735392 or id = 3736189;
 run;

proc print data=aaron.final_merge (obs=200);
 var PF_m FSAInd;
 where PF_m < 0;
 run;

/* Fix missing value */

data final_merge1;
 set aaron.final_merge;

 if PF_Cust =. then PF_Cust = 0;
 if EmailInd_Gst =. then EmailInd_Gst = 0;
 if PhoneInd_Gst =. then PhoneInd_Gst = 0;
 if PhoneInd_TP =. then PhoneInd_TP = 0;
 if EmailInd_TP =. then EmailInd_TP = 0;
 if AW_Cust =. then AW_Cust = 0;
 if FSO_Cust =. then FSO_Cust = 0;
 if CirculationInd =. then CirculationInd = 0;
 if FSAInd =. then FSAInd = 0;
 if SilverPopInd =. then SilverPopInd = 0;
 if RetailerInd =. then RetailerInd = 0;
 if ProfarmerInd =. then ProfarmerInd = 0;
 if EventContactInd =. then EventContactInd = 0;
 if MRDSLiveStockInd =. then MRDSLiveStockInd = 0;
 if CommodityUpdateInd =. then CommodityUpdateInd = 0;
 if PhoneInd_M =. then PhoneInd_M = 0;
 if CellPhoneInd_M =. then CellPhoneInd_M = 0;
 if EmailInd_M =. then EmailInd_M = 0;
 
 if EmailInd_SP =. then EmailInd_SP = 0;
 if PhoneInd_SP =. then PhoneInd_SP = 0;
 if Legacy_R =. then Legacy_R = 0;
 if Moneywise_R =. then Moneywise_R = 0;
 if TOA_R =. then TOA_R = 0;
 if ThirdParty_R =. then ThirdParty_R = 0;
 if Weekend_R =. then Weekend_R = 0;
 if Cattle_Exchange_R =. then Cattle_Exchange_R = 0;
 if DTEU_R =. then DTEU_R = 0;
 if BeefToday_R =. then BeefToday_R = 0;
 if SilverPop_Cust =. then SilverPop_Cust = 0;
 if SilverPop_Num =. then SilverPop_Num = 0;
 
 if Subscription_Cust =. then Subscription_Cust = 0;
 if FarmJournal_Subs =. then FarmJournal_Subs = 0;
 if DairyToday_Subs =. then DairyToday_Subs = 0;
 if TopProducer_Subs =. then TopProducer_Subs = 0;
 if ImplementTractor_Subs =. then ImplementTractor_Subs = 0;
 if BeefToday_Subs =. then BeefToday_Subs = 0;
 if Subscription_num =. then Subscription_num = 0;
 if FarmJournal_Paid =. then FarmJournal_Paid = 0;
 if DairyToday_Paid =. then DairyToday_Paid = 0;
 if TopProducer_Paid =. then TopProducer_Paid = 0;
 if ImplementTractor_Paid =. then ImplementTractor_Paid = 0;
 if BeefToday_Paid =. then BeefToday_Paid = 0;
 if PaidSubs_num =. then PaidSubs_num = 0;
 if CellPhoneInd =. then CellPhoneInd = 0;
 if EmailAddressMobileInd =. then EmailAddressMobileInd = 0;
 if EmailAddressInd =. then EmailAddressInd = 0;
 if EmailInd_FSO =. then EmailInd_FSO = 0;
 if PhoneInd_FSO =. then PhoneInd_FSO = 0;
 
 if ScheduleID =. then ScheduleID = 0;
 if Promo_FJM =. then Promo_FJM = 0;
 if Promo_PHI =. then Promo_PHI = 0;
 if Promo_CUI =. then Promo_CUI = 0;
 if Spon_CU =. then Spon_CU = 0;
 if Spon_PIO =. then Spon_PIO = 0;
 if Spon_IND =. then Spon_IND = 0;
 if PCS_CU =. then PCS_CU = 0;
 if PCS_CP =. then PCS_CP = 0;
 if PCS_AP =. then PCS_AP = 0;
 if PWS_CU =. then PWS_CU = 0;
 if PWS_LS =. then PWS_LS = 0;
 if PWS_WF =. then PWS_WF = 0;
 if Schedule357 =. then Schedule357 = 0;
 if Schedule37 =. then Schedule37 = 0;
 if Schedule10 =. then Schedule10 = 0;

 if Event_Cust =. then Event_Cust = 0;
 if PhoneInd_Event =. then PhoneInd_Event = 0;
 if EmailInd_Event =. then EmailInd_Event = 0;
 if Ser_CornCol =. then Ser_CornCol = 0;
 if Ser_TProdSem =. then Ser_TProdSem = 0;
 if Ser_PFA =. then Ser_PFA = 0;
 if Ser_ProfBrf =. then Ser_ProfBrf = 0;
 if Ser_LegWS =. then Ser_LegWS = 0;
 if EvenSeries_Pop =. then EvenSeries_Pop = 0;
 if Corn_T =. then Corn_T= 0;
 if Eve_CornColCli =. then Eve_CornColCli = 0;
 if Eve_TProdSem =. then Eve_TProdSem = 0;
 if Eve_Soy =. then Eve_Soy = 0;
 if PWS_CU =. then PWS_CU = 0;
 if Event_Pop =. then Event_Pop = 0;
 if TpenMember =. then TpenMember = 0;
 if Guest_Count =. then Guest_Count = 0;
 run;

data aaron.final_merge2;
 set final_merge1;
 
 Email1 = EmailInd_FSO + EmailInd_Gst + EmailInd_TP + EmailInd_M + EmailInd_SP + EmailAddressMobileInd
         + EmailAddressInd + EmailInd_Event;
 Phone1 = PhoneInd_FSO + PhoneInd_Gst + PhoneInd_TP + PhoneInd_M + PhoneInd_SP + PhoneInd_Event;
 Cellphone1 = CellPhoneInd_M + CellPhoneInd;
 
 SilverPop1 = SilverPop_Cust + SilverPopInd;
 ProFarmer1 = ProfarmerInd + PF_Cust;
 Event1 = EventContactInd + Event_Cust;
 
 if Email1 > 0 then Email = 1; else Email = 0;
 if Phone1 > 0 then Phone = 1; else Phone = 0;
 if Cellphone1 >0 then Cellphone = 1; else Cellphone = 0;
 
 if SilverPop1 > 0 then SilverPop_Cst = 1; else SilverPop_Cst = 0;
 if ProFarmer1 > 0 then ProFarmer_Cst = 1; else ProFarmer_Cst = 0;
 if Event1 > 0 then Event_Cst =1; else Event_Cst = 0;

 drop  Email1 EmailInd_FSO EmailInd_Gst EmailInd_TP EmailInd_M EmailInd_SP EmailAddressMobileInd EmailAddressInd EmailInd_Event
       Phone1 PhoneInd_FSO PhoneInd_Gst PhoneInd_TP PhoneInd_M PhoneInd_SP PhoneInd_Event
       Cellphone1 CellPhoneInd_M CellPhoneInd SilverPop1 SilverPop_Cust SilverPopInd ProFarmer1 ProfarmerInd PF_Cust Event1 EventContactInd Event_Cust;
       
 run;

proc means data=aaron.final_merge2 n nmiss; run;
proc contents data=aaron.final_merge2; run;

data aaron.final_merge3;
 set aaron.final_merge2;
 
 if PostalCode_PFG = . then ProFarmer_Gst = 0; else ProFarmer_Gst = 1;
 if Contact_r = . then Miss_Contact = 1; else Miss_Contact = 0;
 if Num_Practice = . then Miss_Practice = 1; else Miss_Practice = 0;
 if Num_Commn = . then Miss_Preference = 1; else Miss_Preference = 0;
 if Log_TotAcres_Crop = . then Miss_Crop = 1; else Miss_Crop = 0;
 if Num_CropPractice = . then Miss_CropPrac = 1; else Miss_CropPrac = 0;
 if Log_TotHead_Stock = . then Miss_Stock = 1; else Miss_Stock = 0;
 if Log_M_CowCalves = . then Miss_MRDS = 1; else Miss_MRDS = 0;
 if Log_TotAcres_seed = . then Miss_Seed = 1; else Miss_Seed = 0;
 
 FJ_Sub = ProFarmer_Cst + FSO_Cust + ProFarmer_Gst + TpenMember + AW_Cust + SilverPop_Cst + Subscription_Cust
 		  + CommodityUpdateInd + Event_Cst + CirculationInd;
 
 if FJ_Sub > 0 then FJ_Cust = 1; else FJ_Cust = 0;
 
 run;
 
proc contents data=aaron.final_merge3; run;
proc means data=aaron.final_merge3 n nmiss; run;
proc means data=aaron.final_merge3; run;

/* select the commercial farmer */

data aaron.universe;
 set aaron.final_merge3;
 
 
 if Log_Corn > 5.521461 or Log_Soybeans > 5.521461 or Log_Cotton > 6.214608 or Log_Wheat > 6.214608 or Log_income > 12.42922
 then Comm_Farmer = 1; else Comm_Farmer = 0;
 
 if Comm_Farmer = 1 and FJ_Cust = 1 then CandJ = 1;else CandJ=0;
 if Comm_Farmer = 1 or FJ_Cust = 1 then CorJ = 1;else CorJ=0;
 
 if State = "IL"	then State_IL = 1; else State_IL = 0;
 if State = "TX"	then State_TX = 1; else State_TX = 0;
 if State = "IA"  then State_IA = 1; else State_IA = 0;
 if State = "MN"	then State_MN = 1; else State_MN = 0;
 if State = "MO"	then State_MO = 1; else State_MO = 0;
 if State = "KS"  then State_KS = 1; else State_KS = 0;
 if State = "NE"	then State_NE = 1; else State_NE = 0;
 if State = "OH"	then State_OH = 1; else State_OH = 0;
 if State = "IN"	then State_IN = 1; else State_IN = 0;
 if State = "WI"	then State_WI = 1; else State_WI = 0;
 
 if PF_r = . then PF_r = 99999;
 if PF_l = . then PF_l = 0;
 if classic = . then classic = 0;
 if preferred = . then preferred = 0;
 if Log_PF_f = . then Log_PF_f = 0;
 if Log_PF_m = . then Log_PF_m = 0;
 
 if FS_r = . then FS_r = 99999;
 if FS_f = . then FS_f = 0;
 if FS_l = . then FS_l = 0;
 if MP = . then MP = 0;
 if FJ1 = . then FJ1 = 0;
 if Log_FS_m = . then Log_FS_m = 0;
 
 if AW_Visit = . then AW_Visit = 0;
 if AW_Session = . then AW_Session = 0;
 if AW_BnE = . then AW_BnE = 0;
 if Log_AW_Time = . then Log_AW_Time = 0;
 
 if Contact_r = . then Contact_r = 99999;
 if Log_Age = . then Miss_Age = 1; else Miss_Age = 0;
 if Num_Practice = . then Num_Practice = 0;
 if Num_Commn = . then Num_Commn = 0;
 if event_r =. then event_r = 99999;
 if Log_SilverPop_r = . then Log_SilverPop_r =99999;
 
 if Num_Crop = . then Num_Crop = 0;
 if Corn_D = . then Corn_D = 0;
 if Soybeans_D = . then Soybeans_D = 0;
 if Wheat_D = . then Wheat_D = 0;
 if Hay_D = . then Hay_D = 0;
 if CowCalves_D = . then CowCalves_D = 0;
 if Dairy_D = . then Dairy_D = 0;
 if Pioneer_D = . then Pioneer_D = 0;
 if Dekalb_D = . then Dekalb_D = 0;
 
 if Log_TotAcres_Crop = . then Log_TotAcres_Crop = 0;
 if Log_AvgAcres_Crop = . then Log_AvgAcres_Crop = 0;
 if Num_CropPractice = . then Num_CropPractice = 0;

 
 if Num_Stock = . then Num_Stock = 0;
 if Log_TotHead_Stock = . then Log_TotHead_Stock = 0;
 if Log_AvgHead_Stock = . then Log_AvgHead_Stock = 0;
 if Num_Seed = . then Num_Seed = 0;
 if Log_TotAcres_seed = . then Log_TotAcres_seed = 0;
 if Log_AvgAcres_Seed = . then Log_AvgAcres_Seed = 0;
 if Log_AvgAcres_Crop = . then Log_AvgAcres_Crop = 0;
 if Log_AvgAcres_Crop = . then Log_AvgAcres_Crop = 0;
 
 run;
 
proc freq data=universe;
 table FJ_Cust Comm_Farmer CandJ CorJ;
 run;
 
proc freq data=universe order=freq;
 table State;
 run;
 
data aaron.commercial;
 set aaron.universe;
 
 if Comm_Farmer = 1;
 
 run;
 
data aaron.FJ_cust;
 set aaron.universe;
 
 if FJ_Cust = 1;
 
 run;
 
data aaron.FJ_cust;
 merge aaron.FJ_Cust PFCust1; by id;
 
 if PF_m = .  then PF_m = 0;
 
 run;
 
proc means data=FJ_cust; run;
proc means data=FJ_cust n nmiss;var PF_m; where PF_m gt 0;run;

 proc print data=FJ_cust (obs=10);var id PF_m; where PF_m gt 0;run;
  proc print data=PFCust (obs=10);var id PF_m; where PF_m gt 0;run;

 
data aaron.CandJ;
 set aaron.universe;
 
 if CandJ = 1;
 
 run;

 
proc contents data=aaron.final_merge3; run;
proc means data=aaron.FJ_cust; run;
proc means data=aaron.universe n nmiss;run;




