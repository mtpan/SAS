libname lim 'L:\Students\SPan\Michelle Lim';
run;
options nolabel; 

PROC IMPORT OUT= WORK.tx
            DATAFILE= "L:\Students\SPan\Michelle Lim\Heart Tx FO Data MA
STER 8.13.2019_4.xlsx" 
            DBMS=EXCEL REPLACE;
     RANGE="used$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;

data lim.tx_n102; set work.tx; if exclude=0;run; 

proc contents data=lim.tx_n102 varnum;
run;

proc freq data=lim.tx_n102;
table hispanic01/missing; /* the missing argument will also include missing values in the output*/
run;

proc freq data=lim.tx_n102;
table FO_1wk_group/missing; /* the missing argument will also include missing values in the output*/
run;
/* char -> num 
var01b=var01+0;
var01b=var01*1; 
*/ 
ods rtf file="freq_table_n102.rtf" path='L:\Students\SPan\Michelle Lim';
proc freq data=lim.tx_n102;
table
/*_all_/missing;*/
D_hosp_aftr_Tx n_hosp_1yr
Age_trspl_yr
Age_LT_1yr01
Male01 
Hispanic01 
Bypass_Time 
Cross_Clamp_Time 
Donor_Ischemic_Time 
Dual_Transplant 
Dual_Transplant_01 
Vaso_Use01 
ECMO_bf_Transplant01 
VADS_bf_Transplant 
VADS_bf_Transplant_01 
Admit_Wt 
Cya_vs_Acy 
Transplant_Indication 
Max_VIS_24H 
Max_VIS_72H 
FO_72H_group 
FO_1wk_group
Max_Chg_SCr 
Max_Increase_SCr 
Lowest_UOP 
Pre_Tx_Cr_Mean 
AKI_w_in_7d_post_Tx01
Stg_3_AKI_w_in_7d_post_Tx01
CRRT_during_Hosp01
Date_of_Death
os_days
Death01*Death_less_1Y01*Death_postop01
Prim_Graft_Fail_ECMO01
Clinc_Rej_less_1Y_post_Tx01
Rej_Epi_n
Clin_rej_less_1Y_post_Tx01
Elevated_RAP_post_OP_1_4Wks
Elevated_PCWP_post_OP_1_4Wks
Low_CO_post_OP_1_4Wks
Elevated_RVP_early_3_6Mo
Elevated_PCWP_early_3_6Mo
Low_CO_early_3_6Mo
Elevated_RVP_late_1Yr
Elevated_PCWP_late_1Yr
Low_CO_late_1Yr
/list missing;
run;
ods rtf close; 

proc freq data=lim.tx_n102;
table Death01*Death_less_1Y01*Death_postop01/list missing; run; 

/*** means ***/
proc glm data=lim.tx_n102;
class  FO_72H_group;
model Age_trspl_yr=FO_72H_group;
lsmeans  FO_72H_group; /* generate means */ 
contrast '<5 vs >5 ' FO_72H_group 1 -0.5 -0.5;
contrast '<5 vs >10 ' FO_72H_group 1 0 -1;
/* FO_72H_group;*/
run; 

/*compare between the <5 and >5, and <5 and >10 for continuous variables*/
%macro m1(v);
proc glm data=lim.tx_n102; 
class FO_72H_group;
model &v=FO_72H_group; 
contrast '<5 vs >5 ' FO_72H_group 1 -0.5 -0.5;  
contrast '<5 vs >10 ' FO_72H_group 1 0 -1;  
run;
%mend;
%m1(Age_trspl_yr);
%m1(Admit_Wt);
%m1(Max_VIS_24H);
%m1(Max_VIS_72H);
%m1(Lowest_UOP); 
%m1(Pre_Tx_Cr_Mean);/*baseline Cr*/
%m1(Donor_Ischemic_Time);
%m1(Cross_Clamp_Time);
%m1(Bypass_Time);

%macro mn(v);
proc means data=lim.tx_n102 n mean std maxdec=2; var &v; run; 
proc means data=lim.tx_n102 n mean std maxdec=2; class  FO_72H_group;
var &v; run; 
proc anova data=lim.tx_n102;
class  FO_72H_group;
model  &v=FO_72H_group;
run; 
%mend;
%mn(Age_trspl_yr); 
%mn(Admit_Wt);
%mn(Max_VIS_24H);
%mn(Max_VIS_72H);
%mn(Lowest_UOP);
%mn(Pre_Tx_Cr_Mean);/*baseline Cr*/
%mn(Donor_Ischemic_Time);
%mn(Cross_Clamp_Time);
%mn(Bypass_Time);

