# vagrant-docker-puppet-desktop-streamexplorer-jdeveloper
This repository provides Vagrant, Docker and Puppet configuration files to create a containerized environment for Oracle StreamExplorer and JDeveloper 12.1.3 (the SX IDE)

Once the configuration is complete - two Docker containers are available - one with the StreamExplorer (and OEP) server up and running and one with JDeveloper 12.1.3 to provide the IDE for the SX/OEP environment. 

The containers are created in several steps:
* Vagrant to to create the dockerdesktophost vm (with desktop support)
* Vagrant to create two containers (my-base-container - headless and my-desktop-base-container - with GUI support)
* Vagrant ssh into dockerdesktophost; run each of the two containers and use Puppet in each to provision the environment (Java + SX/OEP in one and Java + JDeveloper in the other)
* commit each container to turn it into an image
* run headless container OracleStreamExplorer for image me/sx_12_1_3:1.0 exposing port 9002 and forwarding 9002 to 9202 on the host
* from within GUI for DockerDesktopHostVM - run container JDeveloper_12_1_3 with display based on image me/jdeveloper_12_1_3:1.0 (with link to OracleStreamExplorer)

* StreamExplorer can be accessed from with the DockerDesktopHostVM and also from the Vagrant host (both at port 9202)


Preparation:
* on your host - install VirtualBox (5.0 preferably) and Vagrant
* download to your host (to the files folder) the following files:
- jdk-7u79-linux-x64.tar and UnlimitedJCEPolicyJDK7.zip
- fmw_12.1.3.0.0_soa_quickstart.jar and fmw_12.1.3.0.0_soa_quickstart2.jar
- fmw_12.1.3.0.0_oep.jar and ofm_sx_generic_12.1.3.0.1_disk1_2of2
