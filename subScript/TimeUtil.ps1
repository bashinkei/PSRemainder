<#
処理時間を計算し分が変わるまでのミリ秒を取得する
#>
function GetNextMinutesUpToMillSeconds {
    $prevDate = Get-Date
    $end = [datetime]$prevDate.AddMinutes(1).ToString("yyyy/MM/dd HH:mm:00")
    $millseconds = ($end - (Get-Date)).TotalMilliseconds

    return $millseconds
}
<#
分が変わるまでスリープする
単純に60秒sleepすると処理時間分のずれが蓄積されるので、
処理時間分を計算しsleepする時間を決める
#>
function SleepNextMinutes {
    $waitMillseconds = GetNextMinutesUpToMillSeconds
    Start-Sleep -Milliseconds ([Math]::Ceiling($waitMillseconds))
}

<#
現在時刻を分単位(秒以下切り落とし)で取得する
#>
function GetMinutes {
    [OutputType([datetime])]
    param()

    [datetime](Get-Date).ToString("yyyy/MM/dd HH:mm:00")
}
