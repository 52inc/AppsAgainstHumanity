#!/usr/bin/env kscript
//DEPS com.google.api-client:google-api-client:1.23.0
//DEPS com.google.oauth-client:google-oauth-client-jetty:1.23.0
//DEPS com.google.apis:google-api-services-sheets:v4-rev516-1.23.0

import com.google.api.client.auth.oauth2.Credential
import com.google.api.client.extensions.java6.auth.oauth2.AuthorizationCodeInstalledApp
import com.google.api.client.extensions.jetty.auth.oauth2.LocalServerReceiver
import com.google.api.client.util.store.FileDataStoreFactory
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow
import java.io.InputStreamReader
import com.google.api.client.googleapis.auth.oauth2.GoogleClientSecrets
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport
import java.io.IOException
import com.google.api.client.http.javanet.NetHttpTransport
import com.google.api.services.sheets.v4.SheetsScopes
import com.google.api.client.json.jackson2.JacksonFactory
import com.google.api.services.sheets.v4.Sheets
import org.jetbrains.exposed.sql.transactions.transaction

/**
 * Importer util for importing card list from this spreadsheet: https://docs.google.com/spreadsheets/d/1lsy7lIwBe-DWOi2PALZPf5DgXHx9MEvKfRw1GaWQkzg
 */
class CardImporter {

    private val APPLICATION_NAME = "Apps Against Humanity"
    private val SCOPES = listOf(SheetsScopes.SPREADSHEETS_READONLY)
    private val CREDENTIALS_FILE_PATH = "credentials.json"
    private val JSON_FACTORY = JacksonFactory.getDefaultInstance()
    private val TOKENS_DIRECTORY_PATH = "tokens"

    fun import(promptLength: Int = 5297, responseLength: Int = 18872) {
        val transport = GoogleNetHttpTransport.newTrustedTransport()
        val spreadsheetId = "1lsy7lIwBe-DWOi2PALZPf5DgXHx9MEvKfRw1GaWQkzg"

        val service = Sheets.Builder(transport, JSON_FACTORY, getCredentials(transport))
            .setApplicationName(APPLICATION_NAME)
            .build()

        val response = service.spreadsheets().values()
            .batchGet(spreadsheetId)
            .setRanges(listOf(
                "Master Cards List!A2:D$promptLength",
                "Master Cards List!G2:I$responseLength"
            ))
            .execute()

        val prompts = response.valueRanges[0].getValues().map {
            Prompt(it[0] as String, it[1] as String, it[2] as String, it[3] as String)
        }
        val responses = response.valueRanges[1].getValues().map {
            Response(it[0] as String, it[1] as String, it[2] as String)
        }
        val sets = prompts.groupBy { it.set }

        transaction {
            sets.forEach { set, cards ->
                CardSet.new {
                    text = set
                    count = cards.size
                }
            }

            prompts.forEach { prompt ->
                PromptCard.new {
                    text = prompt.text
                    special = prompt.special
                    set = prompt.set
                    sheet = prompt.sheet
                }
            }

            responses.forEach { resp ->
                ResponseCard.new {
                    text = resp.text
                    set = resp.set
                    sheet = resp.sheet
                }
            }
        }
    }

    data class Prompt(
        val text: String,
        val special: String,
        val set: String,
        val sheet: String
    )

    data class Response(
        val text: String,
        val set: String,
        val sheet: String
    )

    /**
     * Creates an authorized Credential object.
     * @param transport The network HTTP Transport.
     * @return An authorized Credential object.
     * @throws IOException If the credentials.json file cannot be found.
     */
    @Throws(IOException::class)
    private fun getCredentials(transport: NetHttpTransport): Credential {
        // Load client secrets.
        val input = CardImporter::class.java.getResourceAsStream(CREDENTIALS_FILE_PATH)
        val clientSecrets = GoogleClientSecrets.load(JSON_FACTORY, InputStreamReader(input))

        // Build flow and trigger user authorization request.
        val flow = GoogleAuthorizationCodeFlow.Builder(transport, JSON_FACTORY, clientSecrets, SCOPES)
            .setDataStoreFactory(FileDataStoreFactory(java.io.File(TOKENS_DIRECTORY_PATH)))
            .setAccessType("offline")
            .build()
        val receiver = LocalServerReceiver.Builder().setPort(8888).build()
        return AuthorizationCodeInstalledApp(flow, receiver).authorize("user")
    }
}

println("Hello from Kotlin!")
for (arg in args) {
    println("arg: $arg")
}
