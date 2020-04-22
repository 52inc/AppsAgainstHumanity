import {PromptCard, ResponseCard} from "./models";
import {computeCardId, cleanPath, hashDocumentId} from "./utils";

const { GoogleSpreadsheet, GoogleSpreadsheetWorksheet } = require('google-spreadsheet');
import * as admin from 'firebase-admin';

const serviceAccount = require("../config/firebase_admin_sdk.json");
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://appsagainsthumanity-c7558.firebaseio.com"
});
const db = admin.firestore();

const argv = require('minimist')(process.argv.slice(2));
console.log(argv);

// Sheet Variables

const promptLength = argv.pl || 6792;
const responseLength = argv.rl || 24413;
const documentId = argv.doc || '1lsy7lIwBe-DWOi2PALZPf5DgXHx9MEvKfRw1GaWQkzg';
const sheetId = argv.sheet || '2018240023';

// @ts-ignore
async function loadAndSavePromptCards(sheet: GoogleSpreadsheetWorksheet) {
    // Let's load all the prompts
    await sheet.loadCells(`A2:D${promptLength}`);
    console.log("Prompt cells loaded");

    const prompts = new Map<string, PromptCard[]>();

    for (let i=2; i<=promptLength; i++) {
        const promptText = sheet.getCellByA1(`A${i}`).value;
        const promptSpecial = sheet.getCellByA1(`B${i}`).value;
        const promptSet = sheet.getCellByA1(`C${i}`).value;
        const sourceSheet = sheet.getCellByA1(`D${i}`).value;

        if (promptText && promptText.length > 0) {
            const cid = computeCardId(promptSet, promptText);
            let cards = prompts.get(promptSet);
            if (!cards) {
                cards = [];
            }
            cards.push({
                cid: cid,
                text: promptText,
                special: promptSpecial,
                set: promptSet,
                source: sourceSheet
            });
            prompts.set(promptSet, cards);
        }
    }

    for (let [promptSet, cards] of prompts) {
        const cardSetDocument = db.collection('cardSets')
            .doc(cleanPath(promptSet));

        // Set the set master document
        await cardSetDocument.set({
            name: promptSet,
            prompts: cards.length,
            promptIndexes: cards.map((card) => card.cid)
        }, { merge: true });

        const promptsCollection = cardSetDocument.collection('prompts');

        let currentBatchCount = 0;
        let batch = db.batch();
        for (let prompt of cards) {
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
}

// @ts-ignore
async function loadAndSaveResponseCards(sheet: GoogleSpreadsheetWorksheet) {
    // Let's load all the prompts
    await sheet.loadCells(`G2:I${responseLength}`);
    console.log("Response cells loaded");

    const responses = new Map<string, ResponseCard[]>();

    for (let i=2; i<=responseLength; i++) {
        const responseText = sheet.getCellByA1(`G${i}`).value?.toString();
        const responseSet = sheet.getCellByA1(`H${i}`).value;
        const sourceSheet = sheet.getCellByA1(`I${i}`).value;

        if (responseText && responseText.length > 0) {
            const cid = computeCardId(responseSet, responseText);
            let cards = responses.get(responseSet);
            if (!cards) {
                cards = [];
            }
            cards.push({
                cid: cid,
                text: responseText,
                set: responseSet,
                source: sourceSheet
            });
            responses.set(responseSet, cards);
        }
    }

    for (let [responseSet, cards] of responses) {
        const cardSetDocument = db.collection('cardSets')
            .doc(cleanPath(responseSet));

        await cardSetDocument.set({
            name: responseSet,
            responses: cards.length,
            responseIndexes: cards.map((card) => card.cid)
        }, { merge: true });

        const responsesCollection = cardSetDocument.collection('responses');

        let currentBatchCount = 0;
        let batch = db.batch();
        for (let response of cards) {
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
}

async function run(docId: String) {
    const doc = new GoogleSpreadsheet(docId);
    await doc.useServiceAccountAuth(require('../config/service_account.json'));
    await doc.loadInfo();
    console.log(doc.title);

    // Master Cards List Sheet
    const sheet = doc.sheetsById[sheetId];
    console.log(sheet.title);
    console.log(sheet.rowCount);

    // Let's load all the prompts
    console.log("Start loading prompts");
    await loadAndSavePromptCards(sheet);
    console.log("Prompt card's read and written");

    // Let's load all the response cards
    console.log("Start loading responses");
    await loadAndSaveResponseCards(sheet);

    console.log("Finished loading all CaH cards into firestore")
}

run(documentId);