# FIXME: mesa should support 'x11-no-tls' option
python () {
    overrides = d.getVar("OVERRIDES", True).split(":")
    if "imxgpu2d" not in overrides:
        return

    x11flag = d.getVarFlag("PACKAGECONFIG", "x11", False)
    d.setVarFlag("PACKAGECONFIG", "x11", x11flag.replace("--enable-glx-tls", "--enable-glx"))
}

# Enable Etnaviv support
PACKAGECONFIG_append = " gallium"
GALLIUMDRIVERS_append = ",etnaviv,imx"
