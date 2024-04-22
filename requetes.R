################### REQUETES
# ne pas oublier d'ouvrir la connection et de la fermer lorsque terminer!!

requetes_sql<- function(liste_tables){
con <- dbConnect(RSQLite::SQLite(), dbname="reseau_data")

###Requetes pour voir si les tables ont bien ete creer 
#req1 <- dbGetQuery(con, 'SELECT * FROM site LIMIT 10')
#req1
#req2 <- dbGetQuery(con, 'SELECT * FROM date LIMIT 10')
#req2
#req3 <- dbGetQuery(con, 'SELECT * FROM espece LIMIT 10')
#req3
#req4 <- dbGetQuery(con, 'SELECT * FROM identification LIMIT 10')
#req4

###############################################


requete7 <- "
SELECT s.largeur_riviere, s.profondeur_riviere, s.vitesse_courant, s.temperature_eau_c, e.abondance_totale
FROM site s
JOIN identification i ON s.id_date = i.id_date
JOIN espece e ON i.ID_observation = e.ID_observation
"

# Récupérer les données
donnees7 <- dbGetQuery(con, requete7)


###############################################


requete8 <- "
SELECT 
    e.famille,
    s.vitesse_courant,
    s.temperature_eau_c
FROM 
    espece e
INNER JOIN 
    identification i ON e.ID_observation = i.ID_observation
INNER JOIN 
    site s ON i.id_date = s.id_date
"

# Exécuter la requête et stocker les résultats
donnees8 <- dbGetQuery(con, requete8)


#######################################################

requete9 <- "
SELECT e.abondance_totale, s.transparence_eau
FROM espece e
JOIN identification i ON e.ID_observation = i.ID_observation
JOIN site s ON i.id_date = s.id_date;
"
donnees9 <- dbGetQuery(con, requete9)

liste_requetes<- list(donnees7,donnees8,donnees9)

return(liste_requetes)
dbDisconnect(con)
}







