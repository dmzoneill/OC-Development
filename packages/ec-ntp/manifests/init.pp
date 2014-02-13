class ec-ntp
{
    $dnsdomain = hiera( 'dnsdomain' , "${domain}" )
    $ntphost1 = hiera( 'ntphost1' , "ntp-host1.$dnsdomain" )
    $ntphost2 = hiera( 'ntphost2' , "ntp-host2.$dnsdomain" )
    $ntphost3 = hiera( 'ntphost3' , "ntp-host3.$dnsdomain" )
	$ntphost4 = hiera( 'ntphost4' , "ntp-host1.$dnsdomain" )
    
    file
    {
        "/etc/ntp.conf":
            path => "/etc/ntp.conf",
            ensure => file,
            checksum => md5,
            mode => 664,
            content => template( "${module_name}/ntp.conf.erb" )
    }
}
