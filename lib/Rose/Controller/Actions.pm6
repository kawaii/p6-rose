unit class Rose::Controller::Actions;

method debug-reaction($message, $toxicity-score) {
    if $toxicity-score > 0.7 {
        $message.add-reaction('☹');
    }
}
