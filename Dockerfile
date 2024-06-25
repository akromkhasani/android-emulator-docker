FROM azul/zulu-openjdk:21

RUN --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    DEBIAN_FRONTEND=noninteractive apt update -q && \
    DEBIAN_FRONTEND=noninteractive apt install -qy curl sudo unzip bzip2 libdrm-dev libxkbcommon-dev libgbm-dev libasound-dev libnss3 libxcursor1 libpulse-dev libxshmfence-dev xauth xvfb x11vnc fluxbox wmctrl libdbus-glib-1-2

RUN --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
    --mount=target=/var/cache/apt,type=cache,sharing=locked \
    --mount=target=/root/.npm,type=cache,sharing=locked \
    rm -f /etc/apt/apt.conf.d/docker-clean && \
    curl -sSL https://deb.nodesource.com/setup_lts.x | bash && \
    DEBIAN_FRONTEND=noninteractive apt update -q && \
    DEBIAN_FRONTEND=noninteractive apt install -qy --no-install-recommends nodejs

#==============================
# Install Appium
#==============================
RUN --mount=target=/root/.npm,type=cache,sharing=locked \
    npm i -g appium --unsafe-perm=true --allow-root && \
    appium driver install uiautomator2

#==============================
# Android SDK variables
#==============================
ARG ANDROID_API_LEVEL="android-34"
ENV EMULATOR_PACKAGE="system-images;${ANDROID_API_LEVEL};google_apis;x86_64"
ENV ANDROID_SDK_ROOT=/opt/android
ENV PATH "$ANDROID_SDK_ROOT/cmdline-tools/tools/bin:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/emulator:$PATH"

#============================================
# Install Android packages
#============================================
ARG ANDROID_CMD="commandlinetools-linux-11076708_latest.zip"
RUN curl -sSL -o /tmp/$ANDROID_CMD https://dl.google.com/android/repository/${ANDROID_CMD} && \
    unzip -d $ANDROID_SDK_ROOT /tmp/$ANDROID_CMD && rm -f /tmp/$ANDROID_CMD && \
    mkdir -p $ANDROID_SDK_ROOT/cmdline-tools/tools && cd $ANDROID_SDK_ROOT/cmdline-tools && mv bin lib tools/ && \
    yes Y | sdkmanager --licenses && \
    yes Y | sdkmanager --verbose --no_https "${EMULATOR_PACKAGE}" "platforms;${ANDROID_API_LEVEL}" platform-tools emulator

#============================================
# Create Android Virtual Device env
#============================================
ENV EMULATOR_NAME="pixel"
ENV EMULATOR_DEVICE="pixel_7"
ENV ANDROID_AVD_HOME=/avd
VOLUME /avd

#=========================
# Copying Scripts to root
#=========================
WORKDIR /
COPY ./ ./
RUN chmod a+x start_vnc.sh && \
    chmod a+x start_emu.sh && \
    chmod a+x start_emu_headless.sh && \
    chmod a+x start_appium.sh

#===================
# Ports
#===================
EXPOSE 4723 5900

CMD [ "/bin/bash" ]
