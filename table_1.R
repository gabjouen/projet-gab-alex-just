# D?finition de la fonction pour cr?er le dataframe
table1 <- function(tab1){
  data1 = data.frame(combined_data$nom_sci,combined_data$date,combined_data$site,combined_data$heure_obs)
  return(data1)
}
