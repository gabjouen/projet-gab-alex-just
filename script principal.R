# BIO 500 - Atelier 1
# Main script pour le jeu de donnee de benthos
# Fait appel a la fonction pour la table 1

# Ces tables ont pu etre former à partir des scripts table_3.R, tables_2.R et table_1.R

# 1. chemin vers les donn?es
Chem <- "combined_data.csv"

# Lecture de la table 1 - Observations de l'échantillon
source ("table_1.R")
table <- table1(data1)
table

# Lecture de la table 2 - Date et heure de l'échantillonnage
source ("table_2.R")
tabl <- table2(data2)
tabl

# Lecture de la table 3 - Caracteristiques physiques des stations d'echantillonnage 
source ("table_3.R")
tab <- table3(data3)
tab

#On ne retrouve pas l'ensemble des variables de notre base de donnees car nous estimons qu'elles ne seront pas utilisables dans le futur (trop de NA's)


source("fonction_nettoyage.R")
trans_data<-convert_transparence_eau(data_transpa)
trans_data
