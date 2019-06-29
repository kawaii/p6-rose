![image](https://user-images.githubusercontent.com/12242877/60367703-d2d1bf80-99e6-11e9-8102-aca14491ac1c.png)

Perl 6 Discord bot for content moderation and toxicity analysis. This project was created initially for [Discord Community Hack Week](https://blog.discordapp.com/discord-community-hack-week-build-and-create-alongside-us-6b2a7b7bba33). Rose performs content moderation via message analysis using Google's Perspective API. She scores users based on the percieved 'toxicity' of their messages and provides server administrators with an overall threat level metric based on aggregate results. 

Want to add Rose to your own server, but don't have the time or know-how to self-host her? Click the button below!

[![image](https://img.shields.io/badge/Click%20here%20to%20invite%20Rose-INVITE-blue.svg)](https://discordapp.com/oauth2/authorize?client_id=593061134307819521&permissions=134597702&scope=bot)

Once she's in, check out the `+help` command to get started.

Thank you for checking out our Discord Hack Week project. Good luck to all participants.

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

If you would like Rose to perform auto-moderation actions on messages, set the `auto-moderation` configuration value to `true` and she will delete messages and/or kick users who cross predetermined thresholds.

In order to see more of the inner workings of Rose, you can set `PERSPECTIVE_DEBUG=true` in your environment and she will provide a [debug emote reaction](https://github.com/kawaii/p6-rose/blob/07468651766834812a4fe6842bec863097acb647/lib/Rose/Controller/Actions.pm6#L25-L37) to all detected messages, and respond with their score from the Perspective API.

![image](https://user-images.githubusercontent.com/12242877/60193711-10d8b300-9830-11e9-9da4-4ccc785bfbc6.png)

## Commands

### `+aggregate $user-id`

Returns the average toxicity score of a user over their last 200 messages, and categorises them as either a low, medium or high risk user. Future iterations of Rose will have the option to automatically kick high risk users (those with an average score of 0.75 or higher across their last 200 messages).

![image](https://user-images.githubusercontent.com/12242877/60301309-f2a2ae00-9928-11e9-9dae-4d0076fdb7d7.png)

## Docker

There is some somewhat experimental Docker relevant material in this repository - mostly included for my own testing and debugging purposes but it's usable if you know what you're doing. Note that in all cases you still must provide an appropriate PostgreSQL server (whether running remotely or in a container on the same Docker virtual network) for Rose to function. This information should be defined within your `config.json` and bind-mounted into the container. You can use the `ROSE_CONFIG` variable to inform Rose of where her configuration file has been mounted.

### Usage

#### ... via [`docker build`](https://docs.docker.com/engine/reference/commandline/build/)
```sh
docker build \                
  --build-arg BUILD_AUTHORS="Kane 'kawaii' Valentine <kawaii@cute.im>" \
  --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
  --build-arg BUILD_SHA1SUM=80549a2f1e7c35bccfd91007f3984c68b07cd4ec \
  --build-arg BUILD_VERSION=0.1rc4 \
  --tag kawaii/rose:0.1rc4 \
  --tag kawaii/rose:latest \
$PWD
```

#### ... via [`docker container run`](https://docs.docker.com/engine/reference/commandline/container_run/)

```
docker container run -e ROSE_CONFIG="/opt/config.json" -v $PWD/config.json:/opt/config.json:ro kawaii/rose:0.1rc4
```

#### ... via [`docker stack deploy`](https://docs.docker.com/engine/reference/commandline/stack_deploy/) or [`docker-compose`](https://github.com/docker/compose)

```yaml
services:
  rose:
    environment:
      ROSE_CONFIG: "/opt/config.json"
    image: kawaii/rose:0.1rc4
    restart: on-failure
    volumes:
    - $PWD/config.json:/opt/config.json:ro
version: '3.7'
```

### FAQ

#### Why Perl 6?

Why not Perl 6? This is Discord _Hack Week_, not Discord write-everything-in-JS week.

Want to get started with Perl 6 yourself? Check out the [Rakudo compiler](https://rakudo.org/).

#### What library does Rose use?

Rose uses the experimental and unfinished Perl 6 [`API::Discord`](https://github.com/shuppet/p6-api-discord) library.

#### What is `API::Discord`?

[`API::Discord`](https://github.com/shuppet/p6-api-discord) is a free and open source Discord API wrapper written in Perl 6 by [Shuppet Laboratories](https://github.com/shuppet).

At the time of writing this document, the library is unfinished and only features a fraction of the full Discord API specification. Due to this setback we were not able to implement all of the features we wanted, although it did enable us to fix a number of existing bugs in the library.

There are dangers of using such a prototype component in any project, but I think that Rose is a good example of what people can achieve in the space of a few evenings - hacking away in true open source spirit.

#### Perspective API? Why don't you use Tensorflow's toxicity model?

A number of reasons. Tensorflow's model was trained on a single dataset of toxic comments (albeit 2 million of them) whereas Perspective is receiving new data for analysis on a daily basis. It seems to be a far more accurate gauge of toxicity at the current time. Another reason is processing, it's much better to offload content analysis to another service, and let your application just take action on the results.

#### The bot crashes, disconnects and does other weird things, what the heck?

Due to upstream bugs in [`Cro::WebSocket`](https://github.com/croservices/cro-websocket) ([#15](https://github.com/croservices/cro-websocket/issues/15) and [#22](https://github.com/croservices/cro-websocket/issues/22)), there will be occasions when the bot drops out, fails to reconnect or just crashes for seemingly no reason.

#### Who is Rose?

My girlfriend, you can join her server here. :)

[![image](https://discordapp.com/api/guilds/262268073363505164/embed.png?style=banner2)](https://discord.gg/cute)
