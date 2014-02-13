class ec-resolv
{
    $dnsdomain = hiera( 'dnsdomain' , "${domain}" )
    $dnssearch = hiera( 'dnssearch' , "${domain} intel.com " )
    $dnshost1 = hiera( 'dnshost1' , "10.248.2.1" )
    $dnshost2 = hiera( 'dnshost2' , "163.33.253.68" )
    $dnshost3 = hiera( 'dnshost3' , "10.184.9.1" )
    
    file
    {
        "/etc/resolv.conf":
            path => "/etc/resolv.conf",
            ensure => file,
            checksum => md5,
            mode => 664,
            content => template( "${module_name}/resolv.conf.erb" )
    }
}
