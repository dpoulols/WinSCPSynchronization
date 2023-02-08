#Install WinSCP and get path where it is installed

#----------------------------------


# Load WinSCP .NET assembly

Add-Type -Path "C:\-\WinSCP\WinSCPnet.dll"

# Set up session options
$sessionOptions = New-Object WinSCP.SessionOptions -Property @{
    Protocol = [WinSCP.Protocol]::Ftp
    HostName = " "
    UserName = " "
    Password = " "
    FtpSecure = [WinSCP.FtpSecure]::Explicit
}

$session = New-Object WinSCP.Session

$localPath = "C:\-\"
$removeLocalPath = $localPath + "*except*"

$remotePath = "/files/outgoing/channel-choice"
$exceptionRemoteFormat = "/*except*"



try
{
    # Connect
    $session.Open($sessionOptions)

    $synchronizationResult = $session.SynchronizeDirectories(
        [WinSCP.SynchronizationMode]::Remote, $localPath, $remotePath, $False, [WinSCP.SynchronizationCriteria]::Time)
    $synchronizationResult.Check()
    #Write-Host "Added and updated files have been succesfully synchronized."

    $session.RemoveFiles($remotePath + $exceptionRemoteFormat)

    #Remove-Item $removeLocalPath       ## Uncomment if want to delete unnecessary files of YOUR LOCAL DIRECTORY

    $session.quit
}
catch
{
    Write-Host "Error : $($_.Exception.Message)"
}
finally
{
    $session.Dispose()
}