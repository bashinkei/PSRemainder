function SetGlobalConst {
    param (
        [Parameter(Mandatory)]
        [string] $Name,
        [Parameter(Mandatory)]
        [Object] $value
    )
# �萔�̐ݒ�i�ς������Ƃ���powersehll���̂��ċN���E�萔�͕ς����Ȃ����ۂ��E�ǂݍ��ݍς݂ł��G���[�ɂȂ�Ȃ��悤��"Ignore"�����Ă�j
Set-Variable $Name -Value $value -Scope "Global" -Option "Constant" -ErrorAction "Ignore"

}

SetGlobalConst "NON_WORKDAY_OF_DAY_OF_WEEKS" $([System.DayOfWeek]::Saturday, [System.DayOfWeek]::Sunday)
SetGlobalConst "SCRIPT_ROOT" (Split-Path $PSScriptRoot -Parent)
SetGlobalConst "RESOURCES_PATH" (Join-Path $SCRIPT_ROOT "resources")

# �e��ݒ�t�@�C����
SetGlobalConst "REMIND_LIST_FILE" (Join-Path $SCRIPT_ROOT "RemindList.csv")
SetGlobalConst "DATE_REMIND_LIST_FILE" (Join-Path $SCRIPT_ROOT "DateRemindList.csv")
SetGlobalConst "HOLIDAYS_FILE" (join-path $RESOURCES_PATH "Holidays.csv")

SetGlobalConst "TOAST_TEMPLATE_FILE" (join-path $RESOURCES_PATH "toast.xml")

SetGlobalConst "ICON_PNG_FILE" (join-path $RESOURCES_PATH "icon.png")
SetGlobalConst "ICON_FILE" (Join-Path $RESOURCES_PATH "icon.ico")

# ���t�̌`���ݒ�
SetGlobalConst "DATE_FORMAT" "yyyy-MM-dd"
SetGlobalConst "TIME_FORMAT" "HH:mm"
