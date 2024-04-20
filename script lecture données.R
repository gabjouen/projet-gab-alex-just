#script pour ouvrir les données excel combinéees 
#indiquer l'emplacer du document "combined_data.csv"
#lire le fichier et le mettre dans un objet:
data<-read.csv(file = "combined_data.csv", header = T)

nom<-unique(data$nom_sci)
length(nom)
