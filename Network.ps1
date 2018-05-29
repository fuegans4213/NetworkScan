# =======================================================

# NAME: Network.ps1
# AUTHOR: COUTURIER Adrien
# DATE: 28/05/2018
#
# Scan network
#
# =======================================================
<#
            .SYNOPSIS
            Scanner réseaux
            
            .DESCRIPTION
            Scanner réseaux vous permettant de scanner une plage d'adresse IP (192.168.51.5 to 192.168.51.85)
            
            .EXAMPLE
            .\Network.ps1 -DebutPlageIP 192.168.178.0 -FinPlageIP 192.168.178.20
#>

[CmdletBinding(DefaultParameterSetName='CIDR')]
Param([Parameter(
            Position=0,
            Mandatory=$true,
            HelpMessage='Début de plage IP exemple :  192.168.51.1')]
        [IPAddress]$DebutPlageIP,

        [Parameter(
                Position=1,
                Mandatory=$true,
                HelpMessage='Fin de plage IP exemple : 192.168.51.50')]
        [IPAddress]$FinPlageIP)



    #Fonction permettant de convertir une IPv4 vers le format Int64 
    function Convert-AdresseIP
    {
          <#
            .SYNOPSIS
            Fonction permettant de convertir une IPv4 vers le format Int64 et vise versa
            
            .DESCRIPTION
            Fonction permettant de convertir une IPv4 vers le format Int64 et vise versa
            
            .EXAMPLE
            Convert-AdresseIP -AdresseIP "172.71.50.14"
            
            .EXAMPLE
            Convert-AdresseIP 2887141128
        #>
        
        #CmdletBinding permet un appel de ce type Convert-AdresseIP -AdresseIP "XXX.XXX.XXX.XXX"
        [CmdletBinding(DefaultParameterSetName='AdresseIP')]
        param(
                [Parameter(
                    ParameterSetName='AdresseIP',
                    Position=0, #Permet de ne pas appeler -AdresseIP 
                    Mandatory=$true,
                    HelpMessage='Veuillez entrer une adresse IPV4 sous forme de string exemple "192.168.1.1"')]
                [IPaddress]$AdresseIP,
                
                [Parameter(
                    ParameterSetName='Int64',
                    Position=1, #Permet de ne pas appeler -Int64 
                    Mandatory=$true,
                    HelpMessage='Veuillez entrer une adresse IPV4 sous forme de int64 exemple 2887141128')]
                [long]$Int64
             ) 
          switch($PSCmdlet.ParameterSetName)
            {   
            
                # Converti une adresse IP de type string en Int64
                "AdresseIP" {
                                $Octets = $AdresseIP.ToString().Split(".") 
                                $Int64 = [long]([long]$Octets[0]*16777216 + [long]$Octets[1]*65536 + [long]$Octets[2]*256 + [long]$Octets[3])
                            }
                # Converti une adresse IP de type Int64 en string
                "Int64" {
                            $AdresseIP = (([System.Math]::Truncate($Int64/16777216)).ToString() + "." + ([System.Math]::Truncate(($Int64%16777216)/65536)).ToString() + "." + ([System.Math]::Truncate(($Int64%65536)/256)).ToString() + "." + ([System.Math]::Truncate($Int64%256)).ToString())
                        }
             }
                   
         $Result = [pscustomobject] 
                  @{   
                        AdresseIP = $AdresseIP
                        Int64 = $Int64
                   }
           
           return $Result
           
      }

    #COnvertion des IP en Int64 
    $DebutPlageIP_Int64 = (Convert-AdresseIP -AdresseIP $DebutPlageIP.ToString()).Int64
    [long]$FinPlageIP_Int64 = (Convert-AdresseIP -AdresseIP $FinPlageIP.ToString()).Int64


$DebutPlageIP_Int64

        # ...
        for ($i = $DebutPlageIP_Int64; $i -le $FinPlageIP_Int64; $i++) 
        { 
            # Convert IP back from Int64
            $IPv4Address = (Convert-AdresseIP -Int64 $i).IPv4Address                

            $IPv4Address
<#

    		# Create hashtable to pass parameters
    		$ScriptParams = @{
    			IPv4Address = $IPv4Address
    			Tries = $Tries
    			DisableDNSResolving = $DisableDNSResolving
    			EnableMACResolving = $EnableMACResolving
    			ExtendedInformations = $ExtendedInformations
                IncludeInactive = $IncludeInactive
              #>
    } 

  
<# #Résolution d'un nom DNS depuis une IP
   #[System.Net.Dns]::GetHostEntry("172.22.71.8").Hostname
   
   
   
   
   
   
$StartIPv4Address = "172.22.71.8"
   [IPaddress]$EndIPv4Address = "172.22.71.15"
   
    $StartIPv4Address_Int64 = (Convert-AdresseIP $StartIPv4Address)
    $EndIPv4Address_Int64 = (Convert-AdresseIP -AdresseIP $EndIPv4Address.ToString())

    $StartIPv4Address_Int64
#>











