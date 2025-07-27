page 50101 "Instruction Card"
{
    PageType = Card;
    Caption = 'Instruction Card';
    SourceTable = "Instruction";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Message Id"; Rec."Message Id") { }
                field("Group Id"; Rec."Group Id") { }
                field("Transaction Type"; Rec."Transaction Type") { }
                field("Transaction Amount Value"; Rec."Transaction Amount Value") { }
                field("Transaction Amount Currency"; Rec."Transaction Amount Currency") { }
                field("Account Id"; Rec."Account Id") { }
                field("Creditor Name"; Rec."Creditor Name") { }
                field("Creditor Account Id"; Rec."Creditor Account Id") { }
                field("Creditor City"; Rec."Creditor City") { }
                field("Creditor Line1"; Rec."Creditor Line1") { }
                field("Creditor Country"; Rec."Creditor Country") { }
                field("Creditor Postcode"; Rec."Creditor Postcode") { }
                field("Creditor Agent BIC"; Rec."Creditor Agent BIC") { }
                field("Creditor Agent Name"; Rec."Creditor Agent Name") { }
                field("Creditor Agent City"; Rec."Creditor Agent City") { }
                field("Creditor Agent Line1"; Rec."Creditor Agent Line1") { }
                field("Creditor Agent Country"; Rec."Creditor Agent Country") { }
                field("Creditor Agent Postcode"; Rec."Creditor Agent Postcode") { }
                field("Debtor Name"; Rec."Debtor Name") { }
                field("Debtor Account Id"; Rec."Debtor Account Id") { }
                field("Debtor Account City"; Rec."Debtor Account City") { }
                field("Debtor Account Currency"; Rec."Debtor Account Currency") { }
                field("Debtor Agent BIC"; Rec."Debtor Agent BIC") { }
                field("Debtor Agent Name"; Rec."Debtor Agent Name") { }
                field("Debtor Agent City"; Rec."Debtor Agent City") { }
                field("Debtor Agent Address Line"; Rec."Debtor Agent Address Line") { }
                field("Debtor Agent Country"; Rec."Debtor Agent Country") { }
                field("Debtor Agent Postcode"; Rec."Debtor Agent Postcode") { }
                field("Debtor Country ISO"; Rec."Debtor Country ISO") { }
                field("Debtor Postcode"; Rec."Debtor Postcode") { }
                field("Debtor Street Name"; Rec."Debtor Street Name") { }
                field("Debtor Address Type"; Rec."Debtor Address Type") { }
                field("Debtor Address Line1"; Rec."Debtor Address Line1") { }
                field("OBO Name"; Rec."OBO Name") { }
                field("OBO Line 1"; Rec."OBO Line 1") { }
                field("OBO City"; Rec."OBO City") { }
                field("OBO State"; Rec."OBO State") { }
                field("OBO Country"; Rec."OBO Country") { }
                field("OBO Account Id"; Rec."OBO Account Id") { }
                field("OBO Type"; Rec."OBO Type") { }
                field("Required Execution Date"; Rec."Required Execution Date") { }
                field("Date Priority"; Rec."Date Priority") { }
                field("Amount Currency Code"; Rec."Amount Currency Code") { }
                field("Amount Value"; Rec."Amount Value") { }
                field("Amount Priority"; Rec."Amount Priority") { }
                field("Reference Id"; Rec."Reference Id") { }
                field("Payment Type"; Rec."Payment Type") { }
                field("Charger Bearer"; Rec."Charger Bearer") { }
                field("Remittance Info Line 1"; Rec."Remittance Info Line 1") { }
                field("Remittance Info Line 2"; Rec."Remittance Info Line 2") { }
                field("Regulatory Instruction Code"; Rec."Regulatory Instruction Code") { }
                field("Regulatory Instruction Details"; Rec."Regulatory Instruction Details") { }
                field("Instruction Code 1"; Rec."Instruction Code 1") { }
                field("Instruction Details 1"; Rec."Instruction Details 1") { }
                field("Instruction Code 2"; Rec."Instruction Code 2") { }
                field("Instruction Details 2"; Rec."Instruction Details 2") { }
                field("Value Date"; Rec."Value Date") { }
                field("Event Date"; Rec."Event Date") { }
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
                    PaymentNotif: Codeunit "Instruction JSON Handler";
                    Notif: Label '{"groupId":"AINABC01","accountIdentifier":{"accountId":"53105112345","currencyCode":{"isoCode":"INR"},"bankCode":"SCBLINBBXXX"},"eventDate":"2020-12-11","transactionIdentifier":{"type":"Other","identifier":"202012110337614"},"adviceType":"Credit","valueDate":"2020-12-11","virtualAccountId":"JUPIIGE1538","accountName":"JUPITER AVIATION LIMITED","transactionCode":"063","baiCode":"063","transactionDescription":"Inward Credit - IMPS","postExecutionBalance":{"currencyCode":"INR","amount":1985920},"preExecutionBalance":{"currencyCode":"INR","amount":1980920},"transactionFreeText":["IMPS/P2A/034610992057/0000000000","JUP1538","MARS TOURS AND TRAVELS","9229811/115205000543","",""],"transactionExtendedFreeText":["eBBS","JUPIIGE1538","VA","IMPS","",""],"transactionMultiLingualFreeText":["","","","","",""],"transactionAmount":{"currencyCode":"INR","amount":5000},"clientIdentifier":{"type":"Other","identifier":""},"externalIdentifier":{"type":"Other","identifier":"IMPS/P2A/034610992057/0000000000"},"contacts":{"contactTypeCode":["EM1","OF1","OT1","WAD","EMO","OT2","OT3","GS1"],"contact":["rajneesh.rai@JUPITER.in","01244852094","01244852751","www.JUPITER.in","TROPS@JUPITER.IN","01244352500","01244352131","BANKSTATEMENT@JUPITER.IN"]},"payerDetails":{"name":"","account":{"id":"","identityType":""},"bank":{"name":"","bankCode":"","clearingSystemId":""}},"referenceIds":{"endToEndId":"","txId":"","clearingSystemReference":""},"additionalTransactionDescription":"","supplementaryTransactionDescription":"","transactionTimestamp":"2020-12-11T10:43:43","bankCode":"531","countryCode":"IN","timestamp":"2020-12-11T05:13:43.708Z","payeeDetails":{"name":"John Doe","account":{"id":"000001"},"bank":{"name":"XYZ","bankCode":"0000"}},"senderCorrespondentBank":{"bankCode":"000"},"postingMode":""}';
                begin
                    PaymentNotif.UpdateBankTransaction(Notif)
                end;
            }
        }
    }
}