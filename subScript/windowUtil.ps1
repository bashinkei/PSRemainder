$Global:windowHandle = 0
$Global:windowState = [nCmdShow]::SW_SHOW

enum nCmdShow {
    SW_HIDE = 0
    SW_SHOW = 5
}

# ShowWindowAsync���\�b�h�̎擾
function ShowWindowAsync {
    $windowcode = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'
    $asyncwindow = Add-Type -MemberDefinition $windowcode -name Win32ShowWindowAsync -namespace Win32Functions -PassThru
    return $asyncwindow
}

# �E�B���h�E�n���h���̎擾
# ����Ăяo�����ɂ̓E�B���h�E���\������Ă���z��
function GetWindowHandle {
    if ($Global:windowHandle -eq 0) {
        $Global:windowHandle = (Get-Process -PID $pid).MainWindowHandle
    }
    return $Global:windowHandle
}

# �E�B���h�E�̏�Ԏ擾
function GetWindowState {
    return $Global:windowState
}

# �E�B���h�E�̏�Ԃ̃Z�b�g
function SetWindowState {
    param(
        [Parameter(Mandatory)]
        [nCmdShow] $stateNo
    )
    $Global:windowState = $stateNo

    $ShowWindowAsync = ShowWindowAsync
    $WindowHandle = GetWindowHandle

    $null = $ShowWindowAsync::ShowWindowAsync($WindowHandle, $stateNo)
}

# �E�B���h�E���B��
function HideWindow {
    SetWindowState -stateNo "SW_HIDE"
}

# �B�ꂽ�E�B���h�E��\��������
function ShowWindow {
    SetWindowState -stateNo "SW_SHOW"
}

