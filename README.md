# DevOps

Animal classifier deployed on Azure using Terraform.

- Define Azure RM subscription ID:

```bash
export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv) 
```

```bash
$SubscriptionId = az account show --query id -o tsv
$env:ARM_SUBSCRIPTION_ID = $SubscriptionId   
```

- Upload images to Azure storage:

```bash
az storage blob upload-batch --account-name stgthe3neurons --destination training-data --source ./data
```