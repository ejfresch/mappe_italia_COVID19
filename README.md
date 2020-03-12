# Mappe italiane COVID-19
L'obiettivo di questo progettino è quello di generare delle mappe "dinamiche" che descrivano l'evoluzione dell'[epidemia di COVID-19](https://it.wikipedia.org/wiki/Epidemia_di_COVID-19_del_2019-2020) in Italia (febbraio- 2020) e che siano di facile interpretazione. Le mappe dell'università John Hopkins ([apri](https://www.arcgis.com/apps/opsdashboard/index.html#/bda7594740fd40299423467b48e9ecf6)) o quelle proposte dai quotidiani nazionali sono bellissime, ma a mio parere non permettono di seguire l'evoluzione dell'epidemia nello spazio (regioni/province) e nel tempo, in particolare a livello di singoli paesi. 

## Mappe dinamiche
Le mappe "dinamiche" permettono di visualizzare l'evoluzione dell'epidemia. Ecco la mappa "dinamica" delle regioni:

<img src="out/mappa_dinamica_regioni/mappa_dinamica_covid19_italia.gif" width="500">

E quella delle province:

<img src="out/mappa_dinamica_province/dinamica_covid19_italia.gif" width=550>

## Filmati .mp4

I filmati `.mp4` fornisce le stesse informazioni delle mappe "dinamiche", ma permettono all'utente cliccare sul pulsante stop e fare i confronti che desidera invece di dover aspettare il ciclo successivo delle immagini `.gif`. I filmati sono disponibili nelle cartelle `out/mp4_dinamica_regioni` e `out_mp4_dinamica_province`.

## Mappe giornaliere

Le mappe giornaliere sono mappe "statiche" che permettono di capire quanti casi positivi c'erano/ci sono in un determinato giorno e fare confronti tra regioni/province. Ecco la mappa più recente delle regioni:

<img src="out/mappe_giornaliere_regioni/mappa_covid19_italia_2020_03_08.png" width="500">

E quella delle province:

<img src="out/mappe_giornaliere_province/mappa_covid19_italia_20200308.png" width="550">


## Note
### Fonti dei dati
I dati sono stati ottenuti dal [repository github COVID-19](https://github.com/pcm-dpc/COVID-19) della [Protezione Civile](http://www.protezionecivile.gov.it/home).

### Licenza

Le immagini (`.gif`, `.png`) e i filmati (`.mp4`) sono rilasciati con licenza Creative Commons [CC-BY-4.0](https://creativecommons.org/licenses/by/4.0/deed.it). Gli script sono rilasciati con licenza `GPLv3`.



### Implementazione
Gli script per generare le mappe/gif/filmati sono scritti in `R`. I pacchetti chiave sono `ggplot2`, `mapIT`, `choroplethrAdmin1`, `lubridate` e `RColorBrewer`. Gli script utilizzano `ffmpeg` per generare le `.gif` e i filmati e sono stati testati su Linux (Ubuntu 18.04.4 LTS).

### Problemi noti relativi ai nomi delle province/regioni 
Per questioni di semplicità  e compatibilità con i pacchetti `R` nella mappa delle regioni le province autonome di Trento e Bolzano sono state accorpate nel Trentino-Alto Adige (e purtroppo manca anche la dizione "/Südtirol"). Per le stesse ragioni la mappa delle province contiene delle province che non esistono più (Carbonia-Iglesias, Medio Campidano, Ogliastra e Olbia-Tempio).
