unit class Rose::ContentAnalysis::Perspective;

use API::Perspective;

my $perspective-api = API::Perspective.new(:api-key(%*ENV<PERSPECTIVE_API_KEY>));

proto method submit (|) {*}

multi method submit(Str :$message!, MODEL :@models = Array[MODEL](SEVERE_TOXICITY)) {
    my $score = $perspective-api.analyze(:@models, :comment($message));
    say @models Z=> $score<attributeScores>{@models}.map: *<summaryScore><value>;
}

multi method submit(Str :$name!, MODEL :@models = Array[MODEL](SEVERE_TOXICITY)) {
    my $score = $perspective-api.analyze(:@models, :comment($name));
    say @models Z=> $score<attributeScores>{@models}.map: *<summaryScore><value>;
}
