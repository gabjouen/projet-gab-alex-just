#ASSEMBLAGE, NETTOYAGE ET VALIDATION DE LA BD
library(dplyr)

# R?pertoire contenant les fichiers CSV
folder_path <- "C:/Users/ALEXIS/OneDrive/Bureau/?co computationnelle/Atelier 1/benthos/benthos"

# Obtention de la liste des fichiers CSV dans le r?pertoire
csv_files <- list.files(path = folder_path, pattern = "\\.csv$", full.names = TRUE)

# V?rification s'il y a des fichiers CSV dans le r?pertoire
if (length(csv_files) == 0) {
  print("Aucun fichier CSV trouv? dans le r?pertoire.")
} else {
  # Lire et combiner tous les fichiers CSV en une seule base de donn?es
  combined_data <- bind_rows(lapply(csv_files, read.csv))
  
  # Affichage de la base de donn?es combin?e
  print(combined_data)
}



#################### nettoyage de la base de donn?es
install.packages("tidyverse")
library(tidyverse) # nous utilisons ce package car cela permet d'avoir une syntaxe cohérente, une facilité d'utilisation et des puissantes capacités de manipulation de données
summary.data.frame(combined_data)
unique(combined_data$transparence_eau)
unique(combined_data$ETIQSTATION)
class(combined_data$ETIQSTATION)

# Ici je veux que la variable de transparence de l'eau soit pris en compte comme un facteur et non un simple charact?re (parce que ici il y a des niveaux!)
combined_data$transparence_eau<- as.factor(combined_data$transparence_eau)
class(combined_data$transparence_eau)
levels(combined_data$transparence_eau)
#Boucle qui place la les valeurs (?lev?e, moyenne et faible) en ordre de niveau
combined_data$transparence_eau <- factor((combined_data$transparence_eau), levels=c("élevée","moyenne","faible"))
levels(combined_data$transparence_eau)
#Cette ligne d?montre que nous avons aucune duplication dans notre base de donn?es!
combined_data[duplicated(combined_data),]

#Je remarque dans la base de donn?es de benthos que plusieurs observations n'ont la variable ETIQSTATION (qui est l'identifiant attribu? ? la station dans le cadre du R?seau-benthos) 
#c'est-?-dire que c'est ?crit NA... Mais je me demande comment cela peut ?tre possible car chaque observation devrait avoir sa station d'attribu?? Est ce que dans le cadre de l'atelier 
#je ferais mieux de remplacer ces NA par un "rien" par exemple car ils ont forc?ment fait ces observations ? quelque part et non nulle part ?
#Une R??valuation de cette variable ce dera plus tard dans le projet

#exemple de fonction qui remplacerais les NA retrouv?s par un autre terme pour ne pas perdre de la donn?e
combined_data %>% 
  select("date","site","date_obs","heure_obs","fraction","nom_sci","abondance","largeur_riviere","profondeur_riviere","vitesse_courant","transparence_eau","temperature_eau_c","ETIQSTATION") %>% 
  filter(!complete.cases(.)) %>% 
  mutate(ETIQSTATION=replace_na(ETIQSTATION,"TERME D?TERMIN? PLUS TARD"))

#On retrouve aussi des NA dans la temp?rature d'eau, vitesse du courant, profondeur rivi?re, largueur rivi?re? Probl?mes sur le terrain lors de l'?chantillonnage? Va-t-on les prendrent en compte dans l'analyse?
#exemple de fonction permettant d'enlever tous les NA dans la variable sp?cifi?e si jamais nous d?cidons de ne pas les garder finalement...
combined_data %>% 
  select("date","site","date_obs","heure_obs","fraction","nom_sci","abondance","largeur_riviere","profondeur_riviere","vitesse_courant","transparence_eau","temperature_eau_c","ETIQSTATION") %>% 
  filter(!complete.cases(.)) %>% 
  drop_na("variable du tableau sp?cifi?e")

#Pour les colonnes 14 ? 30 il y aura aussi une r??valuation plus tard au cours du projet car il y a beaucoup de NA et ces donn?es ne semblent pas ?tre utilisables...
#La colonne date_obs et date? Quelle est la diff?rence entre la date d'?chantillonnage et la date d'observation?

############### Données retenues

summary.data.frame(data) 
data <- data[,-(13:30)]
data <- data[,-(3)]



############### ENREGISTRER LA BD COMPL?T? EN FORMAT CSV
# D?finition du chemin de fichier pour le bureau
chemin_du_bureau <- "C:/Users/ALEXIS/OneDrive/Bureau/?co computationnelle/Atelier 1"

# Nom du fichier CSV de sortie
nom_fichier <- "combined_data.csv"

# Chemin complet du fichier de sortie
chemin_complet <- file.path(chemin_du_bureau, nom_fichier)

# Sauvegarde du tableau en tant que fichier CSV
write.csv(combined_data, file = chemin_complet, row.names = FALSE)

# Affichage d'un message indiquant que le fichier a ?t? enregistr? avec succ?s
cat("Le fichier", nom_fichier, "a ?t? enregistr? sur votre bureau.\n")

#SALUUUUUTTT
