# spark_cluster_monitoring #
Vagrant template to provision a standalone Spark cluster.

# Details #

- Spark running as a standalone cluster. Tested with Spark 3.2.1.
- One head node Ubuntu 16.04 machine and `N` worker machines.

# Usage #

To spin up the local Spark cluster, place a pre-built Spark package into this directory, named "spark.tgz".

In the `Vagrantfile` it is possible to set the `N_workers` to the desired number of workers, along with the RAM and CPU for each of the machines.

`vagrant up` to spawn the cluster. The Spark WebUI is available at `http://192.168.56.20:8080`.
