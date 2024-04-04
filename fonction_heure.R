#################### nettoyage de la base de donnees

install.packages("tidyverse")
library(tidyverse) # nous utilisons ce package car cela permet d'avoir une syntaxe coherente, une facilite d'utilisation et des puissantes capacites de manipulation de donnees
summary.data.frame(combined_data)
unique(combined_data$transparence_eau)


################ Uniformiser le format de la date

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



####################Boucles qui seront peut-etre garder ultimement

#exemple de fonction qui remplacerais les NA retrouver par un autre terme pour ne pas perdre de la donnee
combined_data %>% 
  select("date","site","date_obs","heure_obs","fraction","nom_sci","abondance","largeur_riviere","profondeur_riviere","vitesse_courant","transparence_eau","temperature_eau_c","ETIQSTATION") %>% 
  filter(!complete.cases(.)) %>% 
  mutate(ETIQSTATION=replace_na(ETIQSTATION,"TERME D?TERMIN? PLUS TARD"))

#On retrouve aussi des NA dans la temperature d'eau, vitesse du courant, profondeur riviere, largueur riviere? Problemes sur le terrain lors de l'echantillonnage Va-t-on les prendrent en compte dans l'analyse?
#exemple de fonction permettant d'enlever tous les NA dans la variable specifier si jamais nous d?cidons de ne pas les garder finalement...
combined_data %>% 
  select("date","site","date_obs","heure_obs","fraction","nom_sci","abondance","largeur_riviere","profondeur_riviere","vitesse_courant","transparence_eau","temperature_eau_c","ETIQSTATION") %>% 
  filter(!complete.cases(.)) %>% 
  drop_na("variable du tableau sp?cifi?e")



####################### Donnees retenues

summary.data.frame(combined_data) 
combined_data <- combined_data[,-(13:30)]
combined_data <- combined_data[,-(3)]


###################### Bon format pour SQL (tentative qui n'a pas fonctionner)


combined_data$date <- format(as.Date(combined_data$date, "%Y-%m-%d"))
combined_data$heure_obs<- as.character(combined_data$heure_obs)

###################### ENREGISTRER LA BD COMPLETE EN FORMAT CSV

# Definition du chemin de fichier
chemin_telechargement <- "C:/Users/ALEXIS/OneDrive/Bureau/projet-gab-alex-just"

# Nom du fichier CSV de sortie
nom_fichier <- "combined_data.csv"

# Chemin complet du fichier de sortie
chemin_complet <- file.path(chemin_telechargement, nom_fichier)

# Sauvegarde du tableau en tant que fichier CSV
write.csv(combined_data, file = chemin_complet, row.names = FALSE)

# Affichage d'un message indiquant que le fichier a pu etre enregistrer avec succes
cat("Le fichier", nom_fichier, "a pu etre enregistrer sur votre projet.\n")


