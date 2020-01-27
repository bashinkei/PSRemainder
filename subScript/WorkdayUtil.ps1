
$Global:Holidays = @()

function InitHolidays {

    # ������
    $Global:Holidays = @()

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
    return�@$Global:Holidays
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
