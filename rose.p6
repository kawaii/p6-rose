use Rose::ContentAnalysis::Perspective;

use API::Discord;

my $perspective = Rose::ContentAnalysis::Perspective.new;

sub MAIN($token) {
    my $discord = API::Discord.new(:$token);

    $discord.connect;
    await $discord.ready;

    react {
        whenever $discord.messages -> $message {
            $perspective.submit(:message($message.content));
        }
    }
}
