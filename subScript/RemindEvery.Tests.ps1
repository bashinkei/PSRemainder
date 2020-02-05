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
