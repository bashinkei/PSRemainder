$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot
Set-StrictMode -Version Latest

# �e�X�g�ȊO�̃T�u�X�N���v�g�̓ǂݍ���
Get-ChildItem  -Path ".\subScript" -File | ? { $_.Extension -eq ".ps1" -and $_.BaseName -notlike "*Tests*" } | % { . $_.FullName }

Add-Type -AssemblyName System.Windows.Forms

# �萔��`
$MUTEX_NAME = "81C2DF76-F362-4913-B6E3-8232AAA66F62" # ���d�N���`�F�b�N�p


function CheckRemindFile {
    param(
        [Parameter(Mandatory)]
        [psobject] $remainds
    )
    $message = "�G���[�Ȃ��I"
    # �G���[�`�F�b�N
    if ($remainds.NG.Count -ne 0 ) {
        $message = "���ߕs�\�ȃf�[�^������܂����B`r`n"
        $errs = $remainds.NG | Group-Object -Property "NGMessage"
        foreach ($err in $errs) {
            $message += $err.Name + " No. : "
            foreach ($No in $err.Group.No) {
                $message += $No + " "
            }
            $message += "`r`n"
        }
    }
    & (GetToastScript -message $message )
}

function OutHostMessage {
    param (
        [Parameter(Mandatory)]
        [string] $message
    )
    Write-Host (Get-date).ToString("yyyy/MM/dd HH:mm:ss.fff") $message
}

$Global:lastCheckMinutes = (GetMinutes).AddMinutes(-1)
function CheckRemand {

    # ���}�C���h�ꗗ�̍ēǂݍ���
    $remainders = GetRemindList
    $dateRemainders = GetDateRemindList

    $remainders.OK += $dateRemainders.OK

    # ���}�C���h�Ɉ�v���邩�m�F
    $checkMinutes = GetMinutes
    # PC���X���[�v���Apowershell���~�܂��Ă��܂��̂ŁA�Ō�Ƀ`�F�b�N������(minutes)+1���獡�̕��܂ł��m�F����
    $checkStartMinutes = $Global:lastCheckMinutes.AddMinutes(1)
    $targetToast = @()
    $targetToast += $remainders.OK | % {
        FilterMatchRemind -remined $_ -checkStartMinits $checkStartMinutes -checkEndMinits  $checkMinutes
    }

    # ���}�C���h�Ɉ�v������g�[�X�g�\��
    $targetToast | % { & (GetToastScript $_.message) }

    # �ŏI�`�F�b�N������ۑ�
    $Global:lastCheckMinutes = $checkMinutes
}


