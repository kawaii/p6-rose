unit class Rose::Configuration;

use JSON::Fast;

has $.config-file = %*ENV<ROSE_CONFIG> // "./config.json";
has %.configuration;

submethod TWEAK {
    %!configuration = from-json(slurp($!config-file));
}

method generate-dsn {
    my %config = %.configuration;

    join " ",
        ('dbname=' ~ %config<postgresql-database>),
        ("host=$_" with %config<postgresql-host>),
        ("port=$_" with %config<postgresql-port>),
        ("user=$_" with %config<postgresql-user>),
        ("password=$_" with %config<postgresql-password>);
}
