set -eux

terraform init
terraform apply -auto-approve


ansible-galaxy collection install cloud.terraform
ansible-galaxy collection install community.mysql
ansible-galaxy collection install ansible.posix

ansible-playbook -i inventory.yml ./Ansible/playbook.yml

