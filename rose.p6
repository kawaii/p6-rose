use Rose::Configuration;
use Rose::ContentAnalysis::Perspective;
use Rose::Controller::Actions;
use Rose::Persistence::PostgreSQL;

use API::Discord;

my $configuration-handler = Rose::Configuration.new;
my %configuration = $configuration-handler.configuration;

my $perspective = Rose::ContentAnalysis::Perspective.new(perspective-token => %configuration<perspective-token>);
my $action-handler = Rose::Controller::Actions.new;

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
