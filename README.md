## PXEBOOT

An out-of-the-box start and use TFTP PXE server with CentOS 7 online installation pre-configured. You can also supply your own menu configuration, or even your own PXE boot image/environment for full customization.

#### How to use

For out-of-the-box running

`$ docker pull nanert/pxeboot`
`$ docker run -d --net=host --name=pxeboot nanert/pxeboot`

Configure your DHCP server to give the container IP for next-server and pxelinux.0 as the filename.


#### Advanced Use

The Dockerfile is available [on Github](https://github.com/nanert/docker-pxeboot).

nanert/pxeboot does not expose any ports for you. tftp/PXE uses UDP port 69 by default, but this is configurable in the container via environment variables.

Supported environment variables:

* **LISTEN_IP** - The IP address to listen on. Defaults to 0.0.0.0.

* **LISTEN_PORT** - The UDP PORT to listen on. Defaults to 69.

nanert/pxeboot only supports IPv4. If you need IPv6, you'll have to delve into man in.tftpd and the Dockerfile.

Custom mount points for configurations:

/srv - This is the tftp root that nanert/pxeboot uses. You can mount this to your own directory and provide any PXE images and configurations you want.

/srv/pxelinux.cfg - nanert/pxeboot uses pxelinux.0 from the syslinux package. The "default" file in this directory holds the default menu config with a CentOS7 setup. You can mount only this folder and serve your own config files for custom menus and PXE boot options instead of overriding all of /srv, which requires you to provide your own pxe images. Images/files that are available are: mboot.c32, menu.c32, chain.c32, pxelinux.0, and memdisk.

#### Issues

I have had some trouble getting docker's proxy (port publishing or what have you) to work correctly when PXE booting with this image. The tftp server seems to be errant in it's behavior when going through the proxy (or the proxy is, who knows). Since troubleshooting things over UDP is even more annoying than TCP, I haven't delved much into it. Suffice to say if you need to PXE boot with this server via docker's proxy interface, YMMV (aka it won't work probably). If you get it working pls let me know how. I usually just give a LISTEN_IP and the --net=host to the instance and let it chill on my network PXE booting my things.

