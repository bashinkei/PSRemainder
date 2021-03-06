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
    MonthlyInverse
    MonthlyOfWorkDay
    MonthlyNthWeekOfDay
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
    #region 月次の定義
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
    #endregion
    #region 月次（逆順）の定義
    [PSCustomObject]@{ every = "-1st"; type = [EveryType]::MonthlyInverse }
    [PSCustomObject]@{ every = "-2nd"; type = [EveryType]::MonthlyInverse }
    [PSCustomObject]@{ every = "-3rd"; type = [EveryType]::MonthlyInverse }
    [PSCustomObject]@{ every = "-4th"; type = [EveryType]::MonthlyInverse }
    [PSCustomObject]@{ every = "-5th"; type = [EveryType]::MonthlyInverse }
    [PSCustomObject]@{ every = "-6th"; type = [EveryType]::MonthlyInverse }
    [PSCustomObject]@{ every = "-7th"; type = [EveryType]::MonthlyInverse }
    [PSCustomObject]@{ every = "-8th"; type = [EveryType]::MonthlyInverse }
    [PSCustomObject]@{ every = "-9th"; type = [EveryType]::MonthlyInverse }
    [PSCustomObject]@{ every = "-10th"; type = [EveryType]::MonthlyInverse }
    [PSCustomObject]@{ every = "-11th"; type = [EveryType]::MonthlyInverse }
    [PSCustomObject]@{ every = "-12th"; type = [EveryType]::MonthlyInverse }
    [PSCustomObject]@{ every = "-13th"; type = [EveryType]::MonthlyInverse }
    [PSCustomObject]@{ every = "-14th"; type = [EveryType]::MonthlyInverse }
    [PSCustomObject]@{ every = "-15th"; type = [EveryType]::MonthlyInverse }
    [PSCustomObject]@{ every = "-16th"; type = [EveryType]::MonthlyInverse }
    [PSCustomObject]@{ every = "-17th"; type = [EveryType]::MonthlyInverse }
    [PSCustomObject]@{ every = "-18th"; type = [EveryType]::MonthlyInverse }
    [PSCustomObject]@{ every = "-19th"; type = [EveryType]::MonthlyInverse }
    [PSCustomObject]@{ every = "-20th"; type = [EveryType]::MonthlyInverse }
    [PSCustomObject]@{ every = "-21st"; type = [EveryType]::MonthlyInverse }
    [PSCustomObject]@{ every = "-22nd"; type = [EveryType]::MonthlyInverse }
    [PSCustomObject]@{ every = "-23rd"; type = [EveryType]::MonthlyInverse }
    [PSCustomObject]@{ every = "-24th"; type = [EveryType]::MonthlyInverse }
    [PSCustomObject]@{ every = "-25th"; type = [EveryType]::MonthlyInverse }
    [PSCustomObject]@{ every = "-26th"; type = [EveryType]::MonthlyInverse }
    [PSCustomObject]@{ every = "-27th"; type = [EveryType]::MonthlyInverse }
    [PSCustomObject]@{ every = "-28th"; type = [EveryType]::MonthlyInverse }
    [PSCustomObject]@{ every = "-29th"; type = [EveryType]::MonthlyInverse }
    [PSCustomObject]@{ every = "-30th"; type = [EveryType]::MonthlyInverse }
    [PSCustomObject]@{ every = "-31st"; type = [EveryType]::MonthlyInverse }
    #endregion
    #region 月次(営業日換算)の定義
    [PSCustomObject]@{ every = "1stWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "2ndWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "3rdWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "4thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "5thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "6thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "7thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "8thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "9thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "10thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "11thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "12thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "13thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "14thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "15thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "16thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "17thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "18thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "19thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "20thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "21stWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "22ndWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "23rdWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "24thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "25thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "26thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "27thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "28thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "29thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "30thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "31stWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    #endregion
    #region　月次(営業日換算・逆順)の定義
    [PSCustomObject]@{ every = "-1stWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "-2ndWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "-3rdWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "-4thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "-5thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "-6thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "-7thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "-8thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "-9thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "-10thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "-11thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "-12thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "-13thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "-14thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "-15thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "-16thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "-17thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "-18thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "-19thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "-20thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "-21stWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "-22ndWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "-23rdWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "-24thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "-25thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "-26thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "-27thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "-28thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "-29thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "-30thWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    [PSCustomObject]@{ every = "-31stWorkDay"; type = [EveryType]::MonthlyOfWorkDay }
    #endregion
    #region 月次 第XX曜日
    [PSCustomObject]@{ every = "1st_Monday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "1st_Tuesday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "1st_Wednesday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "1st_Thursday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "1st_Friday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "1st_Saturday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "1st_Sunday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "2nd_Monday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "2nd_Tuesday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "2nd_Wednesday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "2nd_Thursday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "2nd_Friday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "2nd_Saturday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "2nd_Sunday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "3rd_Monday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "3rd_Tuesday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "3rd_Wednesday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "3rd_Thursday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "3rd_Friday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "3rd_Saturday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "3rd_Sunday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "4th_Monday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "4th_Tuesday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "4th_Wednesday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "4th_Thursday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "4th_Friday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "4th_Saturday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "4th_Sunday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "5th_Monday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "5th_Tuesday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "5th_Wednesday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "5th_Thursday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "5th_Friday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "5th_Saturday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "5th_Sunday"; type = [EveryType]::MonthlyNthWeekOfDay }
    #endregion

    #region 月次　第XX曜　月末から数えて
    [PSCustomObject]@{ every = "-1st_Monday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "-1st_Tuesday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "-1st_Wednesday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "-1st_Thursday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "-1st_Friday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "-1st_Saturday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "-1st_Sunday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "-2nd_Monday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "-2nd_Tuesday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "-2nd_Wednesday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "-2nd_Thursday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "-2nd_Friday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "-2nd_Saturday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "-2nd_Sunday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "-3rd_Monday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "-3rd_Tuesday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "-3rd_Wednesday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "-3rd_Thursday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "-3rd_Friday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "-3rd_Saturday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "-3rd_Sunday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "-4th_Monday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "-4th_Tuesday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "-4th_Wednesday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "-4th_Thursday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "-4th_Friday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "-4th_Saturday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "-4th_Sunday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "-5th_Monday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "-5th_Tuesday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "-5th_Wednesday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "-5th_Thursday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "-5th_Friday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "-5th_Saturday"; type = [EveryType]::MonthlyNthWeekOfDay }
    [PSCustomObject]@{ every = "-5th_Sunday"; type = [EveryType]::MonthlyNthWeekOfDay }
    #endregion
}
