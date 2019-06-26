unit class Rose::Persistence::PostgreSQL;

use DB::Pg;

has $.dsn is required;
has $!dbi;

submethod TWEAK() {
    $!dbi = DB::Pg.new(:conninfo($!dsn));
}

method seed-database {
    my $query = $!dbi.db.prepare(
            'CREATE TABLE IF NOT EXISTS rose_messages (
                "guild-id" bigint,
                "user-id" bigint,
                "message-id" bigint,
                "message-content" text,
                "message-timestamp" timestamptz,
                "perspective-score" numeric,
                PRIMARY KEY ("guild-id", "user-id", "message-id")
            )'
    );
    $query.execute;
    $query.finish;
}

method insert-record(:$guild, :$message, :$toxicity) {
    my $query = $!dbi.db.prepare('INSERT INTO rose_messages ("guild-id", "user-id", "message-id", "message-content", "message-timestamp", "perspective-score")
                                  VALUES ($1, $2, $3, $4, $5, $6);');
    $query.execute($guild.id, $message.author.id, $message.id, $message.content, DateTime.now, $toxicity);
    $query.finish;
}
