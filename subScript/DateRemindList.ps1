# csv�t�@�C���̓ǂݍ���
function ReadDateRemindListcsv {

    $remindList = @()
    $remindList += @(Get-Content $Global:DATE_REMIND_LIST_FILE -raw | ConvertFrom-Csv)

    return [array]$remindList
}

# ���}�C���h�̃o���f�[�V����
function ValidateDateRemind {
    param (
        [Parameter(Mandatory)]
        [PSCustomObject] $remaind
    )
    # date�̃`�F�b�N
    $temp = [datetime]::Now
    [bool]$check = [datetime]::TryParseExact($remaind.date, $Global:DATE_FORMAT, [Globalization.DateTimeFormatInfo]::CurrentInfo, [Globalization.DateTimeStyles]::AllowWhiteSpaces, [ref]$temp)
    if (-not $check) {
        return ValidateReslut $false "date���s���ł�"
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
function ValidateDateReminds {
    param (
        [Parameter(Mandatory)]
        [array] $remaindList
    )

    $NG = @()
    $OK = @()

    foreach ($remaind in $remaindList) {
        $validateReslut = ValidateDateRemind $remaind
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
function GetDateRemindList {

    $remindList = ReadDateRemindListcsv

    $remindList = AddNumberToPsobjectArray $remindList

    # validation
    $checkedReminds = ValidateDateReminds -remaindList $remindList

    $remainders = $checkedReminds.OK | ForEach-Object {
        $remind = $_
        $everyCheckScript = {
            param(
                [datetime] $checkDate
            )
            return $checkDate.ToString($Global:DATE_FORMAT) -eq $Script:remind.date
        }.GetNewClosure()
        return [PSCustomObject]@{
            date             = $_.date
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
