# csv�t�@�C���̓ǂݍ���
function ReadRemindListcsv {

    $remindList = @()
    $remindList += @(Get-Content $Global:REMIND_LIST_FILE -raw | ConvertFrom-Csv)

    return [array]$remindList
}

# ���}�C���h�̃o���f�[�V����
function ValidateRemind {
    param (
        [Parameter(Mandatory)]
        [PSCustomObject] $remaind
    )
    # every�̃`�F�b�N
    if ($remaind.every -notin (DefinedEvery).every) {
        return ValidateReslut $false "every���s���ł�"
    }
    # whenNonWorkDay�̃`�F�b�N
    if ($remaind.whenNonWorkDay -notin ([whenNonWorkDay].GetEnumNames())) {
        return ValidateReslut $false "whenNonWorkDay���s���ł�"
    }
    # time�̃`�F�b�N
    $temp = [datetime]::Now
    [bool]$check = [datetime]::TryParseExact($remaind.time, $Global:TIME_FORMAT, [Globalization.DateTimeFormatInfo]::CurrentInfo, [Globalization.DateTimeStyles]::AllowWhiteSpaces, [ref]$temp)
    if (-not $check) {
        return ValidateReslut $false "time���s���ł�"
    }
    # �����܂ŗ�����G���[�Ȃ�
    return ValidateReslut $true ""
}
<#���}�C���h���X�g�̃o���f�[�V����#>
function ValidateReminds {
    param (
        [Parameter(Mandatory)]
        [array] $remaindList
    )

    $NG = @()
    $OK = @()

    foreach ($remaind in $remaindList) {
        $validateReslut = ValidateRemind $remaind
        if ($validateReslut.reslut) {
            $OK += $remaind
        }
        else {
            $pops = (Get-Member -InputObject $remaind -MemberType NoteProperty).Name
            $pops += @{name = 'NGMessage'; expression = { $validateReslut.errorMessage } }
            $NG += $remaind | Select-Object -Property $pops
        }
    }
    return [PSCustomObject]@{
        NG = $NG
        OK = $OK
    }
}

<#���}�C���h���X�g�̎擾#>
function GetRemindList {

    $remindList = ReadRemindListcsv

    $remindList = AddNumberToPsobjectArray $remindList

    # validation
    $checkedReminds = ValidateReminds -remaindList $remindList

    $remainders = $checkedReminds.OK | ForEach-Object {
        # toast���s�p�X�N���v�g�t���ɂ���
        $everyCheckScript = GetEveryCheckScript -every $_.every -whenNonWorkDay $_.whenNonWorkDay
        return [PSCustomObject]@{
            every            = $_.every
            whenNonWorkDay   = $_.whenNonWorkDay
            time             = $_.time
            message          = $_.message
            everyCheckScript = $everyCheckScript
            original         = $_
        }
    }
    return [PSCustomObject]@{
        NG = @($checkedReminds.NG)
        OK = @($remainders)
    }
}
