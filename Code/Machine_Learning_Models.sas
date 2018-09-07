*to find correlation among variables;
proc corr data=Bigmart_cat_data_train pearson 
          plots=matrix(histogram);
   var Item_outlet_sales Item_Weight Item_Visibility Item_MRP Years_Of_Operation Fat_Low Fat_Regular
							  Outlet_01 Outlet_02 Outlet_03 Outlet_04 Outlet_05 Outlet_06 Outlet_07 Outlet_08 Outlet_09 Outlet_10
							  Outlet_size_High Outlet_size_Medium Outlet_size_Small Outlet_Location_Tier_1 Outlet_Location_Tier_2
							  Outlet_Location_Tier_3 Outlet_Type_Grocery Outlet_Type_Super_1 Outlet_Type_Super_2 Outlet_Type_Super_3
							  Item_Type_Drinks Item_Type_Food Item_Type_NonConsumable ;
run;



***********************;
*MULTIPLE LINEAR REGRESSION;
***********************;
*First Iteration of Regression;
Title1 "Proc Reg for Item_outlet_sales";
proc reg data=Bigmart_cat_data_train;
	model Item_outlet_sales = Item_Weight Item_Visibility Item_MRP Years_Of_Operation Fat_Low Fat_Regular
							  Outlet_01 Outlet_02 Outlet_03 Outlet_04 Outlet_05 Outlet_06 Outlet_07 Outlet_08 Outlet_09 Outlet_10
							  Outlet_size_High Outlet_size_Medium Outlet_size_Small Outlet_Location_Tier_1 Outlet_Location_Tier_2
							  Outlet_Location_Tier_3 Outlet_Type_Grocery Outlet_Type_Super_1 Outlet_Type_Super_2 Outlet_Type_Super_3
							  Item_Type_Drinks Item_Type_Food Item_Type_NonConsumable 
/ VIF dwProb selection=STEPWISE;
	OUTPUT OUT = reg_bigmart_OUT RESIDUAL=c_Res h=lev cookd=Cookd dffits=dffit;
	run;
quit;



*Second Iteration of Regression;
Title1 "Proc Reg for Item_outlet_sales";
proc reg data=Bigmart_cat_data_train;
	model Item_outlet_sales = Item_Weight Item_Visibility Item_MRP Years_Of_Operation  Fat_Regular
							   Outlet_size_High Outlet_size_Medium  Outlet_Location_Tier_1 Outlet_Location_Tier_2
							   Outlet_Type_Grocery Outlet_Type_Super_1 Outlet_Type_Super_2 
							  Item_Type_Drinks   
/ VIF dwProb selection=STEPWISE;
	OUTPUT OUT = reg_bigmart_OUT RESIDUAL=c_Res h=lev cookd=Cookd dffits=dffit;
	run;
quit;



*Third Iteration of Regression;
Title1 "Proc Reg for Item_outlet_sales";
proc reg data=Bigmart_cat_data_train;
	model Item_outlet_sales =   Item_MRP   
							   Outlet_size_Medium  
							   Outlet_Type_Grocery Outlet_Type_Super_3  
							     
/ VIF dwProb selection=STEPWISE ;
	OUTPUT OUT = reg_bigmart_OUT RESIDUAL=c_Res h=lev cookd=Cookd dffits=dffit;
	run;
quit;


***************;
***************;
*Fourth Iteration of Regression;
Title1 "Proc Reg for Log of Item_outlet_sales";
proc reg data=Bigmart_cat_data_train;
	model log_Item_outlet_sales =   Item_MRP   
							   Outlet_size_Medium  
							   Outlet_Type_Grocery Outlet_Type_Super_3  / VIF dwProb  selection=STEPWISE;
	OUTPUT OUT = reg_bigmart_OUT RESIDUAL=c_Res h=lev cookd=Cookd dffits=dffit PREDICTED= pred;
	run;
quit;

***************;
***************;


*Calculate actual value of RMSE by taking exponent as we did the log transformation earlier;
data reg_bigmart_OUT ;
	set reg_bigmart_OUT;
	Predicted_Item_outlet_sales = exp(pred);
	Squared_error= (Item_Outlet_Sales - Predicted_Item_outlet_sales)**2;
run;

proc sql;
select SQRT(SUM(Squared_error)/8523) as RMSE from reg_bigmart_OUT;
run;
quit;


*To check normality of Residuals;
PROC UNIVARIATE DATA=reg_bigmart_OUT normal;
 VAR c_Res;
RUN;



***********************;
*DECISION TREE;
***********************;

proc hpsplit data=Bigmart_cat_data_train ;
target Item_outlet_sales / level= INT; *Continuous target variable;
input outlet_size outlet_type /level=NOM; *Categorical dependent variable;
input item_MRP /level=INT; *continuous target variable;
criterion variance;
Prune costcomplexity;
rules file='D:\bigmart_tree_rules.txt'; *Save the file for splitting rules created by SAS;
score out=Dtree_out;

run;
quit;


*Calculate RMSE;
data Dtree_out ;
	set Dtree_out;
	Squared_error= (Item_Outlet_Sales - P_Item_Outlet_Sales)**2;
run;

proc sql;
select SQRT(SUM(Squared_error)/8523) as RMSE from Dtree_out;
run;
quit;



***********************;
*RANDOM FOREST;
***********************;

******sample and partition data;
data Sample_Bigmart_Train Sample_Bigmart_Test;
	set Bigmart_cat_data_train;
	flag= rantbl(-1, 0.7, 0.3);
	if flag=1 then output Sample_Bigmart_Train;
	else output Sample_Bigmart_Test;
run;


******Random Forest;
proc hpforest data = Bigmart_cat_data_train;

	target Item_outlet_sales/level = interval;*Continuous target variable;
	input outlet_size outlet_type / level=nominal;*Categorical independent variables;
	input item_MRP / level = interval; *Continuous independent variables;

	ods output fitstatistics = fitstats;

	save file = "D:\model.bin"; *save the model file;

run;

******Apply Model on Test Data Set;
proc hp4score data = Sample_Bigmart_Test;
	id Item_outlet_sales;
	score file = "D:\model.bin" out = Big_scored;
run;
quit;

*Calculate the RMSE;
data Rforest;
	set Big_scored;
	squared_difference  = (Item_Outlet_Sales - P_Item_Outlet_Sales)**2;
run;

proc sql;
	select sqrt(sum(squared_difference)/2591) as RMSE from Rforest;
run;
quit;


******;
* End of Code;
******;
