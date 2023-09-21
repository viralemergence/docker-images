FROM rocker/r-ver:4.2.2

RUN install2.r devtools remotes
RUN R -e "Sys.setenv("NOT_CRAN" = TRUE); Sys.setenv("LIBARROW_MINIMAL" = FALSE); Sys.setenv("LIBARROW_BINARY" = FALSE)"
RUN R -e "devtools::install_github('ropensci/rglobi')"

RUN install2.r taxize, tidyverse, RCurl, vroom, fs, data.table, zip, devtools, lubridate
RUN install2.r taxize, tidyverse, RCurl, vroom, fs, data.table, zip, devtools, lubridate