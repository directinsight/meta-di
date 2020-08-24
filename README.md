## Yocto Layer for the Karo BSP (Zeus) to enable the etnaviv driver with Qt5 ## 

This layer will allow you to build the Karo Yocto Rocko BSP for TX6 with Qt5 support using the open source etnaviv driver.

Follow the **Mainline Yocto Zeus Guide** on the Direct Insight Customerzone WEB site:
https://customerzone.directinsight.co.uk/doc/yocto-guide/mainline-zeus/

In summary run the following commands after setting up the Yocto build environment:

```
repo init --no-clone-bundle -u https://github.com/karo-electronics/karo-bsp -b zeus
repo sync
```

Now to enable the open source etnaviv GPU driver, add this layer (**meta-di**) to the layers directory of the Zeus BSP:
```
cd layers
git clone https://github.com/directinsight/meta-di.git -b zeus
```

There are two additional recipes in this layer:- **mesa_20.0.2.bbappend** and **qtbase_%.bbappend**.  

The recipe **recipes-graphics/mesa/mesa_20.0.2.bbappend** enables gallium and etnaviv in mesa. The recepie **recipes-qt5/qt5/qtbase_%.bbappend** enables Qt5 mesa support with the the neccessary Qt5 options for the TX6 range of modules.  

Now Qt5 builds its eglfs-platform with the gdm module which is needed for the mesa-etnaviv open source GPU driver.  

For the file **meta-di/recipes-graphics/mesa/mesa_20.0.2.bbappend**, check if 20.0.2 is the correct version of mesa.  
To check the mesa-version search for the mesa-recipe in *meta-karo-distro/recipes-graphics/mesa/mesa_[...].bb*. If it
is a different version change the name for **meta-di/recipes-graphics/mesa/mesa_20.0.2.bbappend** accordingly.  

### Setup the Build and update the Configuration Files ###   

From the BSP root directory configure the build:

```
DISTRO=karo-minimal MACHINE=tx6s-8035 source setup-environment build-tx6s-8035
```
Replace the above MACHINE with the required machine coresponding to your TX module. See the Yocto Rocko guide.

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
  ${BSPDIR}/layers/meta-qt5 \
  ${BSPDIR}/layers/meta-di \
  
```

### Build The Image ###   

From the build root directory now build the image, for example:

```
bitbake core-image-minimal
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
https://mesa3d.org/intro.html  
https://github.com/mesa3d

