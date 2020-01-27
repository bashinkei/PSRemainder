Enum whenNonWorkDay {
    Notify
    NotNotify
    PrevWorkDay
    NextWorkDay
}

Enum EveryType {
    daily
    weekly
    Monthly
    endOfMonth
}

function DefinedEvery {
    [PSCustomObject]@{ every = "day"; type = [EveryType]::daily }
    [PSCustomObject]@{ every = "Monday"; type = [EveryType]::weekly }
    [PSCustomObject]@{ every = "Tuesday"; type = [EveryType]::weekly }
    [PSCustomObject]@{ every = "Wednesday"; type = [EveryType]::weekly }
    [PSCustomObject]@{ every = "Thursday"; type = [EveryType]::weekly }
    [PSCustomObject]@{ every = "Friday"; type = [EveryType]::weekly }
    [PSCustomObject]@{ every = "Saturday"; type = [EveryType]::weekly }
    [PSCustomObject]@{ every = "Sunday"; type = [EveryType]::weekly }
    [PSCustomObject]@{ every = "1st"; type = [EveryType]::Monthly }
    [PSCustomObject]@{ every = "2nd"; type = [EveryType]::Monthly }
    [PSCustomObject]@{ every = "3rd"; type = [EveryType]::Monthly }
    [PSCustomObject]@{ every = "4th"; type = [EveryType]::Monthly }
    [PSCustomObject]@{ every = "5th"; type = [EveryType]::Monthly }
    [PSCustomObject]@{ every = "6th"; type = [EveryType]::Monthly }
    [PSCustomObject]@{ every = "7th"; type = [EveryType]::Monthly }
    [PSCustomObject]@{ every = "8th"; type = [EveryType]::Monthly }
    [PSCustomObject]@{ every = "9th"; type = [EveryType]::Monthly }
    [PSCustomObject]@{ every = "10th"; type = [EveryType]::Monthly }
    [PSCustomObject]@{ every = "11th"; type = [EveryType]::Monthly }
    [PSCustomObject]@{ every = "12th"; type = [EveryType]::Monthly }
    [PSCustomObject]@{ every = "13th"; type = [EveryType]::Monthly }
    [PSCustomObject]@{ every = "14th"; type = [EveryType]::Monthly }
    [PSCustomObject]@{ every = "15th"; type = [EveryType]::Monthly }
    [PSCustomObject]@{ every = "16th"; type = [EveryType]::Monthly }
    [PSCustomObject]@{ every = "17th"; type = [EveryType]::Monthly }
    [PSCustomObject]@{ every = "18th"; type = [EveryType]::Monthly }
    [PSCustomObject]@{ every = "19th"; type = [EveryType]::Monthly }
    [PSCustomObject]@{ every = "20th"; type = [EveryType]::Monthly }
    [PSCustomObject]@{ every = "21st"; type = [EveryType]::Monthly }
    [PSCustomObject]@{ every = "22nd"; type = [EveryType]::Monthly }
    [PSCustomObject]@{ every = "23rd"; type = [EveryType]::Monthly }
    [PSCustomObject]@{ every = "24th"; type = [EveryType]::Monthly }
    [PSCustomObject]@{ every = "25th"; type = [EveryType]::Monthly }
    [PSCustomObject]@{ every = "26th"; type = [EveryType]::Monthly }
    [PSCustomObject]@{ every = "27th"; type = [EveryType]::Monthly }
    [PSCustomObject]@{ every = "28th"; type = [EveryType]::Monthly }
    [PSCustomObject]@{ every = "29th"; type = [EveryType]::Monthly }
    [PSCustomObject]@{ every = "30th"; type = [EveryType]::Monthly }
    [PSCustomObject]@{ every = "31st"; type = [EveryType]::Monthly }
    [PSCustomObject]@{ every = "endOfMonth"; type = [EveryType]::endOfMonth }
}
