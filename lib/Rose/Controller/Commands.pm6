unit class Rose::Controller::Commands;

use Command::Despatch;

has $.db is required;
has $.commands;

submethod TWEAK () {
    $!commands = Command::Despatch.new(
        command-table => {
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

method toxicity-aggregate($cmd-obj) {
    my $user-id = $cmd-obj.args;

    if $cmd-obj.args ~~ / '<@' '!'? <(\d+)> '>' / {
        $user-id = $/;
    }

    unless $user-id ~~ / <(\d+)> / { return my $response = '_sad trombone_ :trumpet:'; }

    my $result = $!db.toxicity-aggregate(:user($user-id), :guild($cmd-obj.payload<guild-id>));

    if $result == 0 {
        my $response = '_sad trombone_ :trumpet:';
    } else {
        my $risk = do given $result {
            when .0 < * <= .4 { $risk = "**LOW**" }
            when .4 < * <= .7 { $risk = "**MEDIUM**" }
            when .7 < * { $risk = "**HIGH**" }
        }

        my $response = "<@$user-id> aggregate threat level $result.round(0.01).\nRisk level classification: $risk.";
    }
}

method ping {
    return my $response = 'pong!'
}
