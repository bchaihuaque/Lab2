/********************************************************************************
* PROJECTO	: 	Lab 2                           
* TITULO	: 	Intention
* DATE		:	24/06/2022
* Author	: 	Bruno Chaihuaque
*********************************************************************************/

clear
cls
*** 0.1 setting user's path (absolutos)

	if ("`c(username)'"  ==  "bchai"){
		global   	project   				"D:/Estudiando/Stata/Stata Avanzado/course-materials-jan-2020"
	}
	
	if ("`c(username)'") == "MEF"{
		global		project					"D:\Doctorado\MetQuant1"
	}
	
*** 0.2 setting folder structure (dinámicos)
	
		global		data 					"${project}/data" 
	
import spss using "${data}/Uso App.sav", clear
tab Gender
tab Gender, nolab

tab Age
tab Age, nolab

tab Main_Activity
tab Main_Activity, nolab
gen D_Hombre =.
replace D_Hombre = 1 if Gender == 1
replace D_Hombre = 0 if Gender == 2 | Gender == .
tab D_Hombre
label define Hombre 0 "female" 1 "male"
label values D_Hombre Hombre 

save "${data}/uso_app.dta", replace
