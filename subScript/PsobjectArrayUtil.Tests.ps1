$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
# ���̒���TestWorkDay���g�����A�X�R�[�v�̖�肪����̂ŁA�e�X�g���Ƀ��b�N���`

function GetPSObjectArray {
    [OutputType([array])]
    param ()

    $array = @()
    $array += [PSCustomObject]@{Name = "Value1" }
    $array += [PSCustomObject]@{Name = "Value2" }
    $array += [PSCustomObject]@{Name = "Value3" }
    $array += [PSCustomObject]@{Name = "Value4" }

    return $array
}

Describe "AddNumberToPsobjectArray" {
    It "No�̗񂪒ǉ������" {

        $psobject = GetPSObjectArray
        $object = AddNumberToPsobjectArray -array $psobject
        $propName = (Get-Member -InputObject $object[0] -MemberType "NoteProperty").name
        $propName -contains "No" | Should Be $true
    }
}
