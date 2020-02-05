$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "GetRemindList" {
    Mock TestWorkDay -MockWith {
        param ([datetime] $datetime)
        if ($datetime -eq "2020/01/01") { return $false }
        if ($datetime -eq "2020/01/02") { return $false }
        if ($datetime -eq "2020/01/03") { return $false }
        if ($datetime -eq "2020/01/04") { return $false }
        if ($datetime -eq "2020/01/05") { return $false }
        if ($datetime -eq "2020/01/06") { return $false }
        if ($datetime -eq "2020/01/07") { return $true }
        if ($datetime -eq "2020/01/08") { return $true }
        if ($datetime -eq "2020/01/09") { return $true }
        if ($datetime -eq "2020/01/10") { return $true }
        if ($datetime -eq "2020/01/11") { return $false }
        if ($datetime -eq "2020/01/12") { return $false }
        if ($datetime -eq "2020/01/13") { return $false }
        if ($datetime -eq "2020/01/14") { return $true }
        if ($datetime -eq "2020/01/15") { return $true }
        if ($datetime -eq "2020/01/16") { return $true }
        if ($datetime -eq "2020/01/17") { return $true }
        if ($datetime -eq "2020/01/18") { return $false }
        if ($datetime -eq "2020/01/19") { return $false }
        if ($datetime -eq "2020/01/20") { return $true }
        if ($datetime -eq "2020/01/21") { return $true }
        if ($datetime -eq "2020/01/22") { return $true }
        if ($datetime -eq "2020/01/23") { return $true }
        if ($datetime -eq "2020/01/24") { return $true }
        if ($datetime -eq "2020/01/25") { return $false }
        if ($datetime -eq "2020/01/26") { return $false }
        if ($datetime -eq "2020/01/27") { return $true }
        if ($datetime -eq "2020/01/28") { return $true }
        if ($datetime -eq "2020/01/29") { return $true }
        if ($datetime -eq "2020/01/30") { return $true }
        if ($datetime -eq "2020/01/31") { return $true }

    }

    Context "営業日のリストが返ってくるか" {

        # 初期化
        $Global:WorkdayListOfMounth = @{ }
        $workDayList = GetWorkDayList "2020/01/01"
        It "Mockの営業日テストの通りの数" {
            $workDayList.count | Should Be 18
        }
        It "Mockの営業日テストの通り（適当に一件）" {
            [datetime]"2020/01/20" -in $workDayList | Should Be $true
        }
        It "計算結果を再利用しているか" {
            # 計算結果をいじる
            $Global:WorkdayListOfMounth["202001"] += [datetime]"2020/01/01"

            # 再取得
            $workDayList = GetWorkDayList "2020/01/01"
            $workDayList.count | Should Be 19
            [datetime]"2020/01/01" -in $workDayList | Should Be $true
        }

    }
}

