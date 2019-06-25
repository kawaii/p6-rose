unit class Rose::Controller::Actions;

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


