libname eddata "/sscc/datasets/imc490/farm";

libname aaron "/sscc/home/r/ras303/sasuser.v94";

/****************** ****************** ****************** ****************** ****************** ****************** ******************/

/* contact info: already reread */

proc sort data=eddata.contactinfo out=aaron.contactinfo1; by id;
run;

/* detect problem with ID */

proc print data=aaron.contactinfo1 (obs=200);
 where id  gt 10000000;
 run;

/* reread contactinfo by enlarging guessingrows */

proc import datafile="/sscc/datasets/imc490/farm/FarmReachContactInfo.txt" DBMS=TAB OUT=contactinfo;
 DATAROW = 2; GUESSINGROWS = 50000;
 run;
 
proc contents data=contactinfo;run;
 
proc sort data=contactinfo out=aaron.contactinfo; by id; run;

 /* detect if dupkey problem exists */

proc print data=aaron.contactinfo (obs=200);
 where id  gt 10000000;
 run; 
 
 /* clean and code the character variables */
 
proc freq data=aaron.contactinfo order=freq;
 table AgInvolvementDesc PTCDesc TractorBrandDesc State / nocum; run;
 
 /* check the problem with the date */
 
proc tabulate data=aaron.contactinfo;
 var LastContactDate;
 table LastContactDate, n nmiss (min max median)*f=mmddyy10. range;
 run;

ods output summary=stacked;
proc means data=aaron.contactinfo n nmiss min max median range stackods;
var LastContactDate; run;

proc print data=stacked noobs;
 format min max median mmddyy10.; run;
 
proc univariate data=aaron.contactinfo;
 var income;
 where income gt 0;
 run;

 /* Which occupation variable do we beleive */
 
data aaron.contactinfo_f;
 set aaron.contactinfo;
 
 if AgInvolvementDesc = "Own/Operate" then S_Own_Operate= 1; else S_Own_Operate = 0;
 if AgInvolvementDesc = "Own a farm, Rent out" then S_Own_Rent= 1; else S_Own_Rent = 0;
 if AgInvolvementDesc = "Farm Manager" then S_Manager= 1; else S_Manager = 0;
 
 if PTCDesc = "Own/Operate" then G_Own_Operate= 1; else G_Own_Operate = 0;
 if PTCDesc = "Own a farm, Rent out" then G_Own_Rent= 1; else G_Own_Rent = 0;
 if PTCDesc = "Farm Manager" then G_Manager= 1; else G_Manager = 0;
 
 if S_Own_Operate = 1 or G_Own_Operate= 1 then Own_Operate =1; else Own_Operate = 0;
 if S_Own_Rent= 1 or G_Own_Rent= 1 then Own_Rent =1; else Own_Rent = 0;
 if S_Manager= 1 or G_Manager= 1 then Manager =1; else Manager = 0;
 
 if Gender = "F" then Male = 1; else Male = 0;
 
 if PromoteInd = "True" then Promotable = 1; else Promotable = 0;
 
 Contact_r = 19983 - LastContactDate;
 
 rename PhoneInd = PhoneInd_M; 
 rename CellPhoneInd = CellPhoneInd_M;
 rename EmailInd = EmailInd_M;
 
 drop Gender PromoteInd LastContactDate FIPS County;
 
 run;

proc print data=aaron.contactinfo_f (obs=50);run;

proc contents data=aaron.contactinfo_f;run;
proc means data=aaron.contactinfo_f n nmiss;
	var id age income; run;
	
proc means data=aaron.contactinfo_f;
 where income gt 100; run;

/****************** ****************** ****************** ****************** ****************** ****************** ******************/

/* contact practice */

proc sort data=eddata.contactpractice out=aaron.contactpractice1; by id;

/* reread contact practice by enlarging guessingrows */

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

data practice1;
 set aaron.contactpractice;

 if GPS = "Y" then GPS = 1; else GPS = 0; 
 if DTN = "Y" then DTN = 1; else DTN = 0;
 if FuturesAndOptions = "Y" then FuturesAndOptions = 1; else FuturesAndOptions = 0;
 if Internet = "Y" then Internet = 1; else Internet = 0;
 if MarketAdvice = "Y" then MarketAdvice = 1; else MarketAdvice = 0;
 if Computer = "Y" then Computer = 1; else Computer = 0;
 if Succession = "Y" then Succession = 1; else Succession = 0;
 if NewTech = "Y" then NewTech = 1; else NewTech = 0;
 if VerificationProgram = "Y" then VerificationProgram = 1; else VerificationProgram = 0;
 if EmailUsage = "Y" then EmailUsage = 1; else EmailUsage = 0;
 if SellSeed = "Y" then SellSeed = 1; else SellSeed = 0;
 if MarketQuote = "Y" then MarketQuote = 1; else MarketQuote = 0;
 if WeatherUpdate = "Y" then WeatherUpdate = 1; else WeatherUpdate = 0;
 if CommodityUpdate = "Y" then CommodityUpdate = 1; else CommodityUpdate = 0;
 
 run;
 
