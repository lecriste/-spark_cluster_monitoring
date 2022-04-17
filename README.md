# spark_cluster_monitoring #
Vagrant template to provision a standalone Spark cluster.

# Details #

- Spark running as a standalone cluster. Tested with Spark 3.2.1.
- One head node Ubuntu 16.04 machine and `N` worker machines.
- Use Ansible for provisioning and Docker to install and run services.

# Usage #

Install Vagrant (tested version 2.2.19) and Ansible (core 2.12.4), then:
```
export PATH=$PATH:~/.local/bin
```

To spin up the local Spark cluster, place a pre-built Spark package into this directory, named "spark.tgz".

In the `Vagrantfile`, set the `Spark` variable to the chosen spark version (tested with spark-3.2.1).\
It is also possible to set `N_workers` to the desired number of workers, along with the RAM and CPU for each of the machines.

`vagrant up` to spawn the cluster. The Spark WebUI is available at `http://192.168.56.20:8080`.

`./run_ansible_playbook.sh` to install Docker with Ansible in the workers and create the Prometheus and Grafana containers.
