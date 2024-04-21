# Definition de la fonction pour creer le dataframe
site <- function(tab3){
  data3 = data.frame(combined_data$site,combined_data$largeur_riviere,combined_data$profondeur_riviere,combined_data$vitesse_courant,
                     combined_data$transparence_eau,combined_data$temperature_eau_c,combined_data$id_date)
  return(data3)
}

site = combined_data[,c("site","largeur_riviere","profondeur_riviere","vitesse_courant",
                        "transparence_eau","temperature_eau_c","id_date")]
