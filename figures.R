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

donnees2$largeur_riviere <- log(donnees2$largeur_riviere)
donnees2$abondance_totale <- log(donnees2$abondance_totale)
  
modele_log <- lm(donnees2$largeur_riviere ~ donnees2$abondance_totale, data = donnees2)

#CALCUL R2
r2 <- summary(modele_log)$r.squared

# CRÉATION DE LA FIGURE

ggplot(donnees2, aes(x = donnees2$largeur_riviere, y = donnees2$abondance_totale)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "blue") +
  labs(title = "Régression linéaire (log) entre la largeur de la rivière et l'abondance totale en benthos",
       x = "Largeur de la rivière (m)",
       y = "Abondance totale en benthos") +
  theme_minimal()
