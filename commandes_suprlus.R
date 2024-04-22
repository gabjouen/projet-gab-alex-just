################### telechager la BD finale dans notre projet

telechargement <- function(combined_data){
  
  # Definition du chemin de fichier
  chemin_telechargement <- "C:/Users/ALEXIS/OneDrive/Bureau/Atelier2_ AlexisGabJust/projet-gab-alex-just"
  
  # Nom du fichier CSV de sortie
  nom_fichier <- "combined_data.csv"
  
  # Chemin complet du fichier de sortie
  chemin_complet <- file.path(chemin_telechargement, nom_fichier)
  
  # Sauvegarde du tableau en tant que fichier CSV
  write.csv(combined_data, file = chemin_complet, row.names = FALSE)
  
  # Affichage d'un message indiquant que le fichier a pu etre enregistrer avec succes
  cat("Le fichier", nom_fichier, "a pu etre enregistrer sur votre projet.\n")
  
}







#####################################################
#REQUETES NON RETENUES POUR NOS 3 FIGURES

# extraction des donnees necessaires pour nos 3 figures
requete1 <- "
SELECT espece.nom_sci, espece.abondance_totale, site.largeur_riviere, site.profondeur_riviere, site.vitesse_courant
FROM espece
JOIN identification ON espece.ID_observation = identification.ID_observation
JOIN site ON identification.id_date = site.id_date
"
donnees1 <- dbGetQuery(con, requete1)


##################################################


requete2 <- "
SELECT SUM(espece.abondance) AS abondance_totale, site.largeur_riviere
FROM espece
JOIN identification ON espece.ID_observation = identification.ID_observation
JOIN site ON identification.id_date = site.id_date
GROUP BY site.largeur_riviere
"
donnees2 <- dbGetQuery(con, requete2)


######################################################


requete3 <- "
SELECT SUM(espece.abondance_totale) AS abondance_totale, site.profondeur_riviere
FROM espece
JOIN identification ON espece.ID_observation = identification.ID_observation
JOIN site ON identification.id_date = site.id_date
GROUP BY site.profondeur_riviere
"
donnees3 <- dbGetQuery(con, requete3)


########################################################


requete4 <- "
SELECT SUM(espece.abondance_totale) AS abondance_totale, site.vitesse_courant
FROM espece
JOIN identification ON espece.ID_observation = identification.ID_observation
JOIN site ON identification.id_date = site.id_date
GROUP BY site.vitesse_courant
"
donnees4 <- dbGetQuery(con, requete4)


####################################################

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

######################################################


requete6 <- "
SELECT SUM(espece.abondance_totale) AS abondance_totale, site.temperature_eau_c
FROM espece
JOIN identification ON espece.ID_observation = identification.ID_observation
JOIN site ON identification.id_date = site.id_date
GROUP BY site.temperature_eau_c
"
donnees6 <- dbGetQuery(con, requete6)










#############################################
#FIGURES NON RETENUES
# Abondance en fonction de la largeur de la rivière (histogramme de points - visualisation mauvaise)

ggplot(donnees1, aes(x = largeur_riviere, y = abondance_totale, color = nom_sci)) +
  geom_point() +
  labs(title = "Abondance du benthos en fonction de la largeur de la rivière",
       x = "Largeur de la rivière (m)",
       y = "Abondance") +
  theme_minimal() +
  theme(legend.position = "none")



# RÉGRESSION LINÉAIRE

# CRÉATION DE LA FIGURE - largeur

donnees2$largeur_riviere <- log(donnees2$largeur_riviere)
donnees2$abondance_totale <- log(donnees2$abondance_totale)
modele_log_larg <- lm(donnees2$largeur_riviere ~ donnees2$abondance_totale, data = donnees2)

#CALCUL R2

r2 <- summary(modele_log_larg)$r.squared

ggplot(donnees2, aes(x = donnees2$largeur_riviere, y = donnees2$abondance_totale)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "blue") +
  labs(title = "Régression linéaire (log) entre la largeur de la rivière et l'abondance totale en benthos",
       x = "Largeur de la rivière (m)",
       y = "Abondance totale en benthos") +
  theme_minimal()


# CRÉATION DE LA FIGURE - profondeur

abondance_totale_log <- log(donnees3$abondance_totale)

modele_log_prof <- lm(donnees3$profondeur_riviere ~ abondance_totale_log, data = donnees3)

r2_prof <- summary(modele_log_prof)$r.squared

ggplot(donnees3, aes(x = donnees3$profondeur_riviere, y = abondance_totale_log)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "orange") +
  labs(title = "Régression linéaire entre la largeur de la rivière et l'abondance totale en benthos",
       x = "Profondeur de la rivière (m)",
       y = "Abondance totale en benthos (log)") +
  theme_minimal()


# CRÉATION DE LA FIGURE - vitesse du courant

abondance_totale_log <- log(donnees4$abondance_totale)

modele_log_vit <- lm(donnees4$vitesse_courant ~ abondance_totale_log, data = donnees4)
summary(modele_log_vit)
r2_vit <- summary(modele_log_vit)$r.squared

ggplot(donnees4, aes(x = donnees4$vitesse_courant, y = abondance_totale_log)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "green") +
  labs(title = "Régression linéaire entre la largeur de la rivière et l'abondance totale en benthos",
       x = "Vitesse du courant (m/s)",
       y = "Abondance totale en benthos (log)") +
  theme_minimal()


###########

donnees5<- na.omit(donnees5)

# Créer le modèle de régression linéaire
model5 <- lm(donnees5$famille ~ donnees5$temperature_eau_c, data = donnees5)

# Résumé du modèle
summary(model5)

# Créer un graphique de la régression
ggplot(donnees5, aes(x = temperature_eau_c, y = famille)) +
  geom_point() +
  geom_smooth(method = "lm", col = "blue") +
  labs(title = "Régression linéaire de la Famille en fonction de la Température de l'eau",
       x = "Température de l'eau (°C)",
       y = "Famille")





# CRÉATION DE LA FIGURE - temperature eau

modele_log_temp <- lm(donnees6$temperature_eau_c ~ donnees6$abondance_totale, data = donnees6)

#CALCUL R2

r2 <- summary(modele_log_temp)$r.squared

ggplot(donnees6, aes(x = donnees6$temperature_eau_c, y = donnees6$abondance_totale)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "blue") +
  labs(title = "Régression linéaire (log) entre la température de l'eau et l'abondance totale en benthos",
       x = "Température de l'eau",
       y = "Abondance totale en benthos") +
  theme_minimal()