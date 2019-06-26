unit class Rose::Persistence::PostgreSQL;

use DB::Pg;

has $.dsn is required;
has $!dbi;

submethod TWEAK() {
    $!dbi = DB::Pg.new(:connection($!dsn));
}
