class ec-ypclient
{
    $nisdomain = hiera( 'nisdomain' , 'basiscomm.ie' )
    $nishost1 = hiera( 'nishost1' , "nis-host1.${domain}" )
    $nishost2 = hiera( 'nishost2' , "nis-host2.${domain}" )

	package 
	{	
		"nis": 
			ensure => "installed"
	}
	
	file
	{
		"defaultdomain":
			path => "/etc/defaultdomain",
			ensure => file,
			checksum => md5,
			mode => 664,
			content => template( "${module_name}/defaultdomain.erb" )
	}

	file
	{
		"yp.conf":
			path => "/etc/yp.conf",
			ensure => file,
			checksum => md5,
			mode => 664,
			content => template( "${module_name}/yp.conf.erb" )
	}
	
	service 
	{ 
		"ypbind":
			ensure => "running",
			enable  => "true",
			subscribe => File[ 'defaultdomain' , 'yp.conf' ],
			restart => '/usr/sbin/iptables -F; /usr/sbin/ufw disable; /etc/init.d/ypbind restart'
	}
}
