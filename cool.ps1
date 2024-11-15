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

function Show-RandomMessage {
    $messages = @(
        "kys",
        "You have been hacked.",
        "Cry about it.",
        "You are cooked.",
        "Performing self destruction",
        "Please stanby, we are erasing your system.",
        "What ra?"
    )
    $randomMessage = $messages | Get-Random
    [System.Windows.Forms.MessageBox]::Show($randomMessage, "International Threat", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
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
    [console]::beep(500, 300)  
    Start-Sleep -Milliseconds 300
}

for ($i = 0; $i -lt 10; $i++) {
    $randomInterval = Get-Random -Minimum 2 -Maximum 3
    Start-Sleep -Minutes $randomInterval

    Show-RandomMessage
    Start-Sleep -Seconds 3

    Open-RandomWebsite
    Start-Sleep -Seconds 3

    Play-Sound
    Start-Sleep -Seconds 3
}

[System.Windows.Forms.MessageBox]::Show("Location reported to CIA.", "You are done.", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
