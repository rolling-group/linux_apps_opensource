# Rolling Linux Apps
Rolling Linux Apps is a set of WWAN-related services for Rolling devices:
- **rolling_flash_service**: firmware update / switch / recovery
- **rolling_config_service**: OEM configuration
- **rolling_helper_service**: provides D-Bus API used by other services

> Note: MA service has been removed in the Lenovo branch.

## License
The `rolling_flash`, `rolling_config`, `rolling_helper` binaries are LGPL-2.0.

## Notes
- This service set must be used with `fw_package`. Before installing, make sure `fw_package` is already installed (provided by OEM).
- `fw_switch` uses `fastboot`.
- Verified on **Ubuntu 24.04**. Fedora is in testing; other OS versions are unverified.

## 1) Build using `setup.sh`
From the `linux-apps/` directory:

```bash
cd linux-apps
chmod +x ./setup.sh
./setup.sh <deb|rpm> rw101 lenovo
```

Optional:

```bash
./setup.sh <deb|rpm> rw101 lenovo --no-install
```

## 2) Output packages (DEB/RPM)
After a successful build, packages are created under:
- `linux-apps/binary_deb/`

Examples:
- `linux-apps/binary_deb/*.deb`
- `linux-apps/binary_deb/*.rpm`

## 3) Install / uninstall packages

### Install DEB (Ubuntu/Debian)

```bash
sudo dpkg -i linux-apps/binary_deb/*.deb
```

If dependency issues occur:

```bash
sudo apt-get -f install
```

### Uninstall DEB

```bash
sudo apt-get remove linux-apps-qualcomm-rw101-lenovo
```

> If your package name differs, check it via `dpkg -l | grep linux-apps`.

### Install RPM (Fedora/RHEL)

```bash
sudo rpm -ivh linux-apps/binary_deb/*.rpm
```

### Uninstall RPM

```bash
sudo rpm -e linux-apps-qualcomm-rw101-lenovo
```

> If your package name differs, check it via `rpm -qa | grep linux-apps`.

## 4) systemd services installed by the package
After installation, the package provides these systemd units:
- `rolling_helper.service` (Helper service)
- `rolling_flash.service` (Flash service)
- `rolling_config.service` (Config service)

Common management commands:

```bash
sudo systemctl daemon-reload
sudo systemctl enable rolling_helper.service
sudo systemctl enable rolling_flash.service
sudo systemctl enable rolling_config.service

sudo systemctl start  rolling_helper.service
sudo systemctl start  rolling_flash.service 
sudo systemctl start  rolling_config.service

sudo systemctl status rolling_XXX.service

sudo systemctl stop   rolling_XXX.service
```

## Release history
- 1.0.0: first version, upload to github.
- 1.0.1：first version for lenovo, new branch from main