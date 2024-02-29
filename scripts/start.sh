#!/bin/bash
source /helper.sh
source /config.sh
export WINEDEBUG=-all
serverDir=/app/steamapps/common/PalServer
steamcmd_url="https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip"
steamcmd_exe="/app/steamcmd.exe"
winecmd="/usr/bin/wine"


cd /app
echo "run script"
#crontab /crontab

startServer() {
    firstInit=false


    if [ ! -d "${WINEPREFIX}" ]; then
        printf "\e[0;32m%s\e[0m\n" "Initializing Wine configuration"
        wineboot --init && wineserver -w
    fi

    # Install steamcmd executable
    if [ ! -f "${steamcmd_exe}" ]; then
        steamcmd_url="http://media.steampowered.com/installer/steamcmd.zip"
        printf "\e[0;32m%s\e[0m\n" "Downloading SteamCmd for Windows"
        curl -fs "${steamcmd_url}" -o /app/steamcmd.zip
        unzip /app/steamcmd.zip -d /app
        rm -rf /appsteamcmd.zip
        firstInit=True
    fi

    # Install Visual C++ Runtime
    if [ "${WINETRICKS_ON_BOOT,,}" = true ]; then
        printf "\e[0;32m%s\e[0m\n" "Installing Visual C++ Runtime 2022"
        trickscmd=("/usr/bin/winetricks")
        trickscmd+=("--optout" "-f" "-q" "vcrun2022")
        echo "${trickscmd[*]}"
        "${trickscmd[@]}"
    fi

    # Update Palworld Server
    if [ "${UPDATE_ON_BOOT,,}" = true ]; then
        printf "\e[0;32m%s\e[0m\n" "Updating and Validating Palworld Server"
        startsteam=("${winecmd}")
        startsteam+=("${steamcmd_exe}")
        startsteam+=("+login" "anonymous" "+app_update" "2394010" "validate" "+quit")
        echo "${startsteam[*]}"
        "${startsteam[@]}"
        wineserver -w
    fi


    if [ ! -f "$serverDir"/Pal/Binaries/Win64/UE4SS.dll ]; then
        wget -P "$serverDir"/Pal/Binaries/Win64 https://github.com/UE4SS-RE/RE-UE4SS/releases/download/v3.0.1/UE4SS_v3.0.1.zip \
            && unzip -q "$serverDir"/Pal/Binaries/Win64/UE4SS_v3.0.1.zip -d "$serverDir"/Pal/Binaries/Win64 \
            && rm "$serverDir"/Pal/Binaries/Win64/UE4SS_v3.0.0.zip \
            && rm "$serverDir"/Pal/Binaries/Win64/README.md \
            && rm "$serverDir"/Pal/Binaries/Win64/Changelog.md
    fi
    # Turn off GuiConsole
    sed -i 's/ConsoleEnabled = 0/ConsoleEnabled = 1/' "$serverDir"/Pal/Binaries/Win64/UE4SS-settings.ini
    sed -i 's/GuiConsoleEnabled = 1/GuiConsoleEnabled = 0/' "$serverDir"/Pal/Binaries/Win64/UE4SS-settings.ini
    sed -i 's/GuiConsoleVisible = 1/GuiConsoleVisible = 0/' "$serverDir"/Pal/Binaries/Win64/UE4SS-settings.ini
    sed -i 's/GraphicsAPI = opengl/GraphicsAPI = dx11/' "$serverDir"/Pal/Binaries/Win64/UE4SS-settings.ini
    sed -i 's/bUseUObjectArrayCache = true/bUseUObjectArrayCache = false/' "$serverDir"/Pal/Binaries/Win64/UE4SS-settings.ini

    engine_file="$serverDir"/Pal/Saved/Config/WindowsServer/Engine.ini
    tag=$(tail -n 1 "$engine_file" | tr -d '\n' | tr -d '\r')

    echo "Check Engine.ini is optimize. ${tag} "
    if [ -z "$tag" ]; then
cat << EOF >> "$serverDir"/Pal/Saved/Config/WindowsServer/Engine.ini
; Online Subsystem Utils Configuration
; Adjusting tick rates for LAN and Internet servers to enhance the frequency of game state updates, 
; leading to smoother gameplay and less desynchronization between server and clients.
[/script/onlinesubsystemutils.ipnetdriver]
LanServerMaxTickRate=120  ; Sets maximum ticks per second for LAN servers, higher rates result in smoother gameplay.
NetServerMaxTickRate=120  ; Sets maximum ticks per second for Internet servers, similarly ensuring smoother online gameplay.

; Player Configuration
; These settings are crucial for optimizing the network bandwidth allocation per player, 
; allowing for more data to be sent and received without bottlenecking.
[/script/engine.player]
ConfiguredInternetSpeed=104857600  ; Sets the assumed player internet speed in bytes per second. High value reduces chances of bandwidth throttling.
ConfiguredLanSpeed=104857600       ; Sets the LAN speed, ensuring LAN players can utilize maximum network capacity.

; Socket Subsystem Epic Configuration
; Tailoring the max client rate for both local and internet clients, this optimizes data transfer rates, 
; ensuring that the server can handle high volumes of data without causing lag.
[/script/socketsubsystemepic.epicnetdriver]
MaxClientRate=104857600          ; Maximum data transfer rate per client for all connections, set to a high value to prevent data capping.
MaxInternetClientRate=104857600  ; Specifically targets internet clients, allowing for high-volume data transfer without restrictions.

; Engine Configuration
; These settings manage how the game's frame rate is handled, which can impact how smoothly the game runs.
; Smoother frame rates can lead to a better synchronization between client and server.
[/script/engine.engine]
bSmoothFrameRate=true    ; Enables the game engine to smooth out frame rate fluctuations for a more consistent visual experience.
bUseFixedFrameRate=false ; Disables the use of a fixed frame rate, allowing the game to dynamically adjust frame rate for optimal performance.
SmoothedFrameRateRange=(LowerBound=(Type=Inclusive,Value=30.000000),UpperBound=(Type=Exclusive,Value=120.000000)) ; Sets a target frame rate range for smoothing.
MinDesiredFrameRate=60.000000 ; Specifies a minimum acceptable frame rate, ensuring the game runs smoothly at least at this frame rate.
FixedFrameRate=120.000000     ; (Not active due to bUseFixedFrameRate set to false) Placeholder for a fixed frame rate if needed.
NetClientTicksPerSecond=120   ; Increases the update frequency for clients, enhancing responsiveness and reducing lag.
EOF
    fi


    # Start Palworld Server settings
    printf "\e[0;32m%s\e[0m\n" "Starting Palword Server"
    startcmd=("${winecmd}")
    paldir="/app/steamapps/common/PalServer/Pal/Binaries/Win64"
    palcmd="${paldir}/PalServer-Win64-Test-Cmd.exe"
    startcmd+=("${palcmd}")

    if [ ! -f "${startcmd[0]}" ]; then
        echo "Try restarting with UPDATE_ON_BOOT=true"
        exit 1
    fi

    if [ "${COMMUNITY,,}" = true ]; then
        startcmd+=("EpicApp=PalServer")
    fi

    if [ -n "${PORT}" ]; then
        startcmd+=("-port=${PORT}")
    fi

    if [ -n "${QUERY_PORT}" ]; then
        startcmd+=("-queryport=${QUERY_PORT}")
    fi

    if [ "${MULTITHREADING,,}" = true ]; then
        startcmd+=("-useperfthreads" "-NoAsyncLoadingThread" "-UseMultithreadForDS")
    fi

    send_start_notification
    setupServerSettings

    #clearMod
    rm -rf "$serverDir"/Pal/Binaries/Win64/Mods/*
    rm -f "$serverDir"/Pal/Content/Paks/*_P.pak/*
    rm -rf "$serverDir"/Pal/Content/Paks/LogicMods/*

    #InputMod
    cp -af /mods/ue4ss/* "$serverDir"/Pal/Binaries/Win64/Mods
    cp -af /mods/paks/* "$serverDir"/Pal/Content/Paks


    echo "${startcmd[*]}"
    "${startcmd[@]}"


    send_stop_notification
}

startServer
