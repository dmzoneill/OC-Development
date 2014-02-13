class ec-mysql
{
	$mysql_master_ip = $ipaddress_eth0
	$mysql_query_cache_size = hiera( 'autofslines' , '0' )
	$mysql_binlog_format = hiera( 'mysql_binlog_format' , 'ROW' )
	$mysql_default_storage_engine = hiera( 'mysql_default_storage_engine' , 'innodb' )
	$mysql_innodb_autoinc_lock_mode = hiera( 'mysql_innodb_autoinc_lock_mode' , '2' )
	$mysql_innodb_doublewrite = hiera( 'mysql_innodb_doublewrite' , '1' )
	$mysql_datadir = hiera( 'mysql_datadir' , '/var/lib/mysql' )	
	$mysql_innodb_buffer_pool_size = hiera( 'mysql_innodb_buffer_pool_size' , '512M' )
	$mysql_innodb_log_file_size = hiera( 'mysql_innodb_log_file_size' , '100M' )
	$mysql_innodb_flush_log_at_trx_commit = hiera( 'mysql_innodb_flush_log_at_trx_commit' , '2' )	
	$mysql_wsrep_provider = hiera( 'mysql_wsrep_provider' , '/usr/lib/galera/libgalera_smm.so' )
	$mysql_wsrep_provider_options = hiera( 'mysql_wsrep_provider_options' , '"gcache.size=32G"' )
	$mysql_wsrep_cluster_address = hiera( 'mysql_wsrep_cluster_address' , 'gcomm://$ipaddress_eth0' )
	$mysql_wsrep_cluster_name = hiera( 'mysql_wsrep_cluster_name' , 'intel' )
	$mysql_wsrep_node_address = hiera( 'mysql_wsrep_node_address' , "$ipaddress_eth0" )
	$mysql_wsrep_node_name = hiera( 'mysql_wsrep_node_name' , 'node2' )
	$mysql_wsrep_sst_method = hiera( 'mysql_wsrep_sst_method' , 'xtrabackup' )
	$mysql_wsrep_sst_auth = hiera( 'mysql_wsrep_sst_auth' , 'root:pass' )
	$mysql_wsrep_node_incoming_address = hiera( 'mysql_wsrep_node_incoming_address' , '0.0.0.0' )
	$mysql_wsrep_sst_donor = hiera( 'mysql_wsrep_sst_donor' , '' )
	$mysql_wsrep_slave_threads = hiera( 'mysql_wsrep_slave_threads' , '16' )

	package 
	{ 
		[ 'mysql-server-wsrep', 'galera' ]:
			ensure => present,
			require => [ Class[ 'apt' ], Class[ 'ec-apt-repos' ] ],
	}
	
	file
    {
        "my.cnf":
			notify  => service[ 'mysql' ],
            path => "/etc/mysql/my.cnf",
            ensure => file,
            checksum => md5,
            mode => 664,
            content => template( "${module_name}/my.cnf.erb" ),
			require => [ Package[ 'mysql-server-wsrep' ] , Package[ 'galera' ] ]
    }
	
	exec 
	{ 
		"/etc/init.d/mysql start --wsrep-new-cluster":
			path => "/usr/bin:/usr/sbin:/bin",
			onlyif => "test ! -f /etc/mysql/.newcluster",
			require => [ File[ 'my.cnf' ] , Package[ 'mysql-server-wsrep' ] , Package[ 'galera' ]  ]
	}
	
	file 
	{ 
		"/etc/mysql/.newcluster":
			ensure => "present",
			audit  => "all"
	}
	
	if $mysql_master_ip == $ipaddress_eth0
	{
		service 
		{ 
			"mysql":
				ensure => "running",
				enable  => "true",
				subscribe => [ File[ 'my.cnf' ], File [ '/etc/mysql/.newcluster' ] ]
		}
	}
	else
	{
		service 
		{ 
			"mysql":
				ensure => "running",
				enable  => "true",
				subscribe => [ File[ 'my.cnf' ] ]
		}
	}
}
