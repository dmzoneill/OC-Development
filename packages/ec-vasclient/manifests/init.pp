class ec-vasclient
{
	$addomain = hiera( 'addomain' , 'amr' )
    $compou = hiera( 'compou' , "OU=Open Cloud,OU=Servers,OU=Engineering Computing,OU=Resources,DC=${addomain},DC=corp,DC=intel,DC=com" )
    $keytab = hiera( 'keytab' , "${addomain}-joiner.keytab" )
    $account = hiera( 'joiner_username' , "sys_${addomain}joiner" )

    package 
    {       
        [ 'vasclnts' ]:
            ensure => present,
            require => [ Class[ 'apt' ], Class[ 'ec-apt-repos' ] ]
    }
	
	file 
	{ 
		'/etc/keytab':
			ensure => file,
            source => "puppet:///modules/$module_name/$keytab"
	}

	exec
	{
		'joindom':
            path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ],
			refreshonly => true,
			command => "/opt/quest/bin/vastool -u $account -k /etc/keytab join -c '$compou' -n '$hostname' -wf $addomain.corp.intel.com",
            onlyif => "/opt/quest/bin/vastool status -v | grep 'host.keytab does not exist'",
            require => Package[ "vasclnts" ]
	}
}
