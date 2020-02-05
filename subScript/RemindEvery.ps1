
<#�Z�Z���̔��菈��#>
function GetEveryCheckScript {
    [OutputType([scriptblock])]
    param (
        [Parameter(Mandatory)]
        [string] $every,
        [Parameter(Mandatory)]
        [string] $whenNonWorkDay
    )
    $definedEvry = DefinedEvery | Where-Object { $_.every -eq $every }

    [scriptblock]$everyCheckSCript =
    if ($definedEvry.type -eq [EveryType]::daily) {
        GetDailyCheckScript
    }
    elseif ($definedEvry.type -eq [EveryType]::weekly) {
        GetWeeklyCheckScript
    }
    elseif ($definedEvry.type -eq [EveryType]::Monthly) {
        GetMonthlyCheckScript
    }
    elseif ($definedEvry.type -eq [EveryType]::MonthlyInverse) {
        GetMonthlyInverseCheckScript
    }
    elseif ($definedEvry.type -eq [EveryType]::MonthlyOfWorkDay) {
        GetMonthlyOfWorkDayCheckScript
    }

    # �x���ł��ʒm����̏ꍇ
    if ($whenNonWorkDay -eq [whenNonWorkDay]::Notify) {
        return {
            param(
                [datetime]$checkdate
            )
            & $everyCheckScript $checkdate $definedEvry.every
        }.GetNewClosure()
    }
    # �x���͒ʒm���Ȃ��̏ꍇ
    if ($whenNonWorkDay -eq [whenNonWorkDay]::NotNotify) {
        return {
            param(
                [datetime]$checkdate
            )
            if (-not (TestWorkDay $checkdate)) { return $false }
            & $everyCheckScript $checkdate $definedEvry.every
        }.GetNewClosure()
    }
    # �x���̒��O���㔻��p�X�N���v�g
    $notifyToWorkdaycheck = {
        param(
            [datetime]$checkdate
        )
        # �x���̏ꍇ�͘_�O
        if (-not (TestWorkDay $checkdate)) { return $false }

        $testDate = $checkDate
        # �Ώۂ̓��܂łɏA�Ɠ������邩�m�F����B
        # �A�Ɠ�������ꍇ�͋x���̒��O����ł͂Ȃ��B
        while (-not (&$everyCheckSCript $testDate $definedEvry.every)) {
            $testDate = $testDate.AddDays($addDays)
            if (TestWorkDay $testDate) { return $false }
        }
        return $true
    }

    # �x���̂Ƃ��O�̏A�Ɠ��ɒʒm����̏ꍇ
    if ($whenNonWorkDay -eq [whenNonWorkDay]::PrevWorkDay) {
        $addDays = 1
        return $notifyToWorkdaycheck.GetNewClosure()
    }

    # �x���̂Ƃ���̏A�Ɠ��ɒʒm����̏ꍇ
    if ($whenNonWorkDay -eq [whenNonWorkDay]::NextWorkDay) {
        $addDays = -1
        return $notifyToWorkdaycheck.GetNewClosure()
    }

}

function GetDailyCheckScript {
    [OutputType([scriptblock])]
    param()

    return {
        param (
            [Parameter(Mandatory)]
            [datetime] $checkDate,
            [Parameter(Mandatory)]
            [string]$checkEvery
        )
        $true
    }
}
function GetWeeklyCheckScript {
    [OutputType([scriptblock])]
    param()

    return {
        param (
            [Parameter(Mandatory)]
            [datetime] $checkDate,
            [Parameter(Mandatory)]
            [string]$checkEvery
        )
        $checkEvery -eq $checkDate.DayOfWeek
    }
}
function GetMonthlyCheckScript {
    [OutputType([scriptblock])]
    param()

    return {
        param (
            [Parameter(Mandatory)]
            [datetime] $checkDate,
            [Parameter(Mandatory)]
            [string]$checkEvery
        )
        $checkEvery.TrimEnd('st nd rd th') -eq $checkDate.Day
    }
}
function GetMonthlyInverseCheckScript {
    [OutputType([scriptblock])]
    param()

    return {
        param (
            [Parameter(Mandatory)]
            [datetime] $checkDate,
            [Parameter(Mandatory)]
            [string]$checkEvery
        )
        # ���̓�����31���̏ꍇ�@-> -1st = 31��; -2nd = 30�� �E�E�E�@-31st = 1��
        $checkEvery.TrimEnd('st nd rd th') -eq $checkDate.Day - [datetime]::DaysInMonth($checkDate.Year, $checkDate.Month) - 1
    }
}
function GetMonthlyOfWorkDayCheckScript {
    [OutputType([scriptblock])]
    param()

    return {
        param (
            [Parameter(Mandatory)]
            [datetime] $checkDate,
            [Parameter(Mandatory)]
            [string]$checkEvery
        )

        $workdays = GetWorkDayList -datetime $checkDate
        [int]$nth = $checkEvery.TrimEnd('st nd rd th WorkDay')

        # �ғ������𒴂��Ă�����NG
        if ($workdays.count -lt [System.Math]::Abs($nth)) { $false }

        $arrayIndex = if ($nth -gt 0) { $nth - 1 } else {$workdays.count + $nth}
        $nthDay = ($workdays | Sort-Object)[$arrayIndex]

        return $nthDay.Day -eq $checkDate.Day
    }
}
