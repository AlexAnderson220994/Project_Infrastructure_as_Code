# Infrastructure as Code

![Alt text](<images/4. IaC Diagram.jpg>)

## IaC Research & Development

#### What is Infrastructure as Code (IaC)?

- Infrastructure as Code (IaC) is a software engineering approach to managing and provisioning infrastructure and its configurations through machine-readable code or scripts.

### Configuration Management (with **Ansible**)

![Alt text](<images/3. Ansible Diagram new.jpg>)

#### What is Configure Management?

- Configuration management, often abbreviated as CM, is a set of practices and processes used in IT and systems engineering to manage and control the configuration of software, hardware, and infrastructure components in a systematic and consistent manner.
- The primary goal of configuration management is to ensure that systems and software remain stable, reliable, and predictable throughout their lifecycle.

#### What is Ansible?

![Alt text](<images/1. Ansible diagram.jpg>)

- Ansible is an open-source automation tool designed to simplify and automate various IT tasks, including configuration management, application deployment, task automation, and orchestration. 
- It allows you to define and manage infrastructure as code, making it easier to provision and configure systems and applications consistently. 
- Ansible is known for its simplicity, agentless architecture, and the use of human-readable YAML files for defining automation tasks

#### Why use Ansible?

- Simplicity: Ansible uses a simple, human-readable YAML syntax for defining automation tasks, making it accessible to both system administrators and developers. You don't need to be a programmer to work effectively with Ansible.
- Agentless: Ansible operates in an agentless mode, which means it doesn't require any software to be installed on the target systems. This makes it easy to set up and manage.
- Idempotence: Ansible ensures idempotence, which means that applying a configuration multiple times has the same effect as applying it once. This reduces the risk of unintended changes and simplifies the automation process.

#### What are Playbooks?

- Playbooks are written in YAML (Yet Another Markup Language) and are used to define a series of tasks, configurations, and automation steps that Ansible will execute on remote systems. 
- Playbooks provide a way to describe how to achieve a specific automation goal, such as configuring servers, deploying applications, or managing infrastructure.
- Playbooks are central to Ansible's configuration management and automation capabilities, allowing you to define, document, and execute complex tasks and operations on remote systems in a repeatable and consistent manner.

#### What are ad-hoc commands?

- Ad-hoc commands in Ansible are one-off, single-line commands that you can use to perform quick tasks or gather information on remote hosts without the need for a separate playbook. 
- These commands are executed using the ansible command-line tool and are useful for tasks that don't require the creation of a complete playbook.

#### What is YAML?

- Stands for "YAML Ain't Markup Language" or "Yet Another Markup Language" (depending on who you speak to) is a human-readable data serialization format. 
- Often used for configuration files and data exchange between languages with different data structures. 
- YAML was designed to be easily read by humans and to be expressive enough to represent complex data structures.
- Human-Readable: YAML files are written in a format that resembles natural language, making it relatively easy for humans to read and write.
- Structured Data: YAML allows you to represent structured data like lists, dictionaries (maps), and scalars in a clear and concise manner.
- Data Types: YAML supports various data types, including strings, numbers, booleans, and more. It also allows for complex data structures like lists and dictionaries.
- Comments: YAML files can include comments to provide additional information or context.

### Orchestration (with **Terraform**)

![Alt text](<images/2. terraform diagram.jpg>)

#### What is Orchestration?

- Orchestration is the coordination and automation of multiple tasks, processes, or operations to achieve a specific outcome or goal. 
- It is often used in the context of managing complex workflows, especially in IT, cloud computing, and application deployment. 
- Orchestration involves managing the sequence, timing, and dependencies of various tasks to ensure they work together harmoniously.

#### What is Terraform?

- Terraform is an open-source infrastructure as Code tool.
- It was developed by HashiCorp. 
- It is designed to automate and simplify the provisioning and management of infrastructure resources such as virtual machines, networks, storage, and other cloud-based services. 
- Terraform allows users to define their infrastructure in a declarative configuration language and then apply that configuration to create and manage resources in various cloud providers, data centers, and other infrastructure environments.

#### Why use Terraform?

- Terraform allows you to define and manage your infrastructure using code, making it manageable, maintainable and version controlled.
- Declarative - You declare the desired state of your infrastructure with config files then Terraform makes your infrastructure match this state.
- Supports a wide range of cloud services.
- Resource dependency management - Terraform automatically manages dependencies, ensuring that resources are created, updated, or destroyed in the correct order, reducing the risk of configuration errors.
- Terraform's two-step process of planning and applying changes allows for validation and review of proposed changes before they are implemented, reducing the risk of unintended consequences.

### Who uses Terraform?

- Terraform is popular among DevOps teams, cloud engineers, system administrators.
- Cloud engineers leverage Terraform to create, modify, and manage resources on cloud platforms like AWS, Azure, Google Cloud, and others. Terraform simplifies the process of building and scaling cloud-based infrastructure.
- DevOps professionals use Terraform to automate the provisioning and management of infrastructure, ensuring that development and operations are closely aligned and enabling continuous integration and delivery (CI/CD) pipelines.

## Using Ansible

### Step 1 - Make an EC2 Instance on AWS

1) Go to the AWS Console and make a new EC2 instance.
- Ubuntu 20.04 lts.
- t2 micro
- `file.pem` SSH key pair
- Base Security group (22, 80, 3000)
2) Connect to your instance on GitBash.
3) Run:
````
sudo apt update
````
````
sudo apt upgrade -y
````

