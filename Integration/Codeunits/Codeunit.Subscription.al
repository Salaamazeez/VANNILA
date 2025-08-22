codeunit 50403 "Subscription API"
{
    procedure TestConnection(): Text
    begin
        exit('Connection established suscessfully')
    end;

    procedure UpdateBankTransaction(TransactionJson: Text) TransactionResult: Text
    var
        InstructionRec: Record "Instruction";
        MyJsonToken: JsonToken;
        MyJsonToken2: JsonToken;
        JsonObject: JsonObject;
        JObject: JsonObject;
        JObject2: JsonObject;
        MyArray: JsonArray;
        ContactTypeArray: JsonArray;
        ContactArray: JsonArray;
        ContactTypeCodes: Text[250];
        Contacts: Text[500];
        i: Integer;
    begin
        JsonObject.ReadFrom(TransactionJson);

        // Initialize record
        InstructionRec.Reset();

        // Set filter based on key field - using Transaction Identifier as Message Id
        if JsonObject.get('transactionIdentifier', MyJsonToken) then begin
            JObject := MyJsonToken.AsObject();
            if JObject.get('identifier', MyJsonToken2) then
                InstructionRec.SetRange("Message Id", MyJsonToken2.AsValue().AsText());
        end;

        // Find or create record
        if not InstructionRec.FindFirst() then begin
            InstructionRec.Init();
            // Set Message Id from transaction identifier
            if JsonObject.get('transactionIdentifier', MyJsonToken) then begin
                JObject := MyJsonToken.AsObject();
                if JObject.get('identifier', MyJsonToken2) then
                    InstructionRec."Message Id" := MyJsonToken2.AsValue().AsText();
            end;
            InstructionRec.Insert(true);
        end;

        // Update fields from JSON
        if JsonObject.get('groupId', MyJsonToken) then
            if not MyJsonToken.AsValue().IsNull then
                InstructionRec."Group Id" := MyJsonToken.AsValue().AsText();

        // Account Identifier object
        if JsonObject.get('accountIdentifier', MyJsonToken) then begin
            JObject := MyJsonToken.AsObject();
            if JObject.get('accountId', MyJsonToken2) then
                if not MyJsonToken2.AsValue().IsNull then
                    InstructionRec."Account Id" := MyJsonToken2.AsValue().AsText();

            if JObject.get('currencyCode', MyJsonToken2) then begin
                JObject2 := MyJsonToken2.AsObject();
                if JObject2.get('isoCode', MyJsonToken2) then
                    if not MyJsonToken2.AsValue().IsNull then
                        InstructionRec."Account Currency Code" := MyJsonToken2.AsValue().AsText();
            end;

            if JObject.get('bankCode', MyJsonToken2) then
                if not MyJsonToken2.AsValue().IsNull then
                    InstructionRec."Account Bank Code" := MyJsonToken2.AsValue().AsText();
        end;

        if JsonObject.get('eventDate', MyJsonToken) then
            if not MyJsonToken.AsValue().IsNull then
                InstructionRec."Event Date" := MyJsonToken.AsValue().AsDate();

        // Transaction Identifier object
        if JsonObject.get('transactionIdentifier', MyJsonToken) then begin
            JObject := MyJsonToken.AsObject();
            if JObject.get('type', MyJsonToken2) then
                if not MyJsonToken2.AsValue().IsNull then
                    InstructionRec."Transaction Type" := MyJsonToken2.AsValue().AsText();

            if JObject.get('identifier', MyJsonToken2) then
                if not MyJsonToken2.AsValue().IsNull then
                    InstructionRec."Transaction Identifier" := MyJsonToken2.AsValue().AsText();
        end;

        if JsonObject.get('adviceType', MyJsonToken) then
            if not MyJsonToken.AsValue().IsNull then
                InstructionRec."Advice Type" := MyJsonToken.AsValue().AsText();

        if JsonObject.get('valueDate', MyJsonToken) then
            if not MyJsonToken.AsValue().IsNull then
                InstructionRec."Value Date" := MyJsonToken.AsValue().AsDate();

        if JsonObject.get('virtualAccountId', MyJsonToken) then
            if not MyJsonToken.AsValue().IsNull then
                InstructionRec."Virtual Account Id" := MyJsonToken.AsValue().AsText();

        if JsonObject.get('accountName', MyJsonToken) then
            if not MyJsonToken.AsValue().IsNull then
                InstructionRec."Account Name" := MyJsonToken.AsValue().AsText();

        if JsonObject.get('transactionCode', MyJsonToken) then
            if not MyJsonToken.AsValue().IsNull then
                InstructionRec."Transaction Code" := MyJsonToken.AsValue().AsText();

        if JsonObject.get('baiCode', MyJsonToken) then
            if not MyJsonToken.AsValue().IsNull then
                InstructionRec."BAI Code" := MyJsonToken.AsValue().AsText();

        if JsonObject.get('transactionDescription', MyJsonToken) then
            if not MyJsonToken.AsValue().IsNull then
                InstructionRec."Transaction Description" := MyJsonToken.AsValue().AsText();

        // Post Execution Balance object
        if JsonObject.get('postExecutionBalance', MyJsonToken) then begin
            JObject := MyJsonToken.AsObject();
            if JObject.get('currencyCode', MyJsonToken2) then
                if not MyJsonToken2.AsValue().IsNull then
                    InstructionRec."Post Balance Currency" := MyJsonToken2.AsValue().AsText();

            if JObject.get('amount', MyJsonToken2) then
                if not MyJsonToken2.AsValue().IsNull then
                    InstructionRec."Post Balance Amount" := MyJsonToken2.AsValue().AsDecimal();
        end;

        // Pre Execution Balance object
        if JsonObject.get('preExecutionBalance', MyJsonToken) then begin
            JObject := MyJsonToken.AsObject();
            if JObject.get('currencyCode', MyJsonToken2) then
                if not MyJsonToken2.AsValue().IsNull then
                    InstructionRec."Pre Balance Currency" := MyJsonToken2.AsValue().AsText();

            if JObject.get('amount', MyJsonToken2) then
                if not MyJsonToken2.AsValue().IsNull then
                    InstructionRec."Pre Balance Amount" := MyJsonToken2.AsValue().AsDecimal();
        end;

        // Transaction Amount object
        if JsonObject.get('transactionAmount', MyJsonToken) then begin
            JObject := MyJsonToken.AsObject();
            if JObject.get('currencyCode', MyJsonToken2) then
                if not MyJsonToken2.AsValue().IsNull then
                    InstructionRec."Transaction Amount Currency" := MyJsonToken2.AsValue().AsText();

            if JObject.get('amount', MyJsonToken2) then
                if not MyJsonToken2.AsValue().IsNull then
                    InstructionRec."Transaction Amount Value" := MyJsonToken2.AsValue().AsDecimal();
        end;

        // Client Identifier object
        if JsonObject.get('clientIdentifier', MyJsonToken) then begin
            JObject := MyJsonToken.AsObject();
            if JObject.get('type', MyJsonToken2) then
                if not MyJsonToken2.AsValue().IsNull then
                    InstructionRec."Client Identifier Type" := MyJsonToken2.AsValue().AsText();

            if JObject.get('identifier', MyJsonToken2) then
                if not MyJsonToken2.AsValue().IsNull then
                    InstructionRec."Client Identifier Value" := MyJsonToken2.AsValue().AsText();
        end;

        // External Identifier object
        if JsonObject.get('externalIdentifier', MyJsonToken) then begin
            JObject := MyJsonToken.AsObject();
            if JObject.get('type', MyJsonToken2) then
                if not MyJsonToken2.AsValue().IsNull then
                    InstructionRec."External Identifier Type" := MyJsonToken2.AsValue().AsText();

            if JObject.get('identifier', MyJsonToken2) then
                if not MyJsonToken2.AsValue().IsNull then
                    InstructionRec."External Identifier Value" := MyJsonToken2.AsValue().AsText();
        end;

        // Transaction Free Text array
        if JsonObject.get('transactionFreeText', MyJsonToken) then begin
            MyArray := MyJsonToken.AsArray();
            for i := 0 to MyArray.Count - 1 do begin
                MyArray.Get(i, MyJsonToken2);
                case i of
                    0:
                        InstructionRec."Free Text 1" := MyJsonToken2.AsValue().AsText();
                    1:
                        InstructionRec."Free Text 2" := MyJsonToken2.AsValue().AsText();
                    2:
                        InstructionRec."Free Text 3" := MyJsonToken2.AsValue().AsText();
                    3:
                        InstructionRec."Free Text 4" := MyJsonToken2.AsValue().AsText();
                    4:
                        InstructionRec."Free Text 5" := MyJsonToken2.AsValue().AsText();
                    5:
                        InstructionRec."Free Text 6" := MyJsonToken2.AsValue().AsText();
                end;
            end;
        end;

        // Transaction Extended Free Text array
        if JsonObject.get('transactionExtendedFreeText', MyJsonToken) then begin
            MyArray := MyJsonToken.AsArray();
            for i := 0 to MyArray.Count - 1 do begin
                MyArray.Get(i, MyJsonToken2);
                case i of
                    0:
                        InstructionRec."Extended Free Text 1" := MyJsonToken2.AsValue().AsText();
                    1:
                        InstructionRec."Extended Free Text 2" := MyJsonToken2.AsValue().AsText();
                    2:
                        InstructionRec."Extended Free Text 3" := MyJsonToken2.AsValue().AsText();
                    3:
                        InstructionRec."Extended Free Text 4" := MyJsonToken2.AsValue().AsText();
                end;
            end;
        end;

        // Transaction Multilingual Free Text array
        // if JsonObject.get('transactionMultiLingualFreeText', MyJsonToken) then begin
        //     MyArray := MyJsonToken.AsArray();
        //     for i := 0 to MyArray.Count - 1 do begin
        //         MyArray.Get(i, MyJsonToken2);
        //         case i of
        //             0: InstructionRec."Multilingual Free Text 1" := MyJsonToken2.AsValue().AsText();
        //             1: InstructionRec."Multilingual Free Text 2" := MyJsonToken2.AsValue().AsText();
        //         end;
        //     end;
        // end;

        if JsonObject.get('transactionTimestamp', MyJsonToken) then
            if not MyJsonToken.AsValue().IsNull then
                InstructionRec."Transaction Timestamp" := MyJsonToken.AsValue().AsDateTime();

        if JsonObject.get('bankCode', MyJsonToken) then
            if not MyJsonToken.AsValue().IsNull then
                InstructionRec."Account Bank Code" := MyJsonToken.AsValue().AsText();

        if JsonObject.get('countryCode', MyJsonToken) then
            if not MyJsonToken.AsValue().IsNull then
                InstructionRec."Country Code" := MyJsonToken.AsValue().AsText();

        if JsonObject.get('timestamp', MyJsonToken) then
            if not MyJsonToken.AsValue().IsNull then
                InstructionRec."Time" := MyJsonToken.AsValue().AsDateTime();

        // Payer Details object
        if JsonObject.get('payerDetails', MyJsonToken) then begin
            JObject := MyJsonToken.AsObject();
            if JObject.get('name', MyJsonToken2) then
                if not MyJsonToken2.AsValue().IsNull then
                    InstructionRec."Payer Name" := MyJsonToken2.AsValue().AsText();

            if JObject.get('account', MyJsonToken2) then begin
                JObject2 := MyJsonToken2.AsObject();
                if JObject2.get('id', MyJsonToken2) then
                    if not MyJsonToken2.AsValue().IsNull then
                        InstructionRec."Payer Account Id" := MyJsonToken2.AsValue().AsText();

                if JObject2.get('identityType', MyJsonToken2) then
                    if not MyJsonToken2.AsValue().IsNull then
                        InstructionRec."Payer Identity Type" := MyJsonToken2.AsValue().AsText();
            end;

            if JObject.get('bank', MyJsonToken2) then begin
                JObject2 := MyJsonToken2.AsObject();
                if JObject2.get('name', MyJsonToken2) then
                    if not MyJsonToken2.AsValue().IsNull then
                        InstructionRec."Payer Bank Name" := MyJsonToken2.AsValue().AsText();

                if JObject2.get('bankCode', MyJsonToken2) then
                    if not MyJsonToken2.AsValue().IsNull then
                        InstructionRec."Payer Bank Code" := MyJsonToken2.AsValue().AsText();

                if JObject2.get('clearingSystemId', MyJsonToken2) then
                    if not MyJsonToken2.AsValue().IsNull then
                        InstructionRec."Payer Clearing System Id" := MyJsonToken2.AsValue().AsText();
            end;
        end;

        // Payee Details object
        if JsonObject.get('payeeDetails', MyJsonToken) then begin
            JObject := MyJsonToken.AsObject();
            if JObject.get('name', MyJsonToken2) then
                if not MyJsonToken2.AsValue().IsNull then
                    InstructionRec."Payee Name" := MyJsonToken2.AsValue().AsText();

            if JObject.get('account', MyJsonToken2) then begin
                JObject2 := MyJsonToken2.AsObject();
                if JObject2.get('id', MyJsonToken2) then
                    if not MyJsonToken2.AsValue().IsNull then
                        InstructionRec."Payee Account Id" := MyJsonToken2.AsValue().AsText();
            end;

            if JObject.get('bank', MyJsonToken2) then begin
                JObject2 := MyJsonToken2.AsObject();
                if JObject2.get('name', MyJsonToken2) then
                    if not MyJsonToken2.AsValue().IsNull then
                        InstructionRec."Payee Bank Name" := MyJsonToken2.AsValue().AsText();

                if JObject2.get('bankCode', MyJsonToken2) then
                    if not MyJsonToken2.AsValue().IsNull then
                        InstructionRec."Payee Bank Code" := MyJsonToken2.AsValue().AsText();
            end;
        end;

        // Reference IDs object
        if JsonObject.get('referenceIds', MyJsonToken) then begin
            JObject := MyJsonToken.AsObject();
            if JObject.get('endToEndId', MyJsonToken2) then
                if not MyJsonToken2.AsValue().IsNull then
                    InstructionRec."End To End Id" := MyJsonToken2.AsValue().AsText();

            if JObject.get('txId', MyJsonToken2) then
                if not MyJsonToken2.AsValue().IsNull then
                    InstructionRec."TX Id" := MyJsonToken2.AsValue().AsText();

            if JObject.get('clearingSystemReference', MyJsonToken2) then
                if not MyJsonToken2.AsValue().IsNull then
                    InstructionRec."Clearing System Reference" := MyJsonToken2.AsValue().AsText();
        end;

        // Sender Correspondent Bank object
        if JsonObject.get('senderCorrespondentBank', MyJsonToken) then begin
            JObject := MyJsonToken.AsObject();
            if JObject.get('bankCode', MyJsonToken2) then
                if not MyJsonToken2.AsValue().IsNull then
                    InstructionRec."Sender Bank Code" := MyJsonToken2.AsValue().AsText();
        end;

        if JsonObject.get('additionalTransactionDescription', MyJsonToken) then
            if not MyJsonToken.AsValue().IsNull then
                InstructionRec."Additional Transaction Des." := MyJsonToken.AsValue().AsText();

        if JsonObject.get('supplementaryTransactionDescription', MyJsonToken) then
            if not MyJsonToken.AsValue().IsNull then
                InstructionRec."Supplementary Transaction Des." := MyJsonToken.AsValue().AsText();

        if JsonObject.get('postingMode', MyJsonToken) then
            if not MyJsonToken.AsValue().IsNull then
                InstructionRec."Posting Mode" := MyJsonToken.AsValue().AsText();

        // Process contacts array - store as comma-separated values
        if JsonObject.get('contacts', MyJsonToken) then begin
            JObject := MyJsonToken.AsObject();

            ContactTypeCodes := '';
            Contacts := '';

            if JObject.get('contactTypeCode', MyJsonToken2) then begin
                ContactTypeArray := MyJsonToken2.AsArray();
                for i := 0 to ContactTypeArray.Count - 1 do begin
                    ContactTypeArray.Get(i, MyJsonToken2);
                    if ContactTypeCodes <> '' then
                        ContactTypeCodes := ContactTypeCodes + ',';
                    ContactTypeCodes := ContactTypeCodes + MyJsonToken2.AsValue().AsText();
                end;
            end;

            if JObject.get('contact', MyJsonToken2) then begin
                ContactArray := MyJsonToken2.AsArray();
                for i := 0 to ContactArray.Count - 1 do begin
                    ContactArray.Get(i, MyJsonToken2);
                    if Contacts <> '' then
                        Contacts := Contacts + ',';
                    Contacts := Contacts + MyJsonToken2.AsValue().AsText();
                end;
            end;

            InstructionRec."Contact Type Codes" := ContactTypeCodes;
            InstructionRec."Contacts" := Contacts;
        end;

        InstructionRec.Modify();

        TransactionResult := 'Bank transaction successfully updated';
    end;
}
