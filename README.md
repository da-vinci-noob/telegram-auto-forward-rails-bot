# Telegram Affliate Link Generator [Ruby on Rails] Bot [Amazon/Flipkart]

## Features

## Setup Project

1. Install rvm [https://rvm.io/rvm/install] (optional)
2. Install Ruby v3.1.2 (Check the file [.ruby_version](https://github.com/da-vinci-noob/telegram-auto-forward-rails-bot/blob/main/.ruby-version) for the latest compatible version)
3. Install PostgreSQL (Tested with v14).
4. Setup the Postgres Credentials in `config/database.yml` file

### Setup New Telegram Bot
1. Open Telegram.
2. Goto [BotFather](https://t.me/BotFather), if link not working search @BotFather in telegram.
3. Then type `/start` in Botfather
4. Click on `/newbot` or type `/newbot`
5. Add Any name you like for the Telegram Bot.
6. Add Username for your bot you like which needs to end with `_bot`
7. Copy the Token generated which will be needed in the next step.

### Setup Environment Variables
```
DB_USERNAME=<Database Username>
DB_PASSWORD=<Database Password>
BOT_TOKEN=<Bot Token>
BOT_USERNAME=<Bot Username excluding '@'>
REDIS_HOST=<localhost>
DEFAULT_ROUTE=<example.com>
```
For Production You need to use Database URL instead of DB Username/Password
```
TELEGRAM_RAILS_DATABASE_URL=postgres://<YourUserName>:<YourPassword>@<YourHostname>:5432/<YourDatabaseName>
RAILS_ENV=production
```


## Development
Run Below commands in Rails Console
> rake telegram:bot:delete_webhook
> rake telegram:bot:poller

## Deployment
Run below command in Rails Console
> rake telegram:bot:set_webhook RAILS_ENV=production

Run Rails Server
> rails server

## Testing
1. Goto your bot in telegram.
2. Click on `start` or type /start
3. Click on `help` or type /help
4. Add your Amazon affliate tracking id. Example below

```
/amazon tracking_id-21
```

5. Add your Flipkart affliate tracking id. Example below

```
/flipkart tracking_id
```

6. Add your Bit.ly Access token. Example below

```
/bitly API-KETuIB
```

7. (Optional) Add your channel username to the bot for auto-forwarding of messages. Example below

```
/forward @username
```

8. (Optional) Disable Link Previews for messages sent back to the bot and channel with affiliate link. Example below

```
/previews disable (For Disabling Previews)
/previews *any other text* (For Enabling Previews if disabled)
```

9. (Optional) You can now add characters/text/word to delete from message (This can include any promotional message). Example below

```
/delete *text to delete*
/delete hello
```

10. Show Your Words which you have included to the delete list.. Example below

```
/show_deleted
```

11. Remova a word from the texts to be filtered

```
/remove_deleted *text to delete*
```

12. Show your Profile i.e. Saved Configuration
```
/user_profile
```

Note:

Bot will guide you how to get Bit.ly Access token by below command.

```
/bitly_setup
```

2. This Bot only supports below URL's.

```
https://amazon.in
https://amzn.to
http://fkrt.it
https://flipkart.com
```

** If any issues while deleting webhook use the below URL in browser
> https://api.telegram.org/bot<BOT_TOKEN>/setwebhook


----------------------------------------------
> You can open an issue on github if you find any.

## To Contribute (Add new Feature, Improve Something )

- Fork the project repository
- Clone your fork
- Navigate to your local repository
- Check that your fork is the 'origin' remote by:
  > `git remote -v`
  - if not add 'origin' remote by:
    > `git remote add origin <URL_OF_YOUR_FORK>`
- Add the project repository as the 'upstream' remote by:
  > `git remote add upstream <URL_OF_THIS_PROJECT>`
- Check that you now have two remotes: an origin that points to your fork, and an upstream that points to the project repository by:
  > `git remote -v`
- Pull the latest changes from upstream into your local repository.
  > `git pull upstream main`
- Create a new branch
  > `git checkout -b BRANCH_NAME`
- Make changes in your local repository
- Commit your changes
- Push your changes to your fork
  > `git push origin BRANCH_NAME`
- Create Pull Request
  > baseRepo - base:main <- yourRepo - compare:BRANCH_NAME
- Add Your description, Add any Images/Videos if required and Submit PR.
- You can add more commits/comments to the PR.
- You can delete the Branch (BRANCH_NAME) after your PR has been accepted and merged
- Sync your local Fork Repo to Updated Project Repo.

  > `git pull upstream main`

  > `git push origin main`

---

Thanks, Contributions are welcome! <3.

Made with :heart: and ![Ruby](https://img.shields.io/badge/-Ruby-000000?style=flat&logo=ruby)

#### DISCLAIMER: This software is for educational purposes only. This software should not be used for illegal activity. The author is not responsible for its use.
