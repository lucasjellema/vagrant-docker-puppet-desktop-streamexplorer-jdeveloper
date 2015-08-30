
# == Define: oep
#
# installs Oracle Event Processor and Stream Explorer
#
define oep::install(  
  $sx_version              = '12.1.3.0.0',
  $sx_pkg                  = 'fmw_12.1.3.0.0_oep.jar',
  $sx_patch_id             = '20636710',
  $oep_wlevs_password      = 'weblogic1',
  $OEP_HOME                = '/u01/app/oracle/OEP_Home',
  $user                    = 'oracle',
  $group                   = 'oracle',
  $downloadDir             = '/vagrant',
  $fullJDKName             = 'jdk1.7.0_79',
) {

$responseFile = "${downloadDir}/oep_install_responsefile"
$inventoryLocFile = "${downloadDir}/oraInst.loc"
$JAVA_HOME               = "/usr/java/$fullJDKName"

#RUN java -jar $SX_PKG -silent -responseFile $res -invPtrLoc /u01/oraInst.loc -jreLoc $JAVA_HOME && \
#    rm $SX_PKG /u01/oraInst.loc /u01/install.file

$installCommand = "java -jar ${downloadDir}/$sx_pkg -silent -responseFile $responseFile -invPtrLoc $inventoryLocFile -jreLoc $JAVA_HOME -ignoreSysPrereqs"
$cleanupCommand = "rm $sx_pkg $inventoryLocFile /u01/install.file"	
	
notify { 'report path':
  message  => "the value for the path variable: $JAVA_HOME/bin",
  withpath => true,
}	
	
  exec {"install oep":
	 path => '/bin:/usr/bin:/sbin:/usr/sbin',
     command => $installCommand,
     #cwd => $downloadDir,
     user => 'oracle',
  	 creates => "$OEP_HOME/oep"
  }


}

define oep::domain(  
  $OEP_HOME                = '/u01/app/oracle/OEP_Home',
  $user                    = 'oracle',
  $group                   = 'oracle',
  $downloadDir             = '/vagrant',
) {

file { "$OEP_HOME":
  ensure => directory,
  group => 'oracle',
  owner => 'oracle',
  require => Exec["install oep"]
}

file { 'user_projects':
  path=> "$OEP_HOME/user_projects",
  source  => "${downloadDir}/user_projects",
  recurse => true,
  require => File["$OEP_HOME"]
}

}