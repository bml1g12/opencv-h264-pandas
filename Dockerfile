FROM continuumio/miniconda3 AS BUILD
##################################################
# Stage 1 - only /opt/conda/ is preserved from this stage
##################################################

WORKDIR /usr/src/app

# libgl1-mesa-glx essential for cv2 it seems. build-essential needed for one of the pandas pypy package.
RUN apt-get update && \
    apt-get install -y --no-install-recommends git wget unzip bzip2 build-essential ca-certificates libgl1-mesa-glx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ./environment.yml /usr/src/app/environment.yml

# Create the environment:
COPY environment.yml .
COPY requirements.txt .

RUN conda env create -f environment.yml && conda clean -afy
 
RUN ["conda", "run", "-n", "opencv-h264", "pip", "install", "-r", "requirements.txt"]
