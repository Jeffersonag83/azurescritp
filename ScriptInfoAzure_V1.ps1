#========================================================================
# Created on:   22-02-2019
# Created by:   Jefferson Andrade
# Version:		1.0  
# Company:      Dell Colombia Inc
# Twitter:		@JjeffersonAg83
# Blog:			https://blog.it-jjag.com
# Microsoft:    MVP Cloud and Datacenter Management
#========================================================================


Import-Module AzureRM

Login-AzureRmAccount

$Results1 = @()
$Results2 = @()
$DataPath1 = ".\AzureSubcription.csv"
$DataPath2 = ".\AzureResource.csv"

$AzureSub = Get-AzureRmSubscription

ForEach ($AzureSub in $AzureSub ) {

    $Properties1 = @{
        Name = $AzureSub.Name
        Id = $AzureSub.Id
        TenantId = $AzureSub.TenantId
           
    }

    $Results1 += New-Object psobject -Property $properties1
    
    Select-AzureRmSubscription -SubscriptionName $AzureSub.name
    
    $AzureRG = Get-AzureRmResourceGroup
    
    ForEach ($AzureRG in $AzureRG){
        
             
        $AzureRes = Get-AzureRmResourceGroup -Name $AzureRG.ResourceGroupName | Get-AzureRmResource

        ForEach ($AzureRes in $AzureRes){
        
            $Properties = @{
                ResourceGroupName = $AzureRes.ResourceGroupName
                ResourceType = $AzureRes.ResourceType
                Name = $AzureRes.Name
                Kind = $AzureRes.Kind
                Location = $AzureRes.Location
                SubscriptionId = $AzureRes.SubscriptionId
            
      
            }

            $Results2 += New-Object psobject -Property $properties
        
        
        }
    
    }
}

$Results2 | Select-Object ResourceGroupName, ResourceType, Name, Kind, Location, SubscriptionId | Export-Csv -notypeinformation -Path $DataPath2
$Results1 | Select-Object Name, Id,TenantId | Export-Csv -notypeinformation -Path $DataPath1



