# バリデーション結果のobject
function ValidateReslut {
    [OutputType([PSCustomObject])]
    param (
        [Parameter(Mandatory)]
        [bool] $reslut,
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string] $errorMessage
    )
    return [PSCustomObject]@{
        reslut       = $reslut
        errorMessage = $errorMessage
    }
}
