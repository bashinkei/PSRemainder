$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot
Set-StrictMode -Version Latest

# テスト以外のサブスクリプトの読み込み
Get-ChildItem  -Path ".\subScript" -File | ? { $_.Extension -eq ".ps1" -and $_.BaseName -notlike "*Tests*" } | % { . $_.FullName }

Add-Type -AssemblyName System.Windows.Forms

# 定数定義
$MUTEX_NAME = "81C2DF76-F362-4913-B6E3-8232AAA66F62" # 多重起動チェック用


function CheckRemindFile {
    param(
        [Parameter(Mandatory)]
        [psobject] $remainds
    )
    $message = "エラーなし！"
    # エラーチェック
    if ($remainds.NG.Count -ne 0 ) {
        $message = "解釈不能なデータがありました。`r`n"
        $errs = $remainds.NG | Group-Object -Property "NGMessage"
        foreach ($err in $errs) {
            $message += $err.Name + " No. : "
            foreach ($No in $err.Group.No) {
                $message += $No + " "
            }
            $message += "`r`n"
        }
    }
    & (GetToastScript -message $message -toastType Alarm)
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

    # リマインド一覧の再読み込み
    $remainders = GetRemindList
    $dateRemainders = GetDateRemindList

    $remainders.OK += $dateRemainders.OK

    # リマインドに一致するか確認
    $checkMinutes = GetMinutes
    # PCがスリープ中、powershellが止まってしまうので、最後にチェックした分(minutes)+1から今の分までを確認する
    $checkStartMinutes = $Global:lastCheckMinutes.AddMinutes(1)
    $targetToast = @()
    $targetToast += $remainders.OK | % {
        FilterMatchRemind -remined $_ -checkStartMinits $checkStartMinutes -checkEndMinits  $checkMinutes
    }

    # 通知対象をログに出力
    if ($targetToast.count -ne 0) {
        OutHostMessage "◆◇◆通知対象がヒット！"
        $targetToast | % { OutHostMessage $_.original }
    }
    # リマインドに一致したらトースト表示
    $targetToast | % { & (GetToastScript -message $_.message -toastType Remind) }

    # 最終チェック日時を保存
    $Global:lastCheckMinutes = $checkMinutes
}

