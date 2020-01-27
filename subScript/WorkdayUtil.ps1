
$Global:Holidays = @()

function InitHolidays {

    # 初期化
    $Global:Holidays = @()

    # ファイル読み込み
    $Holidays = Get-Content $Global:HOLIDAYS_FILE -Raw | ConvertFrom-Csv -Header "dateOfHoliday", "name"

    $Holidays | ForEach-Object {
        # １カラム目が既定の形式なら休日として追加
        $temp = [datetime]::MaxValue
        [bool]$check = [datetime]::TryParseExact(
            $_.dateOfHoliday
            , "yyyy-MM-dd"
            , [Globalization.DateTimeFormatInfo]::CurrentInfo
            , [Globalization.DateTimeStyles]::AllowWhiteSpaces
            , [ref]$temp)
        if ($check) {
            $holiday = [PSCustomObject]@{
                dateOfHoliday = $temp
                name          = $_.name
            }
            $Global:Holidays += $holiday
        }
    }

}
function GetHolidays {
    if ($Global:Holidays.count -eq 0) {
        InitHolidays
    }
    return　$Global:Holidays
}
<#
スクリプトブロックの中から呼び出すためGlobalで定義
(スクリプトブロックだとスコープが違って見えないっぽい)
#>
function Global:TestWorkDay {
    param (
        [Parameter(Mandatory)]
        [datetime] $datetime
    )

    if ($datetime.DayOfWeek -in $Global:NON_WORKDAY_OF_DAY_OF_WEEKS) { return $false }
    $Holidays = GetHolidays
    if ($datetime.Date -in $Holidays.dateOfHoliday.Date) { return $false }

    return $true

}
