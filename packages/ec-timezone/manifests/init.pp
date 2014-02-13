class ec-timezone
{
	$tz_major = hiera( 'tzmajor' , "Europe" )
	$tz_minor = hiera( 'tzminor' , "Dublin" )
    $timezone = hiera( 'timezone' , "$tz_major/$tz_minor" )

    file
    {
        "/etc/timezone":
            path => "/etc/timezone",
            ensure => file,
            checksum => md5,
            mode => 664,
            content => template( "${module_name}/timezone.erb" )
    }
	
	file 
	{ 
		'/usr/share/zoneinfo/$tz_major/$tz_minor':
			ensure => 'link',
			target => '/etc/localtime',
			notify => Exec[ 'tzinfo' ],
	}

	exec
	{
		'tzinfo':
			refreshonly => true,
			command => "dpkg-reconfigure --frontend noninteractive tzdata",
	}
}
