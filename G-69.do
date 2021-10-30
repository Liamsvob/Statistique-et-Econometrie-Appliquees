cd "H:\SEA19\Projet"
use G-69.dta, clear


 // 1.1
 generate male = ( gender == "M")
 
 //1.1.1
 label define male 1 "Masculin" 0 "Feminin"
 
 //1.2
 g cct = ( group == "CCT")
 g ccttraining = ( group == "CCT + Training")
 g control = ( group != "CCT" & group != "CCT + Training")
 
//1.3
replace group = "1" if group == "CCT"
replace group = "2" if group == "CCT + Training"
replace group = "3" if group == "CONTROL"
destring group, replace

//1.4
g cct_male = male*cct
g ccttraining_mal = male*ccttraining

//1.5

//ssc install outreg2

rename z_tvip_06 tvip_05
label variable group "Groupe de traitement"
label define group 1 "CCT" 2 "CCT + formation" 3 "Contrôle"
label values group group

label variable cct "CCT"
label define cct 1 "CCT" 0 "Non CCT"

label variable ccttraining "CCT + formation"
label define ccttraining 1 "CCT + formation" 0 "Non CCT + Formation"

label variable control "Groupe contrôle"
label define control 1 "Contrôle" 0 "Traitement"

label variable male "Homme"


label variable age_transfer " ge (en mois) au premier transfert"
label variable s2mother_inhs_05 "Mère vit dans un foyer"
label define s2mother_inhs_05 1 "Oui" 0 "Non"
label variable ed_mom "Années d’éducation de la mère"
label variable ed_dad "Années d’éducation du père"
label variable tvip_05 "Score au test de vocabulaire"
label variable bweight "Poids de naissance"
label variable s1male_head_05 "Homme chef de ménage"
label define s1male_head_05 1 "Oui" 0 "Non"
label variable s1hhsize_05 "Taille du ménage"
label variable s3awater_access_hh_05 "Accès à l’eau courante"
label define s3awater_access_hh_05 1 "Oui" 0 "Non"
label variable cons_food_pc_05 "Consommation de nourriture par tête"
label variable z_language_08 "Score au test de langue (standardisé)"
label variable z_memory_08 "Score au test de mémoire (standardisé)"
label variable z_martians_08 "Score au test de mémoire associative (standardisé)"
label variable z_social_08 "Score au test de compétences interpersonnelles (standardisé)"
label variable z_grmotor_08 "Score au test de motricité globale (standardisé)"
label variable z_finmotor_08 "Score au test de motricité fine (standardisé)"

//2.1

tabstat male age_transfer s2mother_inhs_05 ed_mom ed_dad bweight s1male_head_05 ///
s1hhsize_05 s3awater_access_hh_05 cons_food_pc_05, stat(mean sd count) by(group) ///
columns(variable)
return list
putexcel set tabstat.xlsx, replace


ttest male if group ==1 | group ==3, by(group)
ttest male if group ==2 | group ==3, by(group)

ttest age_transfer if group ==1 | group ==3, by(group)
ttest age_transfer if group ==2 | group ==3, by(group)

ttest s2mother_inhs_05 if group ==1 | group ==3, by(group)
ttest s2mother_inhs_05 if group ==2 | group ==3, by(group)

ttest ed_mom if group ==1 | group ==3, by(group)
ttest ed_mom if group ==2 | group ==3, by(group)

ttest ed_dad if group ==1 | group ==3, by(group)
ttest ed_dad if group ==2 | group ==3, by(group)

ttest bweight if group ==1 | group ==3, by(group)
ttest bweight if group ==2 | group ==3, by(group)

ttest s1male_head_05 if group ==1 | group ==3, by(group)
ttest s1male_head_05 if group ==2 | group ==3, by(group)

ttest s1hhsize_05 if group ==1 | group ==3, by(group)
ttest s1hhsize_05 if group ==2 | group ==3, by(group)

ttest s3awater_access_hh_05 if group ==1 | group ==3, by(group)
ttest s3awater_access_hh_05 if group ==2 | group ==3, by(group)

