# Base image
FROM busybox:latest

# Path of data directory
ARG PATH_DIR_DATA="/data"

# Set ENV value for an image
ENV PATH_DIR_DATA $PATH_DIR_DATA

# Create directory inside the image and leave a sample
RUN mkdir $PATH_DIR_DATA && \
    echo "Hello data container" > $PATH_DIR_DATA/data_sample1.txt

# Share director
VOLUME $PATH_DIR_DATA

# Add health check command
HEALTHCHECK CMD ls -l -d $(find /) || exit $_