/* subgroup analysis for 1 & 3 group, comparing diachotomous variables <5 and >10 */
%macro ch(v);
proc freq data=lim.tx_n102;
tables &v*FO_72H_group/norow nopercent chisq;
where FO_72H_group in("1. <5","3. >10");   
run; 
%mend;
%ch(Male01); 
%ch(Hispanic01);
%ch(Age_LT_1yr01);
%ch(Transplant_Indication);
%ch(Prim_Graft_Fail_ECMO01);
%ch(ECMO_bf_Transplant01);/*ECMO*/
%ch(VADS_bf_Transplant_01);/*VAD*/
%ch(Dual_Transplant);
%ch(Cya_vs_Acy);

/* comparing diachotomous variables <5 and >5 */
%macro c1(v);
proc freq data=lim.tx_n102;
tables &v*FO_72H_group2/norow nopercent chisq;
run; 
%mend;
%c1(Male01); 
%c1(Hispanic01);
%c1(Age_LT_1yr01);
%c1(Transplant_Indication);
%c1(Prim_Graft_Fail_ECMO01);
%c1(ECMO_bf_Transplant01);/*ECMO*/
%c1(VADS_bf_Transplant_01);/*VAD*/
%c1(Dual_Transplant);
%c1(Cya_vs_Acy);




%macro mn(v);
proc means data=lim.tx_n102 n mean std maxdec=2; var &v; run; 
proc means data=lim.tx_n102 n mean std maxdec=2; class  FO_1wk_group;
var &v; run; 
proc anova data=lim.tx_n102;
class  FO_1wk_group;
model  &v=FO_1wk_group;
run; 
%mend;
%mn(Age_trspl_yr); 
%mn(Admit_Wt);
%mn(Max_VIS_24H); /*48H for the 2rd table, typo?*/
%mn(Max_VIS_72H);
%mn(Lowest_UOP);
%mn(Pre_Tx_Cr_Mean);/*baseline Cr*/
%mn(Donor_Ischemic_Time);
%mn(Cross_Clamp_Time);
%mn(Bypass_Time);

%macro ch(v);
proc freq data=lim.tx_n102;
tables &v*FO_1wk_group/norow nopercent chisq;
run; 
%mend;
%ch(Male01); 
%ch(Hispanic01);
%ch(Age_LT_1yr01);
%ch(Transplant_Indication);
%ch(Prim_Graft_Fail_ECMO01);
%ch(ECMO_bf_Transplant01);/*ECMO*/
%ch(VADS_bf_Transplant_01);/*VAD*/
%ch(Dual_Transplant);
%ch(Cya_vs_Acy);

/*dm 'odsresults; clear';*/

/*compare between the <5 and >5, and <5 and >10 for continuous variables, group by 1wk*/
%macro m1(v);
proc glm data=lim.tx_n102; 
class FO_1wk_group;
model &v=FO_1wk_group; 
contrast '<5 vs >5 ' FO_1wk_group 1 -0.5 -0.5;  
contrast '<5 vs >10 ' FO_1wk_group 1 0 -1;  
run;
%mend;
%m1(Age_trspl_yr);
%m1(Admit_Wt);
%m1(Max_VIS_24H);
%m1(Max_VIS_72H);
%m1(Lowest_UOP); 
%m1(Pre_Tx_Cr_Mean);/*baseline Cr*/
%m1(Donor_Ischemic_Time);
%m1(Cross_Clamp_Time);
%m1(Bypass_Time);

/* subgroup analysis for 1 & 3 group, comparing diachotomous variables <5 and >10, group by 1wk */
%macro ch(v);
proc freq data=lim.tx_n102;
tables &v*FO_1wk_group/norow nopercent chisq;
where FO_1wk_group in("1. <5","3. >10");   
run; 
%mend;
%ch(Male01); 
%ch(Hispanic01);
%ch(Age_LT_1yr01);
%ch(Transplant_Indication);
%ch(Prim_Graft_Fail_ECMO01);
%ch(ECMO_bf_Transplant01);/*ECMO*/
%ch(VADS_bf_Transplant_01);/*VAD*/
%ch(Dual_Transplant);
%ch(Cya_vs_Acy);

/* comparing diachotomous variables <5 and >5, group by 1wk*/
%macro c1(v);
proc freq data=lim.tx_n102;
tables &v*FO_1wk_group2/norow nopercent chisq;
run; 
%mend;
%c1(Male01); 
%c1(Hispanic01);
%c1(Age_LT_1yr01);
%c1(Transplant_Indication);
%c1(Prim_Graft_Fail_ECMO01);
%c1(ECMO_bf_Transplant01);/*ECMO*/
%c1(VADS_bf_Transplant_01);/*VAD*/
%c1(Dual_Transplant);
%c1(Cya_vs_Acy);

