unit class Rose::Controller::Commands;

use Command::Despatch;

has $.db is required;
has $.commands;

submethod TWEAK () {
    $!commands = Command::Despatch.new(
        command-table => {
            aggregate => -> $self {
                self.toxicity-aggregate($self);
            }
        }
    );
}

method despatch($str, :$payload) {
    $.commands.run($str, :$payload);
}

method toxicity-aggregate($cmd-obj) {
    my $user-id = $cmd-obj.args;

    if $cmd-obj.args ~~ / '<@' '!'? <(\d+)> '>' / {
        $user-id = $/;
    }

    my $result = $!db.toxicity-aggregate(:user($user-id), :guild($cmd-obj.payload<guild-id>));
    my $response = "<@$user-id> aggregate threat level $result.";
}
