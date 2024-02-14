#!/bin/bash
export WINEDEBUG=-all
cd /app

steamcmd_url="https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip"

if [ ! -d "$WINEPREFIX" ]; then
  echo ""
  echo "Initializing Wine configuration"
  echo ""
  #/fix-xvfb.sh && xvfb-run -a \
  wineboot --init && wineserver -w
fi

if [ ! -f /app/steamcmd.exe ]; then
  echo ""
  echo "Downloading SteamCmd for Windows"
  echo ""
  wget -O /app/steamcmd.zip ${steamcmd_url}
  unzip /app/steamcmd.zip*
  rm -rf /app/steamcmd.zip*
  echo ""
  echo "Installing Palworld Server..."
  echo "Container might need to be restarted when done"
  echo ""
fi

#Xvfb :99 -screen 0 1000x1000x16 &

# Install Visual C++ Runtime
#/fix-xvfb.sh && xvfb-run -a \
/usr/bin/winetricks \
--optout -f -q vcrun2022 && \
wineserver -w

# Install/Update Palworld Server
echo ""
echo "Updating and Validating Palworld Server"
echo ""
#/fix-xvfb.sh && xvfb-run -a \
/usr/bin/wine \
/app/steamcmd.exe \
+login anonymous +app_update 2394010 validate +quit && \
wineserver -w

# Start Palworld Server
echo ""
echo "Starting Palword Server"
echo ""
#/fix-xvfb.sh && xvfb-run -a \
/usr/bin/wine \
/app/steamapps/common/PalServer/Pal/Binaries/Win64/PalServer-Win64-Test-Cmd.exe \
-useperfthreads -NoAsyncLoadingThread -UseMultithreadForDS
