class ec-proxy
{
	$domain = hiera( 'domain', 'intel.com' )
	$proxyhost = hiera( 'proxy::host', 'proxy' )
	$proxyport = hiera( 'proxy::port', '911' )
	$proxyfqdn = "$proxyhost.$domain"
	$noproxy = "silvpm.$domain"
	
	file 
	{
		"/root/.wgetrc":
			path    => "/root/.wgetrc",
			owner   => 'root',
			group   => 'root',
			mode    => '0644',
			content => template( "$module_name/wgetrc.erb" )
	}	
}
