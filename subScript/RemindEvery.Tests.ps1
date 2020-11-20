$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
. "$here\RemindEveryDefined.ps1"
# この中のTestWorkDayを使うが、スコープの問題があるので、テスト時にモックを定義
# . "$here\WorkdayUtil.ps1"

Describe "GetDailyCheckScript" {
    It "絶対にtrueを返す" {
        $script = GetDailyCheckScript
        & ($script) "2020/01/01" "day" | Should Be $true
    }
}
Describe "GetWeeklyCheckScript" {
    $script = GetWeeklyCheckScript
    It "曜日と一致した場合ににtrueを返す" {
        & ($script) "2020/01/01" "Wednesday" | Should Be $true
    }
    It "曜日と不一致した場合はfalseを返す" {
        & ($script) "2020/01/01" "Monday" | Should Be $false
    }
}
Describe "GetMonthlyCheckScript" {
    $script = GetMonthlyCheckScript

    It "日付と一致した場合ににtrueを返す" {
        & ($script) "2020/01/01" "1st" | Should Be $true
    }
    It "日付と不一致した場合はfalseを返す" {
        & ($script) "2020/01/01" "2nd" | Should Be $false
    }
}

Describe "GetMonthlyInverseCheckScript" {
    $script = GetMonthlyInverseCheckScript

    It "-1thは月末の場合にtrueを返す" {
        & ($script) "2020/01/31" "-1st" | Should Be $true
    }
    It "-31thは月初の場合にtrueを返す" {
        & ($script) "2020/01/01" "-31st" | Should Be $true
    }
    It "日付と不一致した場合はfalseを返す" {
        & ($script) "2020/01/30" "-1st" | Should Be $false
    }
}

Describe "GetMonthlyOfWorkDayCheckScript" {
    function Global:GetWorkDayList{
        param ([datetime] $ParameterName)
        [datetime]"2020/01/07"
        [datetime]"2020/01/08"
        [datetime]"2020/01/09"
        [datetime]"2020/01/10"
        [datetime]"2020/01/14"
        [datetime]"2020/01/15"
        [datetime]"2020/01/16"
        [datetime]"2020/01/17"
        [datetime]"2020/01/20"
        [datetime]"2020/01/21"
        [datetime]"2020/01/22"
        [datetime]"2020/01/23"
        [datetime]"2020/01/24"
        [datetime]"2020/01/27"
        [datetime]"2020/01/28"
        [datetime]"2020/01/29"
        [datetime]"2020/01/30"
        [datetime]"2020/01/31"
        [datetime]"2020/01/02"
        [datetime]"2020/01/03"
        [datetime]"2020/01/04"
    }
    $script = GetMonthlyOfWorkDayCheckScript

    It "1stWorkDayは最初の営業日の場合にtrue" {
        & ($script) "2020/01/02" "1stWorkDay" | Should Be $true
    }
    It "21thは31日だとtrueを返す（上のを数えた）" {
        & ($script) "2020/01/31" "21st" | Should Be $true
    }
    It "-1stWorkDayは最後の営業日の場合にtrue" {
        & ($script) "2020/01/31" "-1stWorkDay" | Should Be $true
    }
    It "-21thは1日だとtrueを返す（上のを数えた）" {
        & ($script) "2020/01/02" "-21st" | Should Be $true
    }
    It "-22thは範囲外なのでfalse" {
        & ($script) "2020/01/02" "-22st" | Should Be $false
    }
    It "日付と不一致した場合はfalseを返す" {
        & ($script) "2020/01/03" "1st" | Should Be $false
    }
    It "日付と不一致した場合はfalseを返す2" {
        & ($script) "2020/01/30" "-1st" | Should Be $false
    }
}

