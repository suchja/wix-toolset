##About
A Docker Image running [Wine](https://www.winehq.org) and [WiX](http://wixtoolset.org) for creating windows installer packages (msi).

**ATTENTION:** This image is pretty large (around 1.2GB).

##Usage

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
