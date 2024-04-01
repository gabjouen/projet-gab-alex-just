#COMMANDES SQL!!!

# OUVRIR LA CONNECTION
install.packages("RSQLite")
library(RSQLite)
library(DBI)
con <- dbConnect(RSQLite::SQLite(), dbname="reseau_data")

################# CREER LES TABLES

date <- "
CREATE TABLE date (
  date      DATE,
  heure_obs TIME,
  PRIMARY KEY (date)
);"

# Vérifier si la table a été créée avec succès
tables <- dbListTables(con)
if ("date" %in% tables) {
  print("La création de la table a réussi.")
} else {
  print("La création de la table a échoué.")
}

View(date)

phys_stations <- "
CREATE TABLE site (
  site               VARCHAR(40),
  largeur_riviere    REAL,
  profondeur_riviere REAL,
  vitesse_courant    INTEGER,
  transparence_eau   VARCHAR(40),
  temperature_eau_c  REAL,
  PRIMARY KEY (site)
);"

observation <- "
CREATE TABLE observation (
  date      DATE,
  site      VARCHAR(40),
  fraction  INTEGER,
  nom_sci   VARCHAR(50),
  abondance REAL,
  PRIMARY KEY (abondance, fraction),
  FOREIGN KEY (date) REFERENCES date(date),
  FOREIGN KEY (site) REFERENCES site(site)
);"

dbSendQuery(con, observation)
dbSendQuery(con, date)
dbSendQuery(con, phys_stations)


############# LECTURE DES FICHIERS CSV

bd_obs <- read.csv(file = 'observation.csv')
bd_dates <- read.csv(file = 'dates.csv')
bd_sites <- read.csv(file = 'sites.csv')

############ INJECTION DES DONNÉES

dbWriteTable(con, append = TRUE, name = "observation", value = bd_obs, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "date", value = bd_dates, row.names = FALSE)
dbWriteTable(con, append = TRUE, name = "site", value = bd_sites, row.names = FALSE)

dbDisconnect(con)
