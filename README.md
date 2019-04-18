# BCON-Game

A game in the BCON RFID Arcade project.

## Overview

Within this repo is the implementation of Skee-Ball, one of the BCON RFID Arcade games. However, this repo makes it incredonly easy to extend the project and add more games. 

The project is built against the [Qt Open Source](https://qt.io) framework, making it easily portable across platforms.

### Functionality

- Playing a game (of Skee-Ball) depending on the number of tokens a user has available.
- Real-time data updates via publish-subscribe mechanisms.

## Prerequisites

- [Qt Open Source](https://qt.io/download) (5.12.0 or later preferred)

	- Download and execute the installer for your platform (macOS or Linux preferred).
	- To run the project, _at least_ the base installation (i.e. "macOS" or "Desktop gcc" for Linux) and the Virtual Keyboard should be checked off when expanding the desired installation version.
	- The Qt Creator IDE will be installed by default.

- [libBCONNetwork](https://github.com/teambcon/libBCONNetwork) (project submodule)

	- Before the project can built, its submodule dependency must be.
	- Ensure Qt's binary directory is in the `PATH` environment variable (i.e. `~/Qt/5.12.0/clang_64/bin` for macOS)
	- Execute the build script for your platform inside of the library _build_ directory.
	- The dynamic library will be created in a platform-dependent directory inside _libBCONNetwork/libs_.

## Building the Game

Once the library dependencie has been built and installed as described above, the game can be built with `qmake` and `make` (typically through Qt Creator).

To build without using the IDE:

```sh
mkdir build
cd build
qmake ../BCON-Game.pro
make
```

## Running the Game (Skee-Ball or any other future extensions)

### Command Line Options

| Option | Description |
| ------ | ----------- |
| `-h`, `--help` | Displays help options. |
| `-v`, `--version` | Displays version information. |
| `-s`, `--server <IP:Port>` | Address of the backend server to connect to. |
| `-n`, `--nonfc` | Do not use NFC functionality (for debugging). |

#### Examples

Run Skee-Ball against a local backend:

```
./BCON-Game --server http://localhost:3000 --g 5c98444ed5229719ab65bdaf
```
### Dynamic Library Path

When running from command line, it may be necessary to resolve the dynamic library path for locating the libBCONNetwork library. On macOS and Linux, this is accomplished by exporting the `DYLD_LIBRARY_PATH` and `LD_LIBRARY_PATH` environment variables, respectively for running the project.

macOS Example:

```sh
export DYLD_LIBRARY_PATH=path/to/BCON-Kiosk/libBCONNetwork/lib/macOS:$DYLD_LIBRARY_PATH
```

### NFC Reader

To actually use the kiosk, the NFC reader supported by libBCONNetwork must be connected before running. Otherwise, the kiosk will never proceed past the waiting screen. For more details, see the libBCONNetwork documentation.