/******* logistic regression *****/
proc freq data=lim.tx_n102;
	tables FO_72H_group2 Death_postop01 FO_72H_group2*Death_postop01;
run;

%macro lr(v); /*comparing <5 and >5 for 72H*/
proc logistic data=lim.tx_n102 descending;
class FO_72H_group2(ref="1. <5") / param=ref;
model &v = FO_72H_group2 / expb;
run; 
%mend;
%lr(death01);
%lr(Death_less_1Y01);
%lr(Death_postop01);
%lr(Clinc_Rej_less_1Y_post_Tx01);
%lr(Clin_rej_biop_less_1Y_post_Tx01);
data lim.tx_n102; /*replace the unk by missing value*/
	set lim.tx_n102; 
	if Elevated_RAP_post_OP_1_4Wks="unk" then Elevated_RAP_post_OP_1_4Wks=""; 
	if Elevated_PCWP_post_OP_1_4Wks="unk" then Elevated_PCWP_post_OP_1_4Wks=""; 
	if Low_CO_post_OP_1_4Wks="unk" then Low_CO_post_OP_1_4Wks="";

	if Elevated_RVP_early_3_6Mo="unk" then Elevated_RVP_early_3_6Mo="";
	if Elevated_PCWP_early_3_6Mo="unk" then Elevated_PCWP_early_3_6Mo="";
	if Low_CO_early_3_6Mo="unk" then Low_CO_early_3_6Mo="";

	if Elevated_RVP_late_1Yr="unk" then Elevated_RVP_late_1Yr="";
	if Elevated_PCWP_late_1Yr="unk" then Elevated_PCWP_late_1Yr="";
	if Low_CO_late_1Yr="unk" then Low_CO_late_1Yr="";
run; 
%lr(Elevated_RAP_post_OP_1_4Wks);
%lr(Elevated_PCWP_post_OP_1_4Wks);
%lr(Low_CO_post_OP_1_4Wks);

%lr(Elevated_RVP_early_3_6Mo);
%lr(Elevated_PCWP_early_3_6Mo);
%lr(Low_CO_early_3_6Mo);

%lr(Elevated_RVP_late_1Yr);
%lr(Elevated_PCWP_late_1Yr);
%lr(Low_CO_late_1Yr);

%lr(AKI_w_in_7d_post_Tx01);
%lr(CRRT_during_Hosp01);




proc freq data=lim.tx_n102; 
	tables Clinc_Rej_less_1Y_post_Tx01 Clin_rej_biop_less_1Y_post_Tx01;
run; 

/*for the 1 week variable */
%macro lr_1wk(v); /*comparing <5 and >5 for 1wk*/
proc logistic data=lim.tx_n102 descending;
class FO_1wk_group2(ref="1. <5") / param=ref;
model &v = FO_1wk_group2 / expb;
run; 
%mend;
%lr_1wk(death01);
%lr_1wk(Death_less_1Y01);
%lr_1wk(Death_postop01);
%lr_1wk(Clinc_Rej_less_1Y_post_Tx01);
%lr_1wk(Clin_rej_biop_less_1Y_post_Tx01);

%lr_1wk(Elevated_RAP_post_OP_1_4Wks);
%lr_1wk(Elevated_PCWP_post_OP_1_4Wks);
%lr_1wk(Low_CO_post_OP_1_4Wks);

%lr_1wk(Elevated_RVP_early_3_6Mo);
/*proc freq data=lim.tx_n102; */
/*	tables Elevated_RVP_early_3_6Mo FO_1wk_group2 Elevated_RVP_early_3_6Mo*FO_1wk_group2;*/
/*run;*/
%lr_1wk(Elevated_PCWP_early_3_6Mo);
%lr_1wk(Low_CO_early_3_6Mo);

%lr_1wk(Elevated_RVP_late_1Yr);
%lr_1wk(Elevated_PCWP_late_1Yr);
%lr_1wk(Low_CO_late_1Yr);

%lr_1wk(AKI_w_in_7d_post_Tx01);
%lr_1wk(CRRT_during_Hosp01);

/*comparing the group in("1. <5","3. >10". for 72H*/
%macro lr_more_10(v); 
proc logistic data=lim.tx_n102 descending;
where FO_72H_group in("1. <5","3. >10");
class FO_72H_group(ref="1. <5") / param=ref;
model &v = FO_72H_group / expb;
run; 
%mend;
%lr_more_10(death01);
%lr_more_10(Death_less_1Y01);
%lr_more_10(Death_postop01);
%lr_more_10(Clinc_Rej_less_1Y_post_Tx01);
%lr_more_10(Clin_rej_biop_less_1Y_post_Tx01);

