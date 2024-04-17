# Cargar los paquetes necesarios
if (!require(bibliometrix)) {
  install.packages("bibliometrix")
}
library(bibliometrix)

if (!require(igraph)) {
  install.packages("igraph")
}
library(igraph)

NumNodes <- 100

# Cargar los datos
load("D:/OneDrive/01_MaestriaGeomatica/05_Network_Science_for_Data_Analytics/03_ProjectProposalProgress/Data/Bibliometrix-Export-File-2024-04-14.RData")

# Crear la red de colaboración de autores
Colla_Ref <- biblioNetwork(M, analysis = "collaboration", network = "authors", n = NumNodes, sep = ";")

# Crear la red de co-ocurrencias de palabras clave
KeyCooc_Ref <- biblioNetwork(M, analysis = "co-occurrences", network = "keywords", n = NumNodes, sep = ";")

# Crear la red de co-citación de autores
M <- metaTagExtraction(M, Field = "CR_AU", sep = ";")
CoCit_Ref <- biblioNetwork(M, analysis = "co-citation", network = "authors", n = NumNodes, sep = ";")

# Definir los tipos de clustering disponibles
cluster_types <- c("none", "optimal", "louvain", "leiden", "infomap", "edge_betweenness", "walktrap", "spinglass", "leading_eigen", "fast_greedy")

# Iterar a través de cada tipo de clustering y generar los gráficos y redes para cada análisis
for (net in list(Colla_Ref, CoCit_Ref, KeyCooc_Ref)) {
  net_type <- if (identical(net, Colla_Ref)) "Collaboration" else if (identical(net, CoCit_Ref)) "CoCitation" else "KeywordCooc"
  for (cluster_type in cluster_types) {
    # Preparar el nombre del archivo y la ruta
    plot_name <- paste(net_type, "_", cluster_type, ".png", sep = "")
    plot_path <- file.path("D:/OneDrive/01_MaestriaGeomatica/05_Network_Science_for_Data_Analytics/03_ProjectProposalProgress/Data", plot_name)
    
    # Abrir dispositivo gráfico PNG
    png(filename = plot_path, width = 2000, height = 1500, res = 300)
    
    # Generar el plot de la red
    net_plot <- networkPlot(net, n = 30, type = "kamada", cluster = cluster_type, Title = paste(net_type, " -", cluster_type), labelsize = 0.5)
    
    # Cerrar el dispositivo gráfico
    dev.off()
    
    # Guardar la red en formato .net
    #net_name <- paste(net_type, "_", cluster_type, ".net", sep = "")
    #net_path <- file.path("D:/OneDrive/01_MaestriaGeomatica/05_Network_Science_for_Data_Analytics/03_ProjectProposalProgress/Data", net_name)
    #write_graph(net_plot$graph, net_path, format = "pajek")
  }
  # Guardar la red en formato .net
  net_type <- if (identical(net, Colla_Ref)) "Collaboration" else if (identical(net, CoCit_Ref)) "CoCitation" else "KeywordCooc"
  net_name <- paste(net_type, ".net", sep = "")
  net_path <- file.path("D:/OneDrive/01_MaestriaGeomatica/05_Network_Science_for_Data_Analytics/03_ProjectProposalProgress/Data", net_name)
  write_graph(net_plot$graph_pajek, net_path, format = "pajek") 
  
  # Analizar estadísticas de la red
  netstat <- networkStat(net_plot$graph, stat = "all", "all")
  #summary(netstat$vertex)
  cent_net_df <- netstat$vertex
  cent_name <- paste(net_type, ".csv", sep = "")
  cent_path <- file.path("D:/OneDrive/01_MaestriaGeomatica/05_Network_Science_for_Data_Analytics/03_ProjectProposalProgress/Data", cent_name)
  write.csv(cent_net_df, cent_path, row.names = TRUE)
}


