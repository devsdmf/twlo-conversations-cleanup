require('dotenv').config();

const TWILIO_ACCOUNT_SID = process.env.TWILIO_ACCOUNT_SID || undefined;
const TWILIO_ACCOUNT_TOKEN = process.env.TWILIO_ACCOUNT_TOKEN || undefined;

if (TWILIO_ACCOUNT_SID === undefined || TWILIO_ACCOUNT_SID === undefined) {
    throw new Error('Error: you must specify your Twilio account SID and token as environment variables');
}

const yargs = require('yargs');
const argv = yargs
    .option('chat-service-sid', { 
        description: 'The chat service ID to query conversations, i.e. ISXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX', 
        demandOption: true,
        type: 'string'
    })
    .options('from', {
        description: 'The offset date to filter conversations, in the following format: yyyy-mm-ddThh:ii:ss',
        demandOption: true,
        type: 'string'
    })
    .help()
    .argv;

const chatServiceSid = argv.chatServiceSid;
const from = new Date(argv.from);

if (!/^IS[0-9a-fA-F]{32}$/.test(chatServiceSid)) {
    console.error('Error: The specified chat service SID is not valid, see help for more information.');
    process.exit(1);
}

const client = require('twilio')(TWILIO_ACCOUNT_SID, TWILIO_ACCOUNT_TOKEN);

console.log(`Attempting to fetch conversations from ${chatServiceSid} chat service`);
client.conversations.services(chatServiceSid)
    .conversations
    .each(conversation => {
        if(conversation.dateUpdated <= from) {
            console.log(`Removing conversation ${conversation.sid}`);
            client.conversations.services(chatServiceSid)
                .conversations(conversation.sid)
                .remove();
        }
    });
