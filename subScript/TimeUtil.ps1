<#
�������Ԃ��v�Z�������ς��܂ł̃~���b���擾����
#>
function GetNextMinutesUpToMillSeconds {
    $prevDate = Get-Date
    $end = [datetime]$prevDate.AddMinutes(1).ToString("yyyy/MM/dd HH:mm:00")
    $millseconds = ($end - (Get-Date)).TotalMilliseconds

    return $millseconds
}
<#
�����ς��܂ŃX���[�v����
�P����60�bsleep����Ə������ԕ��̂��ꂪ�~�ς����̂ŁA
�������ԕ����v�Z��sleep���鎞�Ԃ����߂�
#>
function SleepNextMinutes {
    $waitMillseconds = GetNextMinutesUpToMillSeconds
    Start-Sleep -Milliseconds ([Math]::Ceiling($waitMillseconds))
}

<#
���ݎ����𕪒P��(�b�ȉ��؂藎�Ƃ�)�Ŏ擾����
#>
function GetMinutes {
    [OutputType([datetime])]
    param()

    [datetime](Get-Date).ToString("yyyy/MM/dd HH:mm:00")
}
