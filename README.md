# DevOps

Cat vs. dog classifier deployed on Azure using Terraform.

## Getting Started

1. Define Azure RM subscription ID:

   For Linux:

   ```bash
   export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv) 
   ```

   For Windows (PowerShell):

   ```bash
   $SubscriptionId = az account show --query id -o tsv
   $env:ARM_SUBSCRIPTION_ID = $SubscriptionId   
   ```

2. Verify the code:

   ```bash
   terraform plan
   ```
   
3. Apply the coded infrastructure:

   ```bash
   terraform apply
   ```

4. Download the dataset by [clicking here](https://www.kaggle.com/datasets/antobenedetti/animals/).
5. Unzip the dataset archive and keep only the cat & dog directories & rename
   the folder to `training-data`.
   The dataset directory structure should look like this:

   ```txt
   training-data/
   ├── inf/        # Inference/test samples
   │   ├── cat.png
   │   └── dog.png
   ├── train/      # Training set organized by class
   │   ├── cat/
   │   └── dog/
   └── val/        # Validation set organized by class
       ├── cat/
       └── dog/
   ```

6. Move the `training-data` directory to the root of the project and upload the
   images to Azure storage:

   ```bash
   az storage blob upload-batch --account-name stgthe3neurons --destination training-data --source ./training-data
   ```

## Setup Terraform Backend

To store the Terraform state on Azure, follow those steps:

1. ```bash
   az group create --name rg-terraform-backend --location "francecentral"
   ```
   
2. ```bash
   az storage account create --name stesgitbackend1 --resource-group rg-terraform-backend --location "francecentral" --sku Standard_LR
   ```
   
3. ```bash
   az storage container create --name tfstate --account-name stesgitbackend1
   ```
   
4. ```bash
   terraform destroy -var="location=francecentral" -auto-approve
   ```
   
5. ```bash
   rm -rf .terraform terraform.tfstate
   ```
   
6. ```bash
   terraform init
   ```

7. ```bash
   terraform apply -auto-approve 
   ```
