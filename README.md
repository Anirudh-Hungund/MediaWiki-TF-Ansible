# Media Wiki Installation Terraform and Ansible on an Azure VM.
## Terraform is used for Infrastructure provision on Azure and Ansible is used for configuration of MediaWiki.
Media Wiki installation is one of the self-test projects that is being worked on and automating the the installation process will show the power of using the IAC tool with a Configuration Management tool. 
### Technologies Used:
1. **Terraform**: There are other IAC tools available like Pulumi and Cloud Native tools like Azure ARM, and AWS Cloud Formation, but the decision to use Terraform is due to being accepted as the industry standard and various integrations it has through modules that can be used for Multi-Cloud, be it public or private.
2. **Ansible**: Similarly, Configuration Management can be done using native tools/shell scripts specific to the Operating Systems like Powershell and Bash Scripts but they are not flexible and cannot be scaled to a lot of servers and parallel deployments. This is where Ansible makes Admins/Devs easier with parallel configuration and can be managed from a single controller and agentless as well.

**In this project, have tried to incorporate Terraform's and Ansible's best practices wherever it is feasible.**

## Deployment Prerequisites:
**Need to install the below-required tools/software to run this script:** 
 - All the below code is run from a RHEL-based Linux VM and all commands will only apply to this. You would need to replace it with an equivalent for Debian/Ubuntu-based VMs.

|Prerequisite|	Description|
|--------|-----------|
|IDE Tool| [VSCode](https://code.visualstudio.com/download) or [IntelliJ IDEA](https://www.jetbrains.com/idea/download/?section=linux) are best for the development of Terraform and Ansible code.|
|VM - RHEL based ( Oracle Linux, CentOS or RHEL) | **Linux Operating System is preferred**. Windows cannot execute .sh scripts natively, so needs to run in WSL(Windows Sub System) or using GIT BASH.|
|Azure Account|	You must have a valid [Azure account](https://azure.com/) to create and manage resources on the Azure cloud platform.|
|Terraform| Install [Terraform](https://developer.hashicorp.com/terraform/install) on your local machine. Terraform is an Infrastructure as Code (IaC) tool that enables you to define and manage cloud resources using configuration files.|
|Ansible| Install [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html) on your local machine. Ansible is an automation tool that allows you to configure and manage servers.|
|Azure CLI| Install [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) to provide command-line access to Azure resources. Essential for both Terraform and Ansible to interact with your Azure account.|
|Azure Service Principal|	[Create an Azure service principal](https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli) to authenticate Terraform and Ansible to access your Azure resources. The service principal should have sufficient permissions to create and manage resources.|
|Version Control System (e.g., Git)|	A version control system is crucial for managing and collaborating on code changes. If you're not already using one, consider setting up a [Git repository](https://docs.github.com/en/get-started).|

## Installing software on RHEL/Centos/Oracle Linux-based VM required for this project:

1. Installing Terraform on RHEL/Centos/Oracle Linux:
```
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo
https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install terraform
```
2. Installing Ansible on RHEL/Centos/Oracle Linux:
```
dnf install ansible-core
```
3. Wait for Ansible core to be installed and install below dependencies:
```
ansible-galaxy collection install community.mysql
ansible-galaxy collection install ansible.posix
ansible-galaxy collection install cloud.terraform
```
4. Now, Install Azure CLI:
```
sudo dnf install -y https://packages.microsoft.com/config/rhel/8/packages-microsoft-prod.rpm
sudo dnf install azure-cli
```
5. Please follow the [Link](https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli) to do Azure Service Principle to Authenticate to Azure or just use ` az login ` to log-in interactively. Suggested to do Azure Service Principal for Automation purposes.

6. Clone this code to your own Github Account or alternatively, you can Download this code to VM directly.

## How to Run the code on the VM deployed on RHEL/Centos/Oracle Linux:

1. In the Main directory, where the code is downloaded or cloned, make sure to be inside _<Download_Location>_ directory, where deploy.sh file is present ** Do not CD into subfolders like Ansible/Terraform**.

2. Once you are in the _<Download_Location>_ folder, in your IDE software, open Provider.TF file and edit the below section to your newly created Azure Principal and remove `#` which is at the start of each line. 
> [!TIP]
> _IN case you want to use Azure CLI interactive login using ` AZ Login`, you can skip this step._

```
  # client_id       = "00000000-0000-0000-000-000000000000"
  # client_secret   = "00000000000000000000000000000000000"
  # tenant_id       = "00000000-0000-0000-000-000000000000"
  # subscription_id = "00000000-0000-0000-000-000000000000" 
```

3. Once you are in the _<Download_Location>_ directory, please run the below command, which will trigger both Terraform and Ansible scripts and will show you the running output:

```
./deploy.sh
```
4. On the Command prompt once the script is completed, you will know the public IP to browse to the website. In case you missed it, to Know the public IP on which this website is running, run the below command on the RHEL/Centos/Oracle Linux VM: 

```
terraform output -raw vm_public_ip
```

5. On a browser, open the IP you have obtained from the previous step as below:
```
http:// <IP_Address_from_above>
```
### Major Challenges faced during this deployment:
Due to limited information and documentation, faced issues with integrating Terraform and Ansible to run at once. Previously, it used to run with Local-exec in Terraform to trigger Ansible playbooks but, tried to use the Ansible provider in Terraform which is the latest addition that happened in 2023. 
