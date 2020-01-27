# https://holidays-jp.github.io


$url = "https://holidays-jp.github.io/api/v1/date.csv"
$holidayFile = "Holidays.csv"
(Invoke-WebRequest -Uri $url).content > $holidayFile
