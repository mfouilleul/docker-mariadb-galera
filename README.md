# MariaDB Galera on Kubernetes

Based on official [MariaDB image](https://hub.docker.com/_/mariadb/). `gcomm://` peers are filled with [seeds](https://github.com/mfouilleul/seeds).

# Parameters

See: [MariaDB image](https://hub.docker.com/_/mariadb/) documentation

Additional variables:

- POD_NAMESPACE - The namespace, e.g. default
- CLUSTER_NAME - The logical cluster name for the node., e.g. LOCAL
- DNS_NAME - The DNS name of the service, e.g. cluster.local
