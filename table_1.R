# Definition de la fonction pour creer le dataframe
espece <- function(tab1){
  tab1 = data.frame(combined_data$nom_sci,combined_data$abondance_totale,combined_data$famille,combined_data$ID_observation)
  return(tab1)
}

espece = combined_data[,c("nom_sci","abondance_totale","famille","ID_observation")]

