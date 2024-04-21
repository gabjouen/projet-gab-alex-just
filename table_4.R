# Definition de la fonction pour creer le dataframe
identification <- function(tab4){
  data4 = data.frame(combined_data$id_date,combined_data$site,combined_data$ID_observation)
  return(data4)
}

identification = combined_data[,c("id_date","site","ID_observation")]
