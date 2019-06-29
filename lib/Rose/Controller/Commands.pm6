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
    my %embed-payload =
            color => 12543991,
            description => 'Perl 6 Discord bot for content moderation and toxicity analysis.',
            fields => [
                {name => '+aggregate <@$user-id>', value => 'Run this command to get the tagged user\'s average toxicity value based on their last 200 message scores. Will also return a \'risk\' level based on this aggregate value.'},
                {name => '+ping', value => 'A basic ping command to check that I am still alive!. :)'},
                {name => '+help', value => 'Displays this dialogue.'}
            ],
            image => {
                url => 'https://user-images.githubusercontent.com/12242877/60367703-d2d1bf80-99e6-11e9-8102-aca14491ac1c.png'
            },
            title => 'HackWeek::Rose', url => 'https://github.com/kawaii/p6-rose';

    return embed => %embed-payload;
}




method toxicity-aggregate($cmd-obj) {
    my $user-id = $cmd-obj.args;
    my %payload = $cmd-obj.payload;

    unless $user-id ~~ / <(\d+)> / { return content => '_sad trombone_ :trumpet:'; }

    if $cmd-obj.args ~~ / '<@' '!'? <(\d+)> '>' / {
        $user-id = $/.Int;
    }

    my $result = $!db.toxicity-aggregate(:user($user-id), :guild(%payload<guild>.id));

    if $result == 0 {
        return content => '_sad trombone_ :trumpet:';
    } else {
        return embed => self.generate-toxicity-embed(:$user-id, :$result, :guild(%payload<guild>));
    }
}

method generate-toxicity-embed(:$user-id, :$result, :$guild) {
    my $member = $guild.get-member($user-id);
    my $user = $guild.api.inflate-user($member<user>);

    my ($risk, $colour) = do given $result {
        when 0 ^.. .4 { 'LOW', 50712 }
        when .4 ^.. .7 { 'MEDIUM', 15653632 }
        when .7 ^.. Inf { 'HIGH', 14221312 }
    }

    my %embed-payload =
        author => {
            icon_url => "https://cdn.discordapp.com/avatars/$user-id/{$user.avatar-hash}.png",
            name => $user.username ~ '#' ~ $user.discriminator
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
