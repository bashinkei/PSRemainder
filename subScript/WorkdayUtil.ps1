$Global:Holidays = @()
$Global:WorkdayListOfMounth = @{}

function InitHolidays {

    # ������
    $Global:Holidays = @()
    $Global:WorkdayListOfMounth = @{}

    # �t�@�C���ǂݍ���
    $Holidays = Get-Content $Global:HOLIDAYS_FILE -Raw | ConvertFrom-Csv -Header "dateOfHoliday", "name"

    $Holidays | ForEach-Object {
        # �P�J�����ڂ�����̌`���Ȃ�x���Ƃ��Ēǉ�
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
�X�N���v�g�u���b�N�̒�����Ăяo������Global�Œ�`
(�X�N���v�g�u���b�N���ƃX�R�[�v������Č����Ȃ����ۂ�)
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

# �w�肵�����̉c�Ɠ����X�g��Ԃ�
function Global:GetWorkDayList {
    param (
        [Parameter(Mandatory)]
        [datetime] $datetime
    )

    # �Ώی��̃L�[
    $monthKey = "$($datetime.Year)$($datetime.Month.ToString("00"))"

    # �L�[���v�Z�ς݂Ȃ�����Ԃ�
    if($Global:WorkdayListOfMounth.ContainsKey($monthKey)){
        return $Global:WorkdayListOfMounth.Item($monthKey)
    }

    # �Ώۓ��̖���
    $lastOfmonth =�@[datetime]::DaysInMonth($datetime.Year, $datetime.Month)

    # �ғ����ꗗ�̍쐬
    $workdays = @()
    1..$lastOfmonth | % {
        $checkdate = [datetime]::new($datetime.Year, $datetime.Month, $_)
        if (TestWorkDay -datetime $checkdate) {
            $workdays += $checkdate
        }
    }

    # �ғ����ꗗ�̕ۑ�
    $Global:WorkdayListOfMounth.Add( $monthKey, $workdays)

    return $workdays

}
