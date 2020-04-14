const { GoogleSpreadsheet, GoogleSpreadsheetWorksheet } = require('google-spreadsheet');
import * as admin from 'firebase-admin';
const crypto = require('crypto');

const serviceAccount = require("../config/firebase_admin_sdk.json");
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://appsagainsthumanity-c7558.firebaseio.com"
});
const db = admin.firestore();

// Sheet Variables
const promptLength = 6792;
const responseLength = 24413;

function cleanPath(input: string): string {
    return input.replace('/', '_');
}

function hashDocumentId(input: string): string {
    const hash = crypto.createHash('sha256');
    hash.update(input);
    return hash.digest('hex');
}

// @ts-ignore
async function loadAndSavePromptCards(sheet: GoogleSpreadsheetWorksheet) {
    // Let's load all the prompts
    await sheet.loadCells(`A2:D${promptLength}`);
    console.log("Prompt cells loaded");

    let currentBatchCount = 0;
    let batch = db.batch();
    for (let i=2; i<=promptLength; i++) {
        const promptText = sheet.getCellByA1(`A${i}`).value;
        const promptSpecial = sheet.getCellByA1(`B${i}`).value;
        const promptSet = sheet.getCellByA1(`C${i}`).value;
        const sourceSheet = sheet.getCellByA1(`D${i}`).value;

        try {
            const document = db.collection('cardSets')
                .doc(cleanPath(promptSet))
                .collection('prompts')
                .doc(hashDocumentId(promptText));

            if (currentBatchCount >= 500) {
                await batch.commit();
                batch = db.batch();
                currentBatchCount = 0;
                console.log("Batch committed to Firebase");
            }

            batch.set(document, {
                text: promptText,
                special: promptSpecial,
                set: promptSet,
                source: sourceSheet
            });
            currentBatchCount += 1;
        } catch (e) {
            console.log("Error processing prompt card: " + e);
        }
    }

    await batch.commit();
}

// @ts-ignore
async function loadAndSaveResponseCards(sheet: GoogleSpreadsheetWorksheet) {
    // Let's load all the prompts
    await sheet.loadCells(`G2:I${responseLength}`);
    console.log("Response cells loaded");

    let currentBatchCount = 0;
    let batch = db.batch();
    for (let i=2; i<=responseLength; i++) {
        const responseText = sheet.getCellByA1(`G${i}`).value.toString();
        const responseSet = sheet.getCellByA1(`H${i}`).value;
        const sourceSheet = sheet.getCellByA1(`I${i}`).value;

        try {
            const document = db.collection('cardSets')
                .doc(cleanPath(responseSet))
                .collection('responses')
                .doc(hashDocumentId(responseText));

            if (currentBatchCount >= 500) {
                await batch.commit();
                batch = db.batch();
                currentBatchCount = 0;
                console.log("Batch committed to Firebase");
            }

            batch.set(document, {
                text: responseText,
                set: responseSet,
                source: sourceSheet
            });
            currentBatchCount += 1;
        } catch (e) {
            console.log("Error processing Response Card: " + e);
        }
    }

    await batch.commit();
}

async function run(docId: String) {
    const doc = new GoogleSpreadsheet(docId);
    await doc.useServiceAccountAuth(require('../config/service_account.json'));
    await doc.loadInfo();
    console.log(doc.title);

    // Master Cards List Sheet
    const sheet = doc.sheetsById['2018240023'];
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

run('1lsy7lIwBe-DWOi2PALZPf5DgXHx9MEvKfRw1GaWQkzg');