proc contents data=practice1;run;
proc print data=practice1 (obs=20); run; 

data aaron.ContactPractice;
 set practice1;
 
 GPS_D = GPS * 1;  DTN_D = DTN * 1;  FnO_D = FuturesAndOptions * 1;  Internet_D = Internet * 1;  MarketAdvice_D = MarketAdvice * 1;  Computer_D = Computer * 1;
 Succession_D = Succession * 1;  NewTech_D = NewTech * 1;  VP_D = VerificationProgram * 1;  Email_D = EmailUsage * 1;  SellSeed_D = SellSeed * 1;  
 
 Num_Practice = GPS_D + DTN_D + FnO_D + Internet_D + MarketAdvice_D + Computer_D + Succession_D
 + NewTech_D + VP_D + Email_D + SellSeed_D;
 
 keep ID Num_Practice GPS_D DTN_D FnO_D Internet_D MarketAdvice_D Computer_D Succession_D NewTech_D VP_D Email_D SellSeed_D;
 
 run;

proc contents data=aaron.ContactPractice; run;
proc print data=aaron.ContactPractice (obs=20); run;
proc means data=aaron.contactpractice; run;

/****************** ****************** ****************** ****************** ****************** ****************** ******************/

/* ContactPreference */

proc sort data=eddata.contactpreference out=aaron.contactpreference; by id;

/*
proc freq data=aaron.contactpreference;
	table NoENews NoProdServices DoNotPromoteByAnyMeans DoNotPromoteByPhone DoNotPromoteByMail
		DoNotPromoteByHighDate DoNotPromoteByEmail DoNotPromoteByFax	DoNotPromoteByCellPhone	
		DoNotRentByAnyMedium	DoNotRentEmail	DoNotRentAddress	DoNotRentPhone / nocum;
run;
*/

data aaron.contactpreference;
 set aaron.contactpreference;
 
 if DoNotPromoteByAnyMeans = "Y" then NoPromo = 1; else NoPromo = 0;
 if DoNotRentByAnyMedium = "Y" then NoRent = 1; else NoRent = 0;
 
 if DoNotPromoteByPhone = "N" then ByPhone = 1; else ByPhone = 0;
 if DoNotPromoteByMail = "N" then ByMail = 1; else ByMail = 0;
 if DoNotPromoteByHighDate = "N" then ByHighDate = 1; else ByHighDate = 0;
 if DoNotPromoteByEmail = "N" then ByEmail = 1; else ByEmail = 0;
 if DoNotPromoteByFax = "N" then ByFax = 1; else ByFax = 0;
 if DoNotRentEmail = "N" then RentEmail = 1; else RentEmail = 0;
 if DoNotPromoteByCellPhone = "N" then ByCellPhone = 1; else ByCellPhone = 0;
 if DoNotRentAddress = "N" then RentAddress = 1; else RentAddress = 0;
 if DoNotRentPhone = "N" then RentPhone = 1; else RentPhone = 0;
 
 Num_Commn = ByPhone + ByMail + ByHighDate + ByEmail + ByFax + ByCellPhone + RentEmail + RentAddress + RentPhone;
 
 drop NoENews NoProdServices DoNotPromoteByAnyMeans DoNotRentByAnyMedium DoNotPromoteByPhone DoNotPromoteByMail DoNotPromoteByHighDate
      DoNotPromoteByCellPhone DoNotPromoteByEmail DoNotPromoteByFax DoNotRentEmail DoNotRentAddress DoNotRentPhone;
 
 run;

proc contents data=aaron.contactpreference;run;
proc print data=aaron.contactpreference (obs=20);run;
proc means data=aaron.contactpreference;run;

/****************** ****************** ****************** ****************** ****************** ****************** ******************/

/* FarmReach Crop = Crop */
proc sort data=eddata.crop out=aaron.crop; by id;

proc contents data=aaron.crop;
proc print data=aaron.crop (obs=20);
proc means data=aaron.crop;
run;

