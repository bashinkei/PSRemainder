<#
ˆ—ŽžŠÔ‚ðŒvŽZ‚µ•ª‚ª•Ï‚í‚é‚Ü‚Å‚Ìƒ~ƒŠ•b‚ðŽæ“¾‚·‚é
#>
function GetNextMinutesUpToMillSeconds {
    $prevDate = Get-Date
    $end = [datetime]$prevDate.AddMinutes(1).ToString("yyyy/MM/dd HH:mm:00")
    $millseconds = ($end - (Get-Date)).TotalMilliseconds

    return $millseconds
}
<#
•ª‚ª•Ï‚í‚é‚Ü‚ÅƒXƒŠ[ƒv‚·‚é
’Pƒ‚É60•bsleep‚·‚é‚Æˆ—ŽžŠÔ•ª‚Ì‚¸‚ê‚ª’~Ï‚³‚ê‚é‚Ì‚ÅA
ˆ—ŽžŠÔ•ª‚ðŒvŽZ‚µsleep‚·‚éŽžŠÔ‚ðŒˆ‚ß‚é
#>
function SleepNextMinutes {
    $waitMillseconds = GetNextMinutesUpToMillSeconds
    Start-Sleep -Milliseconds ([Math]::Ceiling($waitMillseconds))
}

<#
Œ»ÝŽž‚ð•ª’PˆÊ(•bˆÈ‰ºØ‚è—Ž‚Æ‚µ)‚ÅŽæ“¾‚·‚é
#>
function GetMinutes {
    [OutputType([datetime])]
    param()

    [datetime](Get-Date).ToString("yyyy/MM/dd HH:mm:00")
}
