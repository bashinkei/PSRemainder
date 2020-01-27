
function NewToolStripMenuItem {
    param (
        [Parameter(Mandatory)]
        [string] $name,
        [Parameter(Mandatory)]
        [scriptblock] $action
    )
    $menuItem = New-Object System.Windows.Forms.ToolStripMenuItem
    $menuItem.Text = $name
    # ���j���[�N���b�N���̃C�x���g
    $menuItem.Add_Click($action)
    return $menuItem
}