data crop1;
 set aaron.crop;
 
 if Beets gt 0 then Beets1 = 1; else Beets1 = 0; if Canola gt 0 then Canola1 = 1; else Canola1 = 0;
 if Corn gt 0 then Corn1 = 1; else Corn1 = 0; if Soybeans gt 0 then Soybeans1 = 1; else Soybeans1 = 0;
 if Sorghum gt 0 then Sorghum1 = 1; else Sorghum1 = 0; if Alfalfa gt 0 then Alfalfa1 = 1; else Alfalfa1 = 0;
 if Hay gt 0 then Hay1 = 1; else Hay1 = 0; if Cotton gt 0 then Cotton1 = 1; else Cotton1 = 0; 
 if Tobacco gt 0 then Tobacco1 = 1; else Tobacco1 = 0; if Oats gt 0 then Oats1 = 1; else Oats1 = 0;
 if Rye gt 0 then Rye1 = 1; else Rye1 = 0; if Barley gt 0 then Barley1 = 1; else Barley1 = 0;
 if Rice gt 0 then Rice1 = 1; else Rice1 = 0; if DryBeans gt 0 then DryBeans1 = 1; else DryBeans1 = 0;
 if Sunflowers gt 0 then Sunflowers1 = 1; else Sunflowers1 = 0; if Peanuts gt 0 then Peanuts1 = 1; else Peanuts = 0;
 if Potatoes gt 0 then Potatoes1 = 1; else Potatoes1 = 0; if Wheat gt 0 then Wheat1 = 1; else Wheat1 = 0;

 
 Num_Crop =  sum (Beets1, Canola1, Corn1, Soybeans1, Sorghum1, Alfalfa1, Hay1, Cotton1, Tobacco1, Oats1, Rye1, Barley1, Rice1, DryBeans1, Sunflowers1, Peanuts1, Potatoes1, Wheat1);
 AvgAcres_Crop = GeneratedAcres/Num_Crop;
 
 rename GeneratedAcres = TotAcres_crop;
 
 drop Beets1 Canola1 Corn1 Soybeans1 Sorghum1 Alfalfa1 Hay1 Cotton1 Tobacco1 Oats1 Rye1 Barley1 Rice1 DryBeans1 Sunflowers1 Peanuts1 Potatoes1 Wheat1;
 
 run;


%macro test2(dsn,vars,func);                                                                                                             
data crop1;                                                                                                                  
 set &dsn;                                                                                                                
  array list(*) &vars;                                                                                                                  
  &func = vname(list[whichn(&func(of list[*]), of list[*])]);                                                                          
run;                                                                                                                                    
%mend test2; 

%test2(crop1,Beets Canola Corn Soybeans Sorghum Alfalfa Hay Cotton Tobacco Oats Rye Barley Rice DryBeans Sunflowers Peanuts Potatoes Wheat, max)                                                                                                                
;

run;


proc freq data=crop1 order = freq;
 table max / nocum ;
 run;


data aaron.crop;
 set crop1;
 
 if max = "Corn" then Corn_D = 1; else Corn_D = 0;
 if max = "Soybeans" then Soybeans_D = 1; else Soybeans_D = 0;
 if max = "Wheat" then Wheat_D = 1; else Wheat_D = 0;
 if max = "Hay" then Hay_D = 1; else Hay_D = 0;
 
 rename max = Prime_Crop;
 
 run;
                                                                                                                            
proc print data=aaron.crop (obs=1000);
proc means data=aaron.crop; run;
proc contents data=aaron.crop; run;

proc freq data=aaron.crop order=freq;
 table beets;
 run;

/****************** ****************** ****************** ****************** ****************** ****************** ******************/

/* CropPractice read data wrong, already reread */

proc sort data=eddata.croppractice out=aaron.CropPractice1; by id;

/* reread crop practice by enlarging guessingrows */

proc import datafile="/sscc/datasets/imc490/farm/FarmReachCropPractice.txt" DBMS=TAB REPLACE OUT=CropPractice;
 DATAROW = 2; GUESSINGROWS = 100;
 run;

proc sort data=CropPractice out=aaron.CropPractice; by id; run;
proc print data=aaron.CropPractice (obs=20); run;
proc contents data=aaron.CropPractice; run;

data aaron.CropPractice;
 set aaron.CropPractice;

 if MinNoTillage = "Y" then MinNoTillage_D = 1; else MinNoTillage_D = 0; 
 if Irrigation = "Y" then Irrigation_D = 1; else Irrigation_D = 0;
 if SeedTreatments = "Y" then SeedTreatments_D = 1; else SeedTreatments_D = 0;
 if Fungicides = "Y" then Fungicides_D = 1; else Fungicides_D = 0;
 
 Num_CropPractice = MinNoTillage_D + Irrigation_D + SeedTreatments_D + Fungicides_D;
 
 Drop MinNoTillage Irrigation SeedTreatments Fungicides;
 
 run;
 
proc print data=aaron.CropPractice (obs=20); run;
proc contents data=aaron.CropPractice; run;
proc means data=aaron.CropPractice; run;

/****************** ****************** ****************** ****************** ****************** ****************** ******************/

/* FJLiveStock */

