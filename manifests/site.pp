node default
{
    if $osfamily == "windows"
    {
        hiera_include( 'packages_windows' )
    }
    else
    {
        hiera_include( 'packages_linux' )
    }
}
