Vagrant.configure("2") do |config|
  Home = "/home/vagrant"
  Spark = "spark-3.2.1-bin-hadoop3.2"
  N_workers = 2
  Master_IP = "192.168.56.20"
  Master_port = "7077"

  config.vm.box = "ubuntu/xenial64"

  # Master node:
  config.vm.define "hn0" do |node|
    node.vm.hostname = "hn0"
    node.vm.network "private_network", ip: Master_IP

    node.vm.provider "virtualbox" do |vb|
      vb.name = "hn0"
      vb.gui = false
      vb.memory = 1024
      vb.cpus = 2
    end

    node.vm.provision "shell" do |s|
      s.inline = "apt-get install -y python"
    end

    node.vm.provision "ansible" do |ansible|
      ansible.playbook = "hn.yml"
      ansible.become = true
    end

    node.vm.provision "shell", inline: <<-SHELL 
      mv #{Home}/#{Spark} #{Home}/spark
      echo "spark.master spark://"#{Master_IP}":"#{Master_port} >> #{Home}/spark/conf/spark-defaults.conf
      echo "SPARK_LOCAL_IP="#{Master_IP} >> #{Home}/spark/conf/spark-env.sh
      echo "SPARK_MASTER_HOST="#{Master_IP} >> #{Home}/spark/conf/spark-env.sh
      sed -i "1i[workers]" /etc/ansible/hosts
    SHELL

    node.vm.provision "shell", run: "once", inline: Home+"/spark/sbin/start-master.sh -h "+Master_IP

    #node.vm.provision "docker", type: "shell", run: "never", path: "run_ansible_playbook.sh"
  end

  # Worker nodes:
  (0..N_workers-1).each do |i|
    config.vm.define "wn#{i}" do |node|
      Worker_IP = "192.168.56.1#{i}"
      node.vm.hostname = "wn#{i}"
      node.vm.network "private_network", ip: Worker_IP

      node.vm.provider "virtualbox" do |vb|
        vb.name = "wn#{i}"
        vb.gui = false
        vb.memory = 1024
        vb.cpus = 2
      end

      node.vm.provision "shell" do |s|
        s.inline = "apt-get install -y python"
      end

      node.vm.provision "ansible" do |ansible|
        ansible.playbook = "wn.yml"
        ansible.become = true
      end

      node.vm.provision "shell", inline: <<-SHELL
        mv #{Home}/#{Spark} #{Home}/spark
        echo "SPARK_LOCAL_IP="#{Worker_IP} >> #{Home}/spark/conf/spark-env.sh
        echo "SPARK_MASTER_IP="#{Master_IP} >> #{Home}/spark/conf/spark-env.sh
      SHELL

      node.vm.provision "shell", run: "once", inline: Home+"/spark/sbin/start-worker.sh -h "+Worker_IP+" spark://"+Master_IP+":"+Master_port

      # Populate #{Home}/.ssh/authorized_keys
      node.vm.provision "shell", inline: <<-SHELL
        ssh-keyscan #{Master_IP} >> ~/.ssh/known_hosts
        ssh -i /vagrant/.vagrant/machines/hn0/virtualbox/private_key vagrant@#{Master_IP} << EOF
          # as vagrant
          ssh-keyscan #{Worker_IP} >> ~/.ssh/known_hosts
          cat ~/.ssh/id_rsa.pub | ssh -i /vagrant/.vagrant/machines/wn#{i}/virtualbox/private_key vagrant@#{Worker_IP} "cat >> #{Home}/.ssh/authorized_keys"
          # as root
          sudo su
          sed -i "2i#{Worker_IP}" /etc/ansible/hosts
          ssh-keyscan #{Worker_IP} >> ~/.ssh/known_hosts
          cat ~/.ssh/id_rsa.pub | ssh -i /vagrant/.vagrant/machines/wn#{i}/virtualbox/private_key vagrant@#{Worker_IP} "cat >> #{Home}/.ssh/authorized_keys"
        #EOF
      SHELL

      # Enable root access from Master
      node.vm.provision "shell", inline: <<-SHELL
        sudo su
        cp #{Home}/.ssh/authorized_keys ~/.ssh/authorized_keys
      SHELL

    end
  end
end
