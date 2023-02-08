#Install WinSCP and get path where it is installed

#----------------------------------


# Load WinSCP .NET assembly

Add-Type -Path "C:\-\WinSCPnet.dll"

# Set up session options
$sessionOptions = New-Object WinSCP.SessionOptions -Property @{
    Protocol = [WinSCP.Protocol]::Ftp
    HostName = ""
    UserName = ""
    Password = ""
    FtpSecure = [WinSCP.FtpSecure]::Explicit
}

$remotePath = ""
$testPath = "C:\test"
$removeLocalPath = "C:\test\*except*"
$session = New-Object WinSCP.Session
$localPath = ""
$exceptionFormat = "/*except*"





###########################         CODE
###############################################################################
##
##
##
##

try
{
    # Connect
    $session.Open($sessionOptions)

    try
    {
        $synchronizationResult = $session.SynchronizeDirectories([WinSCP.SynchronizationMode]::Remote, $localPath, $remotePath, $False, [WinSCP.SynchronizationCriteria]::Time)
        $synchronizationResult.Check()
        Write-Host "Added and updated files have been succesfully synchronized."
    }
    catch
    {
        Write-Host "An unplanned error happened during the synchronization, contact with administrator... "
        Write-Host "Error: $($_.Exception.Message)"
        exit 1
    }
    
    try
    {
        Write-Host "Removing unnecessary files..."
        $session.RemoveFiles($remotePath + $exceptionFormat)

        Write-Host "Removing local unnecessary files.."
        Remove-Item $removeLocalPath
    }
    catch
    {
        "Error trying to remove unnecessary files."
        "Error: $($_.Exception.Message)"
    }

    $session.quit
}
catch
{
    Write-Host "Error trying to open session: $($_.Exception.Message)"
}
finally
{
    $session.Dispose()
}