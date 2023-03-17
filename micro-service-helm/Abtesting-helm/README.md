# **Prod Infra Deployment setup for Abtesting**

## **Provisioning the infra**
1. spinning up set of vm's, kubernates cluster, redis, databases , vpc, artifact, cloud storage etc.
2. here we are creating infra on [GCP](https://console.cloud.google.com/kubernetes), so all resources and terminologies are using with ref of GCP.
3. this can be done by using terraform template with having service account as a project owner role [abtesing terraform template script](https://devops.jio.com/JioMart/3P_Marketplace/_git/ABTestingCentralInfraTemplate)
4. Or you can create resources using GCP console/gcloud/rest interface.
5. Below list of resource need to create with **enable deletion protection**
    1. **VPC**
        1. vpc with subnetwork appropriate region
        2. cloud NAT or proxy setup
        3. Firewall rules
        4. private service connection with alias range
        5. vpc peering if deployment takes place in two diff vpc for communication
    2. **GCS** storage bucket to store sdk script for high availability.
    3. **Artifact registry** for your project to store docker artifacts.
    4. **VM's** spin up according to your cluster requirement as IAAS.
        1. 3 VM's for **kafka broker** and controller.
        2. 2 VM's for **kong gateway** for high availability.
        3. 1 VM's for **nginx** for internal load balancer
    5. Spin up **GKE-cluster** with min 1 worker NODE.
    6. create **Cloud-sql** (_**postgres**_) Database with appropriate replicas.
    7. create **MemoryStore**(_**Redis**_) for cache purpose.
    8. create a **Cloud-scheduler** which hits api after a min to run cron job.
    9. create **Https-External-Load-Balancer** with cloud managed certificates.
    10. Allocate **Domain-name** from google-provider or with your org by provide Load Balancer IP.

## Create VPC, CLOUD NAT, ROUTER AND FIREWALL RULES
1. If you are working in a big organisation where you are having separate network team then will provide you share vpc host with subnets according to your need.
2. In case of **Shared VPC** make sure below network resource access you should have
    1. get access of **vpc** and **subnets** to your users and your service project from Host project
    2. **cloud NAT** or proxy should be setup so that vm get external ip address to download or make interet connection.
    3. subnet cidr block should satisfy your network size requirements e.g. /24 i.e 2^8-4 = 252 Ips available in your network.
    4. check out the secondary pod and service ranges for the subnets used by vm alias or K8 cluster to create pods.
        1. **Pod range** block is /24 is min recommended with that you can create 1 worker node with 110 pods on each node. e.g /23 block you can create 2 node with 110 pods on each or 4 node with 55 pods on each.
        2. **Service range** block is /24 is min recommended with that you can create 256 service in cluster.
        3. [more in detail](https://cloud.google.com/kubernetes-engine/docs/concepts/alias-ips)
    5. If you are using google/third party service providers like cloud sql,redis, memcache then to enable vpc peering with service network provider there has to be private network connect established [more detail](https://cloud.google.com/vpc/docs/private-services-access)
3. In case of manual creation create various below components.
    1. Create vpc.
    2. Select automatic or custom subnets
    3. Create firewall rule to allow access or you can select the default firewall rules as well.
    4. Private service connection with alias range to access service providers service with your private vpc
    5. [For more detail](https://cloud.google.com/vpc/docs/vpc)

## GCS storage bucket to store sdk script
1. [follow](https://cloud.google.com/storage/docs/creating-buckets)
2. upload your script and get public url and configure this bucket according to your access frequency.

## Create artifact registry
1. [follow](https://cloud.google.com/artifact-registry/docs/overview)
2. follow artifact setup on local steps in below section

## VM's spin up according to your cluster requirement
1. [follow for more details](https://cloud.google.com/compute)
2. follow components installation steps in each vms

## Spin GKE cluster
1. create GKE-cluster in standard mode which give you more option for customization.
2. create custom node pool instead of default.
3. assign network tag if firewall rule restrictions are there.
4. give max no. of pods to run on each node in configuration based on bellow steps
    1. subnet cidr block should satisfy your network size requirements e.g. /24 i.e 2^8-4 = 252 Ips available in your network.
    2. check out the secondary pod and service ranges for the subnets used by vm alias or K8 cluster to create pods.
        1. Pod range block is /24 is min recommended with that you can create 1 worker node with 110 pods on each node. e.g /23 block you can create 2 node with 110 pods on each or 4 node with 55 pods on each.
        2. Service range block is /24 is min recommended with that you can create 256 service in cluster.
        3. [more in detail](https://cloud.google.com/kubernetes-engine/docs/concepts/alias-ips)
5. spin up big node instead of multiple small node configuration e.g. take 16 cpu's with 64Gb ram instead of 4cpus 8GB.
6. [follow doc for more info](https://cloud.google.com/kubernetes-engine/docs/concepts/kubernetes-engine-overview)

## Create Cloud-sql (_postgres_) Database
1. create postgres primary database with 8cpu's and 32Gb Ram configuration with initial 250 Gb SSD space.
2. enable autoscale with backup
3. allocate maintainance window
4. select vpc network with private service connection enabled with alias range.
5. enable deletion protection
6. [follow for more detail](https://cloud.google.com/sql/docs/postgres/quickstarts)
7. create cloud-sql with [gcloud command](https://cloud.google.com/sdk/gcloud/reference/sql/instances/create) e.g

        gcloud sql instances create prod-instance --database-version=MYSQL_5_7 --cpu=2 --memory=4GB --region=us-central1 --root-password=password123
8. create read replicas for frequently read data apps as per your need

## Create MemoryStore(_Redis_) for cache purpose.
1. Redis we are using here for cache purpose due to multi-regional availability of redis and have great community support.
2. install redis with latest version and allocation memory for your cache. for our use case add 5GB min for redis 5.x version
3. [for more details](https://cloud.google.com/memorystore/docs/redis)
4. [create redis instance] https://cloud.google.com/memorystore/docs/redis/create-manage-instances

## Create a Cloud-scheduler for our cron job.
1. [read more about cron job with cloud-scheduler](https://cloud.google.com/scheduler/docs)
2. [create cron job](https://cloud.google.com/scheduler/docs/creating)
3. [create http cron job](https://cloud.google.com/scheduler/docs/creating)

## Create Https-External-Load-Balancer with cloud managed certificates.
1. external load balancer have frontend exposed to 443 and backend exposed to 80 with **NEG**(_network endpoint group_) OR **NIG**(_network instance group_).
2. [read more about load balancer](https://cloud.google.com/load-balancing/docs/load-balancing-overview)
3. [read more about internal load balancer](https://cloud.google.com/load-balancing/docs/https)

## Allocate Domain-name from google-provider or with your org by provide Load Balancer IP.
1. assign domain name to your external load balancer ip address to make your product to public with domain name instead of ip.
2. these are chargeable and can't delete one created and allocated the domain for the time period like 1 year min.
3. you can sell it but can't delete the domain. so choose domain carefully after checking the price of domain providers.
4. [doc for domain](https://cloud.google.com/dns/docs/tutorials/create-domain-tutorial)

## Install components to  The provision infra Vm and kubernates cluster
### Install Kafka and controller to create cluster.
1. [follow detailed blog for cluster setup](https://github.com/sonuprajapati15/jenkins-pipeline/wiki/kafka-cluster-setup)
2. Steps
    1. Kafka installation:-
        * Here we will be going to install the Kafka with the kraft and zookeeper controller
        * Here 3 instances of the controller and 4 Kafka broker configurations are going to do.

    2. Install Java
        1. we are installing java 11.
            * using binaries on each machine

                  Install java
                  mkdir /opt/jdk
                  tar -zxf /home/sonu_prajapati/jdk-11.0.17_linux-x64_bin.tar.gz -C /opt/jdk
                  ls /opt/jdk
                  update-alternatives --install /usr/bin/java java /opt/jdk/jdk-11.0.17/bin/java 100
                  update-alternatives --install /usr/bin/javac javac /opt/jdk/jdk-11.0.17/bin/javac 100
                  update-alternatives --display java
                  update-alternatives --display javac
                  java -version
            * With internet on each machine

                   sudo apt-get update;
                   sudo apt install default-jdk
        2. Add JAVA PATH to your PATH, if it's not already there:

                echo PATH=$PATH:$HOME/bin >> ~/.bashrc`
                source ~/.bashrc

    3. Install Apache Kafka
        * Download the latest version of Apache Kafka from https://kafka.apache.org/downloads under Binary downloads. or use below command.

              wget https://downloads.apache.org/kafka/3.4.0/kafka_2.12-3.4.0.tgz
              tar xzf kafka_2.12-3.4.0.tgz
              mv kafka_2.13-3.0.0 ~

    4. Open a Shell and navigate to the root directory of Apache Kafka. For this example, we will assume that the Kafka download is expanded into the `~/kafka_2.13-3.0.0` directory.
    5. Follow the below steps in every machine of your cluster based on your controller (zookeeper/Kraft).
        * ZOOKEEPER
        * KRAFT
            1. change directory to `cd ~/kafka_2.13-3.0.0/config/kraft` directory.
            2. copy file server.properties file to `server-setup.properties` as we don't want to touch the original Kafka-provided a property

                    cp server.proprerties . 
            3. open the file in the vim editor.

                    vi server-setup.properties
            4. choose the first three machines in which you want to make the controller as well as a broker as in 4th machine we will not mark its role as controller. `for more scalable solution then you can create a sub-cluster of kraft and  broker separately by specify roles.`

            5. assign node.id with distinct no to each machine config

                   node.id= <a 32 bit distinct no on each node of cluster>

            6. assign role of the node. for first three machine it is controller,broker and forth machine it will be broker only.

                   process.roles= <controller/broker/controller,broker>
            7. mention controller servers with node.id@ip-address:port_no

                   Controller = 1@10.166.188.70:9093,2@10.166.188.72:9093,3@10.166.188.74:9093

            8. In 4th machine remove controller in 4th machine (_follow this if you want to add one more croker_)

                   listeners=PLAINTEXT://:9092,CONTROLLER://:9093
            9. extra properties

                   broker.heartbeat.interval.ms=3000
                   broker.session.timeout.ms=18000
                   default.replication.factor=3

            10. Assign storage format
                * assign storage format for storing logs and events
                1. generate random-uuid for cluster storage

                        bin/kafka-storage.sh random-uuid
                2. Store this id
                3. run below command with sever.properties file w.r.t. to your controller in every machine

                        bin/kafka-storage.sh format -t <UUID> -c <path_to_your_config_based_on_controller>/server-setup.properties
                4. Allow heap storage with  max 2048mb and min 1024 mb by exporting path

                        export KAFKA_HEAP_OPTS="-Xmx2048M -Xms1024M"
                5. refer [kraft](https://github.com/sonuprajapati15/jenkins-pipeline/tree/main/kafka/kraft) of all 4 server properties for kRaft.


### Install Kong with data plane and control plane to create cluster.
1. there are multiple deployment strategies.
    1. Konnect (hosted control plane)
    2. Hybrid
    3. Traditional (database)
    4. DB-less and declarative
2. we are going ahead with tradition(database) approach as we are using plugins which requires database access.
3. [for more detail for various strategies](https://docs.konghq.com/gateway/3.1.x/production/deployment-topologies/)
4. [install on diff env and machine](https://docs.konghq.com/gateway/3.1.x/install/)
    1. we are going ahead with debian os as ou vms are based on it.
        1. Prerequisites install
            1. [curl](https://curl.se/)
            2. [lsb-release](https://packages.debian.org/search?keywords=lsb-release)
            3. [apt-transport-https](https://packages.debian.org/apt-transport-https)
        2. Download the Kong package:

                curl -Lo kong-enterprise-edition-3.1.1.3.all.deb "https://download.konghq.com/gateway-3.x-debian-$(lsb_release -cs)/pool/all/k/kong-enterprise-edition/kong-enterprise-edition_3.1.1.3_amd64.deb"
        3. update package

                  sudo apt update
                  apt --fix-broken install
        4. Install the package:

                sudo dpkg -i kong-enterprise-edition-3.1.1.3.all.deb
        5. Once Kong Gateway is installed, you may want to run sudo apt-mark hold kong-enterprise-edition. This will prevent an accidental upgrade to a new version.
        6. Kong Gateway comes with a default configuration property file that can be found at `/etc/kong/kong.conf.default` if you installed Kong Gateway with one of the official packages. This configuration file is used for setting Kong Gateway’s configuration properties at startup.
        7. To alter the default properties listed in the kong.conf.default file and configure Kong Gateway, make a copy of the file, rename it (for example `kong.conf`), make your updates, and save it to the same location
        8. ### Installation Modes
            1. **Using a database**
                1. We don’t recommend using Cassandra with Kong Gateway, because support for Cassandra is deprecated and planned to be removed.
                2. The following [configuration properties for PostgreSQL](https://docs.konghq.com/gateway/3.1.x/reference/configuration/#datastore-section) as a database to store Kong configuration.
                3. Provision a database and a user before starting Kong Gateway:

                        CREATE USER kong WITH PASSWORD 'super_secret'; CREATE DATABASE kong OWNER kong;
                4. Run one of the following Kong Gateway migrations:
                    * In Enterprise Mode

                          KONG_PASSWORD={PASSWORD} kong migrations bootstrap -c {PATH_TO_KONG.CONF_FILE}

                    * If you aren’t using Enterprise, run the following:

                          kong migrations bootstrap -c {PATH_TO_KONG.CONF_FILE}
            2. **Using a yaml declarative config file**
                1. If you want to store the configuration properties for all of Kong Gateway’s configured entities in a yaml declarative configuration file, also referred to as DB-less mode, you must create a kong.yml file and update the kong.conf configuration file to include the file path to the kong.yml file.
                2. First, the following command will generate a kong.yml declarative configuration file in your current folder:

                         kong config init
                3. Second, you must configure Kong Gateway using the kong.conf configuration file so it is aware of your declarative configuration file.
                4. Set the database option to off and the declarative_config option to the path of your kong.yml file as in the following example:

                         database = off
                         declarative_config = {PATH_TO_KONG.CONF_FILE}
5. upgrade ulimit

         ulimit -n 8192
6. Start Kong Gateway. [run kong as a non-root user](https://docs.konghq.com/gateway/3.1.x/production/running-kong/kong-user/)

         kong start -c {PATH_TO_KONG.CONF_FILE}
         sudo systemctl start kong  // start kong os
         sudo systemctl enable kong // Enable starting Kong Gateway automatically at system boot
7. to stop kong

        sudo systemctl stop kong // stop kong os
        sudo systemctl disable kong // Disable starting Kong Gateway automatically at system boot
8. Verify install

       curl -i http://localhost:8001
9. [for more detail of kong installation](https://docs.konghq.com/gateway/3.1.x/install/linux/debian/)
10. [securing admin api](https://docs.konghq.com/gateway/3.1.x/production/running-kong/secure-admin-api/)


### Install Nginx as a webserver and load balancer for kong.
1. [installation step for various env and os](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/)
2. we are going ahead to install nginx on debian os
    1. **Installing a Prebuilt Debian Package from the Official NGINX Repository**
        1. Install the prerequisites

               sudo apt install curl gnupg2 ca-certificates lsb-release debian-archive-keyring
        2. Import an official nginx signing key so apt could verify the packages authenticity. Fetch the key:

               curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
           | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
        3. Verify that the downloaded file contains the proper key:

               gpg --dry-run --quiet --no-keyring --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg
        4. The output should contain the full fingerprint _**573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62**_ as follows:

                 pub   rsa2048 2011-08-19 [SC] [expires: 2024-06-14]
                 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
                 uid                      nginx signing key <signing-key@nginx.com>
        5. If the fingerprint is different, remove the file.
        6. To set up the apt repository for stable nginx packages, run the following command:

                 echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
                 http://nginx.org/packages/debian `lsb_release -cs` nginx" \
                 | sudo tee /etc/apt/sources.list.d/nginx.list
           If you would like to use mainline nginx packages, run the following command instead:

                  echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
                  http://nginx.org/packages/mainline/debian `lsb_release -cs` nginx" \
                  | sudo tee /etc/apt/sources.list.d/nginx.list
        7. Set up repository pinning to prefer our packages over distribution-provided ones:

                  echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
                  | sudo tee /etc/apt/preferences.d/99nginx
        8. Install the NGINX package:

               sudo apt-get update
        9. Install the NGINX Open Source package:

               sudo apt update
               sudo apt install nginx
        10. Verify the installation:

                sudo nginx -v
                nginx version: nginx/1.6.2

    4. **Installing a Prebuilt Debian Package from an OS Repository**
        1. Update the Debian repository information:

               sudo apt-get update
        2. Install the NGINX Open Source package:

               sudo apt-get install nginx
        3. Verify the installation:

               sudo nginx -v
               nginx version: nginx/1.6.2

3. Start NGINX Open Source:

       sudo nginx
4. Verify that NGINX Open Source is up and running:

       curl -I 127.0.0.1
       HTTP/1.1 200 OK
       Server: nginx/1.23.2
5. All NGINX configuration files are located in the` /etc/nginx/` directory.
6. The primary configuration file is `/etc/nginx/nginx.conf.`
7. run with diff conf file

        sudo nginx -c <PATH TO NGINX CUSTOM CONF FILE>



### Install Control and data plane of istio_
1. Install helm charts

       helm repo add istio https://istio-release.storage.googleapis.com/charts
       helm repo update
    1. Create istio namespace

           kubectl create namespace istio-system
    2. Install the Istio base chart which contains cluster-wide Custom Resource Definitions (CRDs) which must be installed prior to the deployment of the Istio control plane:

           helm upgrade -i istio-base istio/base -n istio-system
    3. Install the Istio discovery chart which deploys the istiod service:

           helm upgrade -i istiod istio/istiod -n istio-system --wait
    4. Verify the Istio discovery chart installation:

           helm ls -n istio-system
    5. Get the status of the installed helm chart to ensure it is deployed:

           helm status istiod -n istio-system
    6. Check istiod service is successfully installed and its pods are running:

           kubectl get deployments -n istio-system --output wide


#### Install Istio ingress Gateway:-
1. Create new namesapce

        kubectl create namespace istio-ingress
        kubectl label namespace istio-ingress istio-injection=enabled
    1. Deploy deployment, services, roles, horizontal-pod-auto-scaler and service account as well in this namespace
    2. ingres directory and install all the components

           kubectl apply -f ./ingress
    3. verify all components install by executing below commands

            kubectl -n istio-ingress get deployments
            kubectl -n istio-ingress get hpa
            kubectl -n istio-ingress get role
            kubectl -n istio-ingress get rolebinding
            kubectl -n istio-ingress get svc
            kubectl -n istio-ingress get serviceaccounts
            kubectl -n istio-ingress get pods
    4. _for miniKube we can assign public/external ip to external service by run_

            minikube service <EXTERNAL SERVICE NAME>

#### Managing gateways for incoming traffic
1. Depnd upon your deployment you can select topologies from [document](https://istio.io/latest/docs/setup/additional-setup/gateway/)
    1. **Shared gateway**
        1. In this model, a single centralized gateway is used by many applications, possibly across many namespaces. Gateway(s) in the ingress namespace delegate ownership of routes to application namespaces, but retain control over TLS configuration.
        2. This model works well when you have many applications you want to expose externally, as they are able to use shared infrastructure. It also works well in use cases that have the same domain or TLS certificates shared by many applications.
    2. **Dedicated application gateway**
        1. In this model, an application namespace has its own dedicated gateway installation. This allows giving full control and ownership to a single namespace. This level of isolation can be helpful for critical applications that have strict performance or security requirements.
        2. Unless there is another load balancer in front of Istio, this typically means that each application will have its own IP address, which may complicate DNS configurations.
    3.

    4. Create Gateway CRD placed in `gateways` dir. by running below command

           kubectl apply -f ./gateways
    5. Check status of gateways

           kubectl -n istio-ingress get gateway

#### There are set of monitoring deployments as well like kiali, grafana, prometheous etc.
1. check monitoring `addon` dir. and run below command to deploy these addons.

           kubectl create namespace monitoring
           kubectl label namespace monitoring istio-injection=enabled
           kubectl apply -f ./monitoring/addons
    1. run below command to check the status of monitoring app status
       kubectl -n monitoring get deployments
       kubectl -n monitoring get hpa
       kubectl -n monitoring get role
       kubectl -n monitoring get svc
       kubectl -n monitoring get serviceaccounts
       kubectl -n monitoring get pods

#### For demo purpose we are deploying simple app server image to check all service reaches to end point or not
1. run below commands to run app as a frontend app with frontend virtual service.

            kubectl create namespace frontend
            kubectl label namespace frontend istio-injection=enabled
            kubectl apply -f ./demo-app
    1. check app is running or not

                kubectl -n frontend get pods

#### Now create virtual service which manges the traffic routing
1. we can manage traffic based on various configuration see [istio traffic doccument](https://istio.io/latest/docs/concepts/traffic-management/)
    1. run virtual service present in the `virtual-services` dir. configure it according to our use-case.

               kubectl apply -f ./virtual-services
    2. get result config with below command

               kubectl -n <NAME_SPACE> get virtualservice


### Install other kubernates apps through helm charts and deployments.
    





