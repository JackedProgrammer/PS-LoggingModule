#Besure to update the Instance Name and Database Name to reflect your information


#Copy your SQL Module Path here
Import-Module C:\YouTube\SQL\SQLModule.psm1 -Force

function Connect-LoggingDatabase{
    [CmdletBinding()]
    Param()

    try{
        $SQLConnParams=@{
            InstanceName='HYPV2016L\sqlexpress'
            DatabaseName='Logging'
            IntergratedSecurity=$true
        }

        $SQLConnection=Connect-SQLServer @SQLConnParams
        return $SQLConnection
    }catch{
        Write-Error $_.exception.message
    }
}

function Close-LoggingDatabase{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        $Connection
    )

    try{
        Close-SQLServerConnection -Connection $Connection
    }catch{
        Write-Error $_.exception.message
    }
}


function Get-Log{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        $Connection
    )

    try{
        $Results=Invoke-SQLSelect -Connection $Connection -SelectStatement "Select * from log order by id"
        return $Results
    }catch{
        Write-Error $_.exception.message
    }
}

function Add-Log{
        [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        $Connection,
        [Parameter(Mandatory)]
        [string]$AppName,
        [Parameter(Mandatory)]
        [string]$ComputerName,
        [Parameter(Mandatory)]
        $Details
    )

    try{
        $InsertCommand="Insert into Log (appName,computerName,details) values ('$($AppName)','$($ComputerName)','$($Details | ConvertTo-Json)')"

        Invoke-SQLInsert -Connection $Connection -InsertStatement $InsertCommand
    }catch{
        Write-Error $_.exception.message
    }
}
