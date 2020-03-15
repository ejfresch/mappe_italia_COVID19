#!/usr/bin/Rscript

setwd("~/biblioteca/progetti_personali/mappe_italia_COVID19/")

library(lubridate)
library(ggplot2)
library(RColorBrewer)

# I build a csv
data_files = list.files("dati/dati_protezione_civile/COVID-19-master/dati-regioni/",pattern="-2020")

csv_exists = FALSE

for(current_f in sort(data_files,decreasing = TRUE)){
  current_csv = read.csv(paste("dati/dati_protezione_civile/COVID-19-master/dati-regioni/",current_f,sep=""),check.names=FALSE, stringsAsFactors = FALSE, fileEncoding = "iso-8859-1")
  # I get the date
  current_date = as.Date(current_f,"dpc-covid19-ita-regioni-%Y%m%d.csv")
  date_zipped=format(current_date, format="%Y_%m_%d")
  # select and rename columns
  cols=colnames(current_csv)
  cols=gsub("denominazione_regione","Regione",cols)
  colnames(current_csv)=cols
  current_csv = current_csv[,c("Regione","totale_attualmente_positivi")]
  colnames(current_csv)=c("Regione",date_zipped)
  #fix Trento and Bolzano autonomous provinces (compatibility)
  count_trento_bolzano=sum(current_csv[current_csv$Regione %in% c("P.A. Trento", "P.A. Bolzano"),date_zipped])
  temp_trentino_alto_adige=data.frame("Trentino Alto Adige",count_trento_bolzano)
  names(temp_trentino_alto_adige)=c("Regione", date_zipped)
  current_csv=current_csv[!current_csv$Regione %in% c("Trento", "Bolzano"),]
  current_csv=rbind(current_csv,temp_trentino_alto_adige)
  # if the object csv does not exists I create it. Otherwise I populate it with new columns
  if(! csv_exists){
    csv=current_csv
    csv_exists = TRUE
  }else{
      csv=merge(csv,current_csv, by = "Regione")
    }
    
}



vect_data=colSums(csv[,2:ncol(csv)])
df=data.frame(Data=as.Date(names(vect_data),"%Y_%m_%d"),Positivi=vect_data)

p = ggplot(data=df, aes(x=Data, y=Positivi)) +
  geom_line(stat="identity", lwd=1, lineend="round", color="red") +
  ylab("Casi positivi") + 
  scale_y_continuous(trans='log10') +
  labs(caption=paste("Aggiornato il ",sort(names(vect_data[1])),"; Dati: Protezione Civile",sep="")) +
  theme_classic()+ 
  theme(plot.caption = element_text(hjust=1, size=9,family="Helvetica")) +
  theme(plot.margin = unit(c(1,1,1,1), "cm"))
ggsave("out/serie_temporale_casi_positivi/serie_temporale_casi_positivi.png",p, height = 5 , width = 6)
