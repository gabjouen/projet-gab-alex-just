install.packages('httr')
library(httr)

get_tsn <- function(species_name) {
  url <- paste0("https://www.itis.gov/ITISWebService/jsonservice/searchByScientificName?srchKey=", species_name)
  response <- GET(url)
  content <- content(response, "parsed")
  
  if (length(content$scientificNames) > 0) {
    return(content$scientificNames[[1]]$tsn)
  } else {
    return("TSN not found")
  }
}

species_list <- c(
  "Baetis", "Ephemerella", "Eurylophella", "Epeorus", "Leucrocuta",
  "Leptophlebiidae", "Glossosoma", "Hydropsychidae", "Ceratopsyche", "Hydropsyche",
  "Baetis", "Ephemerella"    ,            "Eurylophella"    ,           "Epeorus"  ,                  "Leucrocuta"  ,              
  "Leptophlebiidae"   ,         "Glossosoma"  ,               "Hydropsychidae" ,            "Ceratopsyche" ,              "Hydropsyche"               
   "Lepidostoma"       ,         "Hydatophylax | Pycnopsyche", "Dolophilodes"   ,            "Rhyacophila"  ,              "Paracapnia"                
   "Sweltsa"            ,        "Leuctra"     ,               "Acroneuria"      ,           "Isoperla"      ,             "Probezzia"                 
   "Ceratopogon"         ,       "Tanytarsini"  ,              "Orthocladiinae"   ,          "Pentaneurini"   ,            "Hemerodromia"              
   "Simulium"             ,      "Antocha"       ,             "Dicranota"         ,         "Hexatoma"        ,           "Tipula"                    
   "Promoresia"            ,     "Boyeria"        ,            "Cordulegaster"      ,        "Acari"            ,          "Pisidium"                  
   "Maccaffertium"          ,    "Rhithrogena"     ,           "Cheumatopsyche"      ,       "Ceraclea"          ,         "Limnephilidae"             
   "Polycentropus"           ,   "Taeniopteryx"     ,          "Atherix"              ,      "Chironomidae"       ,        "Chironomini"               
   "Corduliidae"              ,  "Gomphidae"         ,         "Oligochaeta"           ,     "Isonychia"           ,       "Micrasema"                 
   "Goera"          ,            "Helicopsyche"       ,        "Chimarra"               ,    "Paragnetina"          ,      "Optioservus"               
   "Ophiogomphus"    ,           "Sphaerium"           ,       "Plauditus"               ,   "Heptageniidae"         ,     "Neureclipsis"              
   "Alloperla"        ,          "Neoplasta"            ,      "Stenelmis"                ,  "Acerpenna"              ,    "Serratella"                
   "Hydroptila"        ,         "Mystacides"            ,     "Pseudolimnophila"          , "Trichoptera"             ,   "Oecetis"                   
   "Pycnopsyche"        ,        "Neophylax"              ,    "Strophopteryx" ,             "Psephenus"                ,  "Nigronia"                  
   "Nemertea"            ,       "Tricorythodes"           ,   "Oxyethira"      ,            "Nectopsyche" ,               "Setodes"                   
   "Ectopria"             ,      "Calopteryx"               ,  "Coenagrionidae"  ,           "Argia"        ,              "Brachycentrus"             
   "Lanthus"               ,     "Acentrella"                , "Hydatophylax"     ,          "Psychomyia"    ,             "Bezzia | Palpomyia"        
   "Hagenius"               ,    "Crambidae"   ,               "Heterocloeon"      ,         "Agnetina"       ,            "Gomphus"                   
   "Dentatella"              ,   "Macrostemum"  ,              "Stylogomphus"       ,        "Psilotreta"      ,           "Nematoda"                  
   "Chironominae"             ,  "Baetisca"      ,             "Heptagenia"          ,       "Capniidae"        ,          "Perlidae"                  
   "Isogenoides"  ,              "Baetidae"       ,            "Polycentropodidae"    ,      "Diplectrona"       ,         "Nyctiophylax"              
   "Empididae"     ,             "Haploperla"      ,           "Veliidae"              ,     "Diphetor Hageni"    ,        "Ephemerellidae"            
   "Tanypodinae"    ,            "Glossosomatidae"  ,          "Roederiodes"            ,    "Physa"               ,       "Caecidota"                 
   "Sialis"          ,           "Cambarus"          ,         "Hirudinea"               ,   "Philopotamidae"       ,      "Dubiraphia"                
   "Ferrissia"        ,          "Agapetus"           ,        "Pteronarcys"              ,  "Taeniopterygidae"      ,     "Blepharicera"              
  "Oulimnius"          ,        "Arctopsyche"          ,      "Parapsyche"     ,            "Prosimulium"             ,   "Apatania"                  
  "Paraleptophlebia"    ,       "Hydroptilidae"         ,     "Leptoceridae"    ,           "Caenis"                   ,  "Ephemera"                  
  "Protoptila"           ,      "Stenacron"              ,    "Platyhelminthes"  ,          "Helichus"       ,            "Stagnicola"                
  "Pericoma | Telmatoscopus" ,  "Gammarus"    ,               "Mallochohelea"     ,         "Decapoda"        ,           "Leucotrichia"              
   "Diamesinae"               ,  "Elmidae"     ,               "Ostracoda"         ,         "Brachycentridae" ,           "Perlodidae"                
   "Curculionidae" ,             "Hexagenia"    ,              "Chelifera"          ,        "Lype"             ,          "Procloeon"                 
   "Orconectes"     ,            "Stenonema"     ,             "Neoperla"            ,       "Prodiamesinae"     ,         "Chloroperlidae"            
   "Wiedemannia"     ,           "Wormaldia"      ,            "Ameletus"             ,      "Aeshnidae"          ,        "Cloeon"                    
   "Limnophila"       ,          "Drunella"        ,           "Zapada"                ,     "Siphlonurus"         ,       "Stactobiella"              
   "Psychoglypha"      ,         "Simuliidae"    
)

for (species in species_list) {
  tsn <- get_tsn(species)
  cat(species, ": TSN =", tsn, "\n")
}