proc sort data=eddata.FJlivestock out=aaron.FJlivestock; by id;

proc contents data=aaron.FJlivestock;
proc print data=aaron.FJlivestock (obs=20);
proc means data=aaron.FJlivestock;
run;

data stock1;
 set aaron.FJlivestock;
 
 drop DairyTotal;
 
 HeifersTotal = Heifers + HeifersOwned + HeifersGrown;
 
 if Hogs gt 0 then Hogs1 = 1; else Hogs1 = 0; if Sows gt 0 then Sows1 = 1; else Sows1 = 0;
 if Dairy gt 0 then Dairy1 = 1; else Dairy1 = 0; if CowCalves gt 0 then CowCalves1 = 1; else CowCalves1 = 0;
 if Stockers gt 0 then Stockers1 = 1; else Stockers1 = 0; if FedBeef gt 0 then FedBeef1 = 1; else FedBeef1 = 0;
 if Heifers gt 0 then Heifers1 = 1; else Heifers1 = 0; if HeifersTotal gt 0 then HeifersTotal1 = 1; else HeifersTotal1 = 0; 
 if Horses gt 0 then Horses1 = 1; else Horses1 = 0; 
 
 TotalHead_Stock = sum (Hogs, Sows, Dairy, CowCalves, Stockers, FedBeef, HeifersTotal, Horses);
 Num_Stock =  sum (Hogs1, Sows1, Dairy1, CowCalves1, Stockers1, FedBeef1, HeifersTotal1, Horses1);
 AvgHead_Stock = TotalHead_Stock/Num_Stock;
 
 Drop Hogs1 Sows1 Dairy1 CowCalves1 Stockers1 FedBeef1 Heifers Heifers1 HeifersOwned HeifersGrown HeifersTotal1 Horses1;
 
 run;
 
%macro test3(dsn,vars,func);                                                                                                             
data stock1;                                                                                                                  
 set &dsn;                                                                                                                
  array list(*) &vars;                                                                                                                  
  &func = vname(list[whichn(&func(of list[*]), of list[*])]);                                                                          
run;                                                                                                                                    
%mend test3; 

%test3(stock1,Hogs Sows Dairy CowCalves Stockers FedBeef HeifersTotal Horses,max)
        
;
/*
proc freq data=stock order = freq;
 table max / nocum ;
 run;
*/

data aaron.stock;
 set stock1;
 
 if max = "CowCalves" then CowCalves_D = 1; else CowCalves_D = 0;
 if max = "Dairy" then Dairy_D = 1; else Dairy_D = 0;
 
 rename max = Prime_Stock;
 
 run;
                                                                                                                            
proc print data=aaron.stock (obs=20);run;
proc means data=aaron.stock; run;
proc contents data=aaron.stock; run;

/****************** ****************** ****************** ****************** ****************** ****************** ******************/

/* MRDSliveStock: too much disconnection with FJ's records, disgard */

proc sort data=eddata.mrdslivestock out=aaron.mrdslivestock; by id;

data aaron.mrdslivestock;
 set aaron.mrdslivestock;
 
 rename CowCalves = M_CowCalves;
 rename FedBeef = M_FedBeef;
 rename Dairy = M_Dairy;
 
 run;

proc contents data=aaron.mrdslivestock;
proc print data=aaron.stock (obs=20);
proc print data=aaron.mrdslivestock (obs=20);
proc means data=aaron.mrdslivestock;
run;

/****************** ****************** ****************** ****************** ****************** ****************** ******************/

/* merge trial 1 */

data aaron.stock_merge;
 merge aaron.stock aaron.mrdslivestock;
 by id;
 run;

proc print data=aaron.stock_merge (obs=10);
proc contents data=aaron.stock_merge;
proc means data=aaron.stock_merge; run;

/* Profarmer Order Cust: Rolled up as aaron.PFCust */

proc contents data=aaron.PFCust;
proc print data=aaron.PFCust (obs=20);
proc means data=aaron.PFCust;
run;

/****************** ****************** ****************** ****************** ****************** ****************** ******************/

/* Seed */

proc sort data=eddata.Seed out=aaron.Seed; by id;

proc contents data=aaron.Seed;
proc print data=aaron.Seed (obs=20);
proc means data=aaron.Seed;
run;

