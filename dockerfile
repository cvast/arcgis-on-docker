FROM centos:latest

MAINTAINER @steveAGRC <sgourley@utah.gov>

# set up environment variables
ENV USER arcgis
ENV GROUP arcgis

# install server packages
RUN yum -y --nogpg install xorg-x11-server-Xvfb.x86_64 \
			   fontconfig \
			   freetype \
			   gettext \
			   less \
			   htop \
			   vim \
			   mesa-libGLU \
			   libXtst \
			   libXi \
			   libXrender \
			   net-tools

# copy files to arcgis location
RUN mkdir /arcgis
ADD ags.tar.gz /arcgis/
COPY authorize-and-start.sh /arcgis/

# set up permissions
RUN groupadd $GROUP
RUN useradd -m -r $USER -g $GROUP

RUN chown -R $USER:$GROUP /arcgis
RUN chmod -R 755 /arcgis

USER $USER

# install arcgis
RUN /arcgis/ArcGISServer/Setup -m silent -l yes -d /

# set volume up for provising file
VOLUME /license

# open ports
EXPOSE 6080 6443 4001 4002 4004

# start the server
ENTRYPOINT /arcgis/authorize-and-start.sh; /bin/bash
