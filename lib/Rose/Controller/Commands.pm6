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
            return content => '_confused trombone_ :trumpet::question:';
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

    unless $user-id ~~ / <(\d+)> / { return content => '_sad trombone_ :trumpet:'; }

    my $result = $!db.toxicity-aggregate(:user($user-id), :guild($cmd-obj.payload<guild-id>));

    if $result == 0 {
        return content => '_sad trombone_ :trumpet:';
    } else {
        my ($risk, $colour) = do given $result {
            when 0 ^.. .4 { 'LOW', 50712 }
            when .4 ^.. .7 { 'MEDIUM', 15653632 }
            when .7 ^.. Inf { 'HIGH', 14221312 }
        }

        return embed => self.generate-toxicity-embed(:$user-id, :$result, :$risk, :$colour);
    }
}

method generate-toxicity-embed(:$user-id, :$result, :$risk, :$colour) {
    my %embed-payload =
        author => {
            icon_url => "https://cdn.discordapp.com/embed/avatars/$user-id.png",
            name => "<@$user-id>"
        },
        color => $colour,
        fields => [
            {name => "Aggregate threat level:", value => "```$result.round(0.01)```"},
            {name => "Risk level classification:", value => "```$risk```"}
        ],
        footer => {text => "ID: $user-id"}
    ;

    return %embed-payload;
}

method ping {
    return content => 'pong!'
}
