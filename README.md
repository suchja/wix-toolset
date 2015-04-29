##About
An easy way to create installer packages (MSIs) for Microsoft Windows directly from your Linux or OS X box. Simply mount or download your WiX project into the image and compile it. Thus you will easily get the MSI.

**ATTENTION:** This image is pretty large (around 1.45GB).

###Provided core packages
This image provides the following core packages in addition to the ones contained in the parent image(s):

- [WiX Toolset](http://wixtoolset.org) - Creates an MSI from an XML based description

###Docker image structure
I'm a big fan of the *separation of concerns (SoC)* principle. Therefore I try to create Dockerfiles with mainly one responsibility. Thus it happens that an image is using a base image, which is using another base image, ... Here you see all the base images used for this image:

> [debian:jessie](https://github.com/tianon/docker-brew-debian/blob/188b27233cedf32048ee12378e8f8c6fc0fc0cb4/jessie/Dockerfile) / [ubuntu:14.04](https://github.com/tianon/docker-brew-ubuntu-core/blob/7fef77c821d7f806373c04675358ac6179eaeaf3/trusty/Dockerfile) depending on the chosen Tag.
>> [suchja/x11client](https://registry.hub.docker.com/u/suchja/x11client/dockerfile/) Display any X Window content in a separate container
>>> [suchja/wine](https://registry.hub.docker.com/u/suchja/wine/dockerfile/) Run windows applications under Linux or OS X
>>>> [suchja/wix](https://registry.hub.docker.com/u/suchja/wix/dockerfile/) This image

##Usage
Simply run a container from the image in interactive mode, bind-mount a host directory with your source code (i.e. WiX project) or use a data container and then use the WiX toolset from command prompt as you like. Here is an example:

`docker run --rm -it --entrypoint -v $(pwd):/usr/src /bin/bash suchja/wix:latest`

##Maintenance
I do not have a dedicated maintenance schedule for this image. In case a new stable version of Wine is released, I might update the image accordingly.

If you experience any problems with the image, open up an issue on the [source repository](https://github.com/suchja/wix-toolset). I'll look into it as soon as possible.

###Latest wix binaries
Unfortunately the latest released wix-binaries cannot be downloaded programmatically. Problem seems to be some wired behaviour of codeplex. Thus a proper download link for the latest released wix binaries needs to be searched manually.

###Startup time vs. disk space
The pretty large image size is mainly due to the space required by wine. Without booting wine (`wine wineboot`) this image would be less than half the size. Unfortunately booting up wine is required to install some windows components. As I do favour startup time over disk space, I decided for faster startup time. Maybe there will be a different version of this image, which does initialization and downloads at startup and will thus be smaller.

###Errors during docker build
While creating this image with `docker build`, you might see some messages where wine si complaining about not running X server. This is because the image does not contain any X server. As far as I have experienced, the messages can be ignored, if only console applications are run inside the container.

If you plan to run applications with GUI, it might be better to use [suchja/x11server](https://registry.hub.docker.com/u/suchja/x11server/). When going this path, you should link to the x11server container and create a complete new wine prefix:

```
rm -rf ~/.wine
wine wineboot && winetricks --unattended dotnet40
```

##Copyright free
The sources in [this](https://github.com/suchja/wix-toolset) Github repository, from which the docker image is build, are copyright free (see LICENSE.md). Thus you are allowed to use these sources (e.g. Dockerfile and README.md) in which ever way you like.
