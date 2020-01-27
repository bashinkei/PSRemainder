
<# リマインドに日付が一致するかテスト #>
function TestRemind {
    [OutputType([bool])]
    param (
        [Parameter(Mandatory)]
        [PSCustomObject] $remindOK,
        [Parameter(Mandatory)]
        [datetime] $checkMinutes
    )
    $hhmm = $checkMinutes.ToString($Global:TIME_FORMAT)
    $ret = ($remindOK.time -eq $hhmm) -and (& $remindOK.everyCheckScript $checkMinutes)
    return $ret
}

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

    $checkingMinutes = $checkStartMinits
    while ($checkingMinutes -le $checkEndMinits) {
        if (TestRemind -remindOK $remined -checkMinutes $checkingMinutes ) { return  $remined }
        $checkingMinutes = $checkingMinutes.AddMinutes(1)
    }
}
