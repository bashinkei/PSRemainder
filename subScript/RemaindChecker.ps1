# リマインドの中で start~Endの中にあるものを返す
function FilterMatchRemind {
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [PSCustomObject] $remined,
        [Parameter(Mandatory)]
        [datetime] $checkStartMinits,
        [Parameter(Mandatory)]
        [datetime] $checkEndMinits
    )
    # 引数チェック
    if ($checkStartMinits -gt $checkEndMinits) { return }

    # 日付チェック
    $checkStartDate = $checkStartMinits.Date
    $checkEndDate = $checkEndMinits.date

    # チェック対象の日付の範囲
    $testDate = $checkStartDate
    $rangeDateOfTarget = @()
    $rangeDateOfTarget += while ($testDate -le $checkEndDate) {
        Write-Output $testDate
        $testDate = $testDate.AddDays(1)
    }
    foreach ($checkDate in $rangeDateOfTarget ) {
        # 日付が通知対象の日かをチェック
        if (& $remined.everyCheckScript $checkDate) {

            # 時間が通知対象の時間かをチェック
            $reminedMinutes = [datetime] ($checkDate.ToString("yyyy/MM/dd ") + $remined.time + ":00")
            $notifycheckStartMinits = if ($checkDate.date -eq $checkStartDate) { $checkStartMinits } else { $checkDate.Date }
            $notifycheckEndMinits = if ($checkDate.date -eq $checkEndDate) { $checkEndMinits } else { $checkDate.Date.AddDays(1).AddMinutes(-1) }
            if ($notifycheckStartMinits -le $reminedMinutes -and
                $reminedMinutes -le $notifycheckEndMinits) {
                return $remined
            }
        }
    }
}
