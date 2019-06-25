use Rose::ContentAnalysis::Perspective;
use Rose::Controller::Actions;

use API::Discord;

my $perspective = Rose::ContentAnalysis::Perspective.new;
my $action-handler = Rose::Controller::Actions.new;

sub MAIN($token) {
    my $discord = API::Discord.new(:$token);

    $discord.connect;
    await $discord.ready;

    react {
        whenever $discord.messages -> $message {
            my $toxicity = $perspective.submit(:content($message.content));

            $action-handler.moderate-content($message, $toxicity);

            if %*ENV<PERSPECTIVE_DEBUG> {
                $action-handler.debug-reaction($message, $toxicity);
                (await $message.channel).send-message($message.id ~ " toxicity rating: $toxicity.")
            }
        }
    }
}
