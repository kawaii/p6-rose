use Rose::ContentAnalysis::Perspective;
use Rose::Controller::Actions;
use Rose::Configuration;

use API::Discord;

my $perspective = Rose::ContentAnalysis::Perspective.new;

my $action-handler = Rose::Controller::Actions.new;
my $configuration-handler = Rose::Configuration.new;

sub MAIN() {
    my %configuration = $configuration-handler.generate-configuration;
    my $discord = API::Discord.new(:token(%configuration<discord-token>));

    $discord.connect;
    await $discord.ready;

    react {
        whenever $discord.messages -> $message {
            my $toxicity = $perspective.submit(:content($message.content));

            $action-handler.moderate-content(:$message, :$toxicity);

            if %*ENV<PERSPECTIVE_DEBUG> {
                $action-handler.debug-reaction(:$message, :$toxicity);
                (await $message.channel).send-message($message.id ~ " toxicity rating: $toxicity.")
            }
        }
    }
}
