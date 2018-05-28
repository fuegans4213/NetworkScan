# =======================================================

# NAME: Network.ps1
# AUTHOR: COUTURIER Adrien
# DATE: 28/05/2018
#
# Scan network
#
# =======================================================
  
  
  # Fonction permettant de convertir une IPv4 vers Int64 
    function Convert-AdresseIPV4
    {
        [CmdletBinding(DefaultParameterSetName='AdresseIPV4')]
        param(
            [Parameter(
                ParameterSetName='AdresseIPV4',
                Position=0,
                Mandatory=$true,
                HelpMessage='Adresse IPV4 sous forme de string exemple "192.168.1.1"')]
            [IPaddress]$AdresseIPV4

            ) 
        $Octets = $AdresseIPV4.ToString().Split(".") 
        $Int64 = [long]([long]$Octets[0]*16777216 + [long]$Octets[1]*65536 + [long]$Octets[2]*256 + [long]$Octets[3]) 
               
        
            return $Int64

          # [pscustomobject] @{   
           #     AdresseIPV4 = $AdresseIPV4
           #     Int64 = $Int64
           # }
      }


  
    #Résolution d'un nom DNS depuis une IP
   #[System.Net.Dns]::GetHostEntry("172.22.71.8").Hostname
   
   [IPaddress]$StartIPv4Address = "172.22.71.8"
   [IPaddress]$EndIPv4Address = "172.22.71.15"
   
    $StartIPv4Address_Int64 = (Convert-AdresseIPV4 -AdresseIPV4 $StartIPv4Address.ToString())
    $EndIPv4Address_Int64 = (Convert-AdresseIPV4 -AdresseIPV4 $EndIPv4Address.ToString())
   

  
   