ttest cons_food_pc_05 if group ==1 | group ==3, by(group)
ttest cons_food_pc_05 if group ==2 | group ==3, by(group)


//2.2

*test pour déterminer si les différences entre le groupe de traitement CCT et*
*le groupe de traitement CCT + formation sont statistiquement significatives*
*avant l’intervention (2005)*

quietly reg s2mother_inhs_05 cct ccttraining
test ccttraining=cct
quietly reg ed_mom cct ccttraining
test ccttraining=cct
quietly reg ed_dad cct ccttraining
test ccttraining=cct
quietly reg bweight cct ccttraining
test ccttraining=cct
quietly reg s1male_head_05 cct ccttraining
test ccttraining=cct
quietly reg s1hhsize_05 cct ccttraining
test ccttraining=cct
quietly reg s3awater_access_hh_05 cct ccttraining
test ccttraining=cct
quietly reg cons_food_pc_05 cct ccttraining
test ccttraining=cct
quietly reg age_transfer cct ccttraining
test ccttraining=cct
quietly reg male cct ccttraining
test ccttraining=cct



//3.1

//colonne 1
quietly reg z_language_08 cct ccttraining
estimates store reg20
quietly reg z_memory_08 cct ccttraining
estimates store reg21
quietly reg z_martians_08 cct ccttraining
estimates store reg22
quietly reg z_social_08 cct ccttraining
estimates store reg23
quietly reg z_grmotor_08 cct ccttraining
estimates store reg24
quietly reg z_finmotor_08 cct ccttraining
estimates store reg25
esttab reg20 reg21 reg22 reg23 reg24 reg25 , star(* 0.1 ** 0.05 *** 0.01) se


//colonne 2
quietly reg z_language_08 cct ccttraining male i.age_transfer cons_food_pc_05 s3awater_access_hh_05 ///
s1hhsize_05 s1male_head_05 bweight ed_dad ed_mom s2mother_inhs_05
estimates store reg30
quietly reg z_memory_08 cct ccttraining male i.age_transfer cons_food_pc_05 s3awater_access_hh_05 ///
s1hhsize_05 s1male_head_05 bweight ed_dad ed_mom s2mother_inhs_05
estimates store reg31
quietly reg z_martians_08 cct ccttraining male i.age_transfer cons_food_pc_05 s3awater_access_hh_05 ///
s1hhsize_05 s1male_head_05 bweight ed_dad ed_mom s2mother_inhs_05
estimates store reg32
quietly reg z_social_08 cct ccttraining male i.age_transfer cons_food_pc_05 s3awater_access_hh_05 ///
s1hhsize_05 s1male_head_05 bweight ed_dad ed_mom s2mother_inhs_05
estimates store reg33
quietly reg z_grmotor_08 cct ccttraining male i.age_transfer cons_food_pc_05 s3awater_access_hh_05 ///
s1hhsize_05 s1male_head_05 bweight ed_dad ed_mom s2mother_inhs_05
estimates store reg34
quietly reg z_finmotor_08 cct ccttraining male i.age_transfer cons_food_pc_05 s3awater_access_hh_05 ///
s1hhsize_05 s1male_head_05 bweight ed_dad ed_mom s2mother_inhs_05
estimates store reg35
esttab reg30 reg31 reg32 reg33 reg34 reg35 , star(* 0.1 ** 0.05 *** 0.01) se drop(*age_transfer)


//colonne 3

