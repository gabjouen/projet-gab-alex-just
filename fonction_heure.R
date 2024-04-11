################ Uniformiser le format de heure_obs

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