function CheckTodayRemand {

    # リマインド一覧の再読み込み
    $remainders = GetRemindList
    $dateRemainders = GetDateRemindList

    $remainders.OK += $dateRemainders.OK

    # リマインドに一致するか確認
    $todayStart = ((Get-Date).Date)
    $todayEnd = ((Get-Date).Date).AddDays(1).AddMinutes(-1)
    $targetToast = @()
    $targetToast += $remainders.OK | % {
        FilterMatchRemind -remined $_ -checkStartMinits $todayStart -checkEndMinits $todayEnd
    }

    # 通知対象をログに出力
    if ($targetToast.count -ne 0) {
        OutHostMessage "◆◇◆通知対象がヒット！"
        $targetToast | % { OutHostMessage $_.original }
    }
    # リマインドに一致したらトースト表示
    $targetToast | Sort-Object -Property "time" -Descending `
    | % { & (GetToastScript -message ("【" + $_.time + "】" + $_.message) -toastType Alarm) }
}

$mutex = New-Object System.Threading.Mutex($false, $MUTEX_NAME)
# 多重起動チェック
if ($mutex.WaitOne(0) -eq $false) {
    OutHostMessage "すでに実行中かな・・・？"
    $null = $mutex.Close()
    return
}
try {
    # タスクバー非表示
    HideWindow

    # 通知領域アイコンの取得
    $notify_icon = New-Object System.Windows.Forms.NotifyIcon
    $timer = New-Object Windows.Forms.Timer
    try {
        # 通知領域アイコンのアイコンを設定
        $notify_icon.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($Global:ICON_FILE)
        $notify_icon.Visible = $true
        $notify_icon.Text = "PSRemandTool`n実行中・・・"

        # アイコンクリック時にwindowの表示・非表示を反転
        $notify_icon.add_Click( {
                OutHostMessage "アイコンクリック！"
                if ($_.Button -ne [Windows.Forms.MouseButtons]::Left) { return }
                if ((GetWindowState) -eq [nCmdShow]::SW_HIDE) { ShowWindow } else { HideWindow }
            } )


        # アイコンにメニューを追加
        $notify_icon.ContextMenuStrip = New-Object System.Windows.Forms.ContextMenuStrip

        # メニューに今日のリマインド表示を追加
        $script = {
            OutHostMessage "Notify Today Remindクリック！"
            CheckTodayRemand
        }
        $menuItemNotifyTodayRemind = NewToolStripMenuItem -name "Notify Today Remind" -action $script
        $null = $notify_icon.ContextMenuStrip.Items.Add($menuItemNotifyTodayRemind)

        # メニューにセパレータ追加
        $ToolStripSeparator = New-Object System.Windows.Forms.ToolStripSeparator
        $null = $notify_icon.ContextMenuStrip.Items.Add($ToolStripSeparator)


        # メニューにサンプルのリマインド表示を追加
        $script = {
            OutHostMessage "sample Remind toastクリック！"
            & (GetToastScript -message "sample Message" -toastType Remind)
        }
        $menuItemSampleRemind = NewToolStripMenuItem -name "Sample Remind toast" -action $script
        $null = $notify_icon.ContextMenuStrip.Items.Add($menuItemSampleRemind)

        # メニューにセパレータ追加
        $ToolStripSeparator = New-Object System.Windows.Forms.ToolStripSeparator
        $null = $notify_icon.ContextMenuStrip.Items.Add($ToolStripSeparator)


        # メニューに日付リマインドファイルチェックを追加
        $script = {
            OutHostMessage "Check Date Remind Fileクリック！"
            CheckRemindFile (GetDateRemindList)
        }
        $menuItemCheckDateRemind = NewToolStripMenuItem -name "Check Date Remind File" -action $script
        $null = $notify_icon.ContextMenuStrip.Items.Add($menuItemCheckDateRemind)

        # メニューに日付リマインドファイルを開くを追加
        $script = {
            OutHostMessage "Open Date Remind Fileクリック！"
            # リマインドファイルを開く
            $null = Start-process $Global:DATE_REMIND_LIST_FILE
        }
        $menuItemOpenDateRemind = NewToolStripMenuItem -name "Open Date Remind File" -action $script
        $null = $notify_icon.ContextMenuStrip.Items.Add($menuItemOpenDateRemind)

        # メニューにセパレータ追加
        $ToolStripSeparator = New-Object System.Windows.Forms.ToolStripSeparator
        $null = $notify_icon.ContextMenuStrip.Items.Add($ToolStripSeparator)

        # メニューにリマインドファイルチェックを追加
        $script = {
            OutHostMessage "Check Remind Fileクリック！"
            CheckRemindFile (GetRemindList)
        }
        $menuItemCheckRemind = NewToolStripMenuItem -name "Check Remind File" -action $script
        $null = $notify_icon.ContextMenuStrip.Items.Add($menuItemCheckRemind)

        # メニューにリマインドファイルを開くを追加
        $script = {
            OutHostMessage "Open Remind Fileクリック！"
            # リマインドファイルを開く
            $null = Start-process $Global:REMIND_LIST_FILE
        }
        $menuItemOpenRemind = NewToolStripMenuItem -name "Open Remind File" -action $script
        $null = $notify_icon.ContextMenuStrip.Items.Add($menuItemOpenRemind)

        # メニューにセパレータ追加
        $ToolStripSeparator = New-Object System.Windows.Forms.ToolStripSeparator
        $null = $notify_icon.ContextMenuStrip.Items.Add($ToolStripSeparator)


        # メニューに休日データ再読み込みを追加
        $Script = {
            OutHostMessage "Reload Holidays Fileクリック！"
            $null = InitHolidays
        }
        $menuItemReloadHolidays = NewToolStripMenuItem -name "Reload Holidays File" -action $Script
        $null = $notify_icon.ContextMenuStrip.Items.Add($menuItemReloadHolidays)
        # メニューに休日データを開くを追加
        $Script = {
            OutHostMessage "Open Holidays Fileクリック！"
            $null = Start-process $Global:HOLIDAYS_FILE
        }
        $menuItemOpenHolidays = NewToolStripMenuItem -name "Open Holidays File" -action $Script
        $null = $notify_icon.ContextMenuStrip.Items.Add($menuItemOpenHolidays)

        # メニューにセパレータ追加
        $ToolStripSeparator = New-Object System.Windows.Forms.ToolStripSeparator
        $null = $notify_icon.ContextMenuStrip.Items.Add($ToolStripSeparator)

        # メニューにExitメニューを追加
        $exitScript = {
            OutHostMessage "Exitクリック！"
            [void][System.Windows.Forms.Application]::Exit()
        }
        $menuItemExit = NewToolStripMenuItem -name "Exit" -action $exitScript
        $null = $notify_icon.ContextMenuStrip.Items.Add($menuItemExit)


        # タイマーイベント.
        $timerEvent = {
            OutHostMessage  "Timer実行！"
            $timer.Stop()

            # リマインドをチェック！！
            CheckRemand

            $timer.Interval = GetNextMinutesUpToMillSeconds
            $timer.Interval += 100 # 精度の問題か分が変わらないことがあるのでもうちょっと待つ
            $timer.Start()
        }
        $timer.Enabled = $true
        $timer.Add_Tick($timerEvent)
        & $timerEvent

        # exitされるまで待機
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