quietly reg z_language_08 cct ccttraining male i.age_transfer cons_food_pc_05 s3awater_access_hh_05 ///
s1hhsize_05 s1male_head_05 bweight ed_dad ed_mom s2mother_inhs_05, cluster(unique_05)
estimates store reg40
quietly reg z_memory_08 cct ccttraining male i.age_transfer cons_food_pc_05 s3awater_access_hh_05 ///
s1hhsize_05 s1male_head_05 bweight ed_dad ed_mom s2mother_inhs_05, cluster(unique_05)
estimates store reg41
quietly reg z_martians_08 cct ccttraining male i.age_transfer cons_food_pc_05 s3awater_access_hh_05 ///
s1hhsize_05 s1male_head_05 bweight ed_dad ed_mom s2mother_inhs_05, cluster(unique_05)
estimates store reg42
quietly reg z_social_08 cct ccttraining male i.age_transfer cons_food_pc_05 s3awater_access_hh_05 ///
s1hhsize_05 s1male_head_05 bweight ed_dad ed_mom s2mother_inhs_05, cluster(unique_05)
estimates store reg43
quietly reg z_grmotor_08 cct ccttraining male i.age_transfer cons_food_pc_05 s3awater_access_hh_05 ///
s1hhsize_05 s1male_head_05 bweight ed_dad ed_mom s2mother_inhs_05, cluster(unique_05)
estimates store reg44
quietly reg z_finmotor_08 cct ccttraining male i.age_transfer cons_food_pc_05 s3awater_access_hh_05 ///
s1hhsize_05 s1male_head_05 bweight ed_dad ed_mom s2mother_inhs_05, cluster(unique_05)
estimates store reg45
esttab reg40 reg41 reg42 reg43 reg44 reg45 , star(* 0.1 ** 0.05 *** 0.01) se drop(*age_transfer)

//colonne 3* p-value(CCT vs CCT+Formation)


quietly reg z_language_08 cct ccttraining male i.age_transfer cons_food_pc_05 s3awater_access_hh_05 ///
s1hhsize_05 s1male_head_05 bweight ed_dad ed_mom s2mother_inhs_05, cluster(unique_05)
test cct=ccttraining
quietly reg z_memory_08 cct ccttraining male i.age_transfer cons_food_pc_05 s3awater_access_hh_05 ///
s1hhsize_05 s1male_head_05 bweight ed_dad ed_mom s2mother_inhs_05, cluster(unique_05)
test cct=ccttraining
quietly reg z_martians_08 cct ccttraining male i.age_transfer cons_food_pc_05 s3awater_access_hh_05 ///
s1hhsize_05 s1male_head_05 bweight ed_dad ed_mom s2mother_inhs_05, cluster(unique_05)
test cct=ccttraining
reg z_social_08 cct ccttraining male i.age_transfer cons_food_pc_05 s3awater_access_hh_05 ///
s1hhsize_05 s1male_head_05 bweight ed_dad ed_mom s2mother_inhs_05, cluster(unique_05)
test cct=ccttraining
quietly reg z_grmotor_08 cct ccttraining male i.age_transfer cons_food_pc_05 s3awater_access_hh_05 ///
s1hhsize_05 s1male_head_05 bweight ed_dad ed_mom s2mother_inhs_05, cluster(unique_05)
test cct=ccttraining
quietly reg z_finmotor_08 cct ccttraining male i.age_transfer cons_food_pc_05 s3awater_access_hh_05 ///
s1hhsize_05 s1male_head_05 bweight ed_dad ed_mom s2mother_inhs_05, cluster(unique_05)
test cct=ccttraining

//3.1.2
quietly reg z_language_08 cct ccttraining
estimates store reg100
quietly reg z_language_08 cct ccttraining male
estimates store reg101
quietly reg z_language_08 cct ccttraining male s2mother_inhs_05
estimates store reg102
quietly reg z_language_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05
estimates store reg103
quietly reg z_language_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05
estimates store reg104
quietly reg z_language_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05
estimates store reg105
quietly reg z_language_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05 s1male_head_05
estimates store reg106
quietly reg z_language_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05 s1male_head_05 bweight
estimates store reg107
quietly reg z_language_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05 s1male_head_05 bweight ed_dad
estimates store reg108
quietly reg z_language_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05 s1male_head_05 bweight ed_dad ed_mom
estimates store reg109
quietly reg z_language_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05 s1male_head_05 bweight ed_dad ed_mom  i.age_transfer
estimates store reg110
esttab reg100 reg101 reg102 reg103 reg104 reg105 reg106 reg107 reg108 reg109 reg110 , star(* 0.1 ** 0.05 *** 0.01) se r2