Describe "GetMonthlyNthWeekOfDayCheckScript" {
    $script = GetMonthlyNthWeekOfDayCheckScript

    # 正常系
    It "1st_Mondayは第1月曜の場合にtrueを返す" {
        & ($script) "2020/10/5" "1st_Monday" | Should Be $true
    }
    It "2nd_Tuesdayは第2火曜の場合にtrueを返す" {
        & ($script) "2020/10/13" "2nd_Tuesday" | Should Be $true
    }
    It "3rd_Wednesdayは第3水曜の場合にtrueを返す" {
        & ($script) "2020/10/21" "3rd_Wednesday" | Should Be $true
    }
    It "4th_Thursdayは第4木曜の場合にtrueを返す" {
        & ($script) "2020/10/22" "4th_Thursday" | Should Be $true
    }
    It "5th_Fridayは第5金曜の場合にtrueを返す" {
        & ($script) "2020/10/30" "5th_Friday" | Should Be $true
    }

    It "-1st_Mondayは月末から数えて第1月曜の場合にtrueを返す" {
        & ($script) "2020/10/26" "-1st_Monday" | Should Be $true
    }
    It "-2nd_Tuesdayは月末から数えて第2火曜の場合にtrueを返す" {
        & ($script) "2020/10/20" "-2nd_Tuesday" | Should Be $true
    }
    It "-3rd_Wednesdayは月末から数えて第3水曜の場合にtrueを返す" {
        & ($script) "2020/10/14" "-3rd_Wednesday" | Should Be $true
    }
    It "-4th_Thursdayは月末から数えて第4木曜の場合にtrueを返す" {
        & ($script) "2020/10/8" "-4th_Thursday" | Should Be $true
    }
    It "-5th_Fridayは月末から数えて第5金曜の場合にtrueを返す" {
        & ($script) "2020/10/2" "-5th_Friday" | Should Be $true
    }


    # 異常系
    It "曜日が異なる場合はFalse" {
        & ($script) "2020/10/2" "1st_Monday" | Should Be $false
        & ($script) "2020/10/2" "2nd_Monday" | Should Be $false
        & ($script) "2020/10/2" "3rd_Monday" | Should Be $false
    }
    It "曜日が同じでも週が異なればFalse" {
        & ($script) "2020/10/5" "2nd_Monday" | Should Be  $false
        & ($script) "2020/10/19" "2nd_Monday" | Should Be $false
        & ($script) "2020/10/26" "2nd_Monday" | Should Be $false
    }
    It "曜日が同じでも週が異なればFalse 月末からの場合" {
        & ($script) "2020/10/5"  "-2nd_Monday" | Should Be  $false
        & ($script) "2020/10/12" "-2nd_Monday" | Should Be $false
        & ($script) "2020/10/26" "-2nd_Monday" | Should Be $false
    }
}

