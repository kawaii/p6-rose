unit class Rose::ContentAnalysis::Perspective;

use Rose::Controller::Actions;
use API::Perspective;

my $perspective-api = API::Perspective.new(:api-key(%*ENV<PERSPECTIVE_API_KEY>));
my $action-handler = Rose::Controller::Actions.new;

proto method submit (|) {*}

multi method submit((Str :$content, :$author, :$id, *%), MODEL :@models = Array[MODEL](SEVERE_TOXICITY)) {
    my $score = $perspective-api.analyze(:@models, :comment($content));
    say @models Z=> $score<attributeScores>{@models}.map: *<summaryScore><value>;
}

multi method submit(Str :$name!, MODEL :@models = Array[MODEL](SEVERE_TOXICITY)) {
    my $score = $perspective-api.analyze(:@models, :comment($name));
    say @models Z=> $score<attributeScores>{@models}.map: *<summaryScore><value>;
}
