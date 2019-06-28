unit class Rose::Controller::Commands;

use Command::Despatch;

has $.db is required;
has $.commands;

submethod TWEAK () {
    $!commands = Command::Despatch.new(
        command-table => {
            help => -> $self {
                self.help;
            },
            aggregate => -> $self {
                self.toxicity-aggregate($self);
            },
            ping => -> $self {
                self.ping;
            }
        }
    );
}

method despatch($str, :$payload) {
    CATCH {
        when X::Command::Despatch::InvalidCommand {
            return '_confused trombone_ :trumpet::question:';
        }
    }

    $.commands.run($str, :$payload);
}

method help {
    ...
}

method toxicity-aggregate($cmd-obj) {
    my $user-id = $cmd-obj.args;

    if $cmd-obj.args ~~ / '<@' '!'? <(\d+)> '>' / {
        $user-id = $/;
    }

    unless $user-id ~~ / <(\d+)> / { return '_sad trombone_ :trumpet:'; }

    my $result = $!db.toxicity-aggregate(:user($user-id), :guild($cmd-obj.payload<guild-id>));

    if $result == 0 {
        return '_sad trombone_ :trumpet:';
    } else {
        my ($risk, $colour) = do given $result {
            when 0 ^.. .4 { 'LOW', 50712 }
            when .4 ^.. .7 { 'MEDIUM', 15653632 }
            when .7 ^.. Inf { 'HIGH', 14221312 }
        }

        my $response = "<@$user-id> aggregate threat level $result.round(0.01).\nRisk level classification: $risk.";
    }
}

method ping {
    return my $response = 'pong!'
}
