# Android emulator Image

The use of this Docker image simplifies the process of running an Android emulator within a Docker container. This can be achieved through a few basic commands or by utilizing a simple Docker compose file. The image includes the latest version of the Android SDK, as well as the Appium server, which allows for the execution of mobile automation tests.

for more info --> https://medium.com/innovies-club/running-android-emulator-in-a-docker-container-19ecb68e1909

# Feature

- Run android emulator in headless or in headed mode (through VNC)
- Support Appium driver
- Come with the latest JDK lts.

# Setup

## Manual execution

Down below is the list of the main scripts to launch the relevant service, certain environment variables should be passed during starting the container.

1.  **build the docker image :**

        docker buildx build . -t android-emulator

    OR for customized image

        docker buildx build \
        --build-arg ANDROID_API_LEVEL=android-34 \
        --build-arg ANDROID_CMD=commandlinetools-linux-11076708_latest.zip \
        . \
        -t android-emulator

2.  **Start your container:**

        docker run --privileged -it -d -p 4723:4723 --name android-container android-emulator

3.  **Start the emulator in headless mode :**

        docker exec --privileged -it android-container ./start_emu_headless.sh

4.  **Start appium session :**

        docker exec --privileged -it android-container ./start_appium.sh

## Launch emulator in headful mode


1.  **The following command must be used to initiate the Docker container:**

        docker run --privileged -it -d -p 5900:5900 -e VNC_PASSWORD=password --name android-container android-emulator

2.  **Instantiate the VNC service by running:**

        docker exec --privileged -it android-container ./start_vnc.sh

3.  **Connect to the VNC server via remmina or any VNC viewer, on:**

        localhost:5900

4.  **Open dash terminal in vnc viewer and enter the following command:**

        ./start_emu.sh

<a href="https://ibb.co/pPq0bn9"><img src="https://i.ibb.co/pPq0bn9/vnc.png" alt="vnc" border="0"></a>       <a href="https://ibb.co/cJB6qkX"><img src="https://i.ibb.co/cJB6qkX/gif.gif"       alt="gif" border="0"></a>

*Note:
  - The "start_emu.sh" script will start the emulator in a visible mode, therefore it should not be used for integration with a pipeline such as GitHub Actions or CircleCI. Instead, use the "start_emu_headless.sh" script.
  - By default, Running emulator is 'Pixel 7' (emulator name: pixel) (Android 14)
  - It is not necessary to launch all services in the docker-compose file, instead you should only enable the services you require.

## Using Docker-compose

The Docker Compose file simplifies the process of starting the service. It includes multiple services, such as launching the emulator with the Appium instance or launching the VNC server. You have the flexibility to enable or disable any service based on your needs.

    docker compose up

## Environments

**When manually starting the container, ensure to set the necessary environment variables for proper operation**

| Environments           | Description                                                                                              | Required          |  Service   |
| ---------------------- | -------------------------------------------------------------------------------------------------------- | ----------------- | ---------- |
| VNC_PASSWORD           | Password needed to connect to VNC Server                                                                 | optional          | VNC        |
| OSTYPE                 | linux or macos/darwin                                                                                    | optional          | Android    |
| EMULATOR_TIMEOUT       | emulator booting up timeoue, default 240 second                                                          | optional          | Android    |
| HW_ACCEL_OVERRIDE      | Pass aceel options e.g "-accel on" or "-aceel off"                                                       | optional          | Android    |
| APPIUM_BASIC_AUTH_USER | Appium username, default "username"                                                                      | optional          | Android    |
| APPIUM_BASIC_AUTH_PASS | Appium password, default "password"                                                                      | optional          | Android    |

## Kill the container

**Run the following command to kill and remove the container:**

        docker rm -f android-container
