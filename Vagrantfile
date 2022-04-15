Vagrant.configure("2") do |config|
  N_workers = 2
  Master_IP = "192.168.56.20"
  Master_port = "7077"

  config.vm.box = "ubuntu/xenial64"

  # head node:
  config.vm.define "hn0" do |node|
    node.vm.hostname = "hn0"
    node.vm.network "private_network", ip: Master_IP

    node.vm.provider "virtualbox" do |vb|
      vb.name = "hn0"
      vb.gui = false
      vb.memory = 2048
      vb.cpus = 2
    end

    node.vm.provision "shell", inline: <<-SHELL 
      apt-get install -y python-dev ntp default-jdk
      mkdir /home/vagrant/spark
      tar xf /vagrant/spark.tgz -C /home/vagrant/spark --strip 1
      echo "export SPARK_HOME=/home/vagrant/spark" >> /home/vagrant/.bashrc
      echo "export PATH=$PATH:/home/vagrant/spark/bin" >> /home/vagrant/.bashrc
      echo "spark.master spark://"#{Master_IP}":"#{Master_port} >> /home/vagrant/spark/conf/spark-defaults.conf
      echo "SPARK_LOCAL_IP="#{Master_IP} >> /home/vagrant/spark/conf/spark-env.sh
      echo "SPARK_MASTER_HOST="#{Master_IP} >> /home/vagrant/spark/conf/spark-env.sh
    SHELL

    node.vm.provision "shell", run: "always", inline: "/home/vagrant/spark/sbin/start-master.sh -h "+ Master_IP
  end

  # worker nodes:
  (0..N_workers-1).each do |i|
    config.vm.define "wn#{i}" do |node|
      Worker_IP = "192.168.56.1#{i}"
      node.vm.hostname = "wn#{i}"
      node.vm.network "private_network", ip: Worker_IP

      node.vm.provider "virtualbox" do |vb|
        vb.name = "wn#{i}"
        vb.gui = false
        vb.memory = 4096
        vb.cpus = 2
      end

      node.vm.provision "shell", inline: <<-SHELL
        apt-get install -y python-dev ntp avahi-daemon default-jdk
        mkdir /home/vagrant/spark
        tar xf /vagrant/spark.tgz -C /home/vagrant/spark --strip 1
        echo "export SPARK_HOME=/home/vagrant/spark" >> /home/vagrant/.bashrc
        echo "export PATH=$PATH:/home/vagrant/spark/bin" >> /home/vagrant/.bashrc
        echo "SPARK_LOCAL_IP="#{Worker_IP} >> /home/vagrant/spark/conf/spark-env.sh
        echo "SPARK_MASTER_IP="#{Master_IP} >> /home/vagrant/spark/conf/spark-env.sh
      SHELL

      node.vm.provision "shell", run: "always", inline: "/home/vagrant/spark/sbin/start-worker.sh -h "+ Worker_IP +" spark://"+ Master_IP +":"+ Master_port
    end
  end
end