data seed1;
 set aaron.seed;
 
 TotAcres_seed =  sum (Dekalb, Garst, GoldenHarvest, Mycogen, NK, Pioneer, Other, Becks, Burrus, DairyLand, Doeblers, Hoegenmeyer, NuTech, Terral, Triumph, Wyffels);
 
 if Dekalb gt 0 then Dekalb1 = 1; else Dekalb1 = 0; if Garst gt 0 then Garst1 = 1; else Garst1 = 0;
 if GoldenHarvest gt 0 then GoldenHarvest1 = 1; else GoldenHarvest1 = 0; if Mycogen gt 0 then Mycogen1 = 1; else Mycogen1 = 0;
 if NK gt 0 then NK1 = 1; else NK1 = 0; if Pioneer gt 0 then Pioneer1 = 1; else Pioneer1 = 0;
 if Other gt 0 then Other1 = 1; else Other1 = 0; if Becks gt 0 then Becks1 = 1; else Becks1 = 0; 
 if Burrus gt 0 then Burrus1 = 1; else Burrus1 = 0; if DairyLand gt 0 then DairyLand1 = 1; else DairyLand1 = 0;
 if Doeblers gt 0 then Doeblers1 = 1; else Doeblers1 = 0; if Hoegenmeyer gt 0 then Hoegenmeyer1 = 1; else Hoegenmeyer1 = 0;
 if NuTech gt 0 then NuTech1 = 1; else NuTech1 = 0; if Terral gt 0 then Terral1 = 1; else Terral1 = 0;
 if Triumph gt 0 then Triumph1 = 1; else Triumph1 = 0; if Wyffels gt 0 then Wyffels1 = 1; else Wyffels1 = 0;
 
 Num_Seed =  sum (Dekalb1, Garst1, GoldenHarvest1, Mycogen1, NK1, Pioneer1, Other1, Becks1, Burrus1, DairyLand1, Doeblers1, Hoegenmeyer1, NuTech1, Terral1, Triumph1, Wyffels1);
 AvgAcres_Seed = TotAcres_seed/Num_Seed;
 
 drop  Dekalb1 Garst1 GoldenHarvest1 Mycogen1 NK1 Pioneer1 Other1 Becks1 Burrus1 DairyLand1 Doeblers1 Hoegenmeyer1 NuTech1 Terral1 Triumph1 Wyffels1;
 
 run;
 
 /* extract the variable name of max seed value */
                                                                                                          
%macro test(dsn,vars,func);                                                                                                             
data seed1;                                                                                                                  
 set &dsn;                                                                                                                
  array list(*) &vars;                                                                                                                  
  &func = vname(list[whichn(&func(of list[*]), of list[*])]);                                                                          
run;                                                                                                                                    
%mend test; 

%test(seed1,Dekalb Garst GoldenHarvest Mycogen NK Pioneer Other Becks Burrus DairyLand Doeblers Hoegenmeyer NuTech Terral Triumph Wyffels,max)                                                                                                                

;

/*
proc freq data=aaron.seed order = freq;
 table max / nocum ;
 run;
*/

data aaron.seed;
 set seed1;

 
 if max = "Pioneer" then Pioneer_D = 1; else Pioneer_D = 0;
 if max = "Dekalb" then Dekalb_D = 1; else Dekalb_D = 0;
 
 rename max = Prime_Seed;
 
 run;
                                                                                                                            
proc print data=aaron.seed (obs=100);run;
proc means data=aaron.seed; run;
proc contents data=aaron.seed; run;

/****************** ****************** ****************** ****************** ****************** ****************** ******************/


/* SilverPop */

proc sort data=eddata.silverpop out=aaron.silverpop; by id OpenDate;

proc contents data=aaron.silverpop;
proc print data=aaron.silverpop (obs=20);
proc means data=aaron.silverpop; run;

 /* Clean and Recode */

proc freq data=silverpop;
 table Legacy_Requested Moneywise_Requested TOA_Requested ThirdParty_Requested/ nocum;
 run;

data aaron.SilverPop;
 set aaron.Silverpop; 
 by id;
 
 if id =. then delete;
 if OpenDate =. then delete;
 
 SilverPop_r= 19961 - OpenDate;
 
 Lid = last.id ;
 
 if Lid=0 then delete;

 if Legacy_Requested = 'Yes' then Legacy_Requested=1; else Legacy_Requested= 0; Legacy_R = Legacy_Requested*1;
 if Moneywise_Requested = 'Yes' OR Moneywise_Requested = 'yes' then Moneywise_Requested =1; else Moneywise_Requested= 0; Moneywise_R = Moneywise_Requested *1;  
 if TOA_Requested = 'Yes' OR TOA_Requested = 'yes' then TOA_Requested =1; else TOA_Requested=0; TOA_R = TOA_Requested *1;
 if ThirdParty_Requested = 'Yes' OR ThirdParty_Requested = 'yes' then ThirdParty_Requested =1; else ThirdParty_Requested =0; ThirdParty_R = ThirdParty_Requested*1;
 if Weekend_Requested = 'Yes' OR Weekend_Requested = 'yes' then Weekend_Requested =1; else Weekend_Requested=0; Weekend_R = Weekend_Requested *1;
 if Cattle_Exchange_Requested = 'Yes' OR Cattle_Exchange_Requested = 'yes' then Cattle_Exchange_Requested =1; else Cattle_Exchange_Requested=0; Cattle_Exchange_R = Cattle_Exchange_Requested*1;
 if DTEU_Requested = 'Yes' OR DTEU_Requested = 'yes' then DTEU_Requested =1; else DTEU_Requested=0; DTEU_R = DTEU_Requested*1;
 if BeefToday_GrazingTheNet_Requeste = 'Yes' OR BeefToday_GrazingTheNet_Requeste = 'yes' then BeefToday_GrazingTheNet_Requeste =1; else BeefToday_GrazingTheNet_Requeste=0; BeefToday_R = BeefToday_GrazingTheNet_Requeste*1;

 keep ID SilverPop_r Legacy_R Moneywise_R TOA_R ThirdParty_R Weekend_R Cattle_Exchange_R DTEU_R BeefToday_R EmailAddressInd PhoneInd;

 run;

