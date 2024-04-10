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

#Fonction qui place la les valeurs (elever, moyenne et faible) en ordre de niveau

convert_transparence_eau <- function(transparence) {
  combined_data$transparence_eau<- as.factor(combined_data$transparence_eau)
  # Modification de la colonne transparence_eau
  data_transpa <- factor(combined_data$transparence_eau, levels = c("élevée", "moyenne", "faible"))
  # Retourner la base de données modifiée
  levels(combined_data$transparence_eau)
  
  return(data_transpa)
}

####################### Donnees retenues
donnee_retenue<-function(suppression){
  combined_data <-  combined_data[, -c(13:30)]
  combined_data <-  combined_data[, -3]
  
  return( combined_data)
}




