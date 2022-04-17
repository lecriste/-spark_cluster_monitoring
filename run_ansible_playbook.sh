vagrant ssh hn0 -c "cp /vagrant/playbook_docker.yml /home/vagrant/; ansible-galaxy collection install community.docker; ansible-playbook playbook_docker.yml -l workers -u vagrant"