/* create Var Silverpop_num */
 
data aaron.silverpop;
 set aaron.silverpop;
 
 SilverPop_Cust = 1;
 
 rename EmailAddressInd = EmailInd_SP;
 rename PhoneInd = PhoneInd_SP;
 
 SilverPop_Num = Legacy_R+Moneywise_R+TOA_R+ThirdParty_R+Weekend_R+Cattle_Exchange_R+DTEU_R+BeefToday_R;
 
 run;
 
proc contents data=aaron.SilverPop;run;
proc means data=aaron.SilverPop; run;
proc print data=aaron.SilverPop(obs=40);run;

/****************** ****************** ****************** ****************** ****************** ****************** ******************/
 
/* Subscription */

proc sort data=eddata.Subscription out=aaron.Subscription; by id;

proc contents data=aaron.Subscription;
proc means data=aaron.Subscription;run;
proc print data=aaron.Subscription (obs=20);


proc freq data=aaron.Subscription order=freq;
	table Farmjournal / nocum;
	run;

data Subscription1;
 set aaron.Subscription;
 
 Subscription_Cust = 1;
 
 if FarmJournal = "P" or FarmJournal = "R" or FarmJournal = "Q" then FarmJournal=1; else FarmJournal= 0; FarmJournal_Subs = FarmJournal*1;	
 if DairyToday = "P"  or DairyToday = "R" or DairyToday = "Q" then DairyToday=1; else DairyToday= 0; DairyToday_Subs = DairyToday*1;	
 if TopProducer = "P" or TopProducer = "R" or TopProducer = "Q"  then TopProducer=1; else TopProducer= 0; TopProducer_Subs = TopProducer*1;	
 if ImplementTractor = "P" or ImplementTractor = "R" or ImplementTractor = "Q"  then ImplementTractor=1; else  ImplementTractor= 0;  ImplementTractor_Subs = ImplementTractor*1;	
 if BeefToday = "P" or BeefToday = "R" or BeefToday = "Q"  then BeefToday=1; else BeefToday= 0; BeefToday_Subs = BeefToday*1;
 
 Subscription_num = FarmJournal_Subs + DairyToday_Subs + TopProducer_Subs + ImplementTractor_Subs + BeefToday_Subs;
 
 Keep ID Subscription_num FarmJournal_Subs DairyToday_Subs TopProducer_Subs BeefToday_Subs ImplementTractor_Subs Subscription_Cust;
 
 data subscription2;
  set aaron.subscription;
 
 if FarmJournal = "P" then FarmJournal_P=1; else FarmJournal_P= 0; FarmJournal_Paid = FarmJournal_P*1;	
 if DairyToday = "P"  then DairyToday_P=1; else DairyToday_P= 0; DairyToday_Paid = DairyToday_P*1;	
 if TopProducer = "P" then TopProducer_P=1; else TopProducer_P= 0; TopProducer_Paid = TopProducer_P*1;	
 if ImplementTractor = "P" then ImplementTractor_P=1; else  ImplementTractor_P= 0;  ImplementTractor_Paid = ImplementTractor_P*1;	
 if BeefToday = "P" then BeefToday_P=1; else BeefToday_P= 0; BeefToday_Paid = BeefToday_P*1;
 
 PaidSubs_num = FarmJournal_Paid + DairyToday_Paid + TopProducer_Paid + ImplementTractor_Paid + BeefToday_Paid;
 
 Keep ID PaidSubs_num FarmJournal_Paid DairyToday_Paid TopProducer_Paid ImplementTractor_Paid BeefToday_Paid;

run;

data aaron.subscription;
 merge subscription1 subscription2;
 by id;
 
 run;

