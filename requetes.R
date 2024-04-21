################### REQUETES
# ne pas oublier d'ouvrir la connection et de la fermer lorsque terminer!!

req1 <- dbGetQuery(con, 'SELECT * FROM site LIMIT 10')
req1
req2 <- dbGetQuery(con, 'SELECT * FROM date LIMIT 10')
req2
req3 <- dbGetQuery(con, 'SELECT * FROM espece LIMIT 10')
req3
req4 <- dbGetQuery(con, 'SELECT * FROM identification LIMIT 10')
req4


##########

# extraction des donnees necessaires pour nos 3 figures
requete1 <- "
SELECT espece.nom_sci, espece.abondance_totale, site.largeur_riviere, site.profondeur_riviere, site.vitesse_courant
FROM espece
JOIN identification ON espece.ID_observation = identification.ID_observation
JOIN site ON identification.id_date = site.id_date
"
donnees1 <- dbGetQuery(con, requete1)

############

requete2 <- "
SELECT SUM(espece.abondance) AS abondance_totale, site.largeur_riviere
FROM espece
JOIN identification ON espece.ID_observation = identification.ID_observation
JOIN site ON identification.id_date = site.id_date
GROUP BY site.largeur_riviere
"
donnees2 <- dbGetQuery(con, requete2)

##########

requete3 <- "
SELECT SUM(espece.abondance_totale) AS abondance_totale, site.profondeur_riviere
FROM espece
JOIN identification ON espece.ID_observation = identification.ID_observation
JOIN site ON identification.id_date = site.id_date
GROUP BY site.profondeur_riviere
"
donnees3 <- dbGetQuery(con, requete3)

############

requete4 <- "
SELECT SUM(espece.abondance_totale) AS abondance_totale, site.vitesse_courant
FROM espece
JOIN identification ON espece.ID_observation = identification.ID_observation
JOIN site ON identification.id_date = site.id_date
GROUP BY site.vitesse_courant
"
donnees4 <- dbGetQuery(con, requete4)

###########

requete5 <- "
SELECT 
    e.famille,
    s.temperature_eau_c,
    e.abondance_totale
FROM
    espece e
JOIN
    identification i ON e.ID_observation = i.ID_observation
JOIN
    site s ON i.id_date = s.id_date
"
donnees5 <- dbGetQuery(con, requete5)

###########

requete6 <- "
SELECT SUM(espece.abondance_totale) AS abondance_totale, site.temperature_eau_c
FROM espece
JOIN identification ON espece.ID_observation = identification.ID_observation
JOIN site ON identification.id_date = site.id_date
GROUP BY site.temperature_eau_c
"
donnees6 <- dbGetQuery(con, requete6)

############

requete7 <- "
SELECT s.largeur_riviere, s.profondeur_riviere, s.vitesse_courant, s.temperature_eau_c, e.abondance_totale
FROM site s
JOIN identification i ON s.id_date = i.id_date
JOIN espece e ON i.ID_observation = e.ID_observation
"

# Récupérer les données
donnees7 <- dbGetQuery(con, requete7)

############

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

#############

requete9 <- "
SELECT e.abondance_totale, s.transparence_eau
FROM espece e
JOIN identification i ON e.ID_observation = i.ID_observation
JOIN site s ON i.id_date = s.id_date;
"
donnees9 <- dbGetQuery(con, requete9)