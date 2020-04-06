$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
. "$here\config.ps1"
. "$here\RemindEvery.ps1"
. "$here\RemindEveryDefined.ps1"
. "$here\PsobjectArrayUtil.ps1"
. "$here\ValidationResult.ps1"


function MakeRemind {
    param (
        [string] $every ,
        [string] $whenNonWorkDay ,
        [string] $time ,
        [string] $message
    )
    return [PSCustomObject]@{
        every          = $every
        whenNonWorkDay = $whenNonWorkDay
        time           = $time
        message        = $message
    }
}

function GetReminds {
    $reminds = @()
    $reminds += MakeRemind "day"        "Notify"         "00:00" "day,Notify_Test_OK"
    $reminds += MakeRemind "day"        "NotNotify"      "00:00" "day,NotNotify_Test_OK"
    $reminds += MakeRemind "day"        "PrevWorkDay"    "00:00" "day,PrevWorkDay_Test_OK"
    $reminds += MakeRemind "day"        "NextWorkDay"    "00:00" "day,NextWorkDay_Test_OK"
    $reminds += MakeRemind "Monday"     "Notify"         "12:14" "Monday,Notify_test_OK"
    $reminds += MakeRemind "Tuesday"    "NotNotify"      "12:14" "Tuesday,NotNotify_test_OK"
    $reminds += MakeRemind "Wednesday"  "PrevWorkDay"    "15:00" "Wednesday,PrevWorkDay_test_OK"
    $reminds += MakeRemind "Thursday"   "NextWorkDay"    "15:00" "Thursday,NextWorkDay_test_OK"
    $reminds += MakeRemind "Friday"     "Notify"         "15:00" "Friday,Notify_test_OK"
    $reminds += MakeRemind "-1st"       "Notify"         "15:00" "Friday,Notify_test_OK"
    $reminds += MakeRemind "NG1"        "Notify"         "15:00" "every���s��"
    $reminds += MakeRemind "-1st"       "NG2"            "15:00" "whenNonWorkDay���s��"
    $reminds += MakeRemind "-1st"       "Notify"         "25:00" "���Ԃ��s��"
    return $reminds
}


Describe "GetRemindList" {
    Mock GetEveryCheckScript -MockWith { return [scriptblock] { $true } }

    Context "���X�g��1���̃p�^�[��" {
        $reminds = MakeRemind "day"        "Notify"         "00:00" "day,Notify_Test_OK"
        Mock ReadRemindListcsv -MockWith { return $reminds }
        It "OK��1��" {
            $remindList = GetRemindList
            $remindList.OK.count | Should Be 1
        }

    }
    Context "���X�g���������̃p�^�[��" {
        $reminds = GetReminds
        Mock ReadRemindListcsv -MockWith { return $reminds }
        It "OK��10��" {
            (GetRemindList).OK.count | Should Be 10
        }
        It "NG��3��" {
            (GetRemindList).NG.count | Should Be 3
        }
    }
}

