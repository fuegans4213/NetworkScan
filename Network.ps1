# =======================================================

# NAME: Network.ps1
# AUTHOR: XXXXXXXXXXXXX
# DATE: 28/05/2018
#
# Scan network
# Verison de PowerShell a utiliser
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


#paramètre a appeler en ligne de commande 
[CmdletBinding(DefaultParameterSetName='AdresseIP')]
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
        

    #Fonction permettant de convertir une IPv4 vers le format Int64 et vise versa
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
                    Position=1, #Permet de ne pas appeler -Int64 après le paramètre -AdresseIP
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
                   
             [pscustomobject] 
                  @{   
                        AdresseIP = $AdresseIP
                        Int64 = $Int64
                   }
           
      }

    # Convertion des IPs en Int64 afin d'éffectué une boucle sur la plage d'adresse IP 
    $DebutPlageIP_Int64 = (Convert-AdresseIP -AdresseIP $DebutPlageIP.ToString()).Int64
    $FinPlageIP_Int64 = (Convert-AdresseIP -AdresseIP $FinPlageIP.ToString()).Int64

    
    # On vérifie l'intégrité de la page d'adresse IP renseignée
    if($DebutPlageIP_Int64 -gt $FinPlageIP_Int64)
    {
        [System.Windows.MessageBox]::Show("La plage d'adresse IP renseignée n'est pas bonne ! ","Plage d''adresse IP non valide","Ok","Error")
        exit        
    }

    # Calcul du nombre d'adresse à scanner 
    $NrbAdresseIP = ($FinPlageIP_Int64 - $DebutPlageIP_Int64)

    

        # Pour chaque adresse IP on test PING + DNS + MAC 
        for ($i = $DebutPlageIP_Int64; $i -le $FinPlageIP_Int64; $i++) 
        { 
            # On reconvertie le Int64 en IPAddress
            $AdresseIP = (Convert-AdresseIP -Int64 $i).AdresseIP                



            # On fait 3 PING 
            for ($y = 0; $y -lt 3; $y++)
            {
                try
                {

				    $Ping = New-Object System.Net.NetworkInformation.Ping
				
				    $Timeout = 1000

				    $PingResult = $Ping.Send($AdresseIP, $Timeout)

				    if($PingResult.Status -eq "Success")
				    {
					    $Status = "Up"
					    break # Si la machine répond sortie de boucle
				    }
				    else
				    {
					    $Status = "Down"
				    }
			    }
			    catch
			    {
				    $Status = "Down"
				    break # Si erreur sortie de boucle
                }

            }

            if($Status -eq "Up")
            {   	
                    try
                    {
                        #Résolution d'un nom DNS depuis une IP
                        $HostName = [System.Net.Dns]::GetHostEntry($AdresseIP).Hostname
                    }
                    catch
                    {
                        $HostName = "### No DNS ###"
                    }
            }
            
            $report = @{ AdresseIP = $AdresseIP
                         HostName = $HostName
                         Status = $Status} 

            $report

        }
