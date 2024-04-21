install.packages("targets")
library(targets)
# ===========================================
# _targets.R file
# ===========================================
# Dépendances
# si un des packages manque -> tar_option_set(packages = c("RSQLite", "DBI","dplyr","tidyverse"))
library(targets)

# Scripts R
source("commandes_SQL.R")
source("fonction_combiner.R")
source("fonction_heure.R")
source("fonction_nettoyage.R")
source("requetes.R")
source("figures.R")

# Pipeline
list(
  tar_target(
    name = combinaison_donnees,
    command = combine_csv_files("données") # combinaison des fichiers excel
    
  ),
  tar_target(
    name = nettoyage_donnees,
    command = nettoyage(combinaison_donnees) # nettoyage des donnees (uniformisation heure, suppression doublons et donnees non retenues et creation de colonnes)
  )

)
,
  tar_target(
    name = telechargement_donnees,
    command = telechargement("combined_data") #telechargement de la base de donnees dans le projet 
    
  ),
  tar_target(
    name = creation_tables,
    command = commande("combined_data") #creation des tables sql et injection des donnees via les 4 dataframes 
    
  ),
  tar_target(
    name = Requetes,
    command = requetes_sql("liste_tables") #requetes SQL pour recuperer les donnees issus des tables afin de repondre a nos questions biologiques
    
  ),
  tar_target(
    name = Figures,
    command = figures("liste_requetes") #creations de 3 figures a partir des requetes 
    
  )
)

