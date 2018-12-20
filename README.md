Enable QT5-Mesa-Support and gallium and etnaviv in mesa
-------------------------------------------------------

This will allow you to build Yocto Rocko for TX6 with Qt5 support using the open source etnaviv driver.

Follow the Yocto Guide Rocko on the Karo WEB site:
https://www.karo-electronics.de/1920.html?&L=1

Follow the Custonise guide to add Qt5
https://www.karo-electronics.de/1921.html?&L=1

Before running bitbake follow these additional instructions:


Extact meta-di.tar into the sources directory of the Karo BSP (Yocto Rocko).

For the file meta-di/recipes-graphics/mesa/mesa_17.1.7.bbappend, check if 17.1.7 is the correct version of mesa.
To check the mesa-version search for the mesa-recipe in poky/meta/recipes-graphics/mesa/mesa_[...].bb! If it
is a different version change the name for meta-di/recipes-graphics/mesa/mesa_17.1.7.bbappend accordingly.

Add the following to your local.conf:

IMAGE_INSTALL_append = " \
    qtbase-plugins \
    cinematicexperience \
    "

Add the following to your bblayers.conf:

  ${BSPDIR}/sources/meta-di \


Now "bitbake core-image-minimal"

When programming module with the manufacturing tool create an environment file with the following content:

boot_mode=mmc
append_bootargs=init=/sbin/init video=mxcfb0:dev=lcd,800x480M@60,if=RGB24

To run the demo, type at the Linux prompt on the target:

Qt5_CinematicExperience -platform eglfs -plugin evdevtouch:/dev/input/event0


References
----------
https://mesa3d.org/intro.html
https://github.com/mesa3d

