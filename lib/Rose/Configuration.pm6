unit class Rose::Configuration;

use JSON::Fast;

method generate-configuration {
    my %configuration = from-json(slurp("./config.json"));
    return %configuration;
}
