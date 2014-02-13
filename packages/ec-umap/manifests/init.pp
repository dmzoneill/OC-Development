class ec-umap
{
	package 
	{	
		'ksh': 
			ensure => "installed"
	}
	
	file
	{
		"/bin/umap":
			path => "/bin/umap",
			source => "puppet:///modules/${module_name}/umap",
			require => Package[ "ksh" ],
			ensure => file,
			checksum => md5,
			mode => 755
	}

	file
	{
		"/bin/ucat":
			ensure => link,
			require => Package[ "ksh" ],
			target => "/bin/umap"
	}
	
	file 
	{ 
		"/bin/umatch":
			ensure => "link",
			target => "/bin/ucat"
	}
}

