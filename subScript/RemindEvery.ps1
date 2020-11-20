
<#ZZ–ˆ‚Ì”»’èˆ—#>
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
    elseif ($definedEvry.type -eq [EveryType]::MonthlyNthWeekOfDay) {
        GetMonthlyNthWeekOfDayCheckScript
    }

    # ‹x“ú‚Å‚à’Ê’m‚·‚é‚Ìê‡
    if ($whenNonWorkDay -eq [whenNonWorkDay]::Notify) {
        return {
            param(
                [datetime]$checkdate
            )
            & $everyCheckScript $checkdate $definedEvry.every
        }.GetNewClosure()
    }
    # ‹x“ú‚Í’Ê’m‚µ‚È‚¢‚Ìê‡
    if ($whenNonWorkDay -eq [whenNonWorkDay]::NotNotify) {
        return {
            param(
                [datetime]$checkdate
            )
            if (-not (TestWorkDay $checkdate)) { return $false }
            & $everyCheckScript $checkdate $definedEvry.every
        }.GetNewClosure()
    }
    # ‹x“ú‚Ì’¼‘O’¼Œã”»’è—pƒXƒNƒŠƒvƒg
    $notifyToWorkdaycheck = {
        param(
            [datetime]$checkdate
        )
        # ‹x“ú‚Ìê‡‚Í˜_ŠO
        if (-not (TestWorkDay $checkdate)) { return $false }

        $testDate = $checkDate
        # ‘ÎÛ‚Ì“ú‚Ü‚Å‚ÉA‹Æ“ú‚ª‚ ‚é‚©Šm”F‚·‚éB
        # A‹Æ“ú‚ª‚ ‚éê‡‚Í‹x“ú‚Ì’¼‘O’¼Œã‚Å‚Í‚È‚¢B
        while (-not (&$everyCheckSCript $testDate $definedEvry.every)) {
            $testDate = $testDate.AddDays($addDays)
            if (TestWorkDay $testDate) { return $false }
        }
        return $true
    }

    # ‹x“ú‚Ì‚Æ‚«‘O‚ÌA‹Æ“ú‚É’Ê’m‚·‚é‚Ìê‡
    if ($whenNonWorkDay -eq [whenNonWorkDay]::PrevWorkDay) {
        $addDays = 1
        return $notifyToWorkdaycheck.GetNewClosure()
    }

    # ‹x“ú‚Ì‚Æ‚«Œã‚ÌA‹Æ“ú‚É’Ê’m‚·‚é‚Ìê‡
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
        # Œ‚Ì“ú”‚ª31“ú‚Ìê‡@-> -1st = 31“ú; -2nd = 30“ú EEE@-31st = 1“ú
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

        # ‰Ò“­“ú”‚ğ’´‚¦‚Ä‚¢‚½‚çNG
        if ($workdays.count -lt [System.Math]::Abs($nth)) { $false }

        $arrayIndex = if ($nth -gt 0) { $nth - 1 } else { $workdays.count + $nth }
        $nthDay = ($workdays | Sort-Object)[$arrayIndex]

        return $nthDay.Day -eq $checkDate.Day
    }
}function GetMonthlyNthWeekOfDayCheckScript {
    [OutputType([scriptblock])]
    param()

    return {
        param (
            [Parameter(Mandatory)]
            [datetime] $checkDate,
            [Parameter(Mandatory)]
            [string]$checkEvery
        )

        $nthWeekOfDay = $checkEvery.Split("_")
        [int]$nth = $nthWeekOfDay[0].TrimEnd('st nd rd th')
        [DayOfWeek]$dayOfWeek = $nthWeekOfDay[1]

        # —j“ú‚Ì”»’è
        if ($checkDate.DayOfWeek -ne $dayOfWeek) { return $false }

        # ‘æ‰½‚Ì”»’è
        ## ‘ÎÛ‚ÌŒ‚Ì‘æXX—j‚ğæ“¾
        $isInverse = $nth -lt 0
        $inverseCal = if ($isInverse) { -1 }else { 1 }

        $refDay = if ($isInverse) {
            ([datetime]::new($checkDate.Year, $checkDate.Month , 1)).AddMonths(1).AddDays(-1)
        }
        else {
            [datetime]::new($checkDate.Year, $checkDate.Month , 1)
        }
        $refWeekOfDay = $refDay
        while ($refWeekOfDay.DayOfWeek -ne $dayOfWeek) {
            $refWeekOfDay = $refWeekOfDay.AddDays($inverseCal)
        }

        $numOfWeek = [enum]::GetValues("DayOfWeek").Length
        $targetNthWeekOfDay = $refWeekOfDay.AddDays(([math]::Abs($nth) - 1) * $numOfWeek * $inverseCal)

        return $targetNthWeekOfDay -eq $checkDate
    }
}
