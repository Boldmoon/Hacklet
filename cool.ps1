Add-Type -AssemblyName "System.Windows.Forms"
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class HiddenWindow {
    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    [DllImport("kernel32.dll")]
    public static extern IntPtr GetConsoleWindow();
    public static void Hide() {
        IntPtr hWnd = GetConsoleWindow();
        ShowWindow(hWnd, 0); // 0 = SW_HIDE
    }
}
"@
[HiddenWindow]::Hide()

function Show-ScaryMessage {
    $messages = @(
        "ALERT! SYSTEM COMPROMISED!",
        "Your files are now under our control.",
        "SELF-DESTRUCT INITIATED! Get out now.",
        "Warning! Your system is about to crash!",
        "Please standby, we are erasing your system!!",
        "You are being monitored. No escape.",
        "Emergency! This message will self-destruct.",
        "We are in your network. Prepare for consequences."
    )
    $randomMessage = $messages | Get-Random
    [System.Windows.Forms.MessageBox]::Show($randomMessage, "Critical System Alert", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Stop)
}

function Open-RandomWebsite {
    $websites = @(
        "https://www.youtube.com/watch?v=dQw4w9WgXcQ",  
        "https://tenor.com/view/monkey-news-stare-gif-26455378",
        "https://www.youtube.com/watch?v=YbJOTdZBX1g",
        "https://www.youtube.com/watch?v=HzL8lh39Y2Q",
        "https://www.youtube.com/watch?v=RoKDsK8_ToQ",
        "https://www.youtube.com/watch?v=gsLvizl5j4E"
    )
    $randomWebsite = $websites | Get-Random
    Start-Process $randomWebsite
}

function Play-Sound {
    $sounds = @(
        { [console]::beep(1000, 500) },  
        { [console]::beep(2000, 800) },  
        { [console]::beep(500, 300) },   
        { [console]::beep(1000, 1500) }  
    )
    $randomSound = $sounds | Get-Random
    $randomSound.Invoke()
}

for ($i = 0; $i -lt 10; $i++) {
    $randomInterval = Get-Random -Minimum 2 -Maximum 3
    Start-Sleep -Minutes $randomInterval

    Show-ScaryMessage
    Start-Sleep -Seconds 3

    $randomInterval = Get-Random -Minimum 2 -Maximum 3
    Start-Sleep -Minutes $randomInterval

    Open-RandomWebsite
    Start-Sleep -Seconds 3

    $randomInterval = Get-Random -Minimum 2 -Maximum 3
    Start-Sleep -Minutes $randomInterval

    Play-Sound
    Start-Sleep -Seconds 3
}

[System.Windows.Forms.MessageBox]::Show("Location reported to CIA.", "FINAL WARNING", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