proc contents data=aaron.Subscription;
proc means data=aaron.Subscription;run;
proc print data=aaron.Subscription (obs=20);run;

/****************** ****************** ****************** ****************** ****************** ****************** ******************/

/* CommodityUpdate */

proc import datafile="/sscc/datasets/imc490/farm/FarmReachCommodityUpdate.txt" DBMS=TAB OUT=CommodityUpdate;
 DATAROW = 2; GUESSINGROWS = 5000;
 run;

proc sort data=CommodityUpdate out=aaron.CommodityUpdate noduprecs; by id;run;

data aaron.commodityupdate;
 set aaron.commodityupdate;
 
 if PromoCode = "FJM" then Promo_FJM = 1; else Promo_FJM = 0;
 if PromoCode = "PHI-Central" then Promo_PHI = 1; else Promo_PHI = 0;
 if PromoCode = "CUINV" then Promo_CUI = 1; else Promo_CUI = 0;
 
 if MarketSponsor = "Commodity Update" then Spon_CU = 1; else Spon_CU = 0;
 if MarketSponsor = "Pioneer" then Spon_PIO = 1; else Spon_PIO = 0;
 if MarketSponsor = "Individual" then Spon_IND = 1; else Spon_IND = 0;
 
 if ProductCustomSupplemental = "Commodity Update" then PCS_CU = 1; else PCS_CU = 0;
 if ProductCustomSupplemental = "Crop Production" then PCS_CP = 1; else PCS_CP = 0;
 if ProductCustomSupplemental = "Asgrow Plant" then PCS_AP = 1; else PCS_AP = 0;
 
 if ProductWeatherSponsor = "Commodity Update" then PWS_CU = 1; else PWS_CU = 0;
 if ProductWeatherSponsor = "LG Seeds" then PWS_LS = 1; else PWS_LS = 0;
 if ProductWeatherSponsor = "WinField" then PWS_WF = 1; else PWS_WF = 0; 
 
 if ScheduleID = 357 then Schedule357 = 1; else Schedule357 = 0; 
 if ScheduleID = 37 then Schedule37 = 1; else Schedule37 = 0;
 if ScheduleID = 10 then Schedule10 = 1; else Schedule10 = 0; 

 if ProductPulse = "Pulse" then ProductPulse = 1; else ProductPulse = 0;  
 
 drop CommodityUpdateID ;
 
 run;

proc contents data=aaron.CommodityUpdate;run;
proc print data=aaron.CommodityUpdate (obs=100);run;
proc means data=aaron.CommodityUpdate;
run;

proc means data=aaron.commodityupdate n nmiss;
 var ID; /* ID no missing */
 run;

proc freq data=aaron.commodityupdate order=freq;
 table PromoCode MarketSponsor ProductCustomSupplemental ProductWeatherSponsor ScheduleID ProductPulse/ nocum;
 run;
 
/****************** ****************** ****************** ****************** ****************** ****************** ******************/

/* Event */

proc sort data=eddata.Event out=aaron.Event; by id;

/*
proc contents data=aaron.Event;
proc print data=aaron.Event (obs=200);
proc means data=aaron.Event;
run;
*/

/* create the guest count and eliminate the dup recs */

proc freq data=aaron.Event noprint;
   tables ID / out=dup_no(keep=ID Count where=(Count gt 1));
run;

proc contents data=dup_no; run;
proc print data=dup_no (obs=100) noobs; run;

proc sort data=aaron.Event out=aaron.Event noduprecs; by id;run;

data aaron.Event;
 format EventName $50.;
 length EventName $ 50.;	
 merge aaron.Event dup_no;
 by id;
 
 Guest_Count=Count-1; drop Count EventContactKey;
run;


proc contents data=aaron.Event; run;
proc print data=aaron.Event (obs=20); run;
proc means data=aaron.Event; run;


proc freq data=aaron.Event order=freq;
 table EventSeriesDesc EventName / nocum;
 run; /* freq > 5% defines as popular */
 
