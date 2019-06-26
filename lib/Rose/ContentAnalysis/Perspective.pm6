unit class Rose::ContentAnalysis::Perspective;
use Rose::Configuration;

use API::Perspective;

has $.perspective-token is required;
has $!perspective;

submethod TWEAK() {
    $!perspective = API::Perspective.new(:api-key($!perspective-token));
}

proto method submit (|) {*}

multi method submit(Str :$content!, MODEL :@models = Array[MODEL](SEVERE_TOXICITY)) {
    my $result = $!perspective.analyze(:@models, :comment($content));
    my Rat $toxicity-score = $result<attributeScores><SEVERE_TOXICITY><summaryScore><value>;

    return $toxicity-score;
}

multi method submit(Str :$name!, MODEL :@models = Array[MODEL](SEVERE_TOXICITY)) {
    my $result = $!perspective.analyze(:@models, :comment($name));
    my Rat $toxicity-score = $result<attributeScores><SEVERE_TOXICITY><summaryScore><value>;

    return $toxicity-score;
}