quietly reg z_memory_08 cct ccttraining
estimates store reg200
quietly reg z_memory_08 cct ccttraining male
estimates store reg201
quietly reg z_memory_08 cct ccttraining male s2mother_inhs_05
estimates store reg202
quietly reg z_memory_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05
estimates store reg203
quietly reg z_memory_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05
estimates store reg204
quietly reg z_memory_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05
estimates store reg205
quietly reg z_memory_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05 s1male_head_05
estimates store reg206
quietly reg z_memory_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05 s1male_head_05 bweight
estimates store reg207
quietly reg z_memory_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05 s1male_head_05 bweight ed_dad
estimates store reg208
quietly reg z_memory_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05 s1male_head_05 bweight ed_dad ed_mom
estimates store reg209
quietly reg z_memory_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05 s1male_head_05 bweight ed_dad ed_mom  i.age_transfer
estimates store reg210
esttab reg200 reg201 reg202 reg203 reg204 reg205 reg206 reg207 reg208 reg209 reg210 , star(* 0.1 ** 0.05 *** 0.01) se r2

quietly reg z_martians_08 cct ccttraining
estimates store reg300
quietly reg z_martians_08 cct ccttraining male
estimates store reg301
quietly reg z_martians_08 cct ccttraining male s2mother_inhs_05
estimates store reg302
quietly reg z_martians_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05
estimates store reg303
quietly reg z_martians_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05
estimates store reg304
quietly reg z_martians_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05
estimates store reg305
quietly reg z_martians_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05 s1male_head_05
estimates store reg306
quietly reg z_martians_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05 s1male_head_05 bweight
estimates store reg307
quietly reg z_martians_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05 s1male_head_05 bweight ed_dad
estimates store reg308
quietly reg z_martians_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05 s1male_head_05 bweight ed_dad ed_mom
estimates store reg309
quietly reg z_martians_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05 s1male_head_05 bweight ed_dad ed_mom  i.age_transfer
estimates store reg310
esttab reg300 reg301 reg302 reg303 reg304 reg305 reg306 reg307 reg308 reg309 reg310 , star(* 0.1 ** 0.05 *** 0.01) se r2

quietly reg z_social_08 cct ccttraining
estimates store reg400
quietly reg z_social_08 cct ccttraining male
estimates store reg401
quietly reg z_social_08 cct ccttraining male s2mother_inhs_05
estimates store reg402
quietly reg z_social_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05
estimates store reg403
quietly reg z_social_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05
estimates store reg404
quietly reg z_social_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05
estimates store reg405
quietly reg z_social_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05 s1male_head_05
estimates store reg406
quietly reg z_social_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05 s1male_head_05 bweight
estimates store reg407
quietly reg z_social_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05 s1male_head_05 bweight ed_dad
estimates store reg408
quietly reg z_social_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05 s1male_head_05 bweight ed_dad ed_mom
estimates store reg409
quietly reg z_social_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05 s1male_head_05 bweight ed_dad ed_mom  i.age_transfer
estimates store reg410
esttab reg400 reg401 reg402 reg403 reg404 reg405 reg406 reg407 reg408 reg409 reg410 , star(* 0.1 ** 0.05 *** 0.01) se r2

quietly reg z_grmotor_08 cct ccttraining
estimates store reg500
quietly reg z_grmotor_08 cct ccttraining male
estimates store reg501
quietly reg z_grmotor_08 cct ccttraining male s2mother_inhs_05
estimates store reg502
quietly reg z_grmotor_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05
estimates store reg503
quietly reg z_grmotor_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05
estimates store reg504
quietly reg z_grmotor_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05
estimates store reg505
quietly reg z_grmotor_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05 s1male_head_05
estimates store reg506
quietly reg z_grmotor_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05 s1male_head_05 bweight
estimates store reg507
quietly reg z_grmotor_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05 s1male_head_05 bweight ed_dad
estimates store reg508
quietly reg z_grmotor_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05 s1male_head_05 bweight ed_dad ed_mom
estimates store reg509
quietly reg z_grmotor_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05 s1male_head_05 bweight ed_dad ed_mom  i.age_transfer
estimates store reg510
esttab reg500 reg501 reg502 reg503 reg504 reg505 reg506 reg507 reg508 reg509 reg510 , star(* 0.1 ** 0.05 *** 0.01) se r2

