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
		global   	project   				"D:/Doctorado/Semestre I/Métodos Cuantitativos 1/Lab2"
	}
	
	else if ("`c(username)'") == "MEF"{
		global		project					"D:\Doctorado\MetQuant1"
	}
	
*** 0.2 setting folder structure (dinámicos)
	
		global		data 					"${project}/data" 
		
		global		outputs					"${project}/outputs"

cd "${project}"
use "${data}/uso_app.dta", clear
tab Gender
tab Gender, nolab

tab Age
tab Age, nolab

tab Main_Activity
tab Main_Activity, nolab
**** Dummy Hombre
gen D_Hombre =.
replace D_Hombre = 1 if Gender == 1
replace D_Hombre = 0 if Gender == 2 | Gender == .
tab D_Hombre
label define Hombre 0 "female" 1 "male"
label values D_Hombre Hombre 
label variable D_Hombre "Dummy hombre"

save "${data}/uso_app.dta", replace

*** Dummy Comunicacion
gen D_Comunicacion =.
replace D_Comunicacion = 1 if Main_Activity == 1
replace D_Comunicacion = 0 if Main_Activity == 2 | Main_Activity == 3 | Main_Activity == 4 | Main_Activity == .
tab D_Comunicacion
label define Comunicacion 0 "otros" 1 "comunicacion"
label values D_Comunicacion Comunicacion
label variable D_Comunicacion "Dummy Comunicación"

*** Dummy Información
gen D_Informacion =.
replace D_Informacion = 1 if Main_Activity == 2
replace D_Informacion = 0 if Main_Activity == 1 | Main_Activity == 3 | Main_Activity == 4 | Main_Activity == .
tab D_Informacion
label define Informacion 0 "otros" 1 "comunicacion"
label values D_Informacion Informacion
label variable D_Informacion "Dummy Información"
*** Dummy Entretenimiento
gen D_Entretenimiento =.
replace D_Entretenimiento = 1 if Main_Activity == 3
replace D_Entretenimiento = 0 if Main_Activity == 1 | Main_Activity == 2 | Main_Activity == 4 | Main_Activity == .
tab D_Entretenimiento
label define Entretenimiento 0 "otros" 1 "entretenimiento"
label values D_Entretenimiento Entretenimiento
label variable D_Entretenimiento "Dummy Entretenimiento"
*** Regression
regress Intention Usefulness Enjoyment Satisfaction Age D_Hombre D_Comunicacion D_Informacion D_Entretenimiento
outreg2 using "${outputs}/Tables_uso_app.doc", replace ctitle(OLS) label

*** Interaction effects
reg Intention Usefulness Enjoyment Satisfaction Age i.D_Hombre i.D_Comunicacion i.D_Informacion i.D_Entretenimiento // no hay diferencia con el método anterior
reg Intention Usefulness Enjoyment Satisfaction i.Age##c.Usefulness ///
i.Age##c.Enjoyment i.Age##c.Satisfaction i.D_Hombre##c.Usefulness /// 
i.D_Hombre##c.Enjoyment i.D_Hombre##c.Satisfaction // no hay diferencia con el método anterior
outreg2 using "${outputs}/Tables_uso_app.doc", append ctitle(interactions) label
*** Efectos marginales
margins D_Hombre, dydx(Usefulness)
outreg2 using "${outputs}/margin_effects.doc", replace ctitle(Usefulness)
margins D_Hombre, dydx(Enjoyment)
outreg2 using "${outputs}/margin_effects.doc", append ctitle(Enjoyment)
margins D_Hombre, dydx(Satisfaction)
outreg2 using "${outputs}/margin_effects.doc", append ctitle(Satisfaction)
margins Age, dydx(Usefulness)


