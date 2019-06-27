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
    CATCH {
        when X::Command::Despatch::InvalidCommand {
            return "Invalid command."
        }
    }

    $.commands.run($str, :$payload);
}

method toxicity-aggregate($cmd-obj) {
    my $user-id = $cmd-obj.args;

    if $cmd-obj.args ~~ / '<@' '!'? <(\d+)> '>' / {
        $user-id = $/;
    }

    unless $user-id ~~ / <(\d+)> / { return my $response = "Invalid user."; }

    my $result = $!db.toxicity-aggregate(:user($user-id), :guild($cmd-obj.payload<guild-id>));

    if $result == 0 {
        my $response = "Invalid user.";
    } else {
        my $risk = do given $result {
            when .0 < * <= .4 { $risk = "**LOW**" }
            when .4 < * <= .7 { $risk = "**MEDIUM**" }
            when .7 < * { $risk = "**HIGH**" }
        }

        my $response = "<@$user-id> aggregate threat level $result.round(0.01).\nRisk level classification: $risk.";
    }
}
