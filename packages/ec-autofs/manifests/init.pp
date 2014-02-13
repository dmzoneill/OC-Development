class ec-autofs
{
    $autofslines = hiera( 'autofslines' , "+auto.masterpub" )
    
	package 
	{	
		'autofs': 
			ensure => installed
	}
	
	file
    {
        "auto.master":
			notify  => Service[ 'autofs' ],
            path => "/etc/auto.master",
            ensure => file,
            checksum => md5,
            mode => 664,
            content => template( "${module_name}/auto.master.erb" ),
			require => Package[ 'autofs' ],
    }
	
	service 
	{ 
		"autofs":
			ensure => "running",
			enable  => "true",
			subscribe => File[ 'auto.master' ],
	}
}
