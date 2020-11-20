VNET_ID=$(az network vnet show \
    --resource-group binderhub \
    --name binderhub_vnet \
    --query id \
    --output tsv)
    
SUBNET_ID=$(az network vnet subnet show \
    --resource-group binderhub \
    --vnet-name binderhub_vnet \
    --name binderhub_subnet \
    --query id \
    --output tsv)