Describe "GetEveryCheckScript" {

    Context "月末 & 休日でも通知する場合" {
        $script = GetEveryCheckScript "-1st" "Notify"
        It "月末であればtrueを返す" {
            & ($script) "2020/01/31" | Should Be $true

        }
        It "月末が休日としてもtrueを返す" {
            function Global:TestWorkDay { return $false }
            & ($script) "2020/01/31" | Should Be $true

        }
    }
    Context "月末 & 休日は通知しない場合" {
        $script = GetEveryCheckScript "-1st" "NotNotify"
        It "月末であればtrueを返す" {
            # TestWorkDayのモック
            # スコープの問題でMockコマンドだと参照できないっぽいのでここで定義
            function Global:TestWorkDay { return $true }
            & ($script) "2020/01/31" | Should Be $true

        }
        It "月末が休日はfalseを返す" {
            function Global:TestWorkDay { return $false }
            & ($script) "2020/01/31" | Should Be $false
        }
    }
    Context "月末 & 休日は前に就業日に通知の場合" {
        $script = GetEveryCheckScript "-1st" "PrevWorkDay"
        # TestWorkDayのモック
        function Global:TestWorkDay ([datetime] $date) {
            if ($date.ToString("yyyy/MM/dd") -eq "2020/01/31") { return $false }
            if ($date.ToString("yyyy/MM/dd") -eq "2020/01/30") { return $false }
            if ($date.ToString("yyyy/MM/dd") -eq "2020/01/29") { return $true } # ここだけtrueを返したい
            if ($date.ToString("yyyy/MM/dd") -eq "2020/01/28") { return $true }
        }
        It "月末が休日の場合はfalse" {
            & ($script) "2020/01/31" | Should Be $false
        }
        It "対象が休日はfalseを返す" {
            & ($script) "2020/01/30" | Should Be $false
        }
        It "月末の直前の就業日はtrueを返す" {
            & ($script) "2020/01/29" | Should Be $true
        }
        It "月末の直前でないの就業日はfalseを返す" {
            & ($script) "2020/01/28" | Should Be $false
        }
    }
    Context "月末 & 休日は前に就業日に通知の場合" {

        $script = GetEveryCheckScript "-1st" "NextWorkDay"
        # TestWorkDayのモック
        function Global:TestWorkDay ([datetime] $date) {
            if ($date.ToString("yyyy/MM/dd") -eq "2020/02/03") { return $true }
            if ($date.ToString("yyyy/MM/dd") -eq "2020/02/02") { return $true }
            if ($date.ToString("yyyy/MM/dd") -eq "2020/02/01") { return $false }
            if ($date.ToString("yyyy/MM/dd") -eq "2020/01/31") { return $false }
        }
        It "月末が休日の場合はfalse" {
            & ($script) "2020/01/31" | Should Be $false
        }
        It "対象が休日はfalseを返す" {
            & ($script) "2020/02/01" | Should Be $false
        }
        It "月末の直後の就業日はtrueを返す" {
            & ($script) "2020/02/02" | Should Be $true
        }
        It "月末の直後でないの就業日はfalseを返す" {
            & ($script) "2020/02/03" | Should Be $false
        }
    }
    Context "毎日 & 休日は通知しない場合" {
        $script = GetEveryCheckScript "day" "NotNotify"
        It "就業日であればtrueを返す" {
            # TestWorkDayのモック
            # スコープの問題でMockコマンドだと参照できないっぽいのでここで定義
            function Global:TestWorkDay { return $true }
            & ($script) "2020/01/11" | Should Be $true

        }
        It "休日はfalseを返す" {
            function Global:TestWorkDay { return $false }
            & ($script) "2020/01/11" | Should Be $false
        }
    }
    Context "週次 & 休日は通知しない場合" {
        $script = GetEveryCheckScript "Monday" "NotNotify"
        It "就業日かつ月曜であればtrueを返す" {
            # TestWorkDayのモック
            # スコープの問題でMockコマンドだと参照できないっぽいのでここで定義
            function Global:TestWorkDay { return $true }
            & ($script) "2020/01/13" | Should Be $true

        }
        It "就業日で月曜部でなければfalseを返す" {
            # TestWorkDayのモック
            # スコープの問題でMockコマンドだと参照できないっぽいのでここで定義
            function Global:TestWorkDay { return $true }
            & ($script) "2020/01/14" | Should Be $false

        }
        It "休日はfalseを返す" {
            function Global:TestWorkDay { return $false }
            & ($script) "2020/01/13" | Should Be $false
        }
    }
    Context "月次 & 休日は通知しない場合" {
        $script = GetEveryCheckScript "1st" "NotNotify"
        It "就業日かつ指定日であればtrueを返す" {
            # TestWorkDayのモック
            # スコープの問題でMockコマンドだと参照できないっぽいのでここで定義
            function Global:TestWorkDay { return $true }
            & ($script) "2020/01/01" | Should Be $true

        }
        It "就業日で指定日でなければfalseを返す" {
            # TestWorkDayのモック
            # スコープの問題でMockコマンドだと参照できないっぽいのでここで定義
            function Global:TestWorkDay { return $true }
            & ($script) "2020/01/14" | Should Be $false

        }
        It "指定日が休日はfalseを返す" {
            function Global:TestWorkDay { return $false }
            & ($script) "2020/01/01" | Should Be $false
        }
    }
}
