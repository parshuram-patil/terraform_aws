function setup-volume
{
    param(
        [parameter(mandatory = $true)] [string] $devices
    )

    $devices >> C:\test.txt

    $AVAILABLE_DISKS = (Get-Disk | ? { ($_.OperationalStatus -eq "Offline") -and ($_."PartitionStyle" -eq "RAW") }).Number
    foreach ($DISK in $AVAILABLE_DISKS)
    {
        Write-Output "Mounting Disk $DISK"

        try
        {
            Initialize-Disk -Number $DISK -PartitionStyle "MBR"
        }
        catch
        {
            Write-Output "Failed to initialize disk : $_"
        }

        try
        {
            $PARTITION = New-Partition -DiskNumber $DISK -UseMaximumSize -IsActive -AssignDriveLetter
        }
        catch
        {
            Write-Output "Failed to create partition : $_"
        }

        try
        {
            Format-Volume -DriveLetter $PARTITION.DriveLetter -Confirm:$FALSE
        }
        catch
        {
            Write-Output "Failed to format drive $( $PARTITION.DriveLetter ) : $_"
        }

        Write-Output "Disk $DISK mounted as Drive $( $PARTITION.DriveLetter )"
    }
}

<#
function setup-volume {
  param(
    [parameter(mandatory=$true,helpmessage="drive letter")]
    [string] $driveletter,
    [parameter(mandatory=$false,helpmessage="file system label")]
    [string] $label = ""
  )

  $driveletter = $driveletter.ToLower()

  # Assume last character of the device name = drive letter
  # SCSI targets for device names:
  # http://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/ec2-windows-volumes.html#windows-volume-mapping
  $letters = @("b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z")
  # I.e. /dev/xvdb = scsi target 1
  $scsitarget = 1 + $letters.IndexOf( $driveletter )
  if( -not $scsitarget) {
    throw "Invalid drive letter. Could not look up scsitarget for $driveletter"
  }

  $disk = Get-Disk | ?{ $_.Location.EndsWith(("Target {0} : LUN 0" -f $scsitarget)) -and $_.OperationalStatus -eq "Offline" }

  if( -not $disk ) {
    throw "Could not find disk with SCSI target $scsitarget"
  }

  try {
    Initialize-Disk -Number $disk.Number -PartitionStyle "MBR"
  } catch {
    throw "Failed to initialize disk $_"
  }

  try {
    $part = New-Partition -DiskNumber $disk.Number -UseMaximumSize -IsActive -DriveLetter $driveletter
  } catch {
    throw "Failed to create partition $_"
  }

  try {
    Format-Volume -DriveLetter $part.DriveLetter -NewFileSystemLabel $label -Confirm
  } catch {
    throw "Failed to format drive $driveletter $_"
  }
}#>
