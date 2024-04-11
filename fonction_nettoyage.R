#################### nettoyage de la base de donnees

install.packages("tidyverse")
library(tidyverse) # nous utilisons ce package car cela permet d'avoir une syntaxe coherente, une facilite d'utilisation et des puissantes capacites de manipulation de donnees


# Ici je veux que la variable de transparence de l'eau soit pris en compte comme un facteur et non un simple charactere (parce que ici il y a des niveaux!)
# On voulait classr la varibale transparence de l'eau puisque il s'agit d'une variable categorique et nous voulions que R comprenne la différence entre elever, moyen et faible 
unique(combined_data$transparence_eau)
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
convert_transparence_eau(transparence)



####################### Donnees retenues et ajouts de colonnes (ID_observation et id_date)


donnee_retenue<-function(combined_data){
  combined_data <-  combined_data[, -c(13:30)]
  combined_data <-  combined_data[, -3]
  combined_data$ID_observation<- c(1:2006) 
  
  combined_data<- combined_data %>%
    mutate(id_date=cumsum(date != lag(date, default = first(date)))) 
  
  return(combined_data)
}
combined_data<- donnee_retenue(combined_data)



################### ligne pour enlever les doublons

combined_data <-combined_data[!duplicated(combined_data),]



################### telechager la BD finale dans notre projet

telechargement <- function(combined_data){
  
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

}

telechargement(combined_data)
