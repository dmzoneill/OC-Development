class ec-puppet-config
{
	$fileserver = hiera( 'fileserver' , 'puppet.${domain}' )
	$puppetdir = "/etc/puppet"
	$facterdir = "/etc/facter"
	$domain = hiera( 'domain' , 'intel.com' )
	$proxyhost = hiera( 'proxyhost' , 'proxy.${domain}' )
	$proxyport = hiera( 'proxyport' , '911' )
	$intelenv = hiera( 'intelenv' , 'production' )


	file 
	{ 
		"${facterdir}/facts.d":
			ensure => "directory"
	}

	file
	{
		"${puppetdir}/puppet.conf":
			ensure => file,
			owner => 'root',
			group => 'root',
			mode => '0664',
			content => template( "${module_name}/puppet.erb" )
	}

	file
	{
		"${facterdir}/facts.d/facternodes.pl":
			ensure => file,
			owner => 'root',
			group => 'root',
			mode => '0755',
			source => "puppet:///modules/${module_name}/facternodes.pl"
	}


	file
	{
		"${facterdir}/facts.d/testmeta.sh":
			ensure => file,
			owner => 'root',
			group => 'root',
			mode => '0755',
			source => "puppet:///modules/${module_name}/testmeta.sh"
	}
}

