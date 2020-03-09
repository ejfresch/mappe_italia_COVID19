#!/usr/bin/Rscript

library(lubridate)
library(ggplot2)
library(choroplethr)
library(choroplethrAdmin1)
library(RColorBrewer)

setwd("biblioteca/progetti_personali/web/blog/COVID19/")


data_files = list.files("dati/dati_protezione_civile/COVID-19-master/dati-province/",pattern="-2020")

for(current_f in data_files){

# I get the date
current_date = as.Date(current_f,"dpc-covid19-ita-province-%Y%m%d.csv")
cat(format(current_date, format="%A %d %b %Y"),"\n")
date_zipped=format(current_date, format="%Y%m%d")
  
# I read csv file
csv = read.csv(paste("dati/dati_protezione_civile/COVID-19-master/dati-province/",current_f,sep=""),check.names=FALSE, stringsAsFactors = FALSE, fileEncoding = "iso-8859-1")
cols=colnames(csv)
cols=gsub("totale_casi","casi_totali",cols)
colnames(csv)=cols

csv_filtered=csv[csv$denominazione_provincia!="In fase di definizione/aggiornamento", c("denominazione_provincia", "casi_totali")]

# the data about the admin regions (provinces) are old. I patch the names
row_sud_sardegna=csv_filtered[csv_filtered$denominazione_provincia=="Sud Sardegna",]
row_sud_sardegna[,1]="carbonia-iglesias"
csv_filtered=rbind(csv_filtered, row_sud_sardegna)
row_sud_sardegna[,1]="medio campidano"
csv_filtered=rbind(csv_filtered, row_sud_sardegna)

row_nuoro=csv_filtered[csv_filtered$denominazione_provincia=="Nuoro",]
row_nuoro[,1]="ogliastra"
csv_filtered=rbind(csv_filtered, row_nuoro)

row_sassari=csv_filtered[csv_filtered$denominazione_provincia=="Nuoro",]
row_sassari[,1]="olbia-tempio"
csv_filtered=rbind(csv_filtered, row_sassari)

## remove sud sardegna
csv_filtered=csv_filtered[csv_filtered$denominazione_provincia!="Sud Sardegna",]


vect_provinces_file = sort(tolower(paste("provincia di ", csv_filtered$denominazione_provincia,sep="")))
vect_provinces_file_ok = gsub("provincia di arezzo", "province of arezzo", vect_provinces_file)
vect_provinces_file_ok = gsub("provincia di brindisi", "province of brindisi", vect_provinces_file_ok)
vect_provinces_file_ok = gsub("provincia di barletta-andria-trani", "provincia di barletta - andria - trani", vect_provinces_file_ok)
vect_provinces_file_ok = gsub("provincia di forlì-cesena", "provincia di forli", vect_provinces_file_ok)
vect_provinces_file_ok = gsub("provincia di reggio di calabria", "provincia di reggio calabria", vect_provinces_file_ok)
vect_provinces_file_ok = gsub("provincia di vibo valentia", "provincia di vibo-valentia", vect_provinces_file_ok)
vect_provinces_file_ok = gsub("provincia di ascoli piceno", "province of ascoli piceno", vect_provinces_file_ok)
vect_provinces_file_ok = gsub("provincia di fermo", "province of fermo", vect_provinces_file_ok)
vect_provinces_file_ok = gsub("provincia di massa carrara", "provincia di massa-carrara", vect_provinces_file_ok)
vect_provinces_file_ok = gsub("provincia di monza e della brianza", "provincia di monza e brianza", vect_provinces_file_ok)
vect_provinces_file_ok = gsub("provincia di reggio nell'emilia", "provincia di reggio emilia", vect_provinces_file_ok)
vect_provinces_file_ok = gsub("provincia di verbano-cusio-ossola", "provincia verbano-cusio-ossola", vect_provinces_file_ok)

csv_filtered$region=vect_provinces_file_ok


italy_map = get_admin1_map("italy")

vect_provinces_map = sort(unique(italy_map$region)) 

csv_filtered$value=cut(csv_filtered$casi_totali,breaks=c(0,1,10,100,1000,10000),include.lowest=TRUE,right=FALSE)

current_map = admin1_choropleth("italy", csv_filtered, 
                             num_colors = 5, 
                             legend = "Casi totali")
ggsave(paste("out/immagini_italia_province/img",date_zipped,".jpg",sep=""),current_map, height = 5 , width = 5)

}


system("convert -delay 80 out/immagini_italia_province/img*.jpg out/italia_province.gif")
  
