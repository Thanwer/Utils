## This script will log off users which are from the group "“GG_LogoffTS”" from the server.
function Get-TSSessions {
    query user |
    #Parse output
    ForEach-Object {
        $_ = $_.trim() 
        $_ = $_.insert(22,",").insert(40,",").insert(45,",").insert(56,",").insert(64,",")
        $_ = $_ -replace "\s\s+",""
        $_
    } | ConvertFrom-Csv
}

$Users = Get-AdGroupMember -identity “GG_LogoffTS” | Select -ExpandProperty SamAccountName

GET-TSSessions | ForEach-Object {
    if ($_.username -in $Users){
        logoff $_.id
    }
}