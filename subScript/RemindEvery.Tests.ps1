$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
. "$here\RemindEveryDefined.ps1"
# ���̒���TestWorkDay���g�����A�X�R�[�v�̖�肪����̂ŁA�e�X�g���Ƀ��b�N���`
# . "$here\WorkdayUtil.ps1"

Describe "GetDailyCheckScript" {
    It "��΂�true��Ԃ�" {
        $script = GetDailyCheckScript
        & ($script) "2020/01/01" "day" | Should Be $true
    }
}
Describe "GetWeeklyCheckScript" {
    $script = GetWeeklyCheckScript
    It "�j���ƈ�v�����ꍇ�ɂ�true��Ԃ�" {
        & ($script) "2020/01/01" "Wednesday" | Should Be $true
    }
    It "�j���ƕs��v�����ꍇ��false��Ԃ�" {
        & ($script) "2020/01/01" "Monday" | Should Be $false
    }
}
Describe "GetMonthlyCheckScript" {
    $script = GetMonthlyCheckScript

    It "���t�ƈ�v�����ꍇ�ɂ�true��Ԃ�" {
        & ($script) "2020/01/01" "1st" | Should Be $true
    }
    It "���t�ƕs��v�����ꍇ��false��Ԃ�" {
        & ($script) "2020/01/01" "2nd" | Should Be $false
    }
}

