
use foodchoice_last

* race3: 1 = Asian, 2 = White , 3 = Hispanic, 4 = Other
replace race3 = "Other" if race3==""
replace faminc = "me50_100" if faminc==""
g findep = 0
replace findep=1 if financial_indepe=="No"

g asianF = asian_i*gender_i
g hispF = hispanic_i*gender_i

**** WHY***
* Barrier 1: don't care *

eststo clear
eststo: xi: ologit import_healthy gender_i asian_i hispanic_i asianF hispF  
eststo: xi: ologit import_healthy finan_in_i income_i  income_indep 
eststo: xi: ologit import_healthy i.shop i.eat3
eststo: xi: ologit import_healthy gender_i asian_i hispanic_i asianF hispF finan_in_i income_i  income_indep    i.shop i.eat3
eststo: xi: ologit healthy gender_i asian_i hispanic_i asianF hispF
eststo: xi: ologit healthy finan_in_i income_i  income_indep   
eststo: xi: ologit healthy i.shop i.eat3
eststo: xi: ologit healthy gender_i asian_i hispanic_i asianF hispF finan_in_i income_i  income_indep     i.shop i.eat3   

estout * using Output_GH\Bar1a.txt, style(tex) cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) var(20) replace   stats(N r2_p, fmt(%5.0f  %5.3f) labels("N" "Pseudo R$^2$" ))  

* Don't know descriptive * 

**** HOW ****
* Barriers_grouped *

eststo clear
global barriers_g1  individual sociocultural economic
global barriers_g2  expense_g  access_g  peer_g motivation_g control_g time_g 

set more off
foreach x of var $barriers_g2 {
*eststo: xi: probit  `x'  gender_i asian_i hispanic_i asianF hispF
*eststo: xi: probit  `x'  finan_in_i income_i  income_indep   
*eststo: xi: probit  `x'  i.shop i.eat3
eststo: xi: probit  `x'  gender_i asian_i hispanic_i asianF hispF finan_in_i income_i  income_indep   i.shop i.eat3  
}
 
estout * using Output_GH\Bars.txt, style(tex) cells(b(star fmt(3)) se(par fmt(3))) starlevels(* 0.10 ** 0.05 *** 0.01) var(20) replace   stats(N r2_p, fmt(%5.0f  %5.3f) labels("N" "Pseudo R$^2$" ))  
