class ec-ufw
{
	service 
	{ 
		"ufw":
			ensure => "stopped"
	}
    
    package 
	{	
		"ufw": 
			ensure => 'purged'
	}
}
