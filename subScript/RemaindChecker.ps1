
<# ���}�C���h�ɓ��t����v���邩�e�X�g #>
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

    $checkingMinutes = $checkStartMinits
    while ($checkingMinutes -le $checkEndMinits) {
        if (TestRemind -remindOK $remined -checkMinutes $checkingMinutes ) { return  $remined }
        $checkingMinutes = $checkingMinutes.AddMinutes(1)
    }
}