quietly reg z_finmotor_08 cct ccttraining
estimates store reg600
quietly reg z_finmotor_08 cct ccttraining male
estimates store reg601
quietly reg z_finmotor_08 cct ccttraining male s2mother_inhs_05
estimates store reg602
quietly reg z_finmotor_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05
estimates store reg603
quietly reg z_finmotor_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05
estimates store reg604
quietly reg z_finmotor_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05
estimates store reg605
quietly reg z_finmotor_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05 s1male_head_05
estimates store reg606
quietly reg z_finmotor_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05 s1male_head_05 bweight
estimates store reg607
quietly reg z_finmotor_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05 s1male_head_05 bweight ed_dad
estimates store reg608
quietly reg z_finmotor_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05 s1male_head_05 bweight ed_dad ed_mom
estimates store reg609
quietly reg z_finmotor_08 cct ccttraining male s2mother_inhs_05 cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05 s1male_head_05 bweight ed_dad ed_mom  i.age_transfer
estimates store reg610
esttab reg600 reg601 reg602 reg603 reg604 reg605 reg606 reg607 reg608 reg609 reg610 , star(* 0.1 ** 0.05 *** 0.01) se r2

//4.1
*homme* language
quietly reg z_language_08 cct ccttraining i.age_transfer cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05 ///
s1male_head_05 bweight ed_dad ed_mom s2mother_inhs_05 if male == 1, cluster(unique_05)    
estimates store reg50
*femme* language
quietly reg z_language_08 cct ccttraining i.age_transfer cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05 ///
s1male_head_05 bweight ed_dad ed_mom s2mother_inhs_05 if male == 0, cluster(unique_05)    
estimates store reg51
*homme* motor
quietly reg z_grmotor_08 cct ccttraining i.age_transfer cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05 ///
s1male_head_05 bweight ed_dad ed_mom s2mother_inhs_05 if male == 1, cluster(unique_05)
estimates store reg52
*femmes* motor  
quietly reg z_grmotor_08 cct ccttraining i.age_transfer cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05 ///
s1male_head_05 bweight ed_dad ed_mom s2mother_inhs_05 if male == 0, cluster(unique_05)
estimates store reg53
esttab reg50 reg51 reg52 reg53, star(* 0.1 ** 0.05 *** 0.01) se
//4.1.2

//Comparaison des coefficients pour le test de langue
*Femme*
quietly reg z_language_08 cct ccttraining i.age_transfer cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05 ///
s1male_head_05 bweight ed_dad ed_mom s2mother_inhs_05 if male == 1, cluster(unique_05)
return list
*matrice des coefficients*
matrix reg = r(table)
matrix list reg
*matrice des var-cov*
matrix reg_cov = get(VCE)
matrix list reg_cov

scalar cct_z_language_08M=reg[1,1]
scalar cct_z_language_08M_var=reg_cov[1,1]
 
*Hommes*
quietly reg z_language_08 cct ccttraining i.age_transfer cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05 ///
s1male_head_05 bweight ed_dad ed_mom s2mother_inhs_05 if male == 0, cluster(unique_05)    
return list
*matrice des coefficients*
matrix reg = r(table)
matrix list reg
*matrice des var-cov*
matrix reg_cov = get(VCE)
matrix list reg_cov

scalar cct_z_language_08F=reg[1,1]
scalar cct_z_language_08F_var=reg_cov[1,1]


 
//On compare les coefficients pour le test de motricité
*Femme*
quietly reg z_grmotor_08 cct ccttraining i.age_transfer cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05 ///
s1male_head_05 bweight ed_dad ed_mom s2mother_inhs_05 if male == 1, cluster(unique_05)
return list
*matrice des coefficients*
matrix reg = r(table)
matrix list reg
*matrice des var-cov*
matrix reg_cov = get(VCE)
matrix list reg_cov

