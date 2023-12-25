set -eux

terraform init
terraform apply -auto-approve

ansible-playbook -i inventory.yml ./Ansible/playbook.yml

terraform output -raw vm_public_ip