# README

## Project links

- Trello: https://trello.com/b/NyPE5bKy/apocalypse-corp
- Slack: apocalypse-corp.slack.com

## Getting started

- Clone this project
- Have ruby 2.7.0 installed (for example using rbenv) + bundler gem
- Install the gems: `bundle install`, this might require some libraries depending on your system (eg. libpq)
- Install the npm package: `yarn`
- Copy `.env.example` to `.env` and change the settings.
- Run `rails db:setup`
- Enjoy!

## Formatting

### Commands

- Run `rails format` to format your ruby files
- Run `rails format:check` to check the formatting of your ruby files

### Automated formatting

If you are using `VSCode`, use the following config to auto format:

```json
"[ruby]": {
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.formatOnSave": true
},
```

## Contributing

- Make a freature branch for your code
- Commit your canges, push and create a Pull Request from your branch to master.
- Get a core member to review the code and merge it in.
