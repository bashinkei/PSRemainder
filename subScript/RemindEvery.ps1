
<#〇〇毎の判定処理#>
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

    # 休日でも通知するの場合
    if ($whenNonWorkDay -eq [whenNonWorkDay]::Notify) {
        return {
            param(
                [datetime]$checkdate
            )
            & $everyCheckScript $checkdate $definedEvry.every
        }.GetNewClosure()
    }
    # 休日は通知しないの場合
    if ($whenNonWorkDay -eq [whenNonWorkDay]::NotNotify) {
        return {
            param(
                [datetime]$checkdate
            )
            if (-not (TestWorkDay $checkdate)) { return $false }
            & $everyCheckScript $checkdate $definedEvry.every
        }.GetNewClosure()
    }
    # 休日の直前直後判定用スクリプト
    $notifyToWorkdaycheck = {
        param(
            [datetime]$checkdate
        )
        # 休日の場合は論外
        if (-not (TestWorkDay $checkdate)) { return $false }

        $testDate = $checkDate
        # 対象の日までに就業日があるか確認する。
        # 就業日がある場合は休日の直前直後ではない。
        while (-not (&$everyCheckSCript $testDate $definedEvry.every)) {
            $testDate = $testDate.AddDays($addDays)
            if (TestWorkDay $testDate) { return $false }
        }
        return $true
    }

    # 休日のとき前の就業日に通知するの場合
    if ($whenNonWorkDay -eq [whenNonWorkDay]::PrevWorkDay) {
        $addDays = 1
        return $notifyToWorkdaycheck.GetNewClosure()
    }

    # 休日のとき後の就業日に通知するの場合
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
