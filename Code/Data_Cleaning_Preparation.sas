*Create 2 new columns: item_type_cat and years_of_operation ;
proc sql;
alter table bigmart_data add
     item_type_cat char(20),
	 years_of_operation int;
run;
quit;

*Set value of item_type_cat if  item_identifier like 'FD%' ;
proc sql;
update bigmart_data
      set item_type_cat='Food' where item_identifier like 'FD%';
run;
quit;


*Set value of item_type_cat if  item_identifier like 'NC%' ;
proc sql;
update bigmart_data
      set item_type_cat='NonConsumable' where item_identifier like 'NC%';
run;
quit;


*Set value of item_type_cat if  item_identifier like 'DR%' ;
proc sql;
update bigmart_data
      set item_type_cat='Drinks' where item_identifier like 'DR%';
run;
quit;


*Check Distinct values for item_fat_content;
proc sql;
select distinct item_fat_content from bigmart_data;
run;
quit;

*Clean the  item_fat_content data by removing faulty values;
data bigmart_data;
  set bigmart_data;
    if item_fat_content="LF" then item_fat_content="Low Fat";
    else if  item_fat_content="low fat" then item_fat_content="Low Fat";
	else if item_fat_content="reg" then item_fat_content="Regular"; 

	if item_type_cat="NonConsumable" then item_fat_content="NonEdible";
run;

*Again Check Distinct values for item_fat_content just to confirm the above code worked;
proc sql;
select distinct item_fat_content from bigmart_data;
run;
quit;

*Run a summary or proc univariate in the numeric data columns;
proc univariate;
var outlet_establishment_year item_weight item_visibility;
run;

*Create a new column "years_of_operation" to use it as a numeric column instead of using the outlet_establishment_year;
proc sql;
update bigmart_data
      set years_of_operation= 2013 - outlet_establishment_year;
run;
quit;


*Identify missing values of "outlet_size"; 
proc sql;
select outlet_type, outlet_size,  count(outlet_size) as count_obs from bigmart_data group by outlet_type, outlet_size ;
run;
quit;

*Replace missing values of "outlet_size" with the Mode as fetched in previous sql; 
data bigmart_data;
  set bigmart_data;
    if outlet_size="" and (outlet_type = "Grocery Store" or outlet_type = "Supermarket Type1") then outlet_size="Small";     
run;


*Replace missing values of item_visibility and item_weight with their respective Mediam values;
data bigmart_data;
  set bigmart_data;
    if item_visibility = 0 then item_visibility= 0.054021;     
	if item_weight = . then item_weight= 12.60000;     
run;



*to check all the possible values of Categorical variables;
proc sql;
select distinct item_fat_content from bigmart_data ;
select distinct outlet_identifier from bigmart_data ;
select distinct outlet_size from bigmart_data ;
select distinct outlet_location_type from bigmart_data ;
select distinct outlet_type from bigmart_data ;
select distinct item_type_cat from bigmart_data ;

run;
quit;


*Create Categorical dummy Variables;
data bigmart_cat_data;
  set bigmart_data;
    if item_fat_content="Low Fat" then Fat_Low=1;
    else Fat_Low=0;
	if item_fat_content="NonEdib" then Fat_NonEdible=1;
    else Fat_NonEdible=0;
	if item_fat_content="Regular" then Fat_Regular=1;
    else Fat_Regular=0;


	if outlet_identifier="OUT010" then Outlet_01 =1;
	else Outlet_01=0;
	if outlet_identifier="OUT013" then Outlet_02 =1;
	else Outlet_02=0;
	if outlet_identifier="OUT017" then Outlet_03 =1;
	else Outlet_03=0;
	if outlet_identifier="OUT018" then Outlet_04 =1;
	else Outlet_04=0;
	if outlet_identifier="OUT019" then Outlet_05 =1;
	else Outlet_05=0;
	if outlet_identifier="OUT027" then Outlet_06 =1;
	else Outlet_06=0;
	if outlet_identifier="OUT035" then Outlet_07 =1;
	else Outlet_07=0;
	if outlet_identifier="OUT045" then Outlet_08 =1;
	else Outlet_08=0;
	if outlet_identifier="OUT046" then Outlet_09 =1;
	else Outlet_09=0;
	if outlet_identifier="OUT049" then Outlet_10 =1;
	else Outlet_10=0;


	if outlet_size="High" then Outlet_Size_High =1;
	else Outlet_Size_High=0;
	if outlet_size="Medium" then Outlet_Size_Medium =1;
	else Outlet_Size_Medium=0;
	if outlet_size="Small" then Outlet_Size_Small =1;
	else Outlet_Size_Small=0;


	if outlet_location_type="Tier 1" then Outlet_Location_Tier_1 =1;
	else Outlet_Location_Tier_1=0;
	if outlet_location_type="Tier 2" then Outlet_Location_Tier_2 =1;
	else Outlet_Location_Tier_2=0;
	if outlet_location_type="Tier 3" then Outlet_Location_Tier_3 =1;
	else Outlet_Location_Tier_3=0;


	if outlet_location_type="Tier 1" then Outlet_Location_Tier_1 =1;
	else Outlet_Location_Tier_1=0;
	if outlet_location_type="Tier 2" then Outlet_Location_Tier_2 =1;
	else Outlet_Location_Tier_2=0;
	if outlet_location_type="Tier 3" then Outlet_Location_Tier_3 =1;
	else Outlet_Location_Tier_3=0;


	if outlet_type="Grocery Store" then Outlet_Type_Grocery =1;
	else Outlet_Type_Grocery=0;
	if outlet_type="Supermarket Type1" then Outlet_Type_Super_1 =1;
	else Outlet_Type_Super_1=0;
	if outlet_type="Supermarket Type2" then Outlet_Type_Super_2 =1;
	else Outlet_Type_Super_2=0;
	if outlet_type="Supermarket Type3" then Outlet_Type_Super_3 =1;
	else Outlet_Type_Super_3=0;


	if item_type_cat="Drinks" then Item_Type_Drinks =1;
	else Item_Type_Drinks=0;
	if item_type_cat="Food" then Item_Type_Food =1;
	else Item_Type_Food=0;
	if item_type_cat="NonConsumable" then Item_Type_NonConsumable =1;
	else Item_Type_NonConsumable=0;
run;


*Create a new column with Log of  item_outlet_sales value;
Data Bigmart_cat_data;
	set Bigmart_cat_data;
	log_item_outlet_sales =  log(item_outlet_sales);

run;
quit;

*Split the original Test and Train Data;
Data Bigmart_cat_data_train (drop=source);
	set Bigmart_cat_data;
	if source="Train" then output;

run;
quit;

Data Bigmart_cat_data_test (drop=source);
	set Bigmart_cat_data;
	if source="Test" then output;

run;
quit;


******;
* Please run the "Machine_Learning_Models.sas" File
******;
