#packages <- c('shiny', 'shinyjs', 'RJSONIO', 'RCurl', 'warbleR', 'tuneR', 'seewave', 'gbm')
#if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
#install.packages(setdiff(packages, rownames(installed.packages())))
#}

# In Linux, also required:
# sudo apt-get install libcurl4-openssl-dev cmake r-base-core fftw3 fftw3-dev pkg-config

library(shiny)
library(shinyjs)
library(RJSONIO)
library(RCurl)
library(warbleR)
library(parallel)
library(tuneR)

source('config.R')
source('gender.R')

"process is called by processFile"
process <- function(path) {
    content5 <- list(label = '', prob = 0, data = NULL)

    tryCatch({
        content5 <- gender(path, 5)
    }, error = function(e) {
        print(paste0('Error in method process(): ', e))
    })

    content5
}


processFolder <- function(folderName) {
    data <- data.frame(filename=character(), gender=character(), stringsAsFactors=FALSE)
    currentPath <- getwd()
    setwd(folderName)
    list <- list.files(folderName, '\\.wav')

    for (fileName in list) {
        print(fileName)
        content5 <- process(fileName)
        row <- data.frame(fileName, content5$label)
        data <- rbind(data, row)

        write.csv(data, 
                  file='test_data.csv',
                  append=T,
                  quote=F,
                  row.names=F,
                  col.names=F)
    }

}


data <- processFolder('/home/torsho/kaldi/egs/bangla_corpus/audio/test')

