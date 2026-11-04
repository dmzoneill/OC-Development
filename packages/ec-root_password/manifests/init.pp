class ec-root_password
{
    user 
    { 
        root:
            ensure   => present,
            # Root password hash removed at owner request (old, non-functional).
            password => 'CHANGE_ME',
    }
}
