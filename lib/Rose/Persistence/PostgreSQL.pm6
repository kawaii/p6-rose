unit class Rose::Persistence::PostgreSQL;

use DB::Pg;

has $.dsn is required;
has $!dbi;

submethod TWEAK() {
    $!dbi = DB::Pg.new(:connection($!dsn));
}

method seed-database {
    my $seed = $!dbi.prepare(
            'CREATE TABLE IF NOT EXISTS rose_messages (
                "user-id" bigint,
                "message-id" bigint,
                "message-content" text,
                "message-timestamp" timestamptz,
                "perspective-score" numeric,
                PRIMARY KEY ("user-id", "message-id")
            )'
    );
    $seed.execute;
    $seed.finish;
}

method insert-record(:$message) {

}