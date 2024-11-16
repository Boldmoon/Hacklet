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

Start-Process "https://www.youtube.com/watch?v=s7LS5lh0dLQ"
