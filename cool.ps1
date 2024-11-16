If (Get-Process -Name "powershell" -ErrorAction SilentlyContinue | Where-Object {$_.MainWindowTitle -like "Annoy-a-Friend*"} ) {
    Exit
}


$Host.UI.RawUI.WindowTitle = "Critical System Alert"


Function RandomBeep {
    For ($i = 0; $i -lt 10; $i++) {
        [console]::beep((Get-Random -Minimum 100 -Maximum 2000), (Get-Random -Minimum 100 -Maximum 500))
        Start-Sleep -Milliseconds (Get-Random -Minimum 300 -Maximum 1000)
    }
}


Function ToggleCapsLock {
    Add-Type @"
    using System;
    using System.Runtime.InteropServices;
    public class Keyboard {
        [DllImport("user32.dll")]
        public static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, UIntPtr dwExtraInfo);
        public const int KEYEVENTF_EXTENDEDKEY = 0x1;
        public const int KEYEVENTF_KEYUP = 0x2;
    }
"@
    [Keyboard]::keybd_event(0x14, 0, 0, [UIntPtr]::Zero) # Key down
    [Keyboard]::keybd_event(0x14, 0, 2, [UIntPtr]::Zero) # Key up
}

function Open-RandomWebsite {
    $websites = @(
        "https://www.youtube.com/watch?v=dQw4w9WgXcQ",  
        "https://www.youtube.com/watch?v=YbJOTdZBX1g",
        "https://www.youtube.com/watch?v=HzL8lh39Y2Q",
        "https://www.youtube.com/watch?v=RoKDsK8_ToQ",
        "https://www.youtube.com/watch?v=gsLvizl5j4E"
    )
    $randomWebsite = $websites | Get-Random
    Start-Process $randomWebsite
}

Function FakeAlerts {
    $messages = @(
        "Warning: System Overheating!",
        "Alert: Hard Disk Failure Detected!",
        "Error 404: Computer Not Found",
        "Your computer loves you ❤",
        "Please standby, we are erasing your system!!",
        "ALERT! SYSTEM COMPROMISED!"
    )
    $message = $messages | Get-Random
    [System.Windows.Forms.MessageBox]::Show($message, "System Alert", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
}


Function OpenRandomApps {
    $apps = @("notepad", "calc", "mspaint")
    $app = $apps | Get-Random
    Start-Process $app
}


While ($true) {
    RandomBeep
    Start-Sleep -Seconds (Get-Random -Minimum 5 -Maximum 15)
    ToggleCapsLock
    Start-Sleep -Seconds (Get-Random -Minimum 10 -Maximum 20)
    FakeAlerts
    Start-Sleep -Seconds (Get-Random -Minimum 15 -Maximum 30)
    OpenRandomApps
    Start-Sleep -Seconds (Get-Random -Minimum 20 -Maximum 40)
    Open-RandomWebsite
    Start-Sleep -Seconds (Get-Random -Minimum 15 -Maximum 30)
}
