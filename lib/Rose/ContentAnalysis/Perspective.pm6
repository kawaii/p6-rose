unit class Rose::ContentAnalysis::Perspective;
use Rose::Configuration;

use API::Perspective;

my $perspective-api = API::Perspective.new(:api-key(%*ENV<PERSPECTIVE_API_KEY>));

proto method submit (|) {*}

multi method submit(Str :$content!, MODEL :@models = Array[MODEL](SEVERE_TOXICITY)) {
    my $result = $perspective-api.analyze(:@models, :comment($content));
    my Rat $toxicity-score = $result<attributeScores><SEVERE_TOXICITY><summaryScore><value>;

    return $toxicity-score;
}

multi method submit(Str :$name!, MODEL :@models = Array[MODEL](SEVERE_TOXICITY)) {
    my $result = $perspective-api.analyze(:@models, :comment($name));
    my Rat $toxicity-score = $result<attributeScores><SEVERE_TOXICITY><summaryScore><value>;

    return $toxicity-score;
}
