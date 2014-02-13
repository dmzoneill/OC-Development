class ec-apache
{
	$apache_master_ip = $ipaddress_eth0
	$apache_query_cache_size = hiera( 'autofslines' , '0' )
	$apache_binlog_format = hiera( 'apache_binlog_format' , 'ROW' )
	$apache_default_storage_engine = hiera( 'apache_default_storage_engine' , 'innodb' )
	$apache_innodb_autoinc_lock_mode = hiera( 'apache_innodb_autoinc_lock_mode' , '2' )
	$apache_innodb_doublewrite = hiera( 'apache_innodb_doublewrite' , '1' )
	$apache_datadir = hiera( 'apache_datadir' , '/var/lib/apache' )	
	$apache_innodb_buffer_pool_size = hiera( 'apache_innodb_buffer_pool_size' , '512M' )
	$apache_innodb_log_file_size = hiera( 'apache_innodb_log_file_size' , '100M' )
	$apache_innodb_flush_log_at_trx_commit = hiera( 'apache_innodb_flush_log_at_trx_commit' , '2' )	
	$apache_wsrep_provider = hiera( 'apache_wsrep_provider' , '/usr/lib/galera/libgalera_smm.so' )
	$apache_wsrep_provider_options = hiera( 'apache_wsrep_provider_options' , '"gcache.size=32G"' )
	$apache_wsrep_cluster_address = hiera( 'apache_wsrep_cluster_address' , 'gcomm://$ipaddress_eth0' )
	$apache_wsrep_cluster_name = hiera( 'apache_wsrep_cluster_name' , 'intel' )
	$apache_wsrep_node_address = hiera( 'apache_wsrep_node_address' , "$ipaddress_eth0" )
	$apache_wsrep_node_name = hiera( 'apache_wsrep_node_name' , 'node2' )
	$apache_wsrep_sst_method = hiera( 'apache_wsrep_sst_method' , 'xtrabackup' )
	$apache_wsrep_sst_auth = hiera( 'apache_wsrep_sst_auth' , 'root:pass' )
	$apache_wsrep_node_incoming_address = hiera( 'apache_wsrep_node_incoming_address' , '0.0.0.0' )
	$apache_wsrep_sst_donor = hiera( 'apache_wsrep_sst_donor' , '' )
	$apache_wsrep_slave_threads = hiera( 'apache_wsrep_slave_threads' , '16' )

	package 
	{ 
		[ 'apache2', 'apache2-mpm-prefork', 'apache2-utils', 'apache2.2-common', 'libapache2-mod-php5', 'php5', 'php5-cgi', 'php5-common', 'php5-cli', 'php5-mysql', 
		  'python', 'ruby', 'perl', 'libapr1', 'libaprutil1', 'libdbd-mysql-perl', 'libdbi-perl', 'libnet-daemon-perl', 'libplrpc-perl', 'libpq5', 'mysql-client-5.5' ]:
			ensure => present,
			require => [ Class[ 'apt' ], Class[ 'ec-apt-repos' ] ],
	}
	
	service 
	{ 
		"apache2":
			ensure  => "running",
			enable  => "true",
			require => Package[ "apache2" ],
	}	

    file
    {   
        "other_vhosts_access_log":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/conf.d/other-vhosts-access-log",
            ensure => file,                                           
            checksum => md5,                                          
            mode => 664,                                              
            content => template( "${module_name}/apache2/conf.d/other-vhosts-access-log.erb" ),
            require => [ Package[ 'apache2' ] ]                                                    
    }                                                                                              

    file
    {   
        "security":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/conf.d/security",
            ensure => file,                            
            checksum => md5,                           
            mode => 664,                               
            content => template( "${module_name}/apache2/conf.d/security.erb" ),
            require => [ Package[ 'apache2' ] ]                                     
    }                                                                               

    file
    {   
        "localized_error_pages":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/conf.d/localized-error-pages",
            ensure => file,                                         
            checksum => md5,                                        
            mode => 664,                                            
            content => template( "${module_name}/apache2/conf.d/localized-error-pages.erb" ),
            require => [ Package[ 'apache2' ] ]                                                  
    }                                                                                            

    file
    {   
        "charset":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/conf.d/charset",
            ensure => file,                           
            checksum => md5,                          
            mode => 664,                              
            content => template( "${module_name}/apache2/conf.d/charset.erb" ),
            require => [ Package[ 'apache2' ] ]                                    
    }                                                                              

    file
    {   
        "substitute_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/substitute.load",
            ensure => file,                                           
            checksum => md5,                                          
            mode => 664,                                              
            content => template( "${module_name}/apache2/mods-available/substitute.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                    
    }                                                                                              

    file
    {   
        "mem_cache_conf":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/mem_cache.conf",
            ensure => file,                                          
            checksum => md5,                                         
            mode => 664,                                             
            content => template( "${module_name}/apache2/mods-available/mem_cache.conf.erb" ),
            require => [ Package[ 'apache2' ] ]                                                   
    }                                                                                             

    file
    {   
        "ssl_conf":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/ssl.conf",
            ensure => file,                                    
            checksum => md5,                                   
            mode => 664,                                       
            content => template( "${module_name}/apache2/mods-available/ssl.conf.erb" ),
            require => [ Package[ 'apache2' ] ]                                             
    }                                                                                       

    file
    {   
        "negotiation_conf":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/negotiation.conf",
            ensure => file,                                            
            checksum => md5,                                           
            mode => 664,                                               
            content => template( "${module_name}/apache2/mods-available/negotiation.conf.erb" ),
            require => [ Package[ 'apache2' ] ]                                                     
    }                                                                                               

    file
    {   
        "reqtimeout_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/reqtimeout.load",
            ensure => file,                                           
            checksum => md5,                                          
            mode => 664,                                              
            content => template( "${module_name}/apache2/mods-available/reqtimeout.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                    
    }                                                                                              

    file
    {   
        "status_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/status.load",
            ensure => file,                                       
            checksum => md5,                                      
            mode => 664,                                          
            content => template( "${module_name}/apache2/mods-available/status.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                
    }                                                                                          

    file
    {   
        "proxy_ftp_conf":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/proxy_ftp.conf",
            ensure => file,                                          
            checksum => md5,                                         
            mode => 664,                                             
            content => template( "${module_name}/apache2/mods-available/proxy_ftp.conf.erb" ),
            require => [ Package[ 'apache2' ] ]                                                   
    }                                                                                             

    file
    {   
        "dir_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/dir.load",
            ensure => file,                                    
            checksum => md5,                                   
            mode => 664,                                       
            content => template( "${module_name}/apache2/mods-available/dir.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                             
    }                                                                                       

    file
    {   
        "userdir_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/userdir.load",
            ensure => file,                                        
            checksum => md5,                                       
            mode => 664,                                           
            content => template( "${module_name}/apache2/mods-available/userdir.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                 
    }                                                                                           

    file
    {   
        "proxy_balancer_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/proxy_balancer.load",
            ensure => file,                                               
            checksum => md5,                                              
            mode => 664,                                                  
            content => template( "${module_name}/apache2/mods-available/proxy_balancer.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                        
    }                                                                                                  

    file
    {   
        "mime_magic_conf":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/mime_magic.conf",
            ensure => file,                                           
            checksum => md5,                                          
            mode => 664,                                              
            content => template( "${module_name}/apache2/mods-available/mime_magic.conf.erb" ),
            require => [ Package[ 'apache2' ] ]                                                    
    }                                                                                              

    file
    {   
        "deflate_conf":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/deflate.conf",
            ensure => file,                                        
            checksum => md5,                                       
            mode => 664,                                           
            content => template( "${module_name}/apache2/mods-available/deflate.conf.erb" ),
            require => [ Package[ 'apache2' ] ]                                                 
    }                                                                                           

    file
    {   
        "asis_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/asis.load",
            ensure => file,                                     
            checksum => md5,                                    
            mode => 664,                                        
            content => template( "${module_name}/apache2/mods-available/asis.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                              
    }                                                                                        

    file
    {   
        "proxy_ftp_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/proxy_ftp.load",
            ensure => file,                                          
            checksum => md5,                                         
            mode => 664,                                             
            content => template( "${module_name}/apache2/mods-available/proxy_ftp.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                   
    }                                                                                             

    file
    {   
        "disk_cache_conf":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/disk_cache.conf",
            ensure => file,                                           
            checksum => md5,                                          
            mode => 664,                                              
            content => template( "${module_name}/apache2/mods-available/disk_cache.conf.erb" ),
            require => [ Package[ 'apache2' ] ]                                                    
    }                                                                                              

    file
    {   
        "charset_lite_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/charset_lite.load",
            ensure => file,                                             
            checksum => md5,                                            
            mode => 664,                                                
            content => template( "${module_name}/apache2/mods-available/charset_lite.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                      
    }                                                                                                

    file
    {   
        "include_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/include.load",
            ensure => file,                                        
            checksum => md5,                                       
            mode => 664,                                           
            content => template( "${module_name}/apache2/mods-available/include.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                 
    }                                                                                           

    file
    {   
        "headers_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/headers.load",
            ensure => file,                                        
            checksum => md5,                                       
            mode => 664,                                           
            content => template( "${module_name}/apache2/mods-available/headers.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                 
    }                                                                                           

    file
    {   
        "authn_default_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/authn_default.load",
            ensure => file,                                              
            checksum => md5,                                             
            mode => 664,                                                 
            content => template( "${module_name}/apache2/mods-available/authn_default.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                       
    }                                                                                                 

    file
    {   
        "autoindex_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/autoindex.load",
            ensure => file,                                          
            checksum => md5,                                         
            mode => 664,                                             
            content => template( "${module_name}/apache2/mods-available/autoindex.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                   
    }                                                                                             

    file
    {   
        "dbd_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/dbd.load",
            ensure => file,                                    
            checksum => md5,                                   
            mode => 664,                                       
            content => template( "${module_name}/apache2/mods-available/dbd.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                             
    }                                                                                       

    file
    {   
        "cache_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/cache.load",
            ensure => file,                                      
            checksum => md5,                                     
            mode => 664,                                         
            content => template( "${module_name}/apache2/mods-available/cache.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                               
    }                                                                                         

    file
    {   
        "deflate_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/deflate.load",
            ensure => file,                                        
            checksum => md5,                                       
            mode => 664,                                           
            content => template( "${module_name}/apache2/mods-available/deflate.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                 
    }                                                                                           

    file
    {   
        "authnz_ldap_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/authnz_ldap.load",
            ensure => file,                                            
            checksum => md5,                                           
            mode => 664,                                               
            content => template( "${module_name}/apache2/mods-available/authnz_ldap.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                     
    }                                                                                               

    file
    {   
        "autoindex_conf":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/autoindex.conf",
            ensure => file,                                          
            checksum => md5,                                         
            mode => 664,                                             
            content => template( "${module_name}/apache2/mods-available/autoindex.conf.erb" ),
            require => [ Package[ 'apache2' ] ]                                                   
    }                                                                                             

    file
    {   
        "dir_conf":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/dir.conf",
            ensure => file,                                    
            checksum => md5,                                   
            mode => 664,                                       
            content => template( "${module_name}/apache2/mods-available/dir.conf.erb" ),
            require => [ Package[ 'apache2' ] ]                                             
    }                                                                                       

    file
    {   
        "version_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/version.load",
            ensure => file,                                        
            checksum => md5,                                       
            mode => 664,                                           
            content => template( "${module_name}/apache2/mods-available/version.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                 
    }                                                                                           

    file
    {   
        "mime_conf":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/mime.conf",
            ensure => file,                                     
            checksum => md5,                                    
            mode => 664,                                        
            content => template( "${module_name}/apache2/mods-available/mime.conf.erb" ),
            require => [ Package[ 'apache2' ] ]                                              
    }                                                                                        

    file
    {   
        "env_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/env.load",
            ensure => file,                                    
            checksum => md5,                                   
            mode => 664,                                       
            content => template( "${module_name}/apache2/mods-available/env.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                             
    }                                                                                       

    file
    {   
        "imagemap_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/imagemap.load",
            ensure => file,                                         
            checksum => md5,                                        
            mode => 664,                                            
            content => template( "${module_name}/apache2/mods-available/imagemap.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                  
    }                                                                                            

    file
    {   
        "actions_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/actions.load",
            ensure => file,                                        
            checksum => md5,                                       
            mode => 664,                                           
            content => template( "${module_name}/apache2/mods-available/actions.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                 
    }                                                                                           

    file
    {   
        "unique_id_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/unique_id.load",
            ensure => file,                                          
            checksum => md5,                                         
            mode => 664,                                             
            content => template( "${module_name}/apache2/mods-available/unique_id.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                   
    }                                                                                             

    file
    {   
        "authz_host_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/authz_host.load",
            ensure => file,                                           
            checksum => md5,                                          
            mode => 664,                                              
            content => template( "${module_name}/apache2/mods-available/authz_host.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                    
    }                                                                                              

    file
    {   
        "info_conf":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/info.conf",
            ensure => file,                                     
            checksum => md5,                                    
            mode => 664,                                        
            content => template( "${module_name}/apache2/mods-available/info.conf.erb" ),
            require => [ Package[ 'apache2' ] ]                                              
    }                                                                                        

    file
    {   
        "negotiation_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/negotiation.load",
            ensure => file,                                            
            checksum => md5,                                           
            mode => 664,                                               
            content => template( "${module_name}/apache2/mods-available/negotiation.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                     
    }                                                                                               

    file
    {   
        "authz_groupfile_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/authz_groupfile.load",
            ensure => file,                                                
            checksum => md5,                                               
            mode => 664,                                                   
            content => template( "${module_name}/apache2/mods-available/authz_groupfile.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                         
    }                                                                                                   

    file
    {   
        "proxy_balancer_conf":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/proxy_balancer.conf",
            ensure => file,                                               
            checksum => md5,                                              
            mode => 664,                                                  
            content => template( "${module_name}/apache2/mods-available/proxy_balancer.conf.erb" ),
            require => [ Package[ 'apache2' ] ]                                                        
    }                                                                                                  

    file
    {   
        "cgid_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/cgid.load",
            ensure => file,                                     
            checksum => md5,                                    
            mode => 664,                                        
            content => template( "${module_name}/apache2/mods-available/cgid.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                              
    }                                                                                        

    file
    {   
        "authn_file_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/authn_file.load",
            ensure => file,                                           
            checksum => md5,                                          
            mode => 664,                                              
            content => template( "${module_name}/apache2/mods-available/authn_file.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                    
    }                                                                                              

    file
    {   
        "log_forensic_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/log_forensic.load",
            ensure => file,                                             
            checksum => md5,                                            
            mode => 664,                                                
            content => template( "${module_name}/apache2/mods-available/log_forensic.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                      
    }                                                                                                

    file
    {   
        "proxy_http_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/proxy_http.load",
            ensure => file,                                           
            checksum => md5,                                          
            mode => 664,                                              
            content => template( "${module_name}/apache2/mods-available/proxy_http.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                    
    }                                                                                              

    file
    {   
        "authn_alias_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/authn_alias.load",
            ensure => file,                                            
            checksum => md5,                                           
            mode => 664,                                               
            content => template( "${module_name}/apache2/mods-available/authn_alias.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                     
    }                                                                                               

    file
    {   
        "auth_digest_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/auth_digest.load",
            ensure => file,                                            
            checksum => md5,                                           
            mode => 664,                                               
            content => template( "${module_name}/apache2/mods-available/auth_digest.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                     
    }                                                                                               

    file
    {   
        "ident_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/ident.load",
            ensure => file,                                      
            checksum => md5,                                     
            mode => 664,                                         
            content => template( "${module_name}/apache2/mods-available/ident.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                               
    }                                                                                         

    file
    {   
        "userdir_conf":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/userdir.conf",
            ensure => file,                                        
            checksum => md5,                                       
            mode => 664,                                           
            content => template( "${module_name}/apache2/mods-available/userdir.conf.erb" ),
            require => [ Package[ 'apache2' ] ]                                                 
    }                                                                                           

    file
    {   
        "mem_cache_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/mem_cache.load",
            ensure => file,                                          
            checksum => md5,                                         
            mode => 664,                                             
            content => template( "${module_name}/apache2/mods-available/mem_cache.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                   
    }                                                                                             

    file
    {   
        "proxy_connect_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/proxy_connect.load",
            ensure => file,                                              
            checksum => md5,                                             
            mode => 664,                                                 
            content => template( "${module_name}/apache2/mods-available/proxy_connect.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                       
    }                                                                                                 

    file
    {   
        "reqtimeout_conf":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/reqtimeout.conf",
            ensure => file,                                           
            checksum => md5,                                          
            mode => 664,                                              
            content => template( "${module_name}/apache2/mods-available/reqtimeout.conf.erb" ),
            require => [ Package[ 'apache2' ] ]                                                    
    }                                                                                              

    file
    {   
        "proxy_ajp_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/proxy_ajp.load",
            ensure => file,                                          
            checksum => md5,                                         
            mode => 664,                                             
            content => template( "${module_name}/apache2/mods-available/proxy_ajp.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                   
    }                                                                                             

    file
    {   
        "auth_basic_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/auth_basic.load",
            ensure => file,                                           
            checksum => md5,                                          
            mode => 664,                                              
            content => template( "${module_name}/apache2/mods-available/auth_basic.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                    
    }                                                                                              

    file
    {   
        "authn_dbm_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/authn_dbm.load",
            ensure => file,                                          
            checksum => md5,                                         
            mode => 664,                                             
            content => template( "${module_name}/apache2/mods-available/authn_dbm.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                   
    }                                                                                             

    file
    {   
        "proxy_scgi_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/proxy_scgi.load",
            ensure => file,                                           
            checksum => md5,                                          
            mode => 664,                                              
            content => template( "${module_name}/apache2/mods-available/proxy_scgi.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                    
    }                                                                                              

    file
    {   
        "info_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/info.load",
            ensure => file,                                     
            checksum => md5,                                    
            mode => 664,                                        
            content => template( "${module_name}/apache2/mods-available/info.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                              
    }                                                                                        

    file
    {   
        "disk_cache_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/disk_cache.load",
            ensure => file,                                           
            checksum => md5,                                          
            mode => 664,                                              
            content => template( "${module_name}/apache2/mods-available/disk_cache.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                    
    }                                                                                              

    file
    {   
        "usertrack_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/usertrack.load",
            ensure => file,                                          
            checksum => md5,                                         
            mode => 664,                                             
            content => template( "${module_name}/apache2/mods-available/usertrack.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                   
    }                                                                                             

    file
    {   
        "dump_io_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/dump_io.load",
            ensure => file,                                        
            checksum => md5,                                       
            mode => 664,                                           
            content => template( "${module_name}/apache2/mods-available/dump_io.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                 
    }                                                                                           

    file
    {   
        "authz_default_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/authz_default.load",
            ensure => file,                                              
            checksum => md5,                                             
            mode => 664,                                                 
            content => template( "${module_name}/apache2/mods-available/authz_default.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                       
    }                                                                                                 

    file
    {   
        "cgi_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/cgi.load",
            ensure => file,                                    
            checksum => md5,                                   
            mode => 664,                                       
            content => template( "${module_name}/apache2/mods-available/cgi.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                             
    }                                                                                       

    file
    {   
        "mime_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/mime.load",
            ensure => file,                                     
            checksum => md5,                                    
            mode => 664,                                        
            content => template( "${module_name}/apache2/mods-available/mime.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                              
    }                                                                                        

    file
    {   
        "speling_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/speling.load",
            ensure => file,                                        
            checksum => md5,                                       
            mode => 664,                                           
            content => template( "${module_name}/apache2/mods-available/speling.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                 
    }                                                                                           

    file
    {   
        "mime_magic_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/mime_magic.load",
            ensure => file,                                           
            checksum => md5,                                          
            mode => 664,                                              
            content => template( "${module_name}/apache2/mods-available/mime_magic.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                    
    }                                                                                              

    file
    {   
        "ldap_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/ldap.load",
            ensure => file,                                     
            checksum => md5,                                    
            mode => 664,                                        
            content => template( "${module_name}/apache2/mods-available/ldap.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                              
    }                                                                                        

    file
    {   
        "authz_user_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/authz_user.load",
            ensure => file,                                           
            checksum => md5,                                          
            mode => 664,                                              
            content => template( "${module_name}/apache2/mods-available/authz_user.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                    
    }                                                                                              

    file
    {   
        "vhost_alias_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/vhost_alias.load",
            ensure => file,                                            
            checksum => md5,                                           
            mode => 664,                                               
            content => template( "${module_name}/apache2/mods-available/vhost_alias.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                     
    }                                                                                               

    file
    {   
        "authz_owner_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/authz_owner.load",
            ensure => file,                                            
            checksum => md5,                                           
            mode => 664,                                               
            content => template( "${module_name}/apache2/mods-available/authz_owner.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                     
    }                                                                                               

    file
    {   
        "authn_dbd_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/authn_dbd.load",
            ensure => file,                                          
            checksum => md5,                                         
            mode => 664,                                             
            content => template( "${module_name}/apache2/mods-available/authn_dbd.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                   
    }                                                                                             

    file
    {   
        "rewrite_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/rewrite.load",
            ensure => file,                                        
            checksum => md5,                                       
            mode => 664,                                           
            content => template( "${module_name}/apache2/mods-available/rewrite.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                 
    }                                                                                           

    file
    {   
        "setenvif_conf":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/setenvif.conf",
            ensure => file,                                         
            checksum => md5,                                        
            mode => 664,                                            
            content => template( "${module_name}/apache2/mods-available/setenvif.conf.erb" ),
            require => [ Package[ 'apache2' ] ]                                                  
    }                                                                                            

    file
    {   
        "ldap_conf":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/ldap.conf",
            ensure => file,                                     
            checksum => md5,                                    
            mode => 664,                                        
            content => template( "${module_name}/apache2/mods-available/ldap.conf.erb" ),
            require => [ Package[ 'apache2' ] ]                                              
    }                                                                                        

    file
    {   
        "filter_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/filter.load",
            ensure => file,                                       
            checksum => md5,                                      
            mode => 664,                                          
            content => template( "${module_name}/apache2/mods-available/filter.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                
    }                                                                                          

    file
    {   
        "alias_conf":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/alias.conf",
            ensure => file,                                      
            checksum => md5,                                     
            mode => 664,                                         
            content => template( "${module_name}/apache2/mods-available/alias.conf.erb" ),
            require => [ Package[ 'apache2' ] ]                                               
    }                                                                                         

    file
    {   
        "setenvif_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/setenvif.load",
            ensure => file,                                         
            checksum => md5,                                        
            mode => 664,                                            
            content => template( "${module_name}/apache2/mods-available/setenvif.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                  
    }                                                                                            

    file
    {   
        "proxy_conf":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/proxy.conf",
            ensure => file,                                      
            checksum => md5,                                     
            mode => 664,                                         
            content => template( "${module_name}/apache2/mods-available/proxy.conf.erb" ),
            require => [ Package[ 'apache2' ] ]                                               
    }                                                                                         

    file
    {   
        "dav_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/dav.load",
            ensure => file,                                    
            checksum => md5,                                   
            mode => 664,                                       
            content => template( "${module_name}/apache2/mods-available/dav.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                             
    }                                                                                       

    file
    {   
        "suexec_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/suexec.load",
            ensure => file,                                       
            checksum => md5,                                      
            mode => 664,                                          
            content => template( "${module_name}/apache2/mods-available/suexec.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                
    }                                                                                          

    file
    {   
        "expires_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/expires.load",
            ensure => file,                                        
            checksum => md5,                                       
            mode => 664,                                           
            content => template( "${module_name}/apache2/mods-available/expires.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                 
    }                                                                                           

    file
    {   
        "proxy_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/proxy.load",
            ensure => file,                                      
            checksum => md5,                                     
            mode => 664,                                         
            content => template( "${module_name}/apache2/mods-available/proxy.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                               
    }                                                                                         

    file
    {   
        "dav_lock_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/dav_lock.load",
            ensure => file,                                         
            checksum => md5,                                        
            mode => 664,                                            
            content => template( "${module_name}/apache2/mods-available/dav_lock.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                  
    }                                                                                            

    file
    {   
        "ssl_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/ssl.load",
            ensure => file,                                    
            checksum => md5,                                   
            mode => 664,                                       
            content => template( "${module_name}/apache2/mods-available/ssl.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                             
    }                                                                                       

    file
    {   
        "ext_filter_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/ext_filter.load",
            ensure => file,                                           
            checksum => md5,                                          
            mode => 664,                                              
            content => template( "${module_name}/apache2/mods-available/ext_filter.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                    
    }                                                                                              

    file
    {   
        "dav_fs_conf":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/dav_fs.conf",
            ensure => file,                                       
            checksum => md5,                                      
            mode => 664,                                          
            content => template( "${module_name}/apache2/mods-available/dav_fs.conf.erb" ),
            require => [ Package[ 'apache2' ] ]                                                
    }                                                                                          

    file
    {   
        "authn_anon_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/authn_anon.load",
            ensure => file,                                           
            checksum => md5,                                          
            mode => 664,                                              
            content => template( "${module_name}/apache2/mods-available/authn_anon.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                    
    }                                                                                              

    file
    {   
        "status_conf":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/status.conf",
            ensure => file,                                       
            checksum => md5,                                      
            mode => 664,                                          
            content => template( "${module_name}/apache2/mods-available/status.conf.erb" ),
            require => [ Package[ 'apache2' ] ]                                                
    }                                                                                          

    file
    {   
        "alias_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/alias.load",
            ensure => file,                                      
            checksum => md5,                                     
            mode => 664,                                         
            content => template( "${module_name}/apache2/mods-available/alias.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                               
    }                                                                                         

    file
    {   
        "authz_dbm_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/authz_dbm.load",
            ensure => file,                                          
            checksum => md5,                                         
            mode => 664,                                             
            content => template( "${module_name}/apache2/mods-available/authz_dbm.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                   
    }                                                                                             

    file
    {   
        "cgid_conf":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/cgid.conf",
            ensure => file,                                     
            checksum => md5,                                    
            mode => 664,                                        
            content => template( "${module_name}/apache2/mods-available/cgid.conf.erb" ),
            require => [ Package[ 'apache2' ] ]                                              
    }                                                                                        

    file
    {   
        "cern_meta_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/cern_meta.load",
            ensure => file,                                          
            checksum => md5,                                         
            mode => 664,                                             
            content => template( "${module_name}/apache2/mods-available/cern_meta.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                   
    }                                                                                             

    file
    {   
        "dav_fs_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/dav_fs.load",
            ensure => file,                                       
            checksum => md5,                                      
            mode => 664,                                          
            content => template( "${module_name}/apache2/mods-available/dav_fs.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                
    }                                                                                          

    file
    {   
        "actions_conf":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/actions.conf",
            ensure => file,                                        
            checksum => md5,                                       
            mode => 664,                                           
            content => template( "${module_name}/apache2/mods-available/actions.conf.erb" ),
            require => [ Package[ 'apache2' ] ]                                                 
    }                                                                                           

    file
    {   
        "file_cache_load":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/mods-available/file_cache.load",
            ensure => file,                                           
            checksum => md5,                                          
            mode => 664,                                              
            content => template( "${module_name}/apache2/mods-available/file_cache.load.erb" ),
            require => [ Package[ 'apache2' ] ]                                                    
    }                                                                                                                                  

    file
    {   
        "default":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/sites-available/default",
            ensure => file,                                    
            checksum => md5,                                   
            mode => 664,                                       
            content => template( "${module_name}/apache2/sites-available/default.erb" ),
            require => [ Package[ 'apache2' ] ]                                             
    }                                                                                       

    file
    {   
        "default_ssl":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/sites-available/default-ssl",
            ensure => file,                                        
            checksum => md5,                                       
            mode => 664,                                           
            content => template( "${module_name}/apache2/sites-available/default-ssl.erb" ),
            require => [ Package[ 'apache2' ] ]                                                 
    }                                                                                           

    file
    {   
        "000_default":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/sites-enabled/000-default",
            ensure => file,                                      
            checksum => md5,                                     
            mode => 664,                                         
            content => template( "${module_name}/apache2/sites-enabled/000-default.erb" ),
            require => [ Package[ 'apache2' ] ]                                               
    }     
	
    file
    {   
        "apache2_conf":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/apache2.conf",
            ensure => file,                          
            checksum => md5,                         
            mode => 664,
            content => template( "${module_name}/apache2/apache2.conf.erb" ),
            require => [ Package[ 'apache2' ] ]
    }

    file
    {
        "magic":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/magic",
            ensure => file,
            checksum => md5,
            mode => 664,
            content => template( "${module_name}/apache2/magic.erb" ),
            require => [ Package[ 'apache2' ] ]
    }

    file
    {
        "ports_conf":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/ports.conf",
            ensure => file,
            checksum => md5,
            mode => 664,
            content => template( "${module_name}/apache2/ports.conf.erb" ),
            require => [ Package[ 'apache2' ] ]
    }

    file
    {
        "envvars":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/envvars",
            ensure => file,
            checksum => md5,
            mode => 664,
            content => template( "${module_name}/apache2/envvars.erb" ),
            require => [ Package[ 'apache2' ] ]
    }

    file
    {
        "httpd_conf":
            notify  => service[ 'apache2' ],
            path => "/etc/apache2/httpd.conf",
            ensure => file,
            checksum => md5,
            mode => 664,
            content => template( "${module_name}/apache2/httpd.conf.erb" ),
            require => [ Package[ 'apache2' ] ]
    }		
}
