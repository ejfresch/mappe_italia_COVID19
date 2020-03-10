#!/usr/bin/Rscript
#install.packages(c("devtools", "lubridate"))
library(devtools)
#install_github("quantide/mapIT")

library(lubridate)
library(mapIT)
library(ggplot2)
#library(choroplethr)
#library(choroplethrAdmin1)
library(RColorBrewer)
library(gtable)

setwd("biblioteca/progetti_personali/web/blog/coronavirus/")


# I read csv file
csv = read.csv("dati/italia_regioni.tsv", sep="\t",check.names=FALSE, stringsAsFactors = FALSE)

# I get the max num of positives in order to set the scale
max_positive_cases = max(csv[,2:ncol(csv)])

mapIT = function (values, id, data, detail = "regions", dataSource = "istat", 
                sub = NULL, show_missing = TRUE, show_na = TRUE, discrete = NULL, 
                graphPar = list(guide.label = NULL, title = NULL, low = "#f0f0f0", 
                                high = "#005096", na_color = "#333333", palette = "BuGn", 
                                colours = NULL, theme = theme_minimal(), themeOption = list(title = element_text(size = 10), 
                                                                                            axis.ticks = element_blank(), axis.text.x = element_blank(), 
                                                                                            axis.text.y = element_blank()), borderCol = "black", 
                                show_grid = TRUE, show_guide = TRUE), ...) 
{
  if (is.null(graphPar$guide.label)) {
    graphPar$guide.label <- deparse(substitute(values))
    graphPar$guide.label <- strsplit(graphPar$guide.label, 
                                     "\\$")[[1]]
    if (length(graphPar$guide.label) == 2) 
      graphPar$guide.label <- graphPar$guide.label[2]
  }
  if (!missing(data)) 
    values <- data[, deparse(substitute(values))]
  if (!missing(id)) {
    if (!missing(data)) {
      id <- data[, deparse(substitute(id))]
    }
  }
  else {
    id <- 0:(length(values) - 1)
    warning("id not provided. Values assigned by order")
  }
  if (is.factor(id)) 
    id <- as.character(id)
  if (is.numeric(values)) {
    discrete <- FALSE
  }
  else {
    discrete <- TRUE
    values <- as.factor(values)
  }
  if (detail != "regions") {
    warning("the argument 'detail' is currently ignored")
    detail <- "regions"
  }
  if (class(dataSource) == "character") {
    if (dataSource != "istat") {
      stop("dataSource must be 'istat' or a data frame")
    }
  }
  if (class(dataSource) == "data.frame") {
    if (sum(!(names(dataSource) %in% c("long", "lat", "order", 
                                       "hole", "piece", "group", "id", "region")))) {
      stop("dataSource must contains the following columns: long, lat, order, hole, piece, group, id, region")
    }
    if (detail != "regions") {
      warning("shapefile provided. detail is currently ignored")
    }
  }
  if (!show_missing %in% c(TRUE, FALSE)) {
    stop("show_missing must be TRUE or FALSE")
  }
  if (!show_na %in% c(TRUE)) {
    stop("show_na ignored")
  }
  if (!all(sort(names(graphPar)) %in% sort(names(eval(formals(mapIT)$graphPar))))) {
    warning("additional arguments to graphPar ignored")
  }
  if (!is.null(graphPar$themeOption)) {
    if (!all(sort(names(graphPar$themeOption)) %in% sort(names(eval(formals(mapIT)$graphPar$themeOption))))) {
      warning("additional arguments to themeOption ignored")
    }
  }
  onlyChar <- function(string) {
    tolower(gsub(" ", "", gsub("[^[:alnum:]]", " ", string)))
  }
  listDefTO = eval(formals(mapIT)$graphPar$themeOption)
  if (!is.null(graphPar$themeOption)) {
    listDefTO[sort(names(listDefTO[sort(names(listDefTO)) %in% 
                                     sort(names(graphPar$themeOption))]))] = graphPar$themeOption[sort(names(graphPar$themeOption))]
  }
  listDef = eval(formals(mapIT)$graphPar)
  listDef[sort(names(listDef[names(listDef) %in% names(graphPar)]))] = graphPar[sort(names(graphPar))]
  graphPar = listDef
  graphPar$themeOption = listDefTO
  rm(listDef, listDefTO)
  if (graphPar$show_grid == FALSE & identical(graphPar$theme, 
                                              theme_minimal())) {
    graphPar$theme$panel.grid.major <- element_blank()
    graphPar$theme$panel.grid.minor <- element_blank()
  }
  if (class(dataSource) == "data.frame") 
    shapedata = dataSource
  if (class(dataSource) == "character") {
    if (dataSource == "istat") {
      if (detail == "regions") {
        shapedata <- shapedata_istat_regioni
      }
    }
  }
  id_df <- unique(shapedata_istat_regioni[, c("id", "region")])
  if (is.numeric(id)) {
    id_input <- id
    id <- id_df$region[!is.na(match(onlyChar(id_df$id), onlyChar(id)))]
  }
  match_all <- match(onlyChar(id_df$region), onlyChar(id))
  match_missing <- match(onlyChar(id), onlyChar(id_df$region))
  pos <- match(onlyChar(shapedata$region), onlyChar(id))
  if (sum(is.na(match(onlyChar(id), onlyChar(id_df$region)))) > 
      0) {
    warning(paste("Some id not recognized:", paste(id[is.na(match_missing)], 
                                                   collapse = ", ")))
  }
  if (show_missing == FALSE) {
    sub_fromData <- id_df$region[!is.na(match(onlyChar(id_df$region), 
                                              onlyChar(id)))]
    if (is.null(sub)) {
      sub <- sub_fromData
    }
    else {
      sub <- sub[onlyChar(sub) %in% onlyChar(sub_fromData)]
    }
  }
  if (!is.null(sub)) {
    sub_match_all <- match(onlyChar(shapedata$region), onlyChar(sub))
    sub_match_missing <- match(onlyChar(sub), onlyChar(shapedata$region))
    shapedata <- shapedata[onlyChar(shapedata$region) %in% 
                             onlyChar(sub), ]
    values <- values[onlyChar(id) %in% onlyChar(sub)]
    pos <- sub_match_all[which(!is.na(sub_match_all))]
    if (sum(is.na(sub_match_missing)) > 0) {
      warning(paste("Some sub not recognized:", paste(id[is.na(sub_match_missing)], 
                                                      collapse = ", ")))
    }
  }
  shapedata[, "values"] <- values[pos]
  gp <- ggplot(shapedata, aes_string(x = "long", y = "lat"))
  bg <- graphPar$theme
  th <- do.call(theme, graphPar$themeOption)
  map <- geom_map(aes_string(map_id = "region", fill = "values"), 
                  map = shapedata, col = graphPar$borderCol, show_guide = graphPar$show_guide, lwd =0.1)
  lab <- labs(x = "", y = "", title = graphPar$title)
  out <- gp + bg + th + map + lab
  if (discrete == TRUE) {
    if (is.null(graphPar$colours)) {
      scf <- scale_fill_brewer(labels = levels(as.factor(values)), 
                               palette = graphPar$palette, name = graphPar$guide.label)
    }
    else {
      scf <- scale_fill_manual(values = graphPar$colours, 
                               name = graphPar$guide.label)
    }
  }
  else {
    scf <- scale_fill_continuous(low = graphPar$low, high = graphPar$high, 
                                 na.value = graphPar$na_color, name = graphPar$guide.label)
  }
  return(out + scf)
}

