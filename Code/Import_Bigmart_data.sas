PROC IMPORT OUT= WORK.BIGMART_data_Original 
            DATAFILE= "D:\Stevens\Courses\CS593\Project\Bigmart_data.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
Quit;


*Create a copy to work on and perform transformations;
PROC IMPORT OUT= WORK.BIGMART_data
            DATAFILE= "D:\Stevens\Courses\CS593\Project\Bigmart_data.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
Quit;

******;
* Please run the "Exploratory_Analysis.sas" File
******;
