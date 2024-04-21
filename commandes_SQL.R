#COMMANDES SQL!!!

# OUVRIR LA CONNECTION
#install.packages("RSQLite")
library(RSQLite)
library(DBI)

commande <- function(combined_data){
con <- dbConnect(RSQLite::SQLite(), dbname="reseau_data")

identification = combined_data[,c("id_date","site","ID_observation")]
tbl_identification <- "
CREATE TABLE identification (
  id_date           REAL,
  site              VARCHAR(40),
  ID_observation    REAL, 
  PRIMARY KEY (ID_observation, id_date)
);"

date = combined_data[,c("date","heure_obs","id_date")]
date <-date[!duplicated(date),]
tbl_date <- "
CREATE TABLE date (
  date       DATE,
  heure_obs  CHAR,
  id_date    REAL,
  FOREIGN KEY (id_date) REFERENCES identification(id_date)
);"

site = combined_data[,c("site","largeur_riviere","profondeur_riviere","vitesse_courant",
                        "transparence_eau","temperature_eau_c","id_date")]
site<-site[!duplicated(site),]
tbl_site <- "
CREATE TABLE site (
  site               VARCHAR(40),
  largeur_riviere    REAL,
  profondeur_riviere REAL,
  vitesse_courant    REAL,
  transparence_eau   VARCHAR(40),
  temperature_eau_c  REAL,
  id_date            REAL,
  FOREIGN KEY (id_date) REFERENCES identification(id_date)
);"

espece = combined_data[,c("nom_sci","abondance_totale","famille","ID_observation")]
tbl_espece <- "
CREATE TABLE espece (
  nom_sci          VARCHAR(50),
  abondance_totale REAL,
  famille          CHAR,
  ID_observation   REAL,
  FOREIGN KEY (ID_observation) REFERENCES identification(ID_observation)
);"

dbSendQuery(con, tbl_identification)
dbSendQuery(con, tbl_site)
dbSendQuery(con, tbl_date)
dbSendQuery(con, tbl_espece)

############ INJECTION DES DONNÉES

tab_ident<- dbWriteTable(con, append = TRUE, name = "identification", value = identification, row.names = FALSE)
tab_esp<-dbWriteTable(con, append = TRUE, name = "espece", value = espece, row.names = FALSE)
tab_date<-dbWriteTable(con, append = TRUE, name = "date", value = date, row.names = FALSE)
tab_site<-dbWriteTable(con, append = TRUE, name = "site", value = site, row.names = FALSE)
dbListTables(con)

liste_tables<- list(tab_ident,tab_esp,tab_date,tab_site)

dbDisconnect(con)
return(liste_tables)
}

commande(combined_data)


dbDisconnect(con)








#Juste pour faire les changement dans les tables
dbRemoveTable(con, "date")
dbRemoveTable(con, "site")
dbRemoveTable(con, "identification")
dbRemoveTable(con, "espece")




