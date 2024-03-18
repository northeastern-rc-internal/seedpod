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
                       pkg-config \
                       libfreetype6-dev \
                       libpng-dev \
                       python3-matplotlib \
                       default-jre \
                       bash \
                       libboost-dev

# Install FastQC
WORKDIR /opt
RUN echo "Downloading FastQC..." && \
    wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.12.1.zip && \
    unzip fastqc_v0.12.1.zip && \
    chmod 777 /opt/FastQC/fastqc

# Fix language warning in FastQC
RUN echo "Fixing language warning in FastQC..." && \
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y locales && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV PATH="${PATH}:/opt/FastQC"

# Install Miniconda
RUN echo "Installing Miniconda..." && \
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    chmod 755 Miniconda3-latest-Linux-x86_64.sh && \
    ./Miniconda3-latest-Linux-x86_64.sh -b -p /opt/miniconda && \
    rm Miniconda3-latest-Linux-x86_64.sh
ENV PATH /opt/miniconda/bin:$PATH


ENV CONDA_NAME ipyrad
RUN /bin/bash -c "conda create -n $CONDA_NAME python=3.10 -y"
RUN /bin/bash -c "source activate $CONDA_NAME && conda install -y ipyrad -c conda-forge -c bioconda && conda install -c conda-forge ncurses -y"

# Install MultiQC from source
RUN echo "Installing MultiQC..." && \
    git clone https://github.com/MultiQC/MultiQC.git /opt/MultiQC \
    && cd /opt/MultiQC && pip install .

# Install ANGSD
RUN echo "Installing ANGSD..." && \
    apt-get install -y liblzma-dev libcurl4-openssl-dev libssl-dev && \
    wget http://popgen.dk/software/download/angsd/angsd0.940.tar.gz -P /opt && \
    tar xvf /opt/angsd0.940.tar.gz && \
    cd htslib && make && cd /opt/angsd && make HTSSRC=../htslib && rm /opt/angsd0.940.tar.gz
ENV PATH /opt/angsd/angsd:$PATH

# Clone PCAngsd repository
RUN git clone https://github.com/Rosemeis/pcangsd.git /opt/pcangsd  \
    && cd /opt/pcangsd && pip install --no-cache-dir numpy cython scipy \
    && pip install .
ENV PATH="${PATH}:/opt/pcangsd"

#install structure 
RUN wget https://web.stanford.edu/group/pritchardlab/structure_software/release_versions/v2.3.4/release/structure_linux_console.tar.gz -P /opt \
    && tar xzvf structure_linux_console.tar.gz && cd /opt/console \ 
    && chmod 755 structure && rm /opt/structure_linux_console.tar.gz

ENV PATH="${PATH}:/opt/console"    

#install plink2
RUN wget https://s3.amazonaws.com/plink2-assets/alpha5/plink2_linux_amd_avx2_20240105.zip -P /opt \
    && unzip plink2_linux_amd_avx2_20240105.zip

ENV PATH="${PATH}:/opt/plink2"           

#install R
RUN apt-get update && apt-get install r-base r-base-dev -y
RUN add-apt-repository ppa:c2d4u.team/c2d4u4.0+

#Install rstudio
RUN apt-get install gdebi-core -y && wget https://download2.rstudio.org/server/jammy/amd64/rstudio-server-2023.12.1-402-amd64.deb -P /opt \
    && gdebi /opt/rstudio-server-2023.12.1-402-amd64.deb && rm /opt/rstudio-server-2023.12.1-402-amd64.deb

#install FEEMS
#RUN git clone https://github.com/NovembreLab/feems /opt/feems \
#    && cd /opt/feems && pip install .

COPY startup.sh /opt
RUN echo "Setting permissions for startup script..." && \
    chmod 777 /opt/startup.sh