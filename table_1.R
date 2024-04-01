# Definition de la fonction pour creer le dataframe
table1 <- function(tab1){
  data1 = data.frame(combined_data$nom_sci,combined_data$date,combined_data$site,combined_data$abondance,combined_data$fraction)
  return(data1)
}
