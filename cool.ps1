# Import .NET classes
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


Function RandomMouseMove {
    $screenWidth = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
    $screenHeight = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height
    For ($i = 0; $i -lt 10; $i++) {
        $x = Get-Random -Minimum 0 -Maximum $screenWidth
        $y = Get-Random -Minimum 0 -Maximum $screenHeight
        [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)
        Start-Sleep -Milliseconds (Get-Random -Minimum 100 -Maximum 500)
    }
}


Function OpenRandomVideos {
    $video = $videos | Get-Random
    Start-Process $video
}


Function ShowFunMessage {
    $messages = @(
        "Warning: System Overheating!",
        "Alert: Hard Disk Failure Detected!",
        "Error 404: Computer Not Found",
        "Your computer loves you ❤",
        "Please standby, we are erasing your system!!",
        "ALERT! SYSTEM COMPROMISED!"
    )
    $message = $messages | Get-Random
    [System.Windows.Forms.MessageBox]::Show($message, "Fun Alert!")
}

Function CheckForStopShortcut {
    $ctrl = [KeyListener]::GetAsyncKeyState(0x11) -ne 0 # Ctrl key
    $shift = [KeyListener]::GetAsyncKeyState(0x10) -ne 0 # Shift key
    $x = [KeyListener]::GetAsyncKeyState(0x58) -ne 0 # 'X' key
    Return ($ctrl -and $shift -and $x)
}


While ($true) {
    If (CheckForStopShortcut) {
        Break
    }
    RandomMouseMove
    ShowFunMessage
    OpenRandomVideos
    Start-Sleep -Seconds (Get-Random -Minimum 10 -Maximum 20)
}


[System.Windows.Forms.MessageBox]::Show("Location reported to CIA.", "You are done.", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
