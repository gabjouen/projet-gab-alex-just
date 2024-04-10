#COMMANDES SQL!!!

# OUVRIR LA CONNECTION
install.packages("RSQLite")
library(RSQLite)
library(DBI)
con <- dbConnect(RSQLite::SQLite(), dbname="reseau_data")

################# CREER LES TABLES

date <- "
CREATE TABLE date (
  date       DATE,
  heure_obs  CHAR,
  PRIMARY KEY (date)
);"

phys_stations <- "
CREATE TABLE site (
  site               VARCHAR(40),
  largeur_riviere    REAL,
  profondeur_riviere REAL,
  vitesse_courant    REAL,
  transparence_eau   VARCHAR(40),
  temperature_eau_c  REAL,
  PRIMARY KEY (site)
);"

observation <- "
CREATE TABLE observation (
  date      DATE,
  site      VARCHAR(40),
  fraction  REAL,
  nom_sci   VARCHAR(50),
  abondance REAL,
  ID_observation REAL, 
  PRIMARY KEY (abondance, fraction),
  FOREIGN KEY (date) REFERENCES date(date),
  FOREIGN KEY (site) REFERENCES site(site)
);"

dbSendQuery(con, observation)
dbSendQuery(con, date)
dbSendQuery(con, phys_stations)



############# LECTURE DES FICHIERS CSV

bd_obs<- combined_data[, c('date', 'site','fraction','nom_sci','abondance')]
bd_sites<- combined_data[, c('site','largeur_riviere','profondeur_riviere','vitesse_courant','transparence_eau','temperature_eau_c')]
bd_dates<- combined_data[, c('date', 'heure_obs')]

bd_dates<- as.data.frame(bd_dates)
bd_obs<- as.data.frame(bd_obs)
bd_sites<- as.data.frame(bd_sites)


################## Supprimer la contrainte UNIQUE 

# Remarque : Cette opération nécessite de recréer la table sans la contrainte UNIQUE (message d'erreur qui nous sortait)
dbExecute(con, "CREATE TABLE temp_table AS SELECT * FROM date;")
dbExecute(con, "DROP TABLE date;")
dbExecute(con, "ALTER TABLE temp_table RENAME TO date;")

dbExecute(con, "CREATE TABLE temp_table AS SELECT * FROM site;")
dbExecute(con, "DROP TABLE site;")
dbExecute(con, "ALTER TABLE temp_table RENAME TO site;")

dbExecute(con, "CREATE TABLE temp_table AS SELECT * FROM observation;")
dbExecute(con, "DROP TABLE observation;")
dbExecute(con, "ALTER TABLE temp_table RENAME TO observation;")


############ INJECTION DES DONNÉES

dbWriteTable(con, append = TRUE, name = "observation", value = bd_obs, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "date", value = bd_dates, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "site", value = bd_sites, row.names = FALSE)

dbListTables(con)

########## Requetes

res <- dbGetQuery(con, 'SELECT * FROM site LIMIT 10')
res
res1 <- dbGetQuery(con, 'SELECT * FROM date LIMIT 10')
res1
res2 <- dbGetQuery(con, 'SELECT * FROM observation LIMIT 10')
res2
ress <- dbRemoveTable(con, "date")
ress
res3 <- dbGetQuery(con, 'SELECT * FROM observation INNER JOIN site ON observation.site = site.site LIMIT 10')
res3

####### formats SQL
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
