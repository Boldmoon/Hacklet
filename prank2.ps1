Add-Type -AssemblyName System.Windows.Forms

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public static class KeyListener {
    [DllImport("user32.dll")]
    public static extern short GetAsyncKeyState(int vKey);
}
"@

$videos = @(
    "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
    "https://www.youtube.com/watch?v=YbJOTdZBX1g",
    "https://www.youtube.com/watch?v=HzL8lh39Y2Q",
    "https://www.youtube.com/watch?v=RoKDsK8_ToQ",
    "https://www.youtube.com/watch?v=gsLvizl5j4E"
)

Function ConstantRandomMouseMove {
    $screenWidth = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
    $screenHeight = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height

    While ($true) {
        If (CheckForStopShortcut) { Break }

        $x = Get-Random -Minimum 0 -Maximum $screenWidth
        $y = Get-Random -Minimum 0 -Maximum $screenHeight
        [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)

        Start-Sleep -Milliseconds (Get-Random -Minimum 50 -Maximum 150)
    }
}

Function PlayRandomVideos {
    While ($true) {
        If (CheckForStopShortcut) { Break }

        $video = $videos | Get-Random
        Start-Process "chrome.exe" $video  # Specify the browser to open the video
        Start-Sleep -Seconds (Get-Random -Minimum 30 -Maximum 60)
    }
}

Function ShowScaryAlerts {
    $messages = @(
        "SYSTEM BREACH DETECTED!",
        "ERROR: DATA WIPE INITIATED!",
        "UNAUTHORIZED ACCESS DETECTED.",
        "MALWARE ACTIVATED. PLEASE RESTART.",
        "CPU TEMPERATURE CRITICAL! 🔥",
        "FATAL ERROR: DEVICE SHUTDOWN IN PROGRESS."
    )

    While ($true) {
        If (CheckForStopShortcut) { Break }

        $message = $messages | Get-Random
        [System.Windows.Forms.MessageBox]::Show(
            $message, 
            "⚠️ CRITICAL SYSTEM ALERT ⚠️", 
            [System.Windows.Forms.MessageBoxButtons]::OK, 
            [System.Windows.Forms.MessageBoxIcon]::Error
        )

        Start-Sleep -Seconds (Get-Random -Minimum 15 -Maximum 30)
    }
}

Function CheckForStopShortcut {
    $ctrl = [KeyListener]::GetAsyncKeyState(0x11) -ne 0
    $shift = [KeyListener]::GetAsyncKeyState(0x10) -ne 0
    $x = [KeyListener]::GetAsyncKeyState(0x58) -ne 0
    Return ($ctrl -and $shift -and $x)
}

$mouseJob = Start-Job -ScriptBlock { ConstantRandomMouseMove }
$videoJob = Start-Job -ScriptBlock { PlayRandomVideos }
$alertJob = Start-Job -ScriptBlock { ShowScaryAlerts }

While (-not (CheckForStopShortcut)) {
    Start-Sleep -Seconds 1
}

Stop-Job $mouseJob -Force
Stop-Job $videoJob -Force
Stop-Job $alertJob -Force

[System.Windows.Forms.MessageBox]::Show(
    "Prank terminated. System restored to normal.", 
    "Prank Ended", 
    [System.Windows.Forms.MessageBoxButtons]::OK, 
    [System.Windows.Forms.MessageBoxIcon]::Information
)
