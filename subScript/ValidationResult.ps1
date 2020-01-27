# �o���f�[�V�������ʂ�object
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