cases_prev_day=0
for(i in ncol(csv):2){
  
  # I get the date
  current_date = as.Date(colnames(csv)[i],"%Y_%m_%d")
  cat(format(current_date, format="%A %d %b %Y"))
  
  current_cases = sum(csv[,i])
  new_cases = current_cases - cases_prev_day
  trend=""
  if(new_cases > 0){
    trend="↑"
    } else{
    trend="↓"
    }
  msg=paste(format(current_date, format="%Y-%m-%d"),": ",current_cases," positivi (",trend," ",new_cases," nuovi positivi",")",sep="")
  cases_prev_day = current_cases
  
  
  # I create the map of the day
  p = mapIT(values = cut(csv[,i],breaks=c(0,1,10,100,1000,10000), labels=c("[0,1","[1,10","[10,100)","[100,1000)","[1000,10000)"),include.lowest=TRUE,right=FALSE), id=csv$Regione, graphPar = list(show_grid=FALSE, borderCol="#636363")) +
    scale_fill_manual(values=c("[0,1" = "#EFF3FF",
                               "[1,10" = "#BDD7E7",
                               "[10,100)" = "#6BAED6",
                               "[100,1000)" = "#3182BD",
                               "[1000,10000)" = "#08519C"),
                      name="Positivi",
                      drop=FALSE) +
    labs(caption=msg) +
    theme(plot.caption = element_text(hjust=0.1, size=rel(1),family="Helvetica")) +
    theme(legend.title=element_text(size=10,family="Helvetica"), legend.text = element_text(size = 8, family="Helvetica"))
    
    #guides(shape = guide_legend(override.aes = list(size = 0.1)),
    #       color = guide_legend(override.aes = list(size = 0.1)))

    ggsave(paste("out/immagini_italia_regioni/img",colnames(csv)[i],".png",sep=""),p, height = 5 , width = 5)
  
  
}

system("convert -background white -alpha remove -layers OptimizePlus -delay 200 out/immagini_italia_regioni/img*.png -loop 0 out/italia_regioni.gif")
system("ffmpeg -framerate 1/2 -pattern_type glob -i 'out/immagini_italia_regioni/*.png' -c:v libx264 -r 30 -pix_fmt yuv420p out/italia_regioni.mp4")  
