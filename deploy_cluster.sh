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

az aks create \
    --name binderhub_cluster \
    --resource-group binderhub \
    --ssh-key-value $PUBLIC_KEY \
    --node-count 3 \
    --node-vm-size Standard_D2s_v3 \
    --service-principal $TENANT_ID \
    --client-secret $PASSWORD \
    --dns-service-ip 10.0.0.10 \
    --docker-bridge-address 172.17.0.1/16 \
    --network-plugin azure \
    --network-policy azure \
    --service-cidr 10.0.0.0/16 \
    --vnet-subnet-id $SUBNET_ID \
    --output table