%lr_more_10(Elevated_RAP_post_OP_1_4Wks);
%lr_more_10(Elevated_PCWP_post_OP_1_4Wks);
%lr_more_10(Low_CO_post_OP_1_4Wks);

%lr_more_10(Elevated_RVP_early_3_6Mo);
%lr_more_10(Elevated_PCWP_early_3_6Mo);
%lr_more_10(Low_CO_early_3_6Mo);

%lr_more_10(Elevated_RVP_late_1Yr);
%lr_more_10(Elevated_PCWP_late_1Yr);
%lr_more_10(Low_CO_late_1Yr);

%lr_more_10(AKI_w_in_7d_post_Tx01);
%lr_more_10(CRRT_during_Hosp01);

%macro lr_more_10_1wk(v);/*comparing the group in("1. <5","3. >10". 1 wk variable*/
proc logistic data=lim.tx_n102 descending;
where FO_1wk_group in("1. <5","3. >10");
class FO_1wk_group(ref="1. <5") / param=ref;
model &v = FO_1wk_group / expb;
run; 
%mend;
%lr_more_10_1wk(death01);
%lr_more_10_1wk(Death_less_1Y01);
%lr_more_10_1wk(Death_postop01);
%lr_more_10_1wk(Clinc_Rej_less_1Y_post_Tx01);
%lr_more_10_1wk(Clin_rej_biop_less_1Y_post_Tx01);

%lr_more_10_1wk(Elevated_RAP_post_OP_1_4Wks);
%lr_more_10_1wk(Elevated_PCWP_post_OP_1_4Wks);
%lr_more_10_1wk(Low_CO_post_OP_1_4Wks);

%lr_more_10_1wk(Elevated_RVP_early_3_6Mo);
%lr_more_10_1wk(Elevated_PCWP_early_3_6Mo);
%lr_more_10_1wk(Low_CO_early_3_6Mo);

%lr_more_10_1wk(Elevated_RVP_late_1Yr);
%lr_more_10_1wk(Elevated_PCWP_late_1Yr);
%lr_more_10_1wk(Low_CO_late_1Yr);

%lr_more_10_1wk(AKI_w_in_7d_post_Tx01);
%lr_more_10_1wk(CRRT_during_Hosp01);



/*the LOS table */

proc means data=lim.Tx_n102; 
	var D_hosp_aftr_Tx n_hosp_1yr Rej_Epi_n;
	class FO_72H_group2;
run;

proc means data=lim.Tx_n102; 
	var D_hosp_aftr_Tx n_hosp_1yr Rej_Epi_n;
	class FO_72H_group3;
run;

proc univariate data=lim.Tx_n102; 
	var D_hosp_aftr_Tx n_hosp_1yr Rej_Epi_n;
	class FO_72H_group2;
run;

proc univariate data=lim.Tx_n102; 
	var D_hosp_aftr_Tx n_hosp_1yr Rej_Epi_n;
	class FO_72H_group3;
run;

%macro t572H(v);
proc ttest data=lim.tx_n102; 
	class FO_72H_group2;
	var &v;
run;
%mend; 
/*for some reasons the macro doesn't work */
t572H(D_hosp_aftr_Tx);
t572H(n_hosp_1yr);
t572H(Rej_Epi_n);

proc ttest data=lim.tx_n102; 
	class FO_72H_group3;
	var Rej_Epi_n;
run;


/*start to run from here */
proc means data=lim.Tx_n102; 
	var D_hosp_aftr_Tx n_hosp_1yr Rej_Epi_n;
	class FO_1wk_group2;
run;

proc means data=lim.Tx_n102; 
	var D_hosp_aftr_Tx n_hosp_1yr Rej_Epi_n;
	class FO_1wk_group3;
run;

proc univariate data=lim.Tx_n102; 
	var D_hosp_aftr_Tx n_hosp_1yr Rej_Epi_n;
	class FO_1wk_group2;
run;

proc univariate data=lim.Tx_n102; 
	var D_hosp_aftr_Tx n_hosp_1yr Rej_Epi_n;
	class FO_1wk_group3;
run;

proc ttest data=lim.tx_n102; 
	class FO_1wk_group2;
	var Rej_Epi_n;
run;

/*getting the IQR */
proc means data=lim.tx_n102 n mean std min q1 median q3 max maxdec=3; 
	var D_hosp_aftr_Tx n_hosp_1yr Rej_Epi_n;
	class FO_1wk_group3;
run; 

