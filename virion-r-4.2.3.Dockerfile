FROM ubuntu:jammy

LABEL image.source="https://github.com/viralemergence/docker-images/blob/main/virion/Dockerfile" \
      image.authors="Cole Brookson <cole.brookson@gmail.com"

# all the R install stuff 
ENV R_VERSION=4.2.3
ENV R_HOME=/usr/local/lib/R
ENV TZ=Etc/UTC

COPY scripts/install_R_source.sh /verena_scripts/install_R_source.sh

RUN /verena_scripts/install_R_source.sh
ENV CRAN=https://packagemanager.posit.co/cran/__linux__/jammy/2023-04-20
ENV LANG=en_US.UTF-8

# set up R 
COPY scripts/setup_R.sh /verena_scripts/setup_R.sh
RUN /verena_scripts/setup_R.sh

# do the R things we want
RUN install2.r devtools remotes
RUN R -e "Sys.setenv("NOT_CRAN" = TRUE); Sys.setenv("LIBARROW_MINIMAL" = FALSE); Sys.setenv("LIBARROW_BINARY" = FALSE)"
RUN R -e "devtools::install_github('ropensci/rglobi')"

# set up Julia
COPY scripts/install_julia.sh /verena_scripts/install_julia.sh
RUN /verena_scripts/install_julia.sh

CMD ["R"]
CMD ["julia"]

# do the julia things we want
#RUN julia -e 'using Pkg; Pkg.activate("."); Pkg.instantiate()'
RUN julia --project -e 'using Pkg; Pkg.activate("."); Pkg.add("CSV"); Pkg.add("DataFrames")'
RUN julia --project -e 'using Pkg; Pkg.activate("."); Pkg.add(PackageSpec(name="NCBITaxonomy", rev="main"))'
RUN set -eux; \
    mkdir "$JULIA_USER_HOME";

RUN julia -e 'using Pkg; Pkg.instantiate();'

# note, R.utils is needed for datatable to work with csv.gz files
RUN install2.r  --error --skipinstalled --ncpus -1 \
 readr \
 taxize \
 magrittr \
 dplyr \
 tidyr \
 RCurl \
 vroom \
 fs \
 zip \
 devtools \
 lubridate \
 yaml \
 R.utils \
 here \
 data.table \
 && rm -rf /tmp/downloaded_packages
