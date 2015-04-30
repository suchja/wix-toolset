##About
An easy way to create installer packages (MSIs) for Microsoft Windows directly from your Linux or OS X box. Simply mount or download your WiX project into the image and compile it. Thus you will easily get the MSI.

**ATTENTION:** This image is pretty large (around 1.2GB).

###Provided core packages
This image provides the following core packages in addition to the ones contained in the parent image(s):

- [WiX Toolset](http://wixtoolset.org) - Creates an MSI from an XML based description

###Docker image structure
I'm a big fan of the *separation of concerns (SoC)* principle. Therefore I try to create Dockerfiles with mainly one responsibility. Thus it happens that an image is using a base image, which is using another base image, ... Here you see all the base images used for this image:

> [debian:jessie](https://github.com/tianon/docker-brew-debian/blob/188b27233cedf32048ee12378e8f8c6fc0fc0cb4/jessie/Dockerfile) The base image.
>> [suchja/x11client](https://registry.hub.docker.com/u/suchja/x11client/dockerfile/) Display any X Window content in a separate container
>>> [suchja/wine:latest](https://registry.hub.docker.com/u/suchja/wine/dockerfile/) Run windows applications under Linux or OS X
>>>> [suchja/wix](https://registry.hub.docker.com/u/suchja/wix/dockerfile/) This image

##Usage
Simply run a container from the image in interactive mode, bind-mount a host directory with your source code (i.e. WiX project) or use a data container and then use the WiX toolset from command prompt as you like. Here is an example:

`docker run --rm -it --entrypoint -v $(pwd)/sample-wix-project:/home/xclient/wix-example /bin/bash suchja/wix:latest`

Assuming you got the complete [git repository](https://github.com/suchja/wix-toolset) for this image and start a container from the root directory of this repository, you will have a running container with the wix example project available in `/home/xclient/wix-example`.

###Creating an MSI for the wix sample project
Compiling the example project into a MSI is quite easy. The following steps assume that you cloned the [git repository](https://github.com/suchja/wix-toolset) and started the container as described in the previous section.

Once you are in the container you need to do the following:

- Copy an standalone executable into the directory. I'll use the .NET 4.0 Verification tool: `cp ~/.wine/drive_c/windows/system32/netfx_setupverifier.exe ~/wix-example/example.exe`. 
- Compile the project with candle.exe: `wine ../wix/candle.exe example.wxs`. This creates a new file called `example.wixobj`.
- Create the MSI by using the linker (light.exe): `wine ../wix/light.exe -sval example.wixobj`. Congratulation! Now you have an `example.msi`.

The `-sval` switch on `light.exe` is required to suppress validation of the created MSI. Here seems to happen some strange stuff with 32- and 64-Bit. Remember, we are using Wine in 32-Bit (x86) mode.

You can even verify that the newly created MSI works by typing: `wine msiexec /i ~/wix-example/example.msi`. This will install "your application". Whether it was successful or not can be verified by `ls -la ~/.wine/drive_c/Program\ Files/`. You should see a folder called `Example` and in there should be an `example.exe`.

If your container is connected to an X Server (e.g. [suchja/x11server](https://registry.hub.docker.com/u/suchja/x11server/)), you can even check Wine's replacement of the "Add/Remove Programs dialog": `wine uninstaller`. This will show you a dialog. In there should be listed a product with the name "Example Product Name".

##Maintenance
I do not have a dedicated maintenance schedule for this image. In case a new stable version of WiX toolset is released, I might update the image accordingly.

If you experience any problems with the image, open up an issue on the [source repository](https://github.com/suchja/wix-toolset). I'll look into it as soon as possible.

###Latest wix binaries
Unfortunately the latest released wix-binaries cannot be downloaded programmatically. Problem seems to be some wired behaviour of codeplex. Thus a proper download link for the latest released wix binaries needs to be searched manually.

###Startup time vs. disk space
The pretty large image size is mainly due to the space required by wine. Without booting wine (`wine wineboot`) this image would be less than half the size. Unfortunately booting up wine is required to install some windows components. As I do favour startup time over disk space, I decided for faster startup time. Maybe there will be a different version of this image, which does initialization and downloads at startup and will thus be smaller.

###Errors during docker build
While creating this image with `docker build`, you might see some messages where wine is complaining about not running X server. This is because the image does not contain any X server. As far as I have experienced, the messages can be ignored, if only console applications are run inside the container.

If you plan to run applications with GUI, it might be better to use [suchja/x11server](https://registry.hub.docker.com/u/suchja/x11server/). When going this path, you should link to the x11server container and create a complete new wine prefix:

```
rm -rf ~/.wine
wine wineboot && winetricks --unattended dotnet40
```

###Wine/WiX and Dockerfile
Usually a Dockerfile comes in very handy, if you like to automate the build process of an MSI. Unfortunately there are some challenges with using Wine from within a Dockerfile. Please see [suchja/wine](https://registry.hub.docker.com/u/suchja/wine/) for further details.

##Copyright free
The sources in [this](https://github.com/suchja/wix-toolset) Github repository, from which the docker image is build, are copyright free (see LICENSE.md). Thus you are allowed to use these sources (e.g. Dockerfile and README.md) in which ever way you like.
