#!/bin/bash
RG = 'SUH_RG'

#create Resource Group 
#az group create --name demoResourceGroup --location westus ( creating the resource group)
#az group list ( listing the  az groups )
#az group show --name exampleGroup ( to show specific resource group)
#az group delete --name exampleGroup( to delete the specific group)
az group create -l eastus -n ${RG}

#create virtual network & subnet 
#az network vnet create \
   # --resource-group MyResourceGroup \
    #--name MyVirtualNetwork \
    #--address-prefix 10.0.0.0/16

 #az network vnet subnet create \
     #--resource-group MyResourceGroup \
     #--vnet-name MyVirtualNetwork \
     #--name MySubnet \
     #--address-prefix 10.0.1.0/24

az network vnet create -g ${RG} -n ${RG}-vNET1 --address-prefix 10.30.0.0/16 \
    --subnet-name ${RG}-subnet-1 --subnet-prefix 10.30.1.0/24 -l eastus


#create Netwok secuirty group & allow all traffic 

az network nsg create -g ${RG} -n ${RG}_NSG1
az network nsg rule  create -g ${RG} -nsg-name ${RG}_NSG1 -n ${RG}_NSG1_RULE1 --priority 100 \
     --source-address-prefixes '*' --source -port-ranges '*' --destination-address-prefixes '*' \
     --destination-port-ranges '*' --access Allow --protocol TCP  --description "Allow All Traffic For now"

az network nsg rule  create -g ${RG} -nsg-name ${RG}_NSG1 -n ${RG}_NSG1_RULE1 --priority 101 \
     --source-address-prefixes '*' --source -port-ranges '*' --destination-address-prefixes '*' \
     --destination-port-ranges '*' --access Allow --protocol Icmp  --description "Allow All Traffic For now"


#create Linux Virtula Machine 

#IMAGE ='Canonical:0001-com-ubuntu-server-focal-daily:20_04-daily-lts-gen2:20.04.202211030' - this image is unable to find

IMAGE='Canonical:0001-com-ubuntu-server-focal-daily:20_04-daily-lts-gen2:latest'

az vm create -g ${RG}  -n testlinuxvm01 --image ${IMAGE} --vnet-name ${RG} -vNET1 \
    --subnet ${RG} -subnet-1 --admin-username suhel --adminpassword "mohammed@2298" \
    --size Standard_B1s --storage-sku StandardSSD_LRS --private-ip-address 10.30.1.100 --nsg ${RG}_NSG1 