#!/usr/bin/perl

my $hostname = `hostname`;
chomp( $hostname );

if( -e "/bin/ucat" ) 
{
	my $nodesok = 1;
	my $nodesentry = `umatch nodes $hostname`;
	chomp( $nodesentry );

	if( $nodesentry =~ /No such key in map/ )
	{
		print "NODES_key_missing=true\n";
		$nodesok = 0;
	}
	
	if( $nodesentry eq "" )
	{
		print "NODES_ok=false\n";
		$nodesok = 0;
	}

	if( $nodesok == 1 )
	{
		my @pairs = split( /\s/ , $nodesentry );

		foreach my $pair ( @pairs )
		{
			my ( $key, $value ) = split( /=/ , $pair );
			
			if( $value =~ /,/ )
			{
				my @list = split( /,/ , $value );

				foreach my $item( @list )
				{
					$item =~ s/[-\.]/_/g;
					print "NODES_" . $key . "_" . $item . "=true\n";
				}
			}

			print "NODES_" . $key . "=" . $value . "\n";
		}
		
		print "NODES_ok=true\n";
	}
}
else
{
	print "NODES_ok=false\n";
}

