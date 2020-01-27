
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
    elseif ($definedEvry.type -eq [EveryType]::endOfMonth) {
        GetEndOfMonthCheckScript
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
function GetEndOfMonthCheckScript {
    [OutputType([scriptblock])]
    param()

    return {
        param (
            [Parameter(Mandatory)]
            [datetime] $checkDate,
            [Parameter(Mandatory)]
            [string]$checkEvery
        )
        $checkDate.Day -eq [datetime]::DaysInMonth($checkDate.Year, $checkDate.Month)
    }
}
