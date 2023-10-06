# Azure DevOps for building CI/CD pipelines
## Step 1: 01-jobs-pipelines.yml
### This pipeline is defined using YAML and consists of stages, jobs, and steps:
***Key Points:***
- Trigger: The pipeline is triggered when changes are pushed to the master branch.
- Agent Pool: The default agent pool is used for pipeline execution.
- Jobs: Multiple jobs are defined in the pipeline, allowing for parallel or sequential execution.
- Steps: Each job includes a set of steps (tasks), which can be customized to build, test, and deploy the project.
## Step 2: 02-understanding-stages.yml
This pipeline is designed for a typical deployment process where code is built and then deployed to different environments (Dev, QA, Prod) sequentially. The deployment to the production environment only occurs when both the Dev and QA deployments are successful, thanks to the "dependsOn" configuration.

1. **DevDeploy Stage:**
    - This stage is named "DevDeploy" and is associated with the Dev environment.
    - It depends on a previous stage named "Build," which suggests that it will deploy the code built in the "Build" stage.
    - Inside the "DevDeploy" stage, there is a job named "DevDeployJob" that has a single step. The step is a Bash script that echoes the environment variable "$(environment)DeployJob," which will display "DevDeployJob" in this context.

2. **QADeploy Stage:**
    - This stage is named "QADeploy" and is associated with the QA environment.
    - Similar to the "DevDeploy" stage, it depends on the "Build" stage.
    - Inside the "QADeploy" stage, there is a job named "QADeployJob" with a step that echoes the environment variable "$(environment)DeployJob," which will display "QADeployJob."

3. **ProdDeploy Stage:**
    - This stage is named "ProdDeploy" and is intended for deploying to the production environment.
    - It depends on both the "DevDeploy" and "QADeploy" stages, indicating that it will deploy to production only when both Dev and QA deployments are successful.
    - Inside the "ProdDeploy" stage, there is a job named "ProdDeployJob" with a step that echoes "ProdDeployJob."

## Step 3: 04-dockerImage-pipeline.yml:
Azure DevOps pipeline configuration for building a Docker image and pushing it to a container registry. Here's an explanation of what this pipeline does:

1. **Trigger:**
    - This pipeline is triggered when changes are pushed to the `master` branch of your repository.

2. **Resources:**
    - It specifies that the pipeline will use the repository where this YAML file is located (`repo: self`) as the source for the pipeline.

3. **Variables:**
    - It defines a variable named `tag` with the value `$(Build.BuildId)`. The `$(Build.BuildId)` is a predefined variable that represents the unique identifier for the current build. This variable will be used as a tag for the Docker image.

4. **Stages:**
    - The pipeline defines a single stage named "Build" for building the Docker image.

5. **Jobs:**
    - Within the "Build" stage, there is a single job named "Build" that performs the Docker image build and push.

6. **Pool:**
    - It specifies the execution environment for the job. In this case, it uses the default agent pool with the `ubuntu-latest` virtual machine image.

7. **Steps:**
    - The job contains a single step that uses the Docker task (`Docker@2`) to build and push the Docker image.
    - It specifies the following inputs to the Docker task:
        - `containerRegistry`: The name of the Docker container registry where the image will be pushed (`maldini-docker-hub` in this case).
        - `repository`: The name of the Docker repository where the image will be stored (`maldini12/azure-docker-devops` in this case).
        - `command`: Specifies the Docker command to execute. In this case, it's set to `buildAndPush`.
        - `Dockerfile`: The path to the Dockerfile used for building the image (`**/Dockerfile` searches for a Dockerfile in the repository).
        - `tags`: It specifies the tag for the Docker image, which is set to the value of the `tag` variable defined earlier (`$(tag)`).

This pipeline essentially automates the process of building a Docker image from your source code and pushing it to a Docker container registry whenever changes are pushed to the `master` branch. The image is tagged with the build ID to keep track of different versions of the image.

## Step 4: 05-jdk-maven--docker-webapp-pipelines.yml:

This Azure DevOps pipeline configuration appears to be focused on building and deploying a Java application using Maven, Docker, and Azure App Service:

1. **Trigger:**
    - The pipeline is triggered when changes are pushed to the `master` branch.

2. **Pool:**
    - It specifies the execution environment for the pipeline, using the default agent pool with the `ubuntu-latest` virtual machine image.

3. **Variables:**
    - Various variables are defined to configure different aspects of the pipeline, including Azure subscription information, Docker image repository, and more.

4. **Stages:**
    - The pipeline defines multiple stages, each with its own set of jobs and tasks.

Here's a summary of each stage:

- **Install_Jdk17 Stage:**
    - This stage is responsible for installing JDK 17.

- **Build_App Stage:**
    - This stage is focused on building the Java application using Maven.
    - It uses the `Maven@3` task to run Maven commands, such as cleaning, installing dependencies, and running tests.

- **Docker_Image Stage:**
    - This stage is dedicated to building a Docker image for the application.
    - It uses the `Docker@2` task to build and push the Docker image to a container registry.

- **Deploy_App Stage:**
    - This stage is for deploying the application as a web app using Azure App Service.
    - It utilizes the `AzureRMWebAppDeployment@4` task to deploy the Docker container to the specified Azure App Service.

Overall, this pipeline automates the process of building a Java application, containerizing it with Docker, and deploying it to an Azure App Service environment. It's configured to deploy to different environments (Dev and QA), and it tags Docker images with the build ID to track different versions. Please note that you may need to configure the specific values for your Azure subscription, Docker registry, and Azure App Service accordingly in your Azure DevOps project settings.

## Azure CLI Commands for Azure App Service Deployment

These Azure CLI commands help you create the necessary Azure resources for deploying your Java application using Azure App Service.

### 1. Create a Resource Group

```az group create --name devops-rg --location westeurope```

- This command creates a new Azure resource group named `devops-rg` in the `westeurope` region. You can adjust the region as needed.

### 2. Create an App Service Plan

```bash
az appservice plan create --name devops-service-plan --resource-group devops-rg --sku B1 --is-linux
```

- This command creates an Azure App Service Plan named `devops-service-plan` in the `devops-rg` resource group.
- It specifies the `B1` SKU and sets the plan to use Linux. You can change the SKU and other parameters to match your requirements.

### 3. Create a Web App

```bash
az webapp create -g devops-rg -p devops-service-plan -n spring-devops-azure --runtime "JAVA:17-java17"
```

- This command creates an Azure Web App named `spring-devops-azure` in the `devops-rg` resource group.
- It associates the web app with the previously created service plan (`devops-service-plan`) and specifies the runtime as "JAVA:17-java17."

Make sure to authenticate your Azure CLI session and select the appropriate subscription before running these commands. Additionally, customize the resource group names, service plan settings, and web app names to fit your project's naming conventions and requirements.

For more information and additional options, refer to the [Azure CLI documentation](https://docs.microsoft.com/en-us/cli/azure/webapp?view=azure-cli-latest) for Azure Web Apps.