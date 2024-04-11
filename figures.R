############## ANALYSE DES DONNÉES ET CRÉATION DE GRAPHIQUES
library(ggplot2)

# Abondance en fonction de la largeur de la rivière (histogramme de points - visualisation mauvaise)

ggplot(donnees1, aes(x = largeur_riviere, y = abondance, color = nom_sci)) +
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

r2_vit <- summary(modele_log_vit)$r.squared

ggplot(donnees4, aes(x = donnees4$vitesse_courant, y = abondance_totale_log)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "green") +
  labs(title = "Régression linéaire entre la largeur de la rivière et l'abondance totale en benthos",
       x = "Vitesse du courant (m/s)",
       y = "Abondance totale en benthos (log)") +
  theme_minimal()


# Créer le graphique de l'abondance totale en fonction de la profondeur de la riviere et les differentes classes de transparence de l'eau
# Notez que l'axe des y est transformé en échelle logarithmique comme illustré dans l'image

ggplot(donnees5, aes(x = profondeur_riviere, y = abondance_totale, color = transparence_eau)) +
  geom_point() +
  labs(x = "Profondeur de la rivière", y = "Abondance totale", color = "Transparence de l'eau") +
  theme_minimal()


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

unique(combined_data$nom_sci)


#derniere figure!!
install.packages("GGally")
library(GGally)

# S'assurer que les données sont numériques et qu'il n'y a pas de NA
donnees7 <- na.omit(donnees7)
donnees7$largeur_riviere <- as.numeric(donnees7$largeur_riviere)
donnees7$profondeur_riviere <- as.numeric(donnees7$profondeur_riviere)
donnees7$vitesse_courant <- as.numeric(donnees7$vitesse_courant)
donnees7$temperature_eau_c <- as.numeric(donnees7$temperature_eau_c)

# Créer la matrice de corrélation avec GGally
ggpairs(donnees7, 
        upper = list(continuous = wrap("cor", size = 4)),
        lower = list(continuous = wrap("points", size = 1, alpha = 0.3)),
        diag = list(continuous = wrap("densityDiag"))
)

