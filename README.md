# TEW-RF
Risk-based Tsunami Early Warning Using Random Forest
This repository contains MATLAB code for implementing the Random Forest algorithm for regression tasks on building assets loss caused by tsunami. The Random Forest algorithm is a powerful ensemble learning method that combines multiple decision trees to make predictions.

Prerequisites
To run the code in this repository, you need:
•	MATLAB (2021 or higher)

Installation
1.	Clone this repository to your local machine (REQUIRED_DATA.mat and short_code.m)
2.	Open MATLAB and navigate to the repository folder

Usage
1.	Load the dataset (REQUIRED_DATA.mat) into MATLAB
2.	Open the ‘short_code.m’ file in MATLAB
3.	Set the option for response variable (1 for tsunami height and 2 for tsunami loss), number of offshore sensors (1 for 99 sensors and 2 for 6 sensors), and waiting time
4.	The input features are maximum wave amplitude from each offshore sensors and earthquake information, including magnitude, longitude, and latitude. The main response variable is tsunami loss.
5.	Run the ‘short_code.m’ file in MATLAB
6.	The results, including mean squared error and scatter plot for comparing model performance will be displayed in the MATLAB console

Contact
For any inquiries or questions, please contact Yao Li and Katsuichiro Goda at yli3285@uwo.ca, kgoda2@uwo.ca. 
