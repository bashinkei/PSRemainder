# PscustomObject‚Ì”z—ñ‚ÉNo‚ÌƒJƒ‰ƒ€‚ð’Ç‰Á
function AddNumberToPsobjectArray {
    param (
        [Parameter(Mandatory)]
        [array] $array
    )
    $pops = @()
    $pops += (Get-Member -InputObject $array[0] -MemberType NoteProperty).Name
    $pops += @{name = 'No'; expression = { $count } }
    $count = 0
    $AddNoArray = foreach ($object in $array ) {
        $count += 1
        $object | Select-Object -Property $pops
    }

    return $AddNoArray
}