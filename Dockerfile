FROM ubuntu:22.04
ENV TERM linux

ARG DEBIAN_FRONTEND=noninteractive

# Install base compilers and packages
RUN apt-get update && \
    apt-get install -y build-essential \
                       software-properties-common \
                       xsltproc \
                       autoconf \
                       automake \
                       autotools-dev \
                       gfortran \
                       cmake \
                       protobuf-compiler \
                       make \
                       gcc \
                       wget \
                       git \
                       libc-dev \
                       python3-dev \
                       python3-pip \
                       csh \
                       libbz2-dev \
                       perl \
                       xsltproc \
                       docbook-xsl \
                       docbook-xml \
                       zlib1g-dev \
                       libeigen3-dev \
                       gfortran \
                       unzip \
                       vim \
                       nano \
                       pkg-config \
                       libfreetype6-dev \
                       libpng-dev \
                       python3-matplotlib \
                       default-jre \
                       bash \
                       libboost-dev \
                       liblzma-dev  \ 
                       libcurl4-openssl-dev \
                       libssl-dev \
                       gdebi-core

# Install FastQC
WORKDIR /opt
RUN wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.12.1.zip && \
    unzip fastqc_v0.12.1.zip && \
    chmod 777 /opt/FastQC/fastqc && rm /opt/fastqc_v0.12.1.zip

# Fix language warning in FastQC
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8


# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    chmod 755 Miniconda3-latest-Linux-x86_64.sh && \
    ./Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda && \
    rm Miniconda3-latest-Linux-x86_64.sh
ENV PATH="/opt/miniconda/bin:${PATH}"

ENV CONDA_NAME ipyrad
RUN /bin/bash -c "conda create -n $CONDA_NAME python=3.10 -y"
RUN /bin/bash -c "source activate $CONDA_NAME && conda install -y ipyrad -c conda-forge -c bioconda && conda install -c conda-forge ncurses -y"

# Install MultiQC from source
RUN git clone https://github.com/MultiQC/MultiQC.git /opt/MultiQC && \
    cd /opt/MultiQC && pip install .

# Install ANGSD
RUN wget http://popgen.dk/software/download/angsd/angsd0.940.tar.gz -P /opt && \
    tar xvf /opt/angsd0.940.tar.gz && \
    cd htslib && make && cd /opt/angsd && make HTSSRC=../htslib && rm /opt/angsd0.940.tar.gz

# Clone PCAngsd repository
RUN git clone https://github.com/Rosemeis/pcangsd.git /opt/pcangsd  && \
    cd /opt/pcangsd && pip install --no-cache-dir numpy cython scipy && \
    pip install .

#install plink2
RUN wget https://s3.amazonaws.com/plink2-assets/alpha5/plink2_linux_amd_avx2_20240105.zip -P /opt && \
    unzip plink2_linux_amd_avx2_20240105.zip && rm /opt/plink2_linux_amd_avx2_20240105.zip

#install R
RUN apt-get update && apt-get install r-base r-base-dev -y
RUN add-apt-repository ppa:c2d4u.team/c2d4u4.0+

#install R packages
RUN MAKEFLAGS=4 R -e 'install.packages("devtools", repos = "http://cran.us.r-project.org")'
RUN MAKEFLAGS=4 R -e 'install.packages("ggplot2", repos = "http://cran.us.r-project.org")'
RUN MAKEFLAGS=4 R -e 'install.packages("tidyverse", repos = "http://cran.us.r-project.org")'
RUN MAKEFLAGS=4 R -e 'install.packages("ggrepel", repos = "http://cran.us.r-project.org")'
RUN MAKEFLAGS=4 R -e 'install.packages("rstan", repos = "http://cran.us.r-project.org")'
RUN MAKEFLAGS=4 R -e 'install.packages("conStruct", repos = "http://cran.us.r-project.org")'

#Install rstudio
RUN apt-get install gdebi-core -y && wget https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2023.12.1-402-amd64.deb -P /opt && \
    gdebi /opt/rstudio-server-2023.12.1-402-amd64.deb && rm /opt/rstudio-server-2023.12.1-402-amd64.deb

#Install vcftools
RUN git clone https://github.com/vcftools/vcftools.git /opt/vcftools && \
    cd /opt/vcftools && ./autogen.sh && ./configure && make && make install

#install bcftools
RUN wget https://github.com/samtools/bcftools/releases/download/1.19/bcftools-1.19.tar.bz2 -P /opt && \
    tar xjvf /opt/bcftools-1.19.tar.bz2 && cd /opt/bcftools-1.19 && ./configure && make && make install && \
    rm /opt/bcftools-1.19.tar.bz2

#install ngsrelate
RUN git clone https://github.com/ANGSD/ngsRelate /opt/ngsRelate && \
    cd /opt/htslib/ && make -j2 && cd ../ngsRelate && make HTSSRC=../htslib/    

#install migrate
RUN wget https://peterbeerli.com/migrate-html5/download_version4/migrate-newest.src.tar.gz -P /opt && \
    tar xvf /opt/migrate-newest.src.tar.gz && cd /opt/migrate-5.0.6/src && ./configure && make && make install \
    && rm /opt/migrate-newest.src.tar.gz 

#FEEMS
#ENV CONDA_NAME2 feems
#RUN /bin/bash -c "conda create -n $CONDA_NAME2 -y"
#RUN /bin/bash -c "source activate $CONDA_NAME2 && conda install -c bioconda feems -c conda-forge -y"

RUN /bin/bash -c "conda create -n feems_e python=3.8.3 -y && \
                  source activate feems_e && \
                  conda install -c conda-forge geopandas=0.9.0 numpy=1.22.3 scipy=1.5.0 scikit-learn=0.23.1 matplotlib=3.2.2 pyproj=2.6.1.post1 networkx=2.4.0 shapely=1.7.1 fiona pytest=5.4.3 pep8=1.7.1 flake8=3.8.3 click=7.1.2 setuptools pandas-plink msprime=1.0.0 statsmodels=0.12.2 PyYAML=5.4.1 xlrd=2.0.1 openpyxl=3.0.7 suitesparse=5.7.2 scikit-sparse=0.4.4 cartopy=0.18.0 -y"

# Clone and install FEEMS
RUN /bin/bash -c "source /opt/miniconda/bin/activate feems_e && \
                  git clone https://github.com/NovembreLab/feems.git /opt/feems && \
                  pip install /opt/feems"


ENV PATH /opt:/opt/bcftools-1.19:/opt/plink2:/opt/console:/opt/pcangsd:/opt/angsd:/opt/angsd/misc:/opt/MultiQC:/opt/miniconda/bin:/opt/FastQC:/opt/vcftools/src/cpp:/opt/migrate-newest/src:/opt/ngsRelate:${PATH}

COPY startup.sh /opt

RUN chmod 777 /opt/startup.sh
