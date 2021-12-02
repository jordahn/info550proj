FROM rocker/tidyverse

# install R packages
RUN Rscript -e "install.packages('visNetwork', repos = 'https://cran.microsoft.com/')"
RUN Rscript -e "install.packages('rmarkdown', repos = 'https://cran.microsoft.com/')"
RUN Rscript -e "install.packages('igraph', repos = 'https://cran.microsoft.com/')"
RUN Rscript -e "install.packages('htmltools', repos = 'https://cran.microsoft.com/')"
RUN Rscript -e "install.packages('here', repos = 'https://cran.microsoft.com/')"
RUN Rscript -e "install.packages('tidygraph', repos = 'https://cran.microsoft.com/')"
RUN Rscript -e "install.packages('ggraph', repos = 'https://cran.microsoft.com/')"


# create project directory in container
RUN mkdir info550proj

# copy repository files
COPY ./ /info550proj/

RUN chmod +x /info550proj/R/*.R


WORKDIR /info550proj



# execute make file
CMD make africa_trade_report
