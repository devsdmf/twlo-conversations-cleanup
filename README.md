# Twilio Conversations Clean-up

This project is just a housekeeping script to clean-up old conversations on a Twilio account. The scripts were implemented in two different versions, one is made in Shell Script and can be easily used to setup automated jobs to perform this task on a time-basis. The second version was made using JavaScript using [Twilio SDK for NodeJS](https://www.twilio.com/docs/libraries/node) and can be used as a base for a more complex strategy for clean up conversations.

By default, the script takes two arguments:

- Chat Service SID - The chat service where the script will look for the conversations
- From Date - A Date string (ISO-8601 format) used as the bound to filter conversations (the script will remove any conversation that had not any activity until this date)

## Requirements

### ShellScript-based

- An active Twilio account, if you didn't signed-up yet, [click here](https://www.twilio.com/try-twilio)
- [Twilio CLI](https://www.twilio.com/docs/twilio-cli/quickstart) installed with a valid profile
- [JQ](https://stedolan.github.io/jq/) - A JSON processor 
- GREP (for validation purposes only, you might have it already installed on your machine)

### JavaScript-based

- An active Twilio account, if you didn't signed-up yet, [click here](https://www.twilio.com/try-twilio)
- NodeJS 14.17 or higher (check with `node --version` on your terminal)
- NPM 6.14 or higher (check with `npm --version` on your terminal)

## Installation & Usage

### ShellScript-based

To use the ShellScript-based version, you only need to download the script file and make sure it has permission to be executed, like the example below:

```
$ curl -o twlo-conversation-cleanup.sh https://raw.githubusercontent.com/devsdmf/twlo-conversations-cleanup/main/clear-old-conversations.sh 
$ chmod +x twlo-conversation-cleanup.sh
```

This version receives two direct and positional arguments, the first one is the Chat Service SID and the Date string, like the example:

```
$ ./twlo-conversation-cleanup.sh ISXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX 2021-06-23T23:59:59
```

For more information and future consult, you can see a help message running: `./twlo-conversation-cleanup.sh -h`

### JavaScript-based

In order to install the JavaScript based version, first you need to clone this repo:

```
$ git clone https://github.com/devsdmf/twlo-conversations-cleanup.git && cd twlo-conversations-cleanup
```

On the project root folder, you need to install the dependencies using NPM:

```
$ cd /path/to/twlo-conversations-cleanup
$ npm install
```

After installing the dependencies, you can setup an `.env` file with your credentials:
```
$ cp .env.sample .env && edit .env
```

**Note:** You can also setup this values as environment variables or directly in the script execution.

After you installed and configured the application, you can run the script, passing the Chat Service SID and From parameters, like the example below: 

```
$ node clear-old-conversations.js --chat-service-sid=ISXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX --from=2021-06-23T23:59:59
```

## Getting the Chat Service SID

In order to get the Chat Service SID you should go to your Twilio account's [Conversation](https://www.twilio.com/console/conversations/services) console, and there are your chat services with their SID's (inside the red box on the image below).

## Disclaimers

- Be careful while using this script, it will make permant changes on your Twilio account and conversations. Me (Lucas) and Twilio bears no responsibility for a mis-usage of this software, make sure to test it on a development/stage environment before actually taking it to a production application.

- This software is to be considered "sample code", a Type B Deliverable, and is delivered "as-is" to the user. Twilio bears no responsibility to support the use or implementation of this software.

## License

This project is licensed under the [MIT license](LICENSE), that means that it is free to use, copy and modify for your own intents.
