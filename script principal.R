# BIO 500 - Atelier 1
# Main script pour le jeu de donn?e de benthos
# Fait appel ? la fonction pour la table 1

# 1. chemin vers les donn?es
Chem <- "combined_data.csv"

# Lecture de la table 1
source ("table_1.R")
table <- table1(data1)
table

# Lecture de la table 2
source ("table_2.R")
tabl <- table2(data2)
tabl

# Lecture de la table 3
source ("table_3.R")
tab <- table3(data3)
tab

#On ne retrouve pas l'ensemble des variables de notre base de donn?es car nous estimons qu'elles ne seront pas utilisables dans le futur (trop de NA's)