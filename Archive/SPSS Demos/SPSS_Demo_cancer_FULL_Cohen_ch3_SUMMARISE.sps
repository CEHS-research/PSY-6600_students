﻿* Encoding: UTF-8.
*** ==================================================================================== ***.
***   The data set contains part of the data for a study of oral condition of cancer patients 
***   conducted at the Mid-Michigan Medical Center.  The oral conditions of the patients were 
***   measured and recorded at the initial stage, at the end of the second week, at the end of 
***   the fourth week, and at the end of the sixth week.  The variables age, initial weight 
***   and initial cancer stage of the patients were recorded. 
*** 
***   Patients were divided into two groups at random:  
***      One group received a placebo and the other group received aloe juice treatment.  
***
***    Sample size, n = 25 patients with neck cancer. 
*** ==================================================================================== ***.

*** ------------------------------------------------------------------------------------ ***.
*** open new dataset 
*** ------------------------------------------------------------------------------------ ***.

*** You will need to change your path to match where you stored the file on your computer.

GET FILE='C:\Users\A00315273\Box Sync\USU Teaching\Psy6600 Quant 1\Dataset\Cancer.sav'.
DATASET NAME DataSet1 WINDOW=FRONT.


*** ------------------------------------------------------------------------------------ ***.
*** Do some basic prep work
*** ------------------------------------------------------------------------------------ ***.

VARIABLE LABELS
ID      "Identification number"
TRT     "Treatment Group"
AGE     "Incoming Age"
WEIGHIN "Incoming Weight in pounds"
STAGE   "Stage of Cancer".


VALUE LABELS
TRT
   0 "control" 
   1 "aloe treatment" 
   999 "missing"/
AGE WEIGHIN STAGE 
TOTALCIN TOTALCW2 TOTALCW4 TOTALCW6 
   999 "missing".

MISSING VALUES
TRT AGE WEIGHIN STAGE 
TOTALCIN TOTALCW2 TOTALCW4 TOTALCW6
   (999).

RECODE 
TRT AGE WEIGHIN STAGE 
TOTALCIN TOTALCW2 TOTALCW4 TOTALCW6
   (SYSMIS = 999).
EXECUTE.

FORMATS 
ID TRT AGE WEIGHIN STAGE
TOTALCIN TOTALCW2 TOTALCW4 TOTALCW6 (F3).


*** ------------------------------------------------------------------------------------ ***.
*** Compute some new variables.
*** ------------------------------------------------------------------------------------ ***.

NUMERIC total_add total_sum total_avg total_mean (F2).

VARIABLE LABELS
total_add  "TOTAL: ADD using the PLUS symbol"
total_sum  "TOTAL: ADD using the SUM command"
total_avg  "TOTAL: AVG using the PLUS & DIVIDE symbols"
total_mean "TOTAL: AVG using the MEAN command".

COMPUTE total_add = TOTALCIN + TOTALCW2 + TOTALCW4 + TOTALCW6.  
COMPUTE total_sum = sum(TOTALCIN, TOTALCW2, TOTALCW4, TOTALCW6).

COMPUTE total_avg = total_add / 4.  
COMPUTE total_mean = mean(TOTALCIN, TOTALCW2, TOTALCW4, TOTALCW6).
EXECUTE.





*** ==================================================================================== ***.
*** ==================================================================================== ***.
*** CHAPTER 3:CENTER & SPREAD
*** ==================================================================================== ***.
*** ==================================================================================== ***.

*** DESCRIPTIVES /STATISTICS
*** defaults: DEFAULT (MIN, MAX, MEAN, STDDEV)
***   others: RANGE VARIANCE SKEWNESS KURTOSIS SUM

*** MEANS: MEAN && STDDEV, but BY groups

*** FREQUENCIES /STATISTICS
*** defaults: MEAN, STDDEV, MIN, MAX
***   others: SEMEAN VARIANCE, SKEWNESS, SESKEW, RANGE, MODE, KURTOSIS, SEKURT, MEDIAN, SUM

*** EXAMINE /STATISTICS
***  defaults: DESCRIPTIVES (Mean, 95% CI for mean, 5% trimmed mean, median, variance,
                             Stddev, min, max, skewness, kurtosis, range, IQR)                               )
***    others: EXTREME, NONE, ALL

*** ------------------------------------------------------------------------------------ ***.
*** Use the DESCRIPTIVES command to get the SUMMARY STATISTICS (single variables).
*** ------------------------------------------------------------------------------------ ***.

