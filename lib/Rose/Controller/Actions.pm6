unit class Rose::Controller::Actions;

method aggregate-results { ... }

method moderate-content(:$message, :$toxicity) {
    given $toxicity {
        when .0 < * <= .3 { say "good message! :)" }
        when .3 < * <= .5 { say "probably fine! :P" }
        when .5 < * <= .7 { say "probaby a bad message! >:)" }
        when .7 < * { say "most certainly a bad message! >:(" }
    }
}

method bisect-content(:$content, :@badwords) {
    my Str $bisected-message = $content.subst(/$<a>=\w$<b>=@badwords | $<a>=@badwords$<b>=\w /, { "$<a> $<b> " }, :g);
    return $bisected-message;
}

method warn-user() { ... }

method kick-user() { ... }

method ban-user() { ... }

method debug-reaction(:$message, :$toxicity) {
    given $toxicity {
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
