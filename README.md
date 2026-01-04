# Rolling Linux apps
This is a Rolling linux apps set project for wwan devices.<br>
  **Flash service:** firmware update, switch, recovery.<br>
  **Ma service:** fccunlock(It is not open source).<br>
  **Config service:** OEM configuration function.<br>
  **Helper service:** provider dbus API for Flash/Ma/Config service.<br>

# License
The rolling_flash rolling_config  rolling_helper binaries are both LGPL 2.0, and rolling_ma_service is MIT.<br>

# Notice
  - Service must be used with fw_package. Before installing service, ensure that fw_package has been installed. Obtain the fw package from the corresponding OEM .<br>
  - fw_switch using fastboot so you can install fastboot with command `sudo apt-get install fastboot`<br>
- This application runs only on ubuntu24.04, fedora is in testing, other ubuntu versions and other OS have unverified.
# Building on Ubuntu

## 1. Install

- sudo apt install cmake<br>
- sudo apt install build-essential<br>
- sudo apt install -y pkg-config<br>
- sudo apt install libglib2.0-dev<br>
- sudo apt install libxml2-dev<br>
- sudo apt install libudev-dev<br>
- sudo apt install libmbim-glib-dev<br>
- sudo apt install libdbus-1-dev<br>
- sudo apt install libmm-glib-dev<br>
- sudo apt install libxml2-dev<br>
- sudo apt install libfwupd-dev<br>

## 2. Build
1. cmake -S . -B build -DPROJECT_BUILD=xxx -DOEM_BUILD=yyy<br>
    ex:xxx is rw101 and yyyis lenovo then you can use cmd:<br>
    `cmake -S . -B build -DBUILD_DEB=yes -DPROJECT_BUILD=rw101 -DOEM_BUILD=lenovo -DBUILD_BY_LIB=1` <br>
### 2.1 build lib
  1. you can use cmd build helper lib:<br>
    you can use cmd build all helper lib `cmake -S . -B build -DBUILD_LIB=y` 
    or you can build one lib:`cmake -S . -B build -DBUILD_LIB=y -DPROJECT_BUILD=rw101 -DOEM_BUILD=lenovo`<br>
  2. cmake --build build<br>
  3. cd build&&make build_lib<br>
  4. you can see `common_lib` in `build` directory

## 3. If using systemd, use
- load config file<br>
  sudo systemctl daemon-reload
- enable service<br>
  sudo systemctl enable rolling_xxx.service<br>
  **examples:** sudo systemctl enable rolling_helper.service<br>
&emsp;&emsp;&emsp;&emsp;&emsp;sudo systemctl enable rolling_helper.service<br>
&emsp;&emsp;&emsp;&emsp;&emsp;sudo systemctl enable rolling_flash.service<br>
&emsp;&emsp;&emsp;&emsp;&emsp;sudo systemctl enable rolling_config.service<br>
**notices:** this step must be done,then systemd can find and start the service<br>
- start service<br>
	sudo systemctl start rolling_xxx.service<br>
- Get status<br>
	sudo systemctl status rolling_xxx.service<br>
- Stop service<br>
	sudo systemctl stop rolling_xxx.service<br>

# release history
- version:1.0.0<br>
  first version, upload to github.<br>