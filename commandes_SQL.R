#COMMANDES SQL!!!

# OUVRIR LA CONNECTION
install.packages("RSQLite")
library(RSQLite)
library(DBI)
con <- dbConnect(RSQLite::SQLite(), dbname="reseau_data")

################# CREER LES TABLES

tbl_date <- "
CREATE TABLE date (
  date       CHAR,
  heure_obs  CHAR,
  id_date    REAL,
  PRIMARY KEY (id_date),
  FOREIGN KEY (date) REFERENCES identification(date)
);"

tbl_site <- "
CREATE TABLE site (
  site               VARCHAR(40),
  largeur_riviere    REAL,
  profondeur_riviere REAL,
  vitesse_courant    REAL,
  transparence_eau   VARCHAR(40),
  temperature_eau_c  REAL,
  id_date            REAL,
  PRIMARY KEY (id_date),
  FOREIGN KEY (site) REFERENCES identification(site),
  FOREIGN KEY (id_date) REFERENCES date(id_date)
);"

tbl_espece <- "
CREATE TABLE espece (
  fraction  REAL,
  nom_sci   VARCHAR(50),
  abondance REAL,
  ID_observation REAL,
  PRIMARY KEY (ID_observation),
  FOREIGN KEY (ID_observation) REFERENCES identification(ID_observation)
);"

tbl_identification <- "
CREATE TABLE identification (
  date           CHAR,
  site           VARCHAR(40),
  ID_observation REAL, 
  PRIMARY KEY (ID_observation)
);"

dbSendQuery(con, tbl_site)
dbSendQuery(con, tbl_date)
dbSendQuery(con, tbl_identification)
dbSendQuery(con, tbl_espece)


############# LECTURE DES FICHIERS CSV

bd_ident<- combined_data[, c('date','site','ID_observation')]
bd_esp<- combined_data[, c('fraction','nom_sci','abondance','ID_observation')]
bd_sites<- combined_data[, c('site','largeur_riviere','profondeur_riviere','vitesse_courant','transparence_eau','temperature_eau_c','id_date')]
bd_dates<- combined_data[, c('date', 'heure_obs','id_date')]


############### Seulement pour voir quelles variables sont des clés primaires ou secondaires

bd_sites <-bd_sites[!duplicated(bd_sites),]
bd_dates <-bd_dates[!duplicated(bd_dates),]


############ INJECTION DES DONNÉES

dbWriteTable(con, append = TRUE, name = "espece", value = bd_esp, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "date", value = bd_dates, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "site", value = bd_sites, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "identification", value = bd_ident, row.names = FALSE)
dbListTables(con)


########## Requetes

req1 <- dbGetQuery(con, 'SELECT * FROM site LIMIT 10')
req1
req2 <- dbGetQuery(con, 'SELECT * FROM date LIMIT 10')
req2
req3 <- dbGetQuery(con, 'SELECT * FROM espece LIMIT 10')
req3
req4 <- dbGetQuery(con, 'SELECT * FROM identification LIMIT 10')
req4

dbRemoveTable(con, "date")
dbRemoveTable(con, "site")
dbRemoveTable(con, "identification")
dbRemoveTable(con, "espece")

req6 <- dbGetQuery(con, 'SELECT * FROM observation INNER JOIN site ON observation.site = site.site LIMIT 10')
req6


################# formats SQL

# Nous avons essayer de changer les formats des variables heure_obs 
# et date dans nos tables SQL mais nous avons pas réussi c'est pourquoi nous changer les formats après en rajoutant une étape supplémentaire
# UNE ERREUR QUI SERA A REPARER PLUS TARD!

donnee <- dbReadTable(con,"date")
donnee$heure_obs<- format(as.POSIXct(donnee$heure_obs, format = "%H:%M:%S"),"%H:%M")
donnee$date <- format(as.Date(donnee$date), "%Y-%m-%d")
print(donnee)

donnee1 <- dbReadTable(con,"observation")
donnee1$date <- format(as.Date(donnee1$date), "%Y-%m-%d")
print(donnee1)


dbDisconnect(con)
