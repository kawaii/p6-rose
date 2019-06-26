# p6-rose
Perl 6 Discord bot for content moderation and toxicity analysis. This project was created initially for [Discord Community Hack Week](https://blog.discordapp.com/discord-community-hack-week-build-and-create-alongside-us-6b2a7b7bba33). Rose performs content moderation via message analysis using Google's Perspective API. She scores users based on the percieved 'toxicity' of their messages and provides server administrators with an overall threat level metric based on aggregate results. 

## Prerequisites

### Core
- [Rakudo](https://rakudo.org/files) >= 2019.03 (Perl 6.d)
- [PostgreSQL](https://www.postgresql.org/download/) >= 10.0

### Dependencies
All of these can be obtained via [`zef install`](https://github.com/ugexe/zef) in the case of Perl 6 modules, or `apt-get` in the case of packages.
- [`API::Discord`](https://github.com/shuppet/p6-api-discord)
- [`API::Perspective`](https://github.com/shuppet/p6-api-perspective)
- [`Command::Despatch`](https://github.com/shuppet/p6-command-despatch)
- [`DB:Pg`](https://github.com/CurtTilmes/perl6-dbpg)
- [`JSON::Fast`](https://github.com/timo/json_fast)
- [libpq5/libpq-dev](https://packages.debian.org/jessie/libpq-dev)

## Configuration
Create the file `config.json` in the root of the project directory. It should look something like this:
```json
{
  "discord-token": "",
  "perspective-token": "",
  "command-prefix": "+",
  "auto-moderation": false,
  "postgresql-host": "127.0.0.1",
  "postgresql-port": 5432,
  "postgresql-user": "rose",
  "postgresql-password": "password",
  "postgresql-database": "rose"
}
```
You will need to provide your own Discord bot token, and your own Google Perspective API token. If you do not have a Perspective API token you can follow the steps to generate one for free [here](https://github.com/conversationai/perspectiveapi/blob/master/quickstart.md#perspective-api-quickstart).

If you would like Rose to perform auto-moderation actions on messages, set the `auto-moderation` configuration value to `true` and she will delete messages, warn users via DM and kick users who cross predetermined thresholds.

In order to see more of the inner workings of Rose, you can set `PERSPECTIVE_DEBUG=true` in your environment and she will provide a [debug emote reaction](https://github.com/kawaii/p6-rose/blob/master/lib/Rose/Controller/Actions.pm6#L18-L30) to all detected messages, and respond with their score from the Perspective API.

![image](https://user-images.githubusercontent.com/12242877/60193711-10d8b300-9830-11e9-9da4-4ccc785bfbc6.png)