$mutex = New-Object System.Threading.Mutex($false, $MUTEX_NAME)
# ���d�N���`�F�b�N
if ($mutex.WaitOne(0) -eq $false) {
    OutHostMessage "���łɎ��s�����ȁE�E�E�H"
    $null = $mutex.Close()
    return
}
try {
    # �^�X�N�o�[��\��
    HideWindow

    # �ʒm�̈�A�C�R���̎擾
    $notify_icon = New-Object System.Windows.Forms.NotifyIcon
    $timer = New-Object Windows.Forms.Timer
    try {
        # �ʒm�̈�A�C�R���̃A�C�R����ݒ�
        $notify_icon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($Global:ICON_FILE)
        $notify_icon.Visible = $true
        $notify_icon.Text = "PSRemandTool`n���s���E�E�E"

        # �A�C�R���N���b�N����window�̕\���E��\���𔽓]
        $notify_icon.add_Click( {
                OutHostMessage "�A�C�R���N���b�N�I"
                if ($_.Button -ne [Windows.Forms.MouseButtons]::Left) { return }
                if ((GetWindowState) -eq [nCmdShow]::SW_HIDE) { ShowWindow } else { HideWindow }
            } )


        # �A�C�R���Ƀ��j���[��ǉ�
        $notify_icon.ContextMenuStrip = New-Object System.Windows.Forms.ContextMenuStrip

        # ���j���[�ɓ��t���}�C���h�t�@�C���`�F�b�N��ǉ�
        $script = {
            OutHostMessage "Check Date Remind File�N���b�N�I"
            CheckRemindFile (GetDateRemindList)
        }
        $menuItemCheckDateRemind = NewToolStripMenuItem -name "Check Date Remind File" -action $script
        $null = $notify_icon.ContextMenuStrip.Items.Add($menuItemCheckDateRemind)

        # ���j���[�ɓ��t���}�C���h�t�@�C�����J����ǉ�
        $script = {
            OutHostMessage "Open Date Remind File�N���b�N�I"
            # ���}�C���h�t�@�C�����J��
            $null = Start-process $Global:DATE_REMIND_LIST_FILE
        }
        $menuItemOpenDateRemind = NewToolStripMenuItem -name "Open Date Remind File" -action $script
        $null = $notify_icon.ContextMenuStrip.Items.Add($menuItemOpenDateRemind)

        # ���j���[�ɃZ�p���[�^�ǉ�
        $ToolStripSeparator = New-Object System.Windows.Forms.ToolStripSeparator
        $null = $notify_icon.ContextMenuStrip.Items.Add($ToolStripSeparator)

        # ���j���[�Ƀ��}�C���h�t�@�C���`�F�b�N��ǉ�
        $script = {
            OutHostMessage "Check Remind File�N���b�N�I"
            CheckRemindFile (GetRemindList)
        }
        $menuItemCheckRemind = NewToolStripMenuItem -name "Check Remind File" -action $script
        $null = $notify_icon.ContextMenuStrip.Items.Add($menuItemCheckRemind)

        # ���j���[�Ƀ��}�C���h�t�@�C�����J����ǉ�
        $script = {
            OutHostMessage "Open Remind File�N���b�N�I"
            # ���}�C���h�t�@�C�����J��
            $null = Start-process $Global:REMIND_LIST_FILE
        }
        $menuItemOpenRemind = NewToolStripMenuItem -name "Open Remind File" -action $script
        $null = $notify_icon.ContextMenuStrip.Items.Add($menuItemOpenRemind)

        # ���j���[�ɃZ�p���[�^�ǉ�
        $ToolStripSeparator = New-Object System.Windows.Forms.ToolStripSeparator
        $null = $notify_icon.ContextMenuStrip.Items.Add($ToolStripSeparator)


        # ���j���[�ɋx���f�[�^�ēǂݍ��݂�ǉ�
        $Script = {
            OutHostMessage "Reload Holidays File�N���b�N�I"
            $null = InitHolidays
        }
        $menuItemReloadHolidays = NewToolStripMenuItem -name "Reload Holidays File" -action $Script
        $null = $notify_icon.ContextMenuStrip.Items.Add($menuItemReloadHolidays)
        # ���j���[�ɋx���f�[�^���J����ǉ�
        $Script = {
            OutHostMessage "Open Holidays File�N���b�N�I"
            $null = Start-process $Global:HOLIDAYS_FILE
        }
        $menuItemOpenHolidays = NewToolStripMenuItem -name "Open Holidays File" -action $Script
        $null = $notify_icon.ContextMenuStrip.Items.Add($menuItemOpenHolidays)

        # ���j���[�ɃZ�p���[�^�ǉ�
        $ToolStripSeparator = New-Object System.Windows.Forms.ToolStripSeparator
        $null = $notify_icon.ContextMenuStrip.Items.Add($ToolStripSeparator)

        # ���j���[��Exit���j���[��ǉ�
        $exitScript = {
            OutHostMessage "Exit�N���b�N�I"
            [void][System.Windows.Forms.Application]::Exit()
        }
        $menuItemExit = NewToolStripMenuItem -name "Exit" -action $exitScript
        $null = $notify_icon.ContextMenuStrip.Items.Add($menuItemExit)


        # �^�C�}�[�C�x���g.
        $timerEvent = {
            OutHostMessage  "Timer���s�I"
            $timer.Stop()

            # ���}�C���h���`�F�b�N�I�I
            CheckRemand

            $timer.Interval = GetNextMinutesUpToMillSeconds
            $timer.Interval += 100 # ���x�̖�肩�����ς��Ȃ����Ƃ�����̂ł���������Ƒ҂�
            $timer.Start()
        }
        $timer.Enabled = $true
        $timer.Add_Tick($timerEvent)
        & $timerEvent

        # exit�����܂őҋ@
        [void][System.Windows.Forms.Application]::Run()

    }
    finally {
        $null = $notify_icon.Dispose()
        $null = $timer.Dispose()
    }
}
finally {
    $null = $mutex.ReleaseMutex()
    $null = $mutex.Close()
}