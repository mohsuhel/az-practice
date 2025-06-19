#!/bin/bash

# Correct variable assignment (no spaces around =)
RG='SUH_RG'

# Create Resource Group 
az group create -l eastus -n ${RG}

# Create virtual network & subnet 
az network vnet create -g ${RG} -n ${RG}-vNET1 --address-prefix 10.30.0.0/16 \
    --subnet-name ${RG}-subnet-1 --subnet-prefix 10.30.1.0/24 -l eastus

# Create Network Security Group & allow all traffic
az network nsg create -g ${RG} -n ${RG}_NSG1

# Allow all TCP traffic
az network nsg rule create -g ${RG} --nsg-name ${RG}_NSG1 -n ${RG}_NSG1_RULE1 --priority 100 \
    --source-address-prefixes '*' --source-port-ranges '*' --destination-address-prefixes '*' \
    --destination-port-ranges '*' --access Allow --protocol Tcp --description "Allow All Traffic For now"

# Allow all ICMP traffic
az network nsg rule create -g ${RG} --nsg-name ${RG}_NSG1 -n ${RG}_NSG1_RULE2 --priority 101 \
    --source-address-prefixes '*' --source-port-ranges '*' --destination-address-prefixes '*' \
    --destination-port-ranges '*' --access Allow --protocol Icmp --description "Allow All Traffic For now"

# Create Linux Virtual Machine
IMAGE='Canonical:0001-com-ubuntu-server-focal-daily:20_04-daily-lts-gen2:latest'

az vm create -g ${RG} -n testlinuxvm01 --image ${IMAGE} \
    --vnet-name ${RG}-vNET1 --subnet ${RG}-subnet-1 \
    --admin-username suhel --admin-password "mohammed@2298" \
    --size Standard_B1s --storage-sku StandardSSD_LRS \
    --private-ip-address 10.30.1.100 --nsg ${RG}_NSG1