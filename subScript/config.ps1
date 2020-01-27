function SetGlobalConst {
    param (
        [Parameter(Mandatory)]
        [string] $Name,
        [Parameter(Mandatory)]
        [Object] $value
    )
# 定数の設定（変えたいときはpowersehll自体を再起動・定数は変えられないっぽい・読み込み済みでもエラーにならないように"Ignore"をつけてる）
Set-Variable $Name -Value $value -Scope "Global" -Option "Constant" -ErrorAction "Ignore"

}

SetGlobalConst "NON_WORKDAY_OF_DAY_OF_WEEKS" $([System.DayOfWeek]::Saturday, [System.DayOfWeek]::Sunday)
SetGlobalConst "SCRIPT_ROOT" (Split-Path $PSScriptRoot -Parent)
SetGlobalConst "RESOURCES_PATH" (Join-Path $SCRIPT_ROOT "resources")

# 各種設定ファイル等
SetGlobalConst "REMIND_LIST_FILE" (Join-Path $SCRIPT_ROOT "RemindList.csv")
SetGlobalConst "DATE_REMIND_LIST_FILE" (Join-Path $SCRIPT_ROOT "DateRemindList.csv")
SetGlobalConst "HOLIDAYS_FILE" (join-path $RESOURCES_PATH "Holidays.csv")

SetGlobalConst "TOAST_TEMPLATE_FILE" (join-path $RESOURCES_PATH "toast.xml")

SetGlobalConst "ICON_PNG_FILE" (join-path $RESOURCES_PATH "icon.png")
SetGlobalConst "ICON_FILE" (Join-Path $RESOURCES_PATH "icon.ico")

# 日付の形式設定
SetGlobalConst "DATE_FORMAT" "yyyy-MM-dd"
SetGlobalConst "TIME_FORMAT" "HH:mm"
