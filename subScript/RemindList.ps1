# csvファイルの読み込み
function ReadRemindListcsv {

    $remindList = @()
    $remindList += @(Get-Content $Global:REMIND_LIST_FILE -raw | ConvertFrom-Csv)

    return [array]$remindList
}

# リマインドのバリデーション
function ValidateRemind {
    param (
        [Parameter(Mandatory)]
        [PSCustomObject] $remind
    )
    # everyのチェック
    if ($remind.every -notin (DefinedEvery).every) {
        return ValidateReslut $false "everyが不正です"
    }
    # whenNonWorkDayのチェック
    if ($remind.whenNonWorkDay -notin ([whenNonWorkDay].GetEnumNames())) {
        return ValidateReslut $false "whenNonWorkDayが不正です"
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
function ValidateReminds {
    param (
        [Parameter(Mandatory)]
        [array] $remindList
    )

    $NG = @()
    $OK = @()

    foreach ($remind in $remindList) {
        $validateReslut = ValidateRemind $remind
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
function GetRemindList {

    $remindList = ReadRemindListcsv

    $remindList = AddNumberToPsobjectArray $remindList

    # validation
    $checkedReminds = ValidateReminds -remindList $remindList

    $reminders = $checkedReminds.OK | ForEach-Object {
        # toast実行用スクリプト付きにする
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
        OK = @($reminders)
    }
}
