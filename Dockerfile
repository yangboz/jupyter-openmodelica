FROM ubuntu:14.04

# Update index
RUN apt-get update
RUN apt-get install -y software-properties-common

# Install weget
RUN apt-get install -y wget

# Add OpenModelica stable build
RUN for deb in deb deb-src; do echo "$deb http://build.openmodelica.org/apt `lsb_release -cs` stable"; done | sudo tee /etc/apt/sources.list.d/openmodelica.list
RUN wget -q http://build.openmodelica.org/apt/openmodelica.asc -O- | sudo apt-key add - 

# Update index (again)
RUN apt-get update

# Install OpenModelica
RUN apt-get install -y openmodelica

MAINTAINER yangboz "z@smartkit.info"

RUN apt-get update && apt-get install -y build-essential git wget
RUN apt-get install -y vim

# install python 3.5
RUN add-apt-repository -y ppa:fkrull/deadsnakes
RUN apt-get -y update
RUN apt-get -y install python3.5 python3-pip

COPY . /app
WORKDIR /app


RUN pip3 install --upgrade pip

# OMPython
RUN pip3 install -U https://github.com/OpenModelica/OMPython/archive/master.zip

# Notebook
RUN pip3 install ipython
RUN pip3 install notebook

RUN python3 setup.py install

EXPOSE 93
CMD ["jupyter","notebook","--ip=0.0.0.0", "--port=93","--allow-root"]
