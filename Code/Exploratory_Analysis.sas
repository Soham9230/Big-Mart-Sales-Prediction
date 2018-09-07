
*Proc Univariate;
proc univariate DATA=Bigmart_data_original;
var outlet_establishment_year item_weight item_visibility;
run;



*******Plots;
*"Histogram on Item weight";
proc sgplot data=Bigmart_data_original;
  title "Histogram on Item weight";
  histogram item_weight;

  density item_weight;
  density item_weight / type=kernel;
run;

*"Histogram on Item MRP";
proc sgplot data=Bigmart_data_original;
  title "Histogram on Item MRP";
  histogram item_MRP;

  density item_MRP;
  density item_MRP / type=kernel;
run;

*"Histogram on Item visibility";
proc sgplot data=Bigmart_data_original;
  title "Histogram on Item visibility";
  histogram item_visibility;

  density item_visibility;
  density item_visibility / type=kernel;
run;

*"Histogram on Item Outlet Sales";
proc sgplot data=Bigmart_data_original;
  title "Histogram on Item Outlet Sales";
  histogram item_outlet_sales;

  density item_outlet_sales;
  density item_outlet_sales / type=kernel;
run;


*"Outlet vs Sales";
proc sgplot data=Bigmart_data_original;
title "Outlet vs Sales";
xaxis type = discrete;
  yaxis label="Sales" ;
  xaxis label="Outlet" ;
  vbar outlet_identifier / response=item_outlet_sales;

run;

*"Outlet Size vs Sales";
proc sgplot data=Bigmart_data_original;
title "Outlet Size vs Sales";
xaxis type = discrete;
  yaxis label="Sales" ;
  xaxis label="Outlet Size" ;
  vbar outlet_size / response=item_outlet_sales;

run;

*"Outlet Location type vs Sales";
proc sgplot data=Bigmart_data_original;
title "Outlet Location type vs Sales";
xaxis type = discrete;
  yaxis label="Sales" ;
  xaxis label="Outlet Location type" ;
  vbar outlet_location_type / response=item_outlet_sales;

run;

*"outlet Type vs Sales";
proc sgplot data=Bigmart_data_original;
title "outlet Type vs Sales";
xaxis type = discrete;
  yaxis label="Sales" ;
  xaxis label="Outlet Type" ;
  vbar outlet_type / response=item_outlet_sales;

run;


*"Boxplot for Item MRP";
proc sgplot data=Bigmart_data_original;
title "Boxplot for Item MRP";
  hbox item_mrp;
run;

*"Boxplot for Item weight";
proc sgplot data=Bigmart_data_original;
title "Boxplot for Item weight";
  hbox item_weight;
run;

*"Boxplot for Item Outlet Sales";
proc sgplot data=Bigmart_data_original;
title "Boxplot for Item Outlet Sales";
  hbox item_outlet_sales / category=outlet_type;
run;

******;
* Please run the "Data_Cleaning_Preparation.sas" File
******;
