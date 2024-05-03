# Adjusted Script from https://abhimantiwari.github.io/blog/CaptureDumps/

Param(
    [Parameter(Mandatory=$True)]
    [string]$processName,
    [string]$procdumpArguments="-accepteula -s 20 -n 2 -ma",
    [string]$outputFolder = "c:\dumps",
    [Parameter(Mandatory=$True)]   
    [bool]$zipOutput = [System.Convert]::ToBoolean($zipOutput)
)

$procdumpEXE = "procdump"
$originalLocation = Get-Location

#REGEX
$outFolderRegex = "(?<pre>.*\s)(?!\d{1,})(?<outfolder>[^-][^-\s|.]*)\s?(?<post>\-.*)?"
#match 1 (pre) is whatever come before the out folder
#match 2 (outfolder) is the out folder
#match 3 (post) whatever is next


#EXEC
Write-Output ""
if (!$processName) {
    PrintUsage
    return
    }

if ($procdumpArguments -match $outFolderRegex) {
    $outputFolder = $Matches["outfolder"]
    $procdumpArguments = $procdumpArguments -replace $outFolderRegex, '$1$3'
    }
if (!(Test-Path -Path $outputFolder)) {
    New-Item -ErrorAction Ignore -ItemType directory -Path $outputFolder >$null 2>&1
}
Set-Location $outputFolder

#Get PIDs 
$pids = (get-process -Name $processName).Id
if (!$pids.count) {
    Write-Output "Process not running"
    return
}

Write-Output "There are $($pids.count) running processes with name $($processName)"
Write-Output "Invoking procdump with arguments: $($procdumpArguments)"
Write-Output "Collecting dumps, please wait while dumps are being captured..."

#Call procdump for each PID
$pids |foreach {
        $outputLogFile = $outputFolder + "\procdump_$($_).txt"
        Start-Process $procdumpEXE -ArgumentList "$($procdumpArguments) $($_) $($outputFolder)" -RedirectStandardOutput $outputLogFile -NoNewWindow
}

#wait to return and set original location
Wait-Process -Name procdump
Write-Output "Dumps were written in $($outputFolder)!"

#zip and delete temp folder
if ($zipOutput) {
    if (!(Get-Command Compress-Archive -ErrorAction SilentlyContinue)) {
        Write-Output "Compress-Archive cmdlet not found. Data compression will be skipped."
    }
    else {
        Write-Output "Compressing data..."
        Compress-Archive -Path "$($outputFolder)\*.dmp" -Update -DestinationPath "$($outputFolder)\$($processName)-dumps.zip" -CompressionLevel Fastest
        Get-ChildItem $outputFolder | Where { $_.Name -match ".*\.dmp" } | Remove-Item -ErrorAction Ignore >$null 2>&1
        Write-Output "Dumps were compressed and deleted. The ZIP file is located in $($outputFolder)"
    }
}

#QUIT
Set-Location $originalLocation
Write-Output ""


function Unzip($file, $destination)
{
     $shell = new-object -com shell.application
     $zip = $shell.NameSpace($file)
     $items = $zip.items() | Where-Object {$_.Name -match ".*\.exe"}
     foreach($item in $items)
     {
        $shell.Namespace($destination).copyhere($item)
     }
}

#print
function PrintUsage() {
    Write-Output "Usage: BatchProcDump.ps1 [-processName] (-procdumpArguments) (-outputFolder) (-zipOutput)"
    Write-Output ""
    Write-Output "-processName = target process name"
    Write-Output "-procdumpArguments = procdump command line arguments. Default value is: -accepteula -ma -n 2 -s 20\n"
    Write-Output "-outputFolder = sets the output folder !! If not already specified in the procdump arguments !!"
    Write-Output "-zipOutput = archives the dump files into a zip file and deletes the uncompressed files !! Requires PS v5"

    Write-Output ""
}