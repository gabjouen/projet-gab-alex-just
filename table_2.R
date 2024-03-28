# D?finition de la fonction pour cr?er le dataframe
table2 <- function(tab2){
  data2 = data.frame(combined_data$nom_sci,combined_data$abondance,combined_data$fraction,combined_data$date_obs)
  return(data2)
}
