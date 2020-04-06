# csvファイルの読み込み
function ReadDateRemindListcsv {

    $remindList = @()
    $remindList += @(Get-Content $Global:DATE_REMIND_LIST_FILE -raw | ConvertFrom-Csv)

    return [array]$remindList
}

# リマインドのバリデーション
function ValidateDateRemind {
    param (
        [Parameter(Mandatory)]
        [PSCustomObject] $remind
    )
    # dateのチェック
    $temp = [datetime]::Now
    [bool]$check = [datetime]::TryParseExact($remind.date, $Global:DATE_FORMAT, [Globalization.DateTimeFormatInfo]::CurrentInfo, [Globalization.DateTimeStyles]::AllowWhiteSpaces, [ref]$temp)
    if (-not $check) {
        return ValidateReslut $false "dateが不正です"
    }
    # timeのチェック
    $temp = [datetime]::Now
    [bool]$check = [datetime]::TryParseExact($remind.time, $Global:TIME_FORMAT, [Globalization.DateTimeFormatInfo]::CurrentInfo, [Globalization.DateTimeStyles]::AllowWhiteSpaces, [ref]$temp)
    if (-not $check) {
        return ValidateReslut $false "timeが不正です"
    }
    # ここまで来たらエラーなし
    return ValidateReslut $true ""
}
<#リマインドリストのバリデーション#>
function ValidateDateReminds {
    param (
        [Parameter(Mandatory)]
        [array] $remindList
    )

    $NG = @()
    $OK = @()

    foreach ($remind in $remindList) {
        $validateReslut = ValidateDateRemind $remind
        if ($validateReslut.reslut) {
            $OK += $remind
        }
        else {
            $pops = (Get-Member -InputObject $remind -MemberType NoteProperty).Name
            $pops += @{name = 'NGMessage'; expression = { $validateReslut.errorMessage } }
            $NG += $remind | Select-Object -Property $pops
        }
    }
    return [PSCustomObject]@{
        NG = $NG
        OK = $OK
    }
}

<#リマインドリストの取得#>
function GetDateRemindList {

    $remindList = ReadDateRemindListcsv

    $remindList = AddNumberToPsobjectArray $remindList

    # validation
    $checkedReminds = ValidateDateReminds -remindList $remindList

    $reminders = $checkedReminds.OK | ForEach-Object {
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
        OK = @($reminders)
    }
}
