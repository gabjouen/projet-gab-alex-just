install.packages("targets")
library(targets)
# ===========================================
# _targets.R file
# ===========================================
# Dépendances
tar_option_set(packages = c("RSQLite", "DBI","dplyr","tidyverse"))

# Scripts R
source("BD.R")
source("fonction_combiner.R")
source("fonction_heure.R")
source("fonction_nettoyage.R")
source("script principal.R")
source("table_1.R")
source("table_2.R")
source("table_3.R")

# Pipeline
list(
  # Une target pour le chemin du fichier de donnée permet de suivre les 
  # changements dans le fichier
  tar_target(
    name = path, # Cible
    command = "data/data.txt", # Emplacement du fichier
    format = "file"
  ), 
  # La target suivante a "path" pour dépendance et importe les données. Sans
  # la séparation de ces deux étapes, la dépendance serait brisée et une
  # modification des données n'entrainerait pas l'exécution du pipeline
  tar_target(
    name = data, # Cible pour l'objet de données
    command = read.table(path) # Lecture des données
  ),   
  tar_target(
    resultat_modele, # Cible pour le modèle 
    mon_modele(data) # Exécution de l'analyse
  ),
  tar_target(
    figure, # Cible pour l'exécution de la figure
    ma_figure(data, resultat_modele) # Réalisation de la figure
  )
)