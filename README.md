## Yocto Layer for the Karo BSP (Rocko) to enable the etnaviv driver with Qt5 ## 

This layer will allow you to build the Karo Yocto Rocko BSP for TX6 with Qt5 support using the open source etnaviv driver.

Follow the **Yocto Rocko Guide** on the Karo WEB site:  
https://karo-electronics.github.io/docs/yocto-guide/yocto-rocko-guide/

In summary run the following commands after setting up the Yocto build environment:

```
repo init --no-clone-bundle -u https://github.com/karo-electronics/karo-bsp -b rocko
repo sync
```

Add meta-qt5 layer to the sources directory:  

```
cd sources
git clone -b rocko https://github.com/meta-qt5/meta-qt5.git
```
Now enable the open source etnaviv GPU driver by also adding this layer (**meta-di**) to the sources directory:
```
git clone https://github.com/directinsight/meta-di.git -b rocko
```

There are two additional recipes in this layer:- **mesa_17.1.7.bbappend** and **qtbase_%.bbappend**.  

The recipe **recipes-graphics/mesa/mesa_17.1.7.bbappend** enables gallium and etnaviv in mesa. The recepie **recipes-qt5/qt5/qtbase_%.bbappend** enables Qt5 mesa support with the the neccessary Qt5 options for the TX6 range of modules.  

Now Qt5 will build its eglfs-platform with the gdm module which is required for the mesa-etnaviv open source GPU driver.  

For the file **meta-di/recipes-graphics/mesa/mesa_17.1.7.bbappend**, check if 17.1.7 is the correct version of mesa.  
To check the mesa-version search for the mesa-recipe in *poky/meta/recipes-graphics/mesa/mesa_[...].bb*. If it
is a different version change the name for **meta-di/recipes-graphics/mesa/mesa_17.1.7.bbappend** accordingly.  

### Setup the Build and update the Configuration Files ###   

From the BSP root directory configure the build:

```
MACHINE=imx6dl-tx6-emmc source ./setup-environment build-gnulinux
```
Replace the above MACHINE with the required machine coresponding to your TX module. See the Karo Yocto Rocko guide.

In the conf dorectory, add the following to your **local.conf**:
```
IMAGE_INSTALL_append = " \
    qtbase-plugins \
    cinematicexperience \
    "
DISTRO_FEATURES_remove = " x11"
```
Add the following to your **bblayers.conf**:
```
  ${BSPDIR}/sources/meta-qt5 \
  ${BSPDIR}/sources/meta-di \
  
```

### Build The Image ###   

Now from the build root directory build the image, for example:

```
bitbake karo-image-minimal
```

### Programming the TX6 Module and Check ###   

When programming module with the manufacturing tool create an environment file with the following content:

```
boot_mode=mmc
append_bootargs=init=/sbin/init video=mxcfb0:dev=lcd,800x480M@60,if=RGB24
```

To run the demo, type at the Linux prompt on the target:

```
Qt5_CinematicExperience -platform eglfs -plugin evdevtouch:/dev/input/event0
```

### References ### 
https://mesa3d.org   
https://github.com/mesa3d