scalar cct_z_grmotor_08M=reg[1,1]
scalar cct_z_grmotor_08M_var=reg_cov[1,1]

*Homme*
quietly reg z_grmotor_08 cct ccttraining i.age_transfer cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05 ///
s1male_head_05 bweight ed_dad ed_mom s2mother_inhs_05 if male == 0, cluster(unique_05)
return list
*matrice des coefficients*
matrix reg = r(table)
matrix list reg
*matrice des var-cov*
matrix reg_cov = get(VCE)
matrix list reg_cov

scalar cct_z_grmotor_08F=reg[1,1]
scalar cct_z_grmotor_08F_var=reg_cov[1,1]

display ((cct_z_language_08M - cct_z_language_08F) - 0)/(sqrt(cct_z_language_08M_var+cct_z_language_08F_var))

display ((cct_z_grmotor_08M - cct_z_grmotor_08F) -0)/(sqrt(cct_z_grmotor_08F_var + cct_z_grmotor_08M_var))

//4.2
*language*
reg z_language_08 cct ccttraining cct_male male i.age_transfer cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05 ///
s1male_head_05 bweight ed_dad ed_mom s2mother_inhs_05, cluster(unique_05)    
estimates store reg60
*motor*
reg z_grmotor_08 cct ccttraining cct_male male i.age_transfer cons_food_pc_05 s3awater_access_hh_05 s1hhsize_05 ///
s1male_head_05 bweight ed_dad ed_mom s2mother_inhs_05, cluster(unique_05)
estimates store reg61

esttab reg60 reg61, star(* 0.10 ** 0.05 *** 0.01) se drop(*age_transfer)


//5.1 Graphique

ssc install coefplot


*femme* language
eststo languageF : reg z_language_08 cct ccttraining  i.age_transfer cons_food_pc_05 ///
s3awater_access_hh_05 s1hhsize_05 s1male_head_05 bweight ed_dad ed_mom s2mother_inhs_05 ///
if male == 0, cluster(unique_05)     
*homme* language
eststo languageM : reg z_language_08 cct ccttraining  i.age_transfer cons_food_pc_05 ///
s3awater_access_hh_05 s1hhsize_05 s1male_head_05 bweight ed_dad ed_mom s2mother_inhs_05 ///
if male == 1, cluster(unique_05)    
//Graphe Language
coefplot (languageF, label(Femme)) (languageM, label(Homme)), ///
keep(ccttraining) vertical recast(bar)barwidth(0.10) citop ciopts(recast(rcap)) ///
yline (0) xtitle(z_grmotor_08_female Test de motricité globale, ) ytitle(Z-Score) ///
title("Impact sur le test de langage") name(graphe_Lang, replace)

*femmes* motor
eststo motorF: reg z_grmotor_08 ccttraining cct  i.age_transfer cons_food_pc_05 ///
s3awater_access_hh_05 s1hhsize_05 s1male_head_05 bweight ed_dad ed_mom s2mother_inhs_05 ///
if male == 0, cluster(unique_05)
*homme* motor
eststo motorM: reg z_grmotor_08 ccttraining cct  i.age_transfer cons_food_pc_05 ///
s3awater_access_hh_05 s1hhsize_05 s1male_head_05 bweight ed_dad ed_mom s2mother_inhs_05 ///
if male == 1, cluster(unique_05)
//Graphe Motor
coefplot (motorF, label(Femme)) (motorM, label(Homme)), ///
keep(ccttraining) vertical recast(bar)barwidth(0.10) citop ciopts(recast(rcap)) ///
yline (0)xtitle(z_grmotor_08_female Test de motricité globale, ) ytitle(Z-Score) ///
title("Impact sur le test de motricité globale") name(graphe_Motor, replace)


///5.2

graph combine graphe_Lang graphe_Motor, title("Impact du programme CCT + Formation")





