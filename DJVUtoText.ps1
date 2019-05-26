$source = "C:\FolderName\FolderName\FolderName"
$OutputFolderName = "MyOutput"
$outputDir = Split-Path -Parent $source | ForEach-Object{Join-Path $_ $OutputFolderName}
$directories = Get-ChildItem -Path $source -Directory
foreach($inputDirectory in $directories)
{
    $djvuFiles = Get-ChildItem $inputDirectory.FullName -Filter *.djv*
    $outputPath = join-path $outputDir $inputDirectory.Name
    if(-not(Test-path $outputPath))
    {
        New-Item $outputPath -ItemType Directory
    }
    $djvuFiles | ForEach-Object{
        $inputFileFullName = $_.FullName
        $outputfileName = Join-Path $outputPath "$($_.BaseName).txt"
        try {
            Write-Information -MessageData "Converting file $inputFileFullName" -InformationAction Continue
            djvutxt.exe $inputFileFullName $outputfileName
        }
        catch {
            Write-Warning "Error while converting $inputFileFullName"
            Write-Warning $_
        }
    } 
}