Describe "GetMonthlyInverseCheckScript" {
    $script = GetMonthlyInverseCheckScript

    It "-1th�͌����̏ꍇ��true��Ԃ�" {
        & ($script) "2020/01/31" "-1st" | Should Be $true
    }
    It "-31th�͌����̏ꍇ��true��Ԃ�" {
        & ($script) "2020/01/01" "-31st" | Should Be $true
    }
    It "���t�ƕs��v�����ꍇ��false��Ԃ�" {
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

    It "1stWorkDay�͍ŏ��̉c�Ɠ��̏ꍇ��true" {
        & ($script) "2020/01/02" "1stWorkDay" | Should Be $true
    }
    It "21th��31������true��Ԃ��i��̂𐔂����j" {
        & ($script) "2020/01/31" "21st" | Should Be $true
    }
    It "-1stWorkDay�͍Ō�̉c�Ɠ��̏ꍇ��true" {
        & ($script) "2020/01/31" "-1stWorkDay" | Should Be $true
    }
    It "-21th��1������true��Ԃ��i��̂𐔂����j" {
        & ($script) "2020/01/02" "-21st" | Should Be $true
    }
    It "-22th�͔͈͊O�Ȃ̂�false" {
        & ($script) "2020/01/02" "-22st" | Should Be $false
    }
    It "���t�ƕs��v�����ꍇ��false��Ԃ�" {
        & ($script) "2020/01/03" "1st" | Should Be $false
    }
    It "���t�ƕs��v�����ꍇ��false��Ԃ�2" {
        & ($script) "2020/01/30" "-1st" | Should Be $false
    }
}

Describe "GetMonthlyNthWeekOfDayCheckScript" {
    $script = GetMonthlyNthWeekOfDayCheckScript

    # ����n
    It "1st_Monday�͑�1���j�̏ꍇ��true��Ԃ�" {
        & ($script) "2020/10/5" "1st_Monday" | Should Be $true
    }
    It "2nd_Tuesday�͑�2�Ηj�̏ꍇ��true��Ԃ�" {
        & ($script) "2020/10/13" "2nd_Tuesday" | Should Be $true
    }
    It "3rd_Wednesday�͑�3���j�̏ꍇ��true��Ԃ�" {
        & ($script) "2020/10/21" "3rd_Wednesday" | Should Be $true
    }
    It "4th_Thursday�͑�4�ؗj�̏ꍇ��true��Ԃ�" {
        & ($script) "2020/10/22" "4th_Thursday" | Should Be $true
    }
    It "5th_Friday�͑�5���j�̏ꍇ��true��Ԃ�" {
        & ($script) "2020/10/30" "5th_Friday" | Should Be $true
    }

    It "-1st_Monday�͌������琔���đ�1���j�̏ꍇ��true��Ԃ�" {
        & ($script) "2020/10/26" "-1st_Monday" | Should Be $true
    }
    It "-2nd_Tuesday�͌������琔���đ�2�Ηj�̏ꍇ��true��Ԃ�" {
        & ($script) "2020/10/20" "-2nd_Tuesday" | Should Be $true
    }
    It "-3rd_Wednesday�͌������琔���đ�3���j�̏ꍇ��true��Ԃ�" {
        & ($script) "2020/10/14" "-3rd_Wednesday" | Should Be $true
    }
    It "-4th_Thursday�͌������琔���đ�4�ؗj�̏ꍇ��true��Ԃ�" {
        & ($script) "2020/10/8" "-4th_Thursday" | Should Be $true
    }
    It "-5th_Friday�͌������琔���đ�5���j�̏ꍇ��true��Ԃ�" {
        & ($script) "2020/10/2" "-5th_Friday" | Should Be $true
    }


    # �ُ�n
    It "�j�����قȂ�ꍇ��False" {
        & ($script) "2020/10/2" "1st_Monday" | Should Be $false
        & ($script) "2020/10/2" "2nd_Monday" | Should Be $false
        & ($script) "2020/10/2" "3rd_Monday" | Should Be $false
    }
    It "�j���������ł��T���قȂ��False" {
        & ($script) "2020/10/5" "2nd_Monday" | Should Be  $false
        & ($script) "2020/10/19" "2nd_Monday" | Should Be $false
        & ($script) "2020/10/26" "2nd_Monday" | Should Be $false
    }
    It "�j���������ł��T���قȂ��False ��������̏ꍇ" {
        & ($script) "2020/10/5"  "-2nd_Monday" | Should Be  $false
        & ($script) "2020/10/12" "-2nd_Monday" | Should Be $false
        & ($script) "2020/10/26" "-2nd_Monday" | Should Be $false
    }
}

Describe "GetEveryCheckScript" {

    Context "���� & �x���ł��ʒm����ꍇ" {
        $script = GetEveryCheckScript "-1st" "Notify"
        It "�����ł����true��Ԃ�" {
            & ($script) "2020/01/31" | Should Be $true

        }
        It "�������x���Ƃ��Ă�true��Ԃ�" {
            function Global:TestWorkDay { return $false }
            & ($script) "2020/01/31" | Should Be $true

        }
    }
    Context "���� & �x���͒ʒm���Ȃ��ꍇ" {
        $script = GetEveryCheckScript "-1st" "NotNotify"
        It "�����ł����true��Ԃ�" {
            # TestWorkDay�̃��b�N
            # �X�R�[�v�̖���Mock�R�}���h���ƎQ�Ƃł��Ȃ����ۂ��̂ł����Œ�`
            function Global:TestWorkDay { return $true }
            & ($script) "2020/01/31" | Should Be $true

        }
        It "�������x����false��Ԃ�" {
            function Global:TestWorkDay { return $false }
            & ($script) "2020/01/31" | Should Be $false
        }
    }
    Context "���� & �x���͑O�ɏA�Ɠ��ɒʒm�̏ꍇ" {
        $script = GetEveryCheckScript "-1st" "PrevWorkDay"
        # TestWorkDay�̃��b�N
        function Global:TestWorkDay ([datetime] $date) {
            if ($date.ToString("yyyy/MM/dd") -eq "2020/01/31") { return $false }
            if ($date.ToString("yyyy/MM/dd") -eq "2020/01/30") { return $false }
            if ($date.ToString("yyyy/MM/dd") -eq "2020/01/29") { return $true } # ��������true��Ԃ�����
            if ($date.ToString("yyyy/MM/dd") -eq "2020/01/28") { return $true }
        }
        It "�������x���̏ꍇ��false" {
            & ($script) "2020/01/31" | Should Be $false
        }
        It "�Ώۂ��x����false��Ԃ�" {
            & ($script) "2020/01/30" | Should Be $false
        }
        It "�����̒��O�̏A�Ɠ���true��Ԃ�" {
            & ($script) "2020/01/29" | Should Be $true
        }
        It "�����̒��O�łȂ��̏A�Ɠ���false��Ԃ�" {
            & ($script) "2020/01/28" | Should Be $false
        }
    }
    Context "���� & �x���͑O�ɏA�Ɠ��ɒʒm�̏ꍇ" {

        $script = GetEveryCheckScript "-1st" "NextWorkDay"
        # TestWorkDay�̃��b�N
        function Global:TestWorkDay ([datetime] $date) {
            if ($date.ToString("yyyy/MM/dd") -eq "2020/02/03") { return $true }
            if ($date.ToString("yyyy/MM/dd") -eq "2020/02/02") { return $true }
            if ($date.ToString("yyyy/MM/dd") -eq "2020/02/01") { return $false }
            if ($date.ToString("yyyy/MM/dd") -eq "2020/01/31") { return $false }
        }
        It "�������x���̏ꍇ��false" {
            & ($script) "2020/01/31" | Should Be $false
        }
        It "�Ώۂ��x����false��Ԃ�" {
            & ($script) "2020/02/01" | Should Be $false
        }
        It "�����̒���̏A�Ɠ���true��Ԃ�" {
            & ($script) "2020/02/02" | Should Be $true
        }
        It "�����̒���łȂ��̏A�Ɠ���false��Ԃ�" {
            & ($script) "2020/02/03" | Should Be $false
        }
    }
    Context "���� & �x���͒ʒm���Ȃ��ꍇ" {
        $script = GetEveryCheckScript "day" "NotNotify"
        It "�A�Ɠ��ł����true��Ԃ�" {
            # TestWorkDay�̃��b�N
            # �X�R�[�v�̖���Mock�R�}���h���ƎQ�Ƃł��Ȃ����ۂ��̂ł����Œ�`
            function Global:TestWorkDay { return $true }
            & ($script) "2020/01/11" | Should Be $true

        }
        It "�x����false��Ԃ�" {
            function Global:TestWorkDay { return $false }
            & ($script) "2020/01/11" | Should Be $false
        }
    }
    Context "�T�� & �x���͒ʒm���Ȃ��ꍇ" {
        $script = GetEveryCheckScript "Monday" "NotNotify"
        It "�A�Ɠ������j�ł����true��Ԃ�" {
            # TestWorkDay�̃��b�N
            # �X�R�[�v�̖���Mock�R�}���h���ƎQ�Ƃł��Ȃ����ۂ��̂ł����Œ�`
            function Global:TestWorkDay { return $true }
            & ($script) "2020/01/13" | Should Be $true

        }
        It "�A�Ɠ��Ō��j���łȂ����false��Ԃ�" {
            # TestWorkDay�̃��b�N
            # �X�R�[�v�̖���Mock�R�}���h���ƎQ�Ƃł��Ȃ����ۂ��̂ł����Œ�`
            function Global:TestWorkDay { return $true }
            & ($script) "2020/01/14" | Should Be $false

        }
        It "�x����false��Ԃ�" {
            function Global:TestWorkDay { return $false }
            & ($script) "2020/01/13" | Should Be $false
        }
    }
    Context "���� & �x���͒ʒm���Ȃ��ꍇ" {
        $script = GetEveryCheckScript "1st" "NotNotify"
        It "�A�Ɠ����w����ł����true��Ԃ�" {
            # TestWorkDay�̃��b�N
            # �X�R�[�v�̖���Mock�R�}���h���ƎQ�Ƃł��Ȃ����ۂ��̂ł����Œ�`
            function Global:TestWorkDay { return $true }
            & ($script) "2020/01/01" | Should Be $true

        }
        It "�A�Ɠ��Ŏw����łȂ����false��Ԃ�" {
            # TestWorkDay�̃��b�N
            # �X�R�[�v�̖���Mock�R�}���h���ƎQ�Ƃł��Ȃ����ۂ��̂ł����Œ�`
            function Global:TestWorkDay { return $true }
            & ($script) "2020/01/14" | Should Be $false

        }
        It "�w������x����false��Ԃ�" {
            function Global:TestWorkDay { return $false }
            & ($script) "2020/01/01" | Should Be $false
        }
    }
}
