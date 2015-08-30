ENV['VAGRANT_DEFAULT_PROVIDER'] = 'docker'

Vagrant.configure("2") do |config|

  config.vm.define "my-desktop-base-container" do |m|
  
    m.vm.provider "docker" do |master|
        master.build_dir = "docker-desktop"
		master.cmd=["tail", "--f", "/dev/null"] ## to keep container running - see http://stackoverflow.com/questions/30209776/docker-container-will-automatically-stop-after-docker-run-d 		
	    master.name = 'my-desktop-base-container'
        master.vagrant_machine = "dockerdesktophostvm"
        master.vagrant_vagrantfile = "DockerDesktopHostVagrantfile" 
    end
    m.vm.hostname  = "my-desktop.host"
    m.vm.synced_folder "files", "/stage"
    m.vm.synced_folder "puppet", "/puppet"
  end

  config.vm.define "my-base-container" do |m|
  
    m.vm.provider "docker" do |master|
        master.build_dir = "docker-headless"
		master.cmd=["tail", "--f", "/dev/null"] ## to keep container running - see http://stackoverflow.com/questions/30209776/docker-container-will-automatically-stop-after-docker-run-d 		
	    master.name = 'my-base-container'
        master.vagrant_machine = "dockerdesktophostvm"
        master.vagrant_vagrantfile = "DockerDesktopHostVagrantfile" 
    end
    m.vm.hostname  = "my-headless.host"
    m.vm.synced_folder "files", "/stage"
    m.vm.synced_folder "puppet", "/puppet"
  end
  
end

# steps:
# puppet/manifests/base.pp contains Puppet manifest
# files contains installation files
# vagrant up my-desktop-base-container
# vagrant ssh into dockerdesktophostvm
# add desktop: see http://www.htpcbeginner.com/install-gui-on-ubuntu-server-14-04-gnome/
# sudo apt-get install --no-install-recommends lubuntu-desktop
# docker ps -a  to find container id
# docker start container id

#  docker exec -it container id bash 
# to have Java configured through Puppet:
#  puppet apply --debug --modulepath=/puppet/modules /puppet/manifests/base.pp
#  puppet apply --modulepath=/puppet/modules /puppet/manifests/base.pp

# docker commit containerId  me/java-gui:1.0
# vagrant halt dockerdesktophostvm

# restart dockerdesktophostvm from VirtualBox GUI

# docker run -ti -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY me/java-gui:1.0 /bin/bash

# docker run -ti  -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix bash
# docker run -ti -v /tmp/.X11-unix:/tmp/.X11-unix -v /vagrant/files:/my-stage -e DISPLAY=$DISPLAY --volumes-from=<containerId for my-desktop-base-container>  me/java9-gui:1.0 /bin/bash
# docker run -ti -v /tmp/.X11-unix:/tmp/.X11-unix -v /vagrant/files:/my-stage -e DISPLAY=$DISPLAY me/java8-gui:1.0 /bin/bash

# Base CONtainer - desktop - with JDeveloper
# ====================================================
# steps:
# ./puppet/manifests/jdev.pp contains Puppet manifest
# ./files contains installation files (jdk-7u79-linux-x64.tar, jdev_install_responsefile , fmw_12.1.3.0.0_soa_quickstart.jar , fmw_12.1.3.0.0_soa_quickstart2.jar)

# vagrant up my-desktop-base-container

# docker ps -a  to find container id
# docker start container id

#  docker exec -it container id bash 
# to have Java configured and JDeveloper installed and configured through Puppet:
#  puppet apply --modulepath=/puppet/modules /puppet/manifests/jdev.pp

# docker commit containerId  me/jdeveloper_12_1_3:1.0


# to run the container with JDeveloper (from within DockerDesktopHost):
# docker run -v /vagrant/files:/my-stage  -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY --link OracleStreamExplorer:sx  --name JDeveloper_12_1_3 --user oracle -w /u01/app/oracle/JDEV_Home/jdeveloper/jdev/bin  me/jdeveloper_12_1_3:1.0 "./jdev"

## --link OracleStreamExplorer:sx  ensures that the container described below can be accessed from within JDeveloper_12_1_3





# Base CONtainer - headless - with OEP and SX server
# ====================================================
# steps:
# ./puppet/manifests/base.pp contains Puppet manifest
# ./files contains installation files (jdk-7u79-linux-x64.tar, oep_install_responsefile, UnlimitedJCEPolicyJDK7.zip, oraInst.loc, fmw_12.1.3.0.0_oep.jar, ofm_sx_generic_12.1.3.0.1_disk1_2of2, directory user_projects)

# vagrant up my-base-container

# docker ps -a  to find container id
# docker start container id

#  docker exec -it container id bash 
# to have Java configured and OEP and SX installed and configured through Puppet:

#  puppet apply --modulepath=/puppet/modules /puppet/manifests/base.pp

# docker commit containerId  me/sx_12_1_3:1.0


# to run the container with OEP/SX:
# docker run -v /vagrant/files:/my-stage  -p 9202:9002 --user oracle -w /u01/app/oracle/OEP_Home/user_projects/domains/sx_domain/defaultserver --name OracleStreamExplorer  me/sx_12_1_3:1.0 /bin/bash "startwlevs.sh"

#Docker Cheatsheet: https://github.com/wsargent/docker-cheat-sheet 

# install netbeans (from my-stage as oracle)
# do not install as root or as sudo

# bash netbeans-jdk9branch-201506180405-javase-linux.sh --record state.xml -J-Djdk.installation.location=/usr/java/jdk1.8.0_60



## see http://fabiorehm.com/blog/2014/09/11/running-gui-apps-with-docker/ on GUI in Docker Containers
## note: problem with swap space in container solved by setting up swap space in dockethostvm
## see https://www.digitalocean.com/community/tutorials/how-to-install-discourse-on-ubuntu-14-04