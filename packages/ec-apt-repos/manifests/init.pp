class ec-apt-repos
{
	$domain = hiera( 'domain', 'intel.com' )
	$proxyhost = hiera( 'proxy::host', 'proxy' )
	$proxyport = hiera( 'proxy::port', '911' )
	$proxyfqdn = "$proxyhost.$domain"
	
	file 
	{
		"apt.conf":
			path    => "/etc/apt/apt.conf",
			owner   => 'root',
			group   => 'root',
			mode    => '0644',
			content => template( "$module_name/apt.conf.erb" )
	}
	
    apt::key 
    { 
        'opencloud':
            key => 'E65BD74C',
            key_source => 'http://silvpm.ir.intel.com/repos/intel/intel.key'
    }

	apt::source 
	{ 
		'opencloud':
			location => 'http://silvpm.ir.intel.com/repos/intel',
            repos => 'main',
            release => 'precise'
	}
	
    apt::key 
    { 
        'fuel':
			key => 'F8AF89DD',
            key_source => 'http://silvpm.ir.intel.com/repos/fuel/Mirantis.key'
    }

	apt::source 
	{ 
		'fuel':
			location => 'http://silvpm.ir.intel.com/repos/fuel',
            repos => 'main contrib non-free',
            release => 'precise'
	}
}
