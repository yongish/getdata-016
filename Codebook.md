---
title: "Codebook.md"
author: "Zhiyong Tan"
date: "Tuesday, December 09, 2014"
output: html_document
---

## Summary
run_analysis.R does the following steps:

  1. Download and unzip the data file.
  2. Does a mapply() using an anonymous function to combine training and testing data from the training and testing directories.
  3. Names the data and variables using entries in features.txt and path names.
  4. Use grep and subsetting to extract only the measurements on the mean 
   and standard deviations on each measurement.
  5. Rename the variables accordingly.
  6. Use dplyr functions to group by (activity, subject) and summarize by mean.
   Employ chaining for better readability.
  7. Replace numeric activity labels with string labels from activity_labels.txt.
  8. Tidy data preparation complete. Write to file.

## Variables
data - Main data structure that holds intended output data as it is processed.
       1st appearance as a list of all measurements,  with training and testing data concatenated.

feature.names - Variable names extracted from features.txt. Used to name columns in "data" and subset means and standard deviations.

extract.indexes - Indexes in "data" to be subsetted.