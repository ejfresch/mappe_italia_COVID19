# Mappe italiane COVID-19
Le mappe dell'università John Hopkins ([apri](https://www.arcgis.com/apps/opsdashboard/index.html#/bda7594740fd40299423467b48e9ecf6)) o quelle proposte dai quotidiani nazionali sono bellissime, ma a mio parere non permettono di seguire l'evoluzione dell'epidemia nello spazio (province/regioni) e nel tempo, in particolare a livello di singoli paesi. L'obiettivo di questo progettino è quello di generare delle mappe dinamiche che descrivono l'evoluzione dell'[epidemia di COVID-19](https://it.wikipedia.org/wiki/Epidemia_di_COVID-19_del_2019-2020) in Italia (febbraio- 2020) che siano di facile interpretazione. 

## .gif
Ecco una `.gif` animata che descrive  
![Gif animata evolutione epidemia COVID19 in Italia](out/italia_regioni.gif)

## Filmato .mp4
[Apri il filmato .mp4](out/italia_regioni.mp4) 

## Note
### Fonti dei dati
I dati sono stati ottenuti dal [sito della Protezione Civile](http://www.protezionecivile.gov.it/home) (comunicati stampa) oppure dal [repository github COVID-19](https://github.com/pcm-dpc/COVID-19) della stessa.

### Implementazione
Gli script per generare le mappe/gif/filmati sono scritti in `R`. I pacchetti chiave sono `ggplot2`, `mapIT`, `choroplethrAdmin1`, `lubridate` e `RColorBrewer`. Gli script utilizzano `ffmpeg` per generare le `.gif` e i filmati e sono stati testati su Linux (Ubuntu 18.04.4 LTS).

### Problemi noti relativi ai nomi delle province/regioni 
Per questioni di semplicità nella mappa delle regioni le province autonome di Trento e Bolzano sono state accorpate nel Trentino-Alto Adige (e purtroppo manca anche la dizione "/Südtirol"). Sempre per questioni di semplicità (compatibilità con il pacchetto `choroplethrAdmin1`), la mappa delle province contiene delle province che non esistono più (Carbonia-Iglesias, Medio Campidano, Ogliastra e Olbia-Tempio).
