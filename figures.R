############## ANALYSE DES DONNÉES ET CRÉATION DE GRAPHIQUES
library(ggplot2)
library(GGally)

figures <- function (liste_requetes){

# S'assurer que les données sont numériques et qu'il n'y a pas de NA
donnees7<-liste_requetes[1]
donnees7 = as.data.frame(donnees7)
donnees7 <- na.omit(donnees7)
donnees7$largeur_riviere <- as.numeric(donnees7$largeur_riviere)
donnees7$profondeur_riviere <- as.numeric(donnees7$profondeur_riviere)
donnees7$vitesse_courant <- as.numeric(donnees7$vitesse_courant)
donnees7$temperature_eau_c <- as.numeric(donnees7$temperature_eau_c)
donnees7$abondance_totale <- as.numeric(donnees7$abondance_totale)

# Créer la matrice de corrélation avec GGally

# Définir la fonction personnalisée pour ggpairs
custom_fn <- function(data1, mapping, ...){
  data1 = as.data.frame(data1)
  ggplot(data = data1, mapping = mapping) +
    geom_point(color = "blue", size = 1, ...) +
    geom_smooth(method = "lm", color = "red", ...)
}

# Créer la matrice de corrélation avec GGally, incluant des points et des lignes de tendance
figure_3 <- ggpairs(donnees7, 
        upper = list(continuous = wrap("cor", size = 4)),
        lower = list(continuous = custom_fn),
        diag = list(continuous = wrap("densityDiag", size = 0.5))
)


########################################################


donnees8<-liste_requetes[2]
donnees8 = as.data.frame(donnees8)
donnees8 <- na.omit(donnees8)

# Calculer les moyennes par famille
donnees8_agg <- donnees8 %>%
  group_by(famille) %>%
  summarise(vitesse_moyenne = mean(vitesse_courant, na.rm = TRUE),
            temp_moyenne = mean(temperature_eau_c, na.rm = TRUE))

# Réaliser la régression linéaire multiple
model8 <- lm(vitesse_moyenne ~ temp_moyenne, data = donnees8_agg)

# Afficher le résumé du modèle
summary(model8)

figure_1 <- ggplot(donnees8_agg, aes(x = temp_moyenne, y = vitesse_moyenne, color = famille)) +
  geom_point() +  # Utiliser des points de couleur variable selon 'famille'
  geom_smooth(method = "lm", color = "blue") +
  labs(title = "Régression linéaire de la Vitesse Moyenne en fonction de la Température Moyenne",
       x = "Température Moyenne de l'Eau (°C)",
       y = "Vitesse Moyenne du Courant (m/s)",
       color = "Famille") +  # Modifier ici pour définir le titre de la légende
  scale_color_manual(values = rainbow(n = length(unique(donnees8_agg$famille)))) +  # Assigner une couleur unique par famille
  theme_minimal() +  # Utiliser un thème minimal pour une meilleure visualisation
  theme(legend.title = element_text(size = 12))  # Modifier la taille du texte de la légende



########################################################

donnees9<-liste_requetes[3]
donnees9 = as.data.frame(donnees9)

library(RMySQL)

# Tout d'abord, on transforme l'abondance totale en numérique si ce n'est pas déjà fait
donnees9$abondance_totale <- as.numeric(donnees9$abondance_totale)

# Ensuite, on exécute une ANOVA
resultat_anova <- aov(abondance_totale ~ transparence_eau, data = donnees9)

# On affiche le résumé de l'ANOVA pour voir les résultats
summary(resultat_anova)
install.packages("multcomp")
library(multcomp)

# Nous supposons que 'resultat_anova' est votre objet aov déjà créé
tukey_test <- TukeyHSD(resultat_anova)

# Afficher les résultats du test de Tukey
print(tukey_test)

figure_2 <- ggplot(donnees9, aes(x = transparence_eau, y = abondance_totale)) + 
  geom_boxplot() +
  scale_y_log10() + # Ceci met l'échelle de l'axe des y en logarithmique
  xlab('Transparence') +
  ylab('Abondance (logarithmique)') + # Mise à jour de l'étiquette pour refléter l'échelle logarithmique
  ggtitle('Abondance totale en fonction de la transparence de l’eau (échelle logarithmique)') +
  theme_minimal()

liste_figures <- list(figure_1,figure_2,figure_3)
return(liste_figures)
}