* By default this command gives: N, min, max, mean, & STDDEV.
DESCRIPTIVES AGE.

* If you list multiple variables, it handles them one-at-a-time and makes a nice table.
* Does it make sense to calculate the mean of a categorical variable?.
DESCRIPTIVES AGE TRT
   /STATISTICS DEFAULT.

* Using the option STATISTICS, you can ask for...
DESCRIPTIVES WEIGHIN 
   /STATISTICS MIN MAX RANGE  MEAN STDDEV VARIANCE SKEWNESS KURTOSIS SUM.

* ... or you can ALL.
DESCRIPTIVES 
   AGE WEIGHIN 
   TOTALCIN TOTALCW2 TOTALCW4 TOTALCW6
   total_add total_sum
   total_avg total_mean
   /STATISTICS all.


*** ------------------------------------------------------------------------------------ ***.
*** Use the MEANS command to get the SUMMARY STATISTICS (a pair of variables).
*** ------------------------------------------------------------------------------------ ***.

* This command calculates the SUMMARY STAT's for each level of a categorical variable.
* By default this command gives: MEAN & STDDEV.
MEANS AGE BY TRT.



*** ------------------------------------------------------------------------------------ ***.
*** Use the FREQUENCIES command to get the SUMMARY STATISTICS.
*** ------------------------------------------------------------------------------------ ***.

* Easiest way - all default options.
FREQUENCIES AGE /STATISTICS all.


* Again, you can include the option to not bother with the table & do more than one variable.
FREQUENCIES AGE WEIGHIN total_add total_sum
   /FORMAT NOTABLE
   /STATISTICS all.


* Instead of requesting ALL the statistics, you can list the ones you want.
FREQUENCIES AGE WEIGHIN
   /FORMAT NOTABLE
   /STATISTICS MINIMUM MAXIMUM MEAN MEDIAN 
               STDDEV RANGE SKEWNESS KURTOSIS.


* You can wrap it in the sort/split analyze by subgroups.

* FIRST:  you have to SORT by the variable you are going to split on.
* SECOND: make sure you use a 'temporary.' command so its not permanent.
* THIRD:  make sure you turn the split off at the end.
* FOURTH: its nice to go back to the original sorting.

SORT CASES by TRT.
SPLIT FILE by TRT.
FREQUENCIES AGE WEIGHIN total_add total_sum
   /FORMAT NOTABLE
   /STATISTICS MINIMUM MAXIMUM MEAN MEDIAN STDDEV
   /NTILES(4).
SPLIT FILE off.
SORT CASES by ID.




*** ------------------------------------------------------------------------------------ ***.
*** Use the EXAMINE command to get the SUMMARY STATISTICS (MORE details...including IQR !).
*** ------------------------------------------------------------------------------------ ***.


* This gives a more extensive list of descriptives, byt its all-or-none.
EXAMINE AGE 
   /PLOT NONE
   /STATISTICS DESCRIPTIVES.

* The EXTREME option lists out the 5 highest and 5 lowest values, including the case #.
EXAMINE AGE 
   /PLOT NONE
   /STATISTICS EXTREME.


* This does almost the same thing as wrapping FREQUENCIES in SORT-SPLIT,...
* ... except this one gives you more...like the Range & IQR "Inter Quartile Range!.
EXAMINE AGE BY TRT
   /PLOT NONE
   /STATISTICS DESCRIPTIVES.


EXAMINE AGE BY TRT
   /PLOT NONE
   /STATISTICS all.



*** ------------------------------------------------------------------------------------ ***.
*** Create a BOXPLOT for a continuous variable.
*** ------------------------------------------------------------------------------------ ***.

* Cretae a single boxplot for all subjects.
EXAMINE total_sum /PLOT BOXPLOT /STATISTICS NONE.


* ...seperate by one grouping variable...
EXAMINE total_sum BY TRT
  /PLOT BOXPLOT
  /STATISTICS NONE
  /NOTOTAL.

* You can ask for the statistics with the boxplot.
EXAMINE total_sum BY STAGE
  /PLOT BOXPLOT
  /STATISTICS DESCRIPTIVES
  /NOTOTAL.

* ... or seperate by two grouping variables.
EXAMINE total_sum BY TRT*STAGE
  /PLOT BOXPLOT
  /STATISTICS NONE
  /NOTOTAL.

