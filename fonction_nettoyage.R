#################### nettoyage de la base de donnees

install.packages("tidyverse")
library(tidyverse) # nous utilisons ce package car cela permet d'avoir une syntaxe coherente, une facilite d'utilisation et des puissantes capacites de manipulation de donnees
summary.data.frame(combined_data)
unique(combined_data$transparence_eau)


# Ici je veux que la variable de transparence de l'eau soit pris en compte comme un facteur et non un simple charactere (parce que ici il y a des niveaux!)
# On voulait classr la varibale transparence de l'eau puisque il s'agit d'une variable categorique et nous voulions que R comprenne la différence entre elever, moyen et faible 
combined_data$transparence_eau<- as.factor(combined_data$transparence_eau)
class(combined_data$transparence_eau)
levels(combined_data$transparence_eau)


################ Fonction qui place la les valeurs (elever, moyenne et faible) en ordre de niveau

convert_transparence_eau <- function(transparence) {
  combined_data$transparence_eau<- as.factor(combined_data$transparence_eau)
  # Modification de la colonne transparence_eau
  data_transpa <- factor(combined_data$transparence_eau, levels = c("élevée", "moyenne", "faible"))
  # Retourner la base de données modifiée
  levels(combined_data$transparence_eau)
  
  return(data_transpa)
}


####################### Donnees retenues et ajouts de colonnes (ID_observation et id_date)

donnee_retenue<-function(suppression){
  combined_data <-  combined_data[, -c(13:30)]
  combined_data <-  combined_data[, -3]
  combined_data$ID_observation<- c(1:2006) 
  
  combined_data<- combined_data %>%
    mutate(id_date=cumsum(date != lag(date, default = first(date)))) 
  
  return(combined_data)
}


###################### Uniformiser le format des dates

# Convertir la colonne "heure_obs" en format hh:mm:ss
# Fonction pour convertir le format xxhmm.ss en hh:mm:ss

convertir_heure <- function(heure) {
  # Extraire les heures, les minutes et les secondes
  
  heures <- substr(heure, 1, 2)
  minutes <- substr(heure, 4, 5)
  secondes <- sprintf("%.0f", as.numeric(substr(heure, 7, 9)) * 60)
  
  # Assembler les composantes en format hh:mm:ss
  heure_convertie <- paste(heures, minutes, secondes, sep = ":")
  
  return(heure_convertie)
  
}


# Appliquer la fonction de conversion à la colonne "heure_obs"
combined_data$heure_obs <- sapply(combined_data$heure_obs, convertir_heure)
# Afficher les premières lignes du tableau pour vérifier
head(combined_data)



################### ligne pour enlever les doublons

combined_data <-combined_data[!duplicated(combined_data),]



################### telechager la BD finale dans notre projet

telechargement <- function(sauvegarde){
# Definition du chemin de fichier
chemin_telechargement <- "C:/Users/ALEXIS/OneDrive/Bureau/Atelier2_ AlexisGabJust/projet-gab-alex-just"

# Nom du fichier CSV de sortie
nom_fichier <- "combined_data.csv"

# Chemin complet du fichier de sortie
chemin_complet <- file.path(chemin_telechargement, nom_fichier)

# Sauvegarde du tableau en tant que fichier CSV
write.csv(combined_data, file = chemin_complet, row.names = FALSE)

# Affichage d'un message indiquant que le fichier a pu etre enregistrer avec succes
cat("Le fichier", nom_fichier, "a pu etre enregistrer sur votre projet.\n")

return(combined_data)
}
