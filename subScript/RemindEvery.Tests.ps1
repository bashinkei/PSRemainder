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