data aaron.EventF;
 set aaron.Event;
 
 Event_Cust = 1;
 PhoneInd_Event = PhoneCellInd;
 EmailInd_Event = EmailAddressInd;

 EventDate = datepart(EventEndDate);
 
 if EventSeriesDesc = "Corn College" then Ser_CornCol = 1; else Ser_CornCol = 0;
 if EventSeriesDesc = "Top Producer Semin" then Ser_TProdSem = 1; else Ser_TProdSem = 0;
 if EventSeriesDesc = "PFA Midwest Crop T" then Ser_PFA = 1; else Ser_PFA = 0;
 if EventSeriesDesc = "Profit Briefing" then Ser_ProfBrf = 1; else Ser_ProfBrf = 0;
 if EventSeriesDesc = "Legacy Workshops" then Ser_LegWS = 1; else Ser_LegWS = 0;
 
 if EventSeriesDesc = "Corn College" or EventSeriesDesc = "Top Producer Semin" or EventSeriesDesc = "PFA Midwest Crop T"
 or EventSeriesDesc = "Profit Briefing" or EventSeriesDesc = "Legacy Workshops" then EvenSeries_Pop=1; else EvenSeries_Pop= 0; 

 Corn_T = INDEX(EventName, "Crop Tour");
 
 if EventName = "Corn College Planter Clinic" then Eve_CornColCli = 1; else Eve_CornColCli = 0;
 if EventName = "Top Producer Seminar" then Eve_TProdSem = 1; else Eve_TProdSem = 0;
 if EventName = "Soybean College" then Eve_Soy = 1; else Eve_Soy = 0;

 if EventName = "Top Producer Seminar" or EventName = "Corn College Planter Clinic" or EventName = "Soybean College"
 or Corn_T = 1 then Event_Pop = 1; else Event_Pop= 0;
 
 Event_R = 19935 - EventDate;
 
 drop PhoneBusinessInd PhoneCellInd PhoneHomeInd EmailAddressInd EventEndDate EventStartDate EventYear EventDate;
 
run;

proc contents data=aaron.EventF;run;
proc print data=aaron.EventF (obs=20);run;
proc means data=aaron.EventF;run;

/****************** ****************** ****************** ****************** ****************** ****************** ******************/

/* FSO */ /* aleady rolled up to cust */

proc sort data=eddata.FSO out=aaron.FSO; by id;

proc contents data=aaron.FSOCust;
proc print data=aaron.FSOCust (obs=20);
proc means data=aaron.FSOCust;
run;

proc freq data=aaron.FSO order=freq;
	table ProductReference / nocum;
	run;
	
/****************** ****************** ****************** ****************** ****************** ****************** ******************/

/* ProfarmerGuest */

proc sort data=eddata.ProfarmerGuest out=aaron.ProfarmerGuest; by id;

proc contents data=aaron.ProfarmerGuest;
proc print data=aaron.ProfarmerGuest (obs=20);
proc means data=aaron.ProfarmerGuest;
run;

data aaron.PFGuest;
 
 set aaron.ProfarmerGuest;
 if id =. then delete;
 
 rename EmailAddressInd = EmailInd_Gst;
 rename PhoneID = PhoneInd_Gst;
 
 PostalCode_PFG = PostalCode *1;
 
 format PostalCode_PFG  9.;
 
 drop PGID City County FIPS PostalCode;
 
run;
 
proc contents data=aaron.PFGuest;run;
proc means data=aaron.PFGuest; run;
proc print data=aaron.PFGuest(obs=20);run;

/****************** ****************** ****************** ****************** ****************** ****************** ******************/

/* Top Producer Executive Network (TPEN) */

proc sort data=eddata.TPEN out=aaron.TPEN; by id;

data aaron.TPEN;
 set aaron.TPEN;
 if id = . then delete;
 
 drop TPENkey;

run;

proc contents data=aaron.TPEN;
proc print data=aaron.TPEN (obs=20);
proc means data=aaron.TPEN;
run;

/* CSO */

proc sort data=eddata.CSO out=aaron.CSO; by id;

proc contents data=aaron.CSO;
proc print data=aaron.CSO (obs=20);
proc means data=aaron.CSO;
run;

data aaron.CSO;
 set aaron.CSO;
 if id=. then delete;
 
 drop FarmStoreKey;
 run;
 
proc contents data=aaron.CSO;
proc print data=aaron.CSO (obs=20);
proc means data=aaron.CSO;
run;

/* Merge CSO with TPEN */

data aaron.TPEN;
merge aaron.TPEN aaron.CSO;
by id;
run;

proc sort data=aaron.TPEN out=aaron.TPEN noduprecs;by id;run;

proc contents data=aaron.TPEN;run;
proc print data=aaron.TPEN (obs=50);run;

data aaron.TPENCSO;
 set aaron.TPEN;
 
 rename PhoneInd = PhoneInd_TP;
 rename EmailInd = EmailInd_TP;
 rename TpenMemberInd = TpenMember;
 
 run;
 
proc print data=aaron.TPENCSO (obs=20);run;

/****************** ****************** ****************** ****************** ****************** ****************** ******************/

/* AgWeb Traffic: rolled up to ADWEB */

proc sort data=eddata.ADWEB out=aaron.ADWEB; by frid;

proc contents data=aaron.ADWEB;
proc print data=aaron.ADWEB (obs=20);run;
proc means data=aaron.ADWEB;
run;

/****************** ****************** ****************** ****************** ****************** ****************** ******************/