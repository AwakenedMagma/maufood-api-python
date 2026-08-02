set -e

MAMP_APP="/Applications/MAMP/MAMP.app"
URL="http://localhost:8888/MauFood/"

if [ -d "$MAMP_APP" ]; then
  open -a "$MAMP_APP"
  echo "MAMP dibuka. Menunggu aplikasi untuk siap..."
  sleep 3
  
  # Auto start MAMP servers menggunakan AppleScript
  osascript <<EOF
tell application "MAMP"
    activate
    delay 2
    try
        tell application "System Events"
            tell process "MAMP"
                -- Klik tombol Start Servers
                click button "Start" of window 1
            end tell
        end tell
    end try
end tell
EOF
  
  echo "Menunggu server MAMP untuk siap..."
  sleep 5
fi

open "$URL"
echo "Membuka $URL"
