/******************************************************************************************************/

proc datasets;
   delete survey;
run;


/* Upload data */
proc import datafile = "/home/u62537962/sample_chess.csv"
 out = survey
 dbms = CSV
 ;
run;

/* View data */
proc print data = survey;
run;

/*fitting Poisson regression model*/
proc genmod;
 class Termination(ref="Normal") White_elo_category(ref="Low rating") Black_elo_category(ref="Low rating") 
 Game_type(ref="Rapid") ;
 model White_blunders = Termination White_elo_category Black_elo_category increment Game_type Total_moves / dist=poisson link=log;
run;

/*checking model fit*/
proc genmod;
 model White_blunders = / dist=poisson link=log;
run; 

data deviance;
 deviance = -2*(-69.8215 - (-53.0404));
 pvalue = 1 - probchi(deviance,8);
run;

proc print noobs;
run;

/*using fitted model for prediction*/
data prediction;
input Termination$ White_elo_category$ Black_elo_category$ increment Game_type$ Total_moves;
cards;
Normal night Low rating High rating 0 Rapid 40
;

  
data survey;
set survey prediction;
run;

proc genmod;
 class Termination(ref="Normal") White_elo_category(ref="Low rating") Black_elo_category(ref="Low rating") 
 Game_type(ref="Rapid");
 model White_blunders = Termination White_elo_category Black_elo_category increment Game_type Total_moves / dist=poisson link=log;
 output out=outdata p=pred;
run;

proc print data=outdata (firstobs=93) noobs;
 var pred;
run;
/******************************************************************************************************/