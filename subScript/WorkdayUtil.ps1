$Global:Holidays = @()
$Global:WorkdayListOfMounth = @{}

function InitHolidays {

    # 初期化
    $Global:Holidays = @()
    $Global:WorkdayListOfMounth = @{}

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
    return $Global:Holidays
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

# 指定した日の営業日リストを返す
function Global:GetWorkDayList {
    param (
        [Parameter(Mandatory)]
        [datetime] $datetime
    )

    # 対象月のキー
    $monthKey = "$($datetime.Year)$($datetime.Month.ToString("00"))"

    # キーを計算済みならをれを返す
    if($Global:WorkdayListOfMounth.ContainsKey($monthKey)){
        return $Global:WorkdayListOfMounth.Item($monthKey)
    }

    # 対象日の末日
    $lastOfmonth =　[datetime]::DaysInMonth($datetime.Year, $datetime.Month)

    # 稼働日一覧の作成
    $workdays = @()
    1..$lastOfmonth | % {
        $checkdate = [datetime]::new($datetime.Year, $datetime.Month, $_)
        if (TestWorkDay -datetime $checkdate) {
            $workdays += $checkdate
        }
    }

    # 稼働日一覧の保存
    $Global:WorkdayListOfMounth.Add( $monthKey, $workdays)

    return $workdays

}
