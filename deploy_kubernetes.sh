RESOURCE_GROUP=binderhub
VNET_NAME=binderhubVnet
SUBNET_NAME=binderhubSubnet
CLUSTER_NAME=binderhubCluster
SERVICE_PRINCIPAL_NAME=binderhubSP

az group create \
    --location northeurope \
    --name $RESOURCE_GROUP
    
az network vnet create \
    --resource-group $RESOURCE_GROUP \
    --name $VNET_NAME \
    --address-prefixes 10.0.0.0/8 \
    --subnet-name $SUBNET_NAME \
    --subnet-prefix 10.240.0.0/16
    
VNET_ID=$(az network vnet show \
    --resource-group $RESOURCE_GROUP \
    --name $VNET_NAME \
    --query id \
    --output tsv)
    
SUBNET_ID=$(az network vnet subnet show \
    --resource-group $RESOURCE_GROUP \
    --vnet-name $VNET_NAME \
    --name $SUBNET_NAME \
    --query id \
    --output tsv)

SP_PASSWD=$(az ad sp create-for-rbac \
   --name=$SERVICE_PRINCIPAL_NAME \
   --role Contributor \
   --scopes $VNET_ID \
   --query password \
   --output tsv)

SP_ID=$(az ad sp show \
   --id http://$SERVICE_PRINCIPAL_NAME \
   --query appId \
   --output tsv)

az aks create \
    --name $CLUSTER_NAME \
    --resource-group $RESOURCE_GROUP \
    --ssh-key-value=$GITHUB_WORKSPACE/key.pub \
    --node-count 3 \
    --node-vm-size Standard_D2s_v3 \
    --service-principal=$SP_ID \
    --client-secret=$SP_PASSWD \
    --dns-service-ip 10.0.0.10 \
    --docker-bridge-address 172.17.0.1/16 \
    --network-plugin azure \
    --network-policy azure \
    --service-cidr 10.0.0.0/16 \
    --vnet-subnet-id=$SUBNET_ID \
    --output table
    
az aks get-credentials \
             --name $CLUSTER_NAME \
             --resource-group $RESOURCE_GROUP \
             --output table

kubectl get node

