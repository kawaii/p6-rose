unit class Rose::Controller::Actions;

use JSON::Fast;

method aggregate-results { ... }

method moderate-content($message, $toxicity) {
    if $toxicity < .5 {
        self.contains-badwords(:content($message.content))
    } elsif $toxicity > .5 {
        say "probably a bad message!"
    }
}

method contains-badwords(:$content) {
    my @badwords = 'fizz', 'buzz', 'bosh';
}

method bisect-content(:$content, :@badwords) {
    my Str $bisected-message = $content.subst(/$<a>=\w$<b>=@badwords | $<a>=@badwords$<b>=\w /, { "$<a> $<b>" }, :g);
    return $bisected-message;
}

method content-resubmission { ... }

method debug-reaction($message, $toxicity) {
    given ($toxicity) {
        when .0 < * <= .1 { $message.add-reaction('😄') }
        when .1 < * <= .2 { $message.add-reaction('😃') }
        when .2 < * <= .3 { $message.add-reaction('🙂') }
        when .3 < * <= .4 { $message.add-reaction('😐') }
        when .4 < * <= .6 { $message.add-reaction('🙁') }
        when .6 < * <= .7 { $message.add-reaction('😦') }
        when .7 < * <= .8 { $message.add-reaction('😠') }
        when .8 < * <= .9 { $message.add-reaction('😡') }
        when .9 < * { $message.add-reaction('👿')  }
    }
}
