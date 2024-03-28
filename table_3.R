# D?finition de la fonction pour cr?er le dataframe
table3 <- function(tab3){
  data3 = data.frame(combined_data$site,combined_data$ETIQSTATION,combined_data$profondeur_riviere,combined_data$largeur_riviere,
                     combined_data$transparence_eau,combined_data$temperature_eau_c,combined_data$vitesse_courant)
  return(data3)
}
