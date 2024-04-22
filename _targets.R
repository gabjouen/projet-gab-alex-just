library(targets)
install.packages("tarchetypes")
install.packages("rticles")
install.packages("tinytex")
library(tarchetypes)
library(rticles)
library(tinytex)
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
  ),
  tar_target(
  name = creation_tables,
  command = commande(nettoyage_donnees) #creation des tables sql et injection des donnees via les 4 dataframes 
  
  ),
  tar_target(
  name = Requetes,
  command = requetes_sql(creation_tables) #requetes SQL pour recuperer les donnees issus des tables afin de repondre a nos questions biologiques
  
  ),
  tar_target(
  name = Figures,
  command = figures(Requetes) #creations de 3 figures a partir des requetes 
  
  ),
  tar_render(
    name = Rapport,
    path = "cahier laboratoire.Rmd" 
  )
)  


