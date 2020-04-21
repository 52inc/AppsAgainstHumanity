import * as fs from 'fs';
import * as crypto from "crypto";
import * as admin from 'firebase-admin';
import {PromptCard, ResponseCard} from "./models";
import {computeCardId, cleanPath, hashDocumentId} from "./utils";
const argv = require('minimist')(process.argv.slice(2));
console.log(argv);

const serviceAccount = require("../config/firebase_admin_sdk.json");
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://appsagainsthumanity-c7558.firebaseio.com"
});
const db = admin.firestore();

type CustomPrompt = {
    text: string;
    special?: string;
}

type CustomPack = {
    set: string;
    sheet: string;
    prompts: CustomPrompt[],
    responses: string[]
}

let customPackFile = argv.pack || argv.p || argv._[0];
if (customPackFile) {
    const customPackText = fs.readFileSync(customPackFile, 'utf8');
    const customPack: CustomPack = JSON.parse(customPackText);
    importCustomPack(customPack)
        .then(() => {
            console.log("Import Finished!")
        })
} else {
    console.log("Please specify a custom card pack file")
}

async function importCustomPack(customPack: CustomPack) {
    console.log("Importing prompt cards...");
    await importPromptCards(customPack);
    console.log("Importing response cards...");
    await importResponseCards(customPack);
}

async function importPromptCards(customPack: CustomPack) {
    // Import Prompt cards
    const promptCards = customPack.prompts.map((prompt) => {
        const card: PromptCard = {
            cid: computeCardId(customPack.set, prompt.text),
            text: prompt.text,
            special: prompt.special,
            set: customPack.set,
            source: customPack.sheet
        };
        return card;
    });

    const cardSetDocument = db.collection('cardSets')
        .doc(cleanPath(customPack.set));

    await cardSetDocument.set({
        name: customPack.set,
        prompts: promptCards.length,
        promptIndexes: promptCards.map((card) => card.cid)
    }, { merge: true });

    const promptsCollection = cardSetDocument.collection('prompts');
    let currentBatchCount = 0;
    let batch = db.batch();
    for (let prompt of promptCards) {
        try {
            const document = promptsCollection.doc(hashDocumentId(prompt.text));
            if (currentBatchCount >= 500) {
                await batch.commit();
                batch = db.batch();
                currentBatchCount = 0;
                console.log("Batch committed to Firebase");
            }
            batch.set(document, prompt);
            currentBatchCount += 1;
        } catch (e) {
            console.log("Error processing prompt card: " + e);
        }
    }

    await batch.commit();
}

async function importResponseCards(customPack: CustomPack) {
    const responseCards: ResponseCard[] = customPack.responses.map((response) => {
        return {
            cid: computeCardId(customPack.set, response),
            text: response,
            set: customPack.set,
            source: customPack.sheet
        };
    });

    const cardSetDocument = db.collection('cardSets')
        .doc(cleanPath(customPack.set));

    await cardSetDocument.set({
        name: customPack.set,
        responses: responseCards.length,
        responseIndexes: responseCards.map((card) => card.cid)
    }, { merge: true });

    const responsesCollection = cardSetDocument.collection('responses');

    let currentBatchCount = 0;
    let batch = db.batch();
    for (let response of responseCards) {
        try {
            const document = responsesCollection.doc(hashDocumentId(response.text));
            if (currentBatchCount >= 500) {
                await batch.commit();
                batch = db.batch();
                currentBatchCount = 0;
                console.log("Batch committed to Firebase");
            }
            batch.set(document, response);
            currentBatchCount += 1;
        } catch (e) {
            console.log("Error processing response card: " + e);
        }
    }

    await batch.commit();
}