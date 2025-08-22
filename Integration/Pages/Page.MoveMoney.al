page 50401 "Instruction"
{
    PageType = List;
    SourceTable = "Instruction";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Instructions';

    layout
    {
        area(Content)
        {
            repeater(Instructions)
            {
                // Original fields from Instruction table
                field("Message Sender"; Rec."Message Sender")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the message sender.';
                }
                field("Message Id"; Rec."Message Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the message ID.';
                }
                field("Country Code"; Rec."Country Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the country code.';
                }
                field("Required Execution Date"; Rec."Required Execution Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the required execution date.';
                }
                field("Date Priority"; Rec."Date Priority")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date priority.';
                }
                field("Amount Currency Code"; Rec."Amount Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount currency code.';
                }
                field("Amount Value"; Rec."Amount Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount value.';
                }
                field("Amount Priority"; Rec."Amount Priority")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount priority.';
                }
                field("Reference Id"; Rec."Reference Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the reference ID.';
                }
                field("Payment Type"; Rec."Payment Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the payment type.';
                }
                field("Charger Bearer"; Rec."Charger Bearer")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the charge bearer.';
                }

                // Debtor fields
                field("Debtor Name"; Rec."Debtor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the debtor name.';
                }
                field("Debtor Account Id"; Rec."Debtor Account Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the debtor account ID.';
                }
                field("Debtor Account City"; Rec."Debtor Account City")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the debtor account city.';
                }
                field("Debtor Account Currency"; Rec."Debtor Account Currency")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the debtor account currency.';
                }
                field("Debtor Agent BIC"; Rec."Debtor Agent BIC")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the debtor agent BIC.';
                }
                field("Debtor Agent Name"; Rec."Debtor Agent Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the debtor agent name.';
                }
                field("Debtor Agent City"; Rec."Debtor Agent City")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the debtor agent city.';
                }
                field("Debtor Agent Address Line"; Rec."Debtor Agent Address Line")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the debtor agent address line.';
                }
                field("Debtor Agent Country"; Rec."Debtor Agent Country")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the debtor agent country.';
                }
                field("Debtor Agent Postcode"; Rec."Debtor Agent Postcode")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the debtor agent postcode.';
                }

                // On Behalf Of fields
                field("OBO Name"; Rec."OBO Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the on behalf of name.';
                }
                field("OBO Line 1"; Rec."OBO Line 1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the on behalf of line 1.';
                }
                field("OBO City"; Rec."OBO City")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the on behalf of city.';
                }
                field("OBO State"; Rec."OBO State")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the on behalf of state.';
                }
                field("OBO Country"; Rec."OBO Country")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the on behalf of country.';
                }
                field("OBO Account Id"; Rec."OBO Account Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the on behalf of account ID.';
                }
                field("OBO Type"; Rec."OBO Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the on behalf of type.';
                }

                // Debtor Address fields
                field("Debtor Country ISO"; Rec."Debtor Country ISO")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the debtor country ISO.';
                }
                field("Debtor Postcode"; Rec."Debtor Postcode")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the debtor postcode.';
                }
                field("Debtor Street Name"; Rec."Debtor Street Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the debtor street name.';
                }
                field("Debtor Address Type"; Rec."Debtor Address Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the debtor address type.';
                }
                field("Debtor Address Line1"; Rec."Debtor Address Line1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the debtor address line 1.';
                }

                // Creditor fields
                field("Creditor Name"; Rec."Creditor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the creditor name.';
                }
                field("Creditor City"; Rec."Creditor City")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the creditor city.';
                }
                field("Creditor Line1"; Rec."Creditor Line1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the creditor line 1.';
                }
                field("Creditor Country"; Rec."Creditor Country")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the creditor country.';
                }
                field("Creditor Postcode"; Rec."Creditor Postcode")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the creditor postcode.';
                }

                // Creditor Agent fields
                field("Creditor Agent BIC"; Rec."Creditor Agent BIC")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the creditor agent BIC.';
                }
                field("Creditor Agent Name"; Rec."Creditor Agent Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the creditor agent name.';
                }
                field("Creditor Agent City"; Rec."Creditor Agent City")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the creditor agent city.';
                }
                field("Creditor Agent Line1"; Rec."Creditor Agent Line1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the creditor agent line 1.';
                }
                field("Creditor Agent Country"; Rec."Creditor Agent Country")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the creditor agent country.';
                }
                field("Creditor Agent Postcode"; Rec."Creditor Agent Postcode")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the creditor agent postcode.';
                }
                field("Creditor Account Id"; Rec."Creditor Account Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the creditor account ID.';
                }

                // Remittance Info fields
                field("Remittance Info Line 1"; Rec."Remittance Info Line 1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the remittance info line 1.';
                }
                field("Remittance Info Line 2"; Rec."Remittance Info Line 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the remittance info line 2.';
                }

                // Regulatory fields
                field("Regulatory Instruction Code"; Rec."Regulatory Instruction Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the regulatory instruction code.';
                }
                field("Regulatory Instruction Details"; Rec."Regulatory Instruction Details")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the regulatory instruction details.';
                }

                // Instruction Code Details fields
                field("Instruction Code 1"; Rec."Instruction Code 1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the instruction code 1.';
                }
                field("Instruction Details 1"; Rec."Instruction Details 1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the instruction details 1.';
                }
                field("Instruction Code 2"; Rec."Instruction Code 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the instruction code 2.';
                }
                field("Instruction Details 2"; Rec."Instruction Details 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the instruction details 2.';
                }

                // New JSON Fields
                field("Group Id"; Rec."Group Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the group ID.';
                }
                field("Account Id"; Rec."Account Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the account ID.';
                }
                field("Account Currency Code"; Rec."Account Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the account currency code.';
                }
                field("Account Bank Code"; Rec."Account Bank Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the account bank code.';
                }
                field("Event Date"; Rec."Event Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the event date.';
                }
                field("Transaction Identifier"; Rec."Transaction Identifier")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the transaction identifier.';
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the transaction type.';
                }
                field("Advice Type"; Rec."Advice Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the advice type.';
                }
                field("Value Date"; Rec."Value Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value date.';
                }
                field("Virtual Account Id"; Rec."Virtual Account Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the virtual account ID.';
                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the account name.';
                }
                field("Transaction Code"; Rec."Transaction Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the transaction code.';
                }
                field("BAI Code"; Rec."BAI Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the BAI code.';
                }
                field("Transaction Description"; Rec."Transaction Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the transaction description.';
                }
                field("Post Balance Currency"; Rec."Post Balance Currency")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the post balance currency.';
                }
                field("Post Balance Amount"; Rec."Post Balance Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the post balance amount.';
                }
                field("Pre Balance Currency"; Rec."Pre Balance Currency")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the pre balance currency.';
                }
                field("Pre Balance Amount"; Rec."Pre Balance Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the pre balance amount.';
                }
                field("Transaction Amount Currency"; Rec."Transaction Amount Currency")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the transaction amount currency.';
                }
                field("Transaction Amount Value"; Rec."Transaction Amount Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the transaction amount value.';
                }
                field("Client Identifier Type"; Rec."Client Identifier Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the client identifier type.';
                }
                field("Client Identifier Value"; Rec."Client Identifier Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the client identifier value.';
                }
                field("External Identifier Type"; Rec."External Identifier Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the external identifier type.';
                }
                field("External Identifier Value"; Rec."External Identifier Value")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the external identifier value.';
                }
                field("Transaction Timestamp"; Rec."Transaction Timestamp")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the transaction timestamp.';
                }
                field("Time"; Rec."Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the time.';
                }
                field("Posting Mode"; Rec."Posting Mode")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the posting mode.';
                }

                // Contacts fields
                field("Contact Type Codes"; Rec."Contact Type Codes")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the contact type codes (comma-separated).';
                }
                field("Contacts"; Rec."Contacts")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the contacts (comma-separated).';
                }

                // Payer fields
                field("Payer Name"; Rec."Payer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the payer name.';
                }
                field("Payer Account Id"; Rec."Payer Account Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the payer account ID.';
                }
                field("Payer Identity Type"; Rec."Payer Identity Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the payer identity type.';
                }
                field("Payer Bank Name"; Rec."Payer Bank Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the payer bank name.';
                }
                field("Payer Bank Code"; Rec."Payer Bank Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the payer bank code.';
                }
                field("Payer Clearing System Id"; Rec."Payer Clearing System Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the payer clearing system ID.';
                }

                // Payee fields
                field("Payee Name"; Rec."Payee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the payee name.';
                }
                field("Payee Account Id"; Rec."Payee Account Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the payee account ID.';
                }
                field("Payee Bank Name"; Rec."Payee Bank Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the payee bank name.';
                }
                field("Payee Bank Code"; Rec."Payee Bank Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the payee bank code.';
                }

                // Sender Correspondent Bank field
                field("Sender Bank Code"; Rec."Sender Bank Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the sender bank code.';
                }

                // Reference IDs fields
                field("End To End Id"; Rec."End To End Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the end to end ID.';
                }
                field("TX Id"; Rec."TX Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the TX ID.';
                }
                field("Clearing System Reference"; Rec."Clearing System Reference")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the clearing system reference.';
                }

                // Additional Descriptions fields
                field("Additional Transaction Des."; Rec."Additional Transaction Des.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the additional transaction description.';
                }
                field("Supplementary Transaction Des."; Rec."Supplementary Transaction Des.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the supplementary transaction description.';
                }

                // Free Text fields
                field("Free Text 1"; Rec."Free Text 1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the free text 1.';
                }
                field("Free Text 2"; Rec."Free Text 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the free text 2.';
                }
                field("Free Text 3"; Rec."Free Text 3")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the free text 3.';
                }
                field("Free Text 4"; Rec."Free Text 4")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the free text 4.';
                }
                field("Free Text 5"; Rec."Free Text 5")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the free text 5.';
                }
                field("Free Text 6"; Rec."Free Text 6")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the free text 6.';
                }

                // Extended Free Text fields
                field("Extended Free Text 1"; Rec."Extended Free Text 1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the extended free text 1.';
                }
                field("Extended Free Text 2"; Rec."Extended Free Text 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the extended free text 2.';
                }
                field("Extended Free Text 3"; Rec."Extended Free Text 3")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the extended free text 3.';
                }
                field("Extended Free Text 4"; Rec."Extended Free Text 4")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the extended free text 4.';
                }

                // Multilingual Free Text fields
                field("Multilingual Free Text 1"; Rec."Multilingual Free Text 1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the multilingual free text 1.';
                }
                field("Multilingual Free Text 2"; Rec."Multilingual Free Text 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the multilingual free text 2.';
                }
            }
        }
    }

    actions
    {
        area(Creation)
        {
            action(CreateNotification)
            {
                ApplicationArea = All;
                trigger OnAction()
                var
                    PaymentNotif: Codeunit "Subscription API";
                    Notif: Label '{"groupId":"AINABC01","accountIdentifier":{"accountId":"53105112345","currencyCode":{"isoCode":"INR"},"bankCode":"SCBLINBBXXX"},"eventDate":"2020-12-11","transactionIdentifier":{"type":"Other","identifier":"202012110337614"},"adviceType":"Credit","valueDate":"2020-12-11","virtualAccountId":"JUPIIGE1538","accountName":"JUPITER AVIATION LIMITED","transactionCode":"063","baiCode":"063","transactionDescription":"Inward Credit - IMPS","postExecutionBalance":{"currencyCode":"INR","amount":1985920},"preExecutionBalance":{"currencyCode":"INR","amount":1980920},"transactionFreeText":["IMPS/P2A/034610992057/0000000000","JUP1538","MARS TOURS AND TRAVELS","9229811/115205000543","",""],"transactionExtendedFreeText":["eBBS","JUPIIGE1538","VA","IMPS","",""],"transactionMultiLingualFreeText":["","","","","",""],"transactionAmount":{"currencyCode":"INR","amount":5000},"clientIdentifier":{"type":"Other","identifier":""},"externalIdentifier":{"type":"Other","identifier":"IMPS/P2A/034610992057/0000000000"},"contacts":{"contactTypeCode":["EM1","OF1","OT1","WAD","EMO","OT2","OT3","GS1"],"contact":["rajneesh.rai@JUPITER.in","01244852094","01244852751","www.JUPITER.in","TROPS@JUPITER.IN","01244352500","01244352131","BANKSTATEMENT@JUPITER.IN"]},"payerDetails":{"name":"","account":{"id":"","identityType":""},"bank":{"name":"","bankCode":"","clearingSystemId":""}},"referenceIds":{"endToEndId":"","txId":"","clearingSystemReference":""},"additionalTransactionDescription":"","supplementaryTransactionDescription":"","transactionTimestamp":"2020-12-11T10:43:43","bankCode":"531","countryCode":"IN","timestamp":"2020-12-11T05:13:43.708Z","payeeDetails":{"name":"John Doe","account":{"id":"000001"},"bank":{"name":"XYZ","bankCode":"0000"}},"senderCorrespondentBank":{"bankCode":"000"},"postingMode":""}';
                begin
                    PaymentNotif.UpdateBankTransaction(Notif)
                end;
            }
        }
    }
}