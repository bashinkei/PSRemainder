# ���}�C���h�̒��� start~End�̒��ɂ�����̂�Ԃ�
function FilterMatchRemind {
    param (
        [Parameter(Mandatory, ValueFromPipeline)]
        [PSCustomObject] $remined,
        [Parameter(Mandatory)]
        [datetime] $checkStartMinits,
        [Parameter(Mandatory)]
        [datetime] $checkEndMinits
    )
    # �����`�F�b�N
    if ($checkStartMinits -gt $checkEndMinits) { return }

    # ���t�`�F�b�N
    $checkStartDate = $checkStartMinits.Date
    $checkEndDate = $checkEndMinits.date

    # �`�F�b�N�Ώۂ̓��t�͈̔�
    $testDate = $checkStartDate
    $rangeDateOfTarget = @()
    $rangeDateOfTarget += while ($testDate -le $checkEndDate) {
        Write-Output $testDate
        $testDate = $testDate.AddDays(1)
    }
    foreach ($checkDate in $rangeDateOfTarget ) {
        # ���t���ʒm�Ώۂ̓������`�F�b�N
        if (& $remined.everyCheckScript $checkDate) {

            # ���Ԃ��ʒm�Ώۂ̎��Ԃ����`�F�b�N
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
