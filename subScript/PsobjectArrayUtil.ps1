# PscustomObject�̔z���No�̃J������ǉ�
function AddNumberToPsobjectArray {
    param (
        [Parameter(Mandatory)]
        [array] $array
    )
    $pops = @()
    $pops += $array[0].psobject.Properties.Name # �v���p�e�B�̈ꗗ�擾(�ǉ����Ŏ擾�ł���)
    $pops += @{name = 'No'; expression = { $count } }
    $count = 0
    $AddNoArray = foreach ($object in $array ) {
        $count += 1
        $object | Select-Object -Property $pops
    }

    return $AddNoArray
}