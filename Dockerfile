FROM ubuntu:jammy
EXPOSE 1900
EXPOSE 5000
EXPOSE 8080
EXPOSE 80

# Blender and Flamenco Manager API dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt install -y curl gzip bzip2 && \
    apt-get install -y \
        ffmpeg \
        nasm \
        libx264-dev \
        libx265-dev \
        libnuma-dev \
        libvpx-dev \
        libfdk-aac-dev \
        libmp3lame-dev \
        libopus-dev \
        libaom-dev \
        libfreetype6 \
        libglu1-mesa \
        libglu1-mesa-dev \
        libegl-dev \
        libxi6 \
        libsm-dev \
        libxrender1 \
        libtbb-dev \
        libosd-dev \
        xz-utils \
        build-essential git \
        python3-dev \
        python3-pip && \ 
        pip3 install bpy wheel requests urllib3 python-dateutil docopt pyyaml nano && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists/*

# Blender 
ENV BLENDER_MAJOR 3.5
ENV BLENDER_VERSION 3.5.1
ENV PATH=${PATH}:/usr/local/blender
RUN curl -o /usr/local/blender-3.5.1-linux-x64.tar.xz https://download.blender.org/release/Blender3.5/blender-3.5.1-linux-x64.tar.xz 
RUN tar -xf /usr/local/blender-3.5.1-linux-x64.tar.xz -C /usr/local/ && \
    mv /usr/local/blender-3.5.1-linux-x64 /usr/local/blender

# Flamenco Manager and Worker executables
RUN mkdir -p /code/flamenco/ && \
    curl https://flamenco.blender.org/downloads/flamenco-3.2-linux-amd64.tar.gz > /code/flamenco/flamenco-3.2-linux-amd64.tar.gz && \
    cd /code/flamenco/ && \
    tar xzf flamenco-3.2-linux-amd64.tar.gz && \
    mv flamenco-3.2-linux-amd64/* .

# Blender Benchmark
RUN mkdir -p /code/benchmark/ && \
    curl https://download.blender.org/release/BlenderBenchmark2.0/launcher/benchmark-launcher-cli-3.1.0-linux.tar.gz > /code/benchmark/benchmark-launcher-cli-3.1.0-linux.tar.gz && \
    cd /code/benchmark/ && \
    tar zxf benchmark-launcher-cli-3.1.0-linux.tar.gz

RUN mkdir -p /code/benchmark-src/ && \
    curl https://opendata.blender.org/cdn/BlenderBenchmark2.0/script/blender-benchmark-script-2.0.0.tar.gz > /code/benchmark-src/blender-benchmark-script-2.0.0.tar.gz && \
    curl https://mirrors.ocf.berkeley.edu/blender/release/BlenderBenchmark2.0/scenes/bmw27.tar.bz2 > /code/benchmark-src/bmw27.tar.bz2

#    cd /code/benchmark-src
#bunzip2 bmw27.tar.bz2 && \
#tar zxf blender-benchmark-script-2.0.0.tar.gz

ENV DEBIAN_FRONTEND=dialog

# Flamenco Manager and Worker configuration -> Make Sure The Uncommented "COPY" Lines Have The Files "flamenco-worker.yaml" and "flamenco-manager.yaml" in the same directory as the Dockerfile

COPY flamenco-worker.yaml /code/flamenco/    

# Only Uncomment The Below Line If Your Local Directory Has A Fully Populated Manager.YAML File

#COPY flamenco-manager.yaml /code/flamenco/    

WORKDIR /code/flamenco/
CMD ["/code/flamenco/flamenco-manager"]
