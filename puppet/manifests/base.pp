$my_full_name = "developer"
$group=oracle

include java::install


group { "oracle":
	ensure		=> present,
}

group { "admin":
	ensure		=> present,
}

user { "oracle":
	ensure		=> present,
	comment		=> "$my_full_name",
	gid			=> "oracle",
		groups		=> ["admin", "sudo" ,"root"],
#	membership	=> minimum,
	shell		=> "/bin/bash",
	home		=> "/u01/app/oracle",
}


exec { "oracle homedir":
	command	=> "/bin/cp -R /etc/skel /home/$username; /bin/chown -R $username:$group /home/$username",
	creates	=> "/home/$username",
	require	=> User[oracle],
}

$oracle_product_home_directories = ["/u01","/u01/app","/u01/app/oracle"]

file { $oracle_product_home_directories:
  ensure => directory,
  group => 'oracle',
  owner => 'oracle',
  require => User[oracle],
}

exec { "apt-update":
    command => "/usr/bin/apt-get update"
}

Exec["apt-update"]	-> Package <| |>


## this configuration calls for the installation of OEP using the oep module and its oep::install configuration
## the installation requires the existence of the swap file and the installation of Java
## parameters can be passed to the oep::install configuration to specify what should be installed (and where)



File[$oracle_product_home_directories] -> Class['oep_installation']

class oep_installation {
  require java::install 


  oep::install {'Install_OEP':
    sx_version              => '12.1.3.0.0',
    sx_pkg                  => 'fmw_12.1.3.0.0_oep.jar',
    downloadDir             => '/stage',
  }

  oep::domain {'Install_OEP_Domain_sx_domain':
   # OEP_HOME                => '/u01/app/oracle/OEP_Home',
    downloadDir             => '/stage',
 }
}

include oep_installation

include sx_installation

Class['oep_installation'] -> Class['sx_installation']

class sx_installation {
  
  $oracle_home_dir = '/u01/app/oracle'
  $download_dir = '/stage'
  $opatchId ='20636710'
  $opatchFile ='ofm_sx_generic_12.1.3.0.1_disk1_2of2.zip'
  $JDKName ='jdk1.7.0_79'
  $targetOracleProductHome = '/u01/app/oracle/OEP_Home'

  opatch::apply{ 'StreamExplorer_12_1_3_0_1':
  oracleProductHome       => $targetOracleProductHome,
  fullJDKName             => $JDKName,
  patchId                 => $opatchId,
  patchFile               => $opatchFile,
  user                    => 'oracle',
  group                   => 'oracle',
  downloadDir             => $download_dir,
  remoteFile              => false,
}
}



