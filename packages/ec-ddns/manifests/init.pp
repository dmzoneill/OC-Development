class ec-ddns
{
	$addomain = hiera( 'addomain' , 'amr' )

    package 
    {       
        [ 'quest-dnsupdate' ]:
            ensure => present,
            require => [ Class[ 'apt' ], Class[ 'ec-apt-repos' ] ]
    }
	
	file 
	{ 
		'/etc/dhcp/dhclient-exit-hooks.d/dnsupdate':
			ensure  => file,
			content => 'dnsupdate -h $hostname.$addomain.corp.intel.com',			
			notify => Exec[ 'dnsupdate' ]
	}

	exec
	{
		'dnsupdate':
			refreshonly => true,
			command => "/opt/quest/sbin/dnsupdate -v -h $hostname.$addomain.corp.intel.com $ipaddress >/var/log/dnsupdate.log 2>/var/log/dnsupdate.log",
	}
	
	cron 
	{
		'dnsupdate':
			command => "/opt/quest/sbin/dnsupdate -v -h $hostname.$addomain.corp.intel.com $ipaddress >/var/log/dnsupdate.log 2>/var/log/dnsupdate.log",
			user    => root,
			hour    => 2,
			minute  => 0
	}
}
