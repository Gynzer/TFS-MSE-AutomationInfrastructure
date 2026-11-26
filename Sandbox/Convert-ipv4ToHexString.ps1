# Convert-ipv4ToHexString.ps1
# Idea Borrowed from https://www.pwsh.ch/converting-an-ipv4-ip-address-into-an-hex-string-78.html
function Convert-ipv4ToHexString($ipv4){
 
    # Validation
    $valid = $true
    $ipv4.split(".") | foreach { if([int]$_ -ge 0 -and [int]$_ -le 255) { } else { $valid = $false } }
 
    if($valid -eq $true){
 
        # Conversion
        $hexString = ""
        $hexList = @("0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f")
        $ipv4.split(".") | foreach {
            $mod = [int]$_ % 16
            $first = $hexList[(([int]$_ - $mod) / 16)]
            $second = $hexList[$mod]
            $hexString += $first+$second
        } 
        return $hexString
    }
    else{
        return $false
    }
}