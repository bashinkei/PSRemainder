$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
. "$here\config.ps1"

function GetPSObjectArray {
    [OutputType([array])]
    param ()

    $array = @()
    $array += [PSCustomObject]@{time = "00:00"; everyCheckScript = { param($date) if ($date.Date -eq [datetime]"2020/02/01") { $true } else { $false } } }
    $array += [PSCustomObject]@{time = "00:01"; everyCheckScript = { param($date) if ($date.Date -eq [datetime]"2020/02/01") { $true } else { $false } } }
    $array += [PSCustomObject]@{time = "23:59"; everyCheckScript = { param($date) if ($date.Date -eq [datetime]"2020/02/01") { $true } else { $false } } }
    $array += [PSCustomObject]@{time = "08:00"; everyCheckScript = { param($date) if ($date.Date -eq [datetime]"2020/02/03") { $true } else { $false } } }
    $array += [PSCustomObject]@{time = "14:00"; everyCheckScript = { param($date) if ($date.Date -eq [datetime]"2020/02/06") { $true } else { $false } } }
    $array += [PSCustomObject]@{time = "17:59"; everyCheckScript = { param($date) if ($date.Date -eq [datetime]"2020/02/09") { $true } else { $false } } }
    $array += [PSCustomObject]@{time = "18:00"; everyCheckScript = { param($date) if ($date.Date -eq [datetime]"2020/02/09") { $true } else { $false } } }

    return $array
}

Describe "FilterMatchRemind" {
    It "開始分をちょうど含む" {
        $reminds = GetPSObjectArray
        $checkStartMinits = "2020/02/01 00:00:00"
        $checkEndMinits   = "2020/02/01 00:00:00"
        $object = @()
        $object += $reminds | % {
            FilterMatchRemind -remined $_ -checkStartMinits $checkStartMinits -checkEndMinits $checkEndMinits
        }
        $object.count | Should Be 1
    }
    It "開始分をちょうど含まない" {
        $reminds = GetPSObjectArray
        $checkStartMinits = "2020/02/01 00:02:00"
        $checkEndMinits   = "2020/02/01 00:02:00"
        $object = @()
        $object += $reminds | % {
            FilterMatchRemind -remined $_ -checkStartMinits $checkStartMinits -checkEndMinits $checkEndMinits
        }
        $object.count | Should Be 0
    }
    It "終了分をちょうど含む" {
        $reminds = GetPSObjectArray
        $checkStartMinits = "2020/02/01 23:59:00"
        $checkEndMinits   = "2020/02/01 23:59:00"
        $object = @()
        $object += $reminds | % {
            FilterMatchRemind -remined $_ -checkStartMinits $checkStartMinits -checkEndMinits $checkEndMinits
        }
        $object.count | Should Be 1
    }
    It "終了分をちょうど含まない" {
        $reminds = GetPSObjectArray
        $checkStartMinits = "2020/02/01 23:58:00"
        $checkEndMinits   = "2020/02/01 23:58:00"
        $object = @()
        $object += $reminds | % {
            FilterMatchRemind -remined $_ -checkStartMinits $checkStartMinits -checkEndMinits $checkEndMinits
        }
        $object.count | Should Be 0
    }
    It "日付をまたいでもできる" {
        $reminds = GetPSObjectArray
        $checkStartMinits = "2020/02/01 00:01:00"
        $checkEndMinits = "2020/02/09 17:59:00"
        $object = @()
        $object += $reminds | % {
            FilterMatchRemind -remined $_ -checkStartMinits $checkStartMinits -checkEndMinits $checkEndMinits
        }
        $object.count | Should Be 5
    }
}
