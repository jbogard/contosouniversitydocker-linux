# Taken from psake https://github.com/psake/psake

<#
.SYNOPSIS
  This is a helper function that runs a scriptblock and checks the PS variable $lastexitcode
  to see if an error occcured. If an error is detected then an exception is thrown.
  This function allows you to run command-line programs without having to
  explicitly check the $lastexitcode variable.
.EXAMPLE
  exec { svn info $repository_trunk } "Error executing SVN. Please verify SVN command-line client is installed"
#>
function Exec
{
    [CmdletBinding()]
    param(
        [Parameter(Position=0,Mandatory=1)][scriptblock]$cmd,
        [Parameter(Position=1,Mandatory=0)][string]$errorMessage = ($msgs.error_bad_command -f $cmd)
    )
    & $cmd
    if ($lastexitcode -ne 0) {
        throw ("Exec: " + $errorMessage)
    }
}

exec { & dotnet --info }

#exec { & dotnet build ContosoUniversity.CI.sln -c Release --version-suffix=$buildSuffix }
exec { & dotnet build ContosoUniversity.CI.sln -c Release }

Push-Location -Path .\ContosoUniversity.IntegrationTests

try {
	exec { & dotnet xunit -configuration Release -nobuild --fx-version 2.0.5 }
}
finally {
	Pop-Location
}

#exec { & dotnet publish ContosoUniversity --output .\..\publish --configuration Release }

#$octo_revision = @{ $true = $env:APPVEYOR_BUILD_NUMBER; $false = "0" }[$env:APPVEYOR_BUILD_NUMBER -ne $NULL];
#$octo_version = "1.0.$octo_revision"

#exec { & .\tools\Octo.exe pack --id ContosoUniversity --version $octo_version --basePath publish --outFolder artifacts }




