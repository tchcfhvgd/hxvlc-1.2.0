![](https://github.com/MAJigsaw77/hxvlc/raw/main/logo.png)

# hxvlc

![](https://img.shields.io/github/repo-size/MAJigsaw77/hxvlc) ![](https://badgen.net/github/open-issues/MAJigsaw77/hxvlc) ![](https://badgen.net/badge/license/MIT/green)

A Haxe/[OpenFL](https://www.openfl.org) library for @:native video playback using [libVLC](https://www.videolan.org/vlc/libvlc.html).

## Supported platforms

* Windows **(x86_64 only)**.
* MacOS **(x86_64 and arm64 only)**.
* Linux.
* Android **(arm64, armv7a, x86 and x86_64 only)**.
* iOS **(arm64 and simulator only)**.

> [!CAUTION]
> These platforms needs be to compiled with `C++` using [Lime](https://lime.openfl.org) in order to work.

## Instructions

1. Install the library.

   * You can install it through `Haxelib`
        ```bash
        haxelib install hxvlc
        ```

   * Or through `Git`, if you want the latest updates
        ```bash
        haxelib git hxvlc https://github.com/MAJigsaw77/hxvlc.git
        ```

2. Add this code in the **project.xml** file.

    ```xml
    <section if="cpp">
    	<haxelib name="hxvlc" if="desktop || mobile" />
    </section>
    ```

3. ***Linux users only***, you need to install [`vlc`](https://www.videolan.org/vlc) from your distro's package manager.

    * [Debian](https://debian.org) based distributions:
        ```bash
        sudo apt-get install libvlc-dev libvlccore-dev vlc-bin vlc
        ```

    * [Arch](https://archlinux.org) based distributions:
        ```bash
        sudo pacman -S vlc
        ```

    * [Gentoo](https://www.gentoo.org) based distributions:
        ```bash
        sudo emerge media-video/vlc
        ```

4. ***iOS users only***, you need to add the `MobileVLCKit` framework.

    * Download the [Framework](https://download.videolan.org/cocoapods/unstable/MobileVLCKit-3.6.0b10-615f96dc-4733d1cc.tar.xz) and extract it.

    * In your apps, on the `.xcodeproj` file click on the target named after your app.

    * Navigate to `Build Settings` and change `Debug Information Format` to `DWARF`.

    * After that go to `Build Phases/Link Binary With Libraries` and at the bottom click on the plus sign and click `Add Other/Add Files`.

    * Locate the path of the `MobileVLCKit.xcframework` were you extracted the downloaded framework and add it.

5. **Well done!**

## Usage Examples

Check out the [Samples Folder](samples/) for examples on how to use this library.

## Licensing

**hxvlc** is made available under the **MIT License**. Check [LICENSE](./LICENSE) for more information.

![](https://images.videolan.org/images/goodies/Cone-Video-small.png)

**libVLC** is an embeddable engine for 3rd party applications and frameworks released under the **LGPL2.1 License**. Check [VideoLAN.org](https://videolan.org/legal.html) for more information.
