The Myplanet README
===================

This document aims to be the bare minimum needed to help
Myplaneteers contribute to the Pantzbot IRC bot.

Full scripting docs [available in the official Hubot
documentation](https://github.com/github/hubot/blob/master/docs/scripting.md).

Contributing
------------

Pantzbot is open for anyone at Myplanet to hack on. It's pretty hard to
break, and as of right now, we're not using it for anything mission
critical, so definitely don't worry too much about jumping in and adding
some plugins.

### Scripting Hints

Here are some quick pointers to help orientate you before your first
contribution:

- There are tons of community scripts available:
  https://github.com/github/hubot-scripts/blob/master/src/scripts/

- This repo doesn't contain the hubot codebase, but the `packages.json`
file pulls in that codebase, among other things.

- Hubot scripts can live in a couple of places:

  1. **Community scripts** are already pulled in via the `hubot-scripts` dep
    in `package.json`, so we just need to enable them in
    `hubot-scripts.json`.

  2. **Custom scripts** can be placed as `scripts/*.coffee`. Unlike community
    scripts, these do not need to be enabled via `hubot-scripts.json`.

  3. A few scripts come with the actual `hubot` package (rather than the
    community scripts package) and so these **default scripts** are
    included with that package.  We treat them a little like custom scripts,
    and load them by symlinking them into our `scripts/` directory.

  4. **Package scripts** are actually external packages, which can be
    pulled in via inclusion in `packages.json`. They are the
    recommended type of script, as they can have their own dependencies
    pulled in automatically from *their* `package.json`.

### Local Testing

- You can test pantzbot locally by running it like this:

        # Install redis server and follow post-install instructions
        brew install redis

        # Install all the node.js packages
        cd path/to/where/you/checked/out/hubot
        npm install
        bin/hubot
        Hubot> hubot help

If the functionality you wish to test requires configuration via
environment variables, you can start the bot like this:

        HUBOT_VAR1=value1 HUBOT_VAR2=value2 bin/hubot

### Easy Deployment

- We host pantzbot on Heroku, a service like Acquia, but for
  node.js apps rather than Drupal.
- To make things a little easier, we've set things up so that you just
  need to push/merge into `master` branch on GitHub, and Travis CI will take care
  of the deploy. Pull requests are highly recommended. You can follow
  along with the Travis output after pushing, and if the deploy was
  successful, you'll see a message dropped into the `#hubot` channel in
  the company chat.

### Advanced Deployment

  - If you need to set environment variables for your addition, you'll
  need to talk to someone with direct access to Heroku. Ask someone with
  prior access (most obviously @patcon or @emarchak), and they should be
  able to do it for you or grant you Heroku access via this page:
  https://dashboard.heroku.com/apps/pantzbot/collaborators
  - You'll want to install the heroku toolbelt for convenience:

            https://toolbelt.heroku.com/

  - To set any configurations via environment variables, do this:

            heroku config:set ENVVAR1=value1 ENVVAR2=value2

  - Lastly, add the git remote and push:

            git remote add heroku git@heroku.com:pantzbot.git
            git push heroku
