# Cargar las librerías necesarias
library(bibliometrix)
library(dplyr)

# Establecer un valor grande para VROOM_CONNECTION_SIZE
Sys.setenv("VROOM_CONNECTION_SIZE" = 5999999)

# Establecer la ruta donde se encuentran los archivos descargados de WOS
path <- "D:/OneDrive/01_MaestriaGeomatica/05_Network_Science_for_Data_Analytics/03_ProjectProposalProgress/Data/"
#path <- "D:/OneDrive/01_MaestriaGeomatica/05_Network_Science_for_Data_Analytics/03_ProjectProposalProgress/Data/prueba/"

# Obtener una lista de todos los archivos de texto en la carpeta especificada
files <- list.files(path, pattern = "\\.txt$", full.names = TRUE)

# Inicializar una lista para almacenar los datos de cada archivo
database_list <- list()

# Procesar cada archivo
for (i in seq_along(files)) {
  file_name <- files[i]
  
  # Imprimir el nombre del archivo y el progreso
  cat(sprintf("Procesando %s (%d de %d)\n", basename(file_name), i, length(files)))
  
  # Convertir los datos del archivo a un formato de data frame que bibliometrix pueda manejar
  M <- convert2df(file = file_name, dbsource = "wos", format = "plaintext")
  
  #M2 <- head(M["TC"])
  
  # Almacenar el resultado en la lista
  database_list[[i]] <- M
}

# Unir todos los data frames individuales en un único objeto bibliometrixDB
#bibliometrixDB <- do.call(rbind, database_list)
bibliometrixDB <- bind_rows(database_list)

# Guardar el objeto final en el disco
save(bibliometrixDB, file = "Network_Science_References.RData")

cat("Todos los archivos han sido procesados y guardados con éxito.\n")

# Iniciar biblioshiny para análisis interactivo (comentar si no lo deseas)
biblioshiny()
