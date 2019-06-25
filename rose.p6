use Rose::ContentAnalysis::Perspective;

use API::Discord;

sub MAIN($token) {
    my $discord = API::Discord.new(:$token);

    $discord.connect;
    await $discord.ready;

    react {
        whenever $discord.messages -> $message {
            say $message.content;
        }
    }
}