### Step 2 - Install Ansible

1) Check if you have ansible installed:
````
ansible --version
````
2) Run the following commands:
````
sudo apt install software-properties-common
````
````
sudo apt-add-repository ppa:ansible/ansible
````
3) Press "Enter"
4) Run update again:
````
sudo apt update -y
````
5) Install Ansible:
````
sudo apt install ansible -y
````
6) Check Ansible version again to see if its installed:
````
ansible --version
````
7) cd into the ansible folder:
````
cd /etc/ansible/
````
8) Make sure the correct Ansible files are there.

**NOTE**: Run the following commands to view files in a folder in a better way:
````
sudo apt install tree
````
```` 
tree
````

### Step 3 - Make sure the SSH key has been added to .ssh folder in Ubuntu

1) cd into the .ssh folder on Ubuntu
````
cd ~/.ssh
````
2) Open up a new GitBash terminal connected to your local OS and run the following command to copy the .pem file SSH key to Ubuntu:
````
scp -i "~/.ssh/tech254.pem" ~/.ssh/tech254.pem ubuntu@<Public Instance IP>:~/.ssh
````

### Set up instances for Ansible

1) Set up 3 instances, "ansible-controller", "ansible-app", "ansible-db".
2) Run `sudo apt update` and `sudo apt upgrade-y` on all instances.
- This can be done later for the app and db instances using a Playbook for update and upgrade.
3) On "ansible-controller", follow the Ansible Install steps (or create from a previous AMI with Ansible Installed).
4) Make sure all 3 EC2 instances have the file.pem private key added to the .ssh folder (see Ansible Connection Step 3).
5) Good practice to manually connect to each instance first to check connections.

### Connecting from Ansible Controller Instance to other Instances

1) Connect to your "ansible-controller" EC2 instance the normal way (command below):
````
ssh -i YourControllerKeyName.pem ubuntu@controller-instance-ip
````
2) Give the file.pem in your "ansible-controller" instance the correct permissions:
````
cd ~/.ssh
````
````
sudo chmod 400 file.pem
````
3) Make sure you're in the .ssh folder on "ansible-controller":

4) Check that you can connect to the other instances using the file.pem SSH connection and the public IP of the instance you want to connect to from the controller. e.g.
````
sudo ssh -i "controller_file.pem" ubuntu@ec2-3-250-69-186.eu-west-1.compute.amazonaws.com
````
5) Do `uname -a` to check that you've successfully SSH'd into the required instance.
6) Type `exit` then press enter to go back to the controller instance.
7) Move to the Ansible folder in your controller:
````
cd /etc/ansible/
````
8) Nano into the "hosts" file to add the web IP address:
````
sudo nano hosts
````
9) Under "Ex 2", Make a collection called hosts `[web]` and put the public IP address of the web server underneath.
- The format of the public IP address is as follows:
````
ec2-instance ansible_host=3.250.69.186 ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/.ssh/tech254.pem
````
10) Each element in the above is now defined.
11) Do the command:
````
sudo ansible web -m ping
````
12) Should come back with a successful ping if the link is there.

## Using Terraform

### Setting up Terraform

#### Download

1) Go onto your internet browser and type in "Terraform install"
2) Choose the latest version of Terraform compatible with your system OS (Windows 10 or 11).
3) Download the file.
4) Extract the file to somewhere in your C: drive (windows folder) and make a folder called Terraform to extract it to.
5) Open Gitbash and do the following commands:
````
terraform
````
````
terraform --version
````
6) This will confirm that terraform has been installed and you have the correct version.

#### Add AWS access and secret keys as USER variables on your system

1) On your computer:
- Go to "settings"
- Go to "advanced settings"
- Under advanced, go to "Environment Variables"
- Under User Variables, Select new.
- Make one new user variable for Access key ID with the key value. Give the Variable name as `AWS_ACCESS_KEY_ID`
- Make another user variable with the secret key and the key value. Give the variable name as `AWS_SECRET_ACCESS_KEY`
- **NOTE** - NEVER share your AWS access and secret keys on any repository or over video/screenshare.
2) Make sure to open a new Bash console everytime you change variables so it can register the change.

### Using Terraform to create Instances

1) Make a folder on your c: drive to house your terraform project (e.g. `tech254-terraform`)
2) cd into this folder
3) Make a new terraform file within this folder. e.g. `main.tf`
````
nano main.tf
````
4) The `file.tf` needs certain information to run in JSON format.
- The Cloud Provider (AWS, Azure, GCP)
- The region (e.g. eu-west-1)
- The dependencies for EC2 instance creation (resource type, ami, instane_type, tags)
- The number of spaces used within the file doensn't matter but make sure they are there when needed.
- Make sure to include "" where needed.

#### Terraform commands

1) Make sure you're in the folder with the `main.tf` file.
2) Run these commands:
- terraform init - Prepare your working directory for other commands
````
terraform init
````
- terraform validate - Check whether the configuration is valid
````
terraform validate
````
- terraform plan - Show changes required by the current configuration
````
terraform plan
````
- terraform apply - Create or update infrastructure
````
terraform apply
````
- terraform destroy - Destroy previously-created infrastructure (destroys the instance you've made)
````
terraform destroy
````
3) The command `terraform` shows that Terraform exists on your system and shows other commands that can be used.
