// #pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 90208 "Payment-Integr. Hook"
{


    var
        Window: Dialog;
        PmtTranSetup: Record "Payment Schedule Setup";
        MyOwnJObject: JsonObject;
        JObject2: JsonObject;
        JObject: JsonObject;
        MyArray: JsonArray;
        DebitAccounts: Record "Payment-DebitAccounts";
        MessageText: Text;
        Result: Text;
        Success: Boolean;
        TrueTxt: label 'TRUE';
        LineNo: Integer;
        NotFoundErr: label 'Account No. %1,Bank Code %2 cannot be found on the related debit accounts', Comment = '%1 is the Account No.,%2 is the Bank Code';

    // procedure CreateSchedule(var PaymentTranHdr: Record "Payment Schedule Header")
    // var
    //     PaymentTranLine: Record "Payment Schedule Line";
    //     DebitAccount: Record "Payment-DebitAccounts";
    //     HttpResponseMessage: HttpResponseMessage;
    //     MyJsonToken: JsonToken;
    //     json: Text;
    //     Myjson: Text;
    //     MyJsonToken2: JsonToken;
    //     Contact: Record Contact;
    //     RequestType: Text;
    //     BaseUrl: Text;
    //     ServiceResult: Text;
    //     BearerToken: Text;
    //     CashLitSetup: Record "Payment Trans Setup";
    //     SubResult: Text;
    //     JObject: JsonObject;
    //     JsonArray: JsonArray;
    //     StringContent: HttpContent;
    //     JsonObject: JsonObject;
    // begin
    //     PmtTranSetup.Get();
    //     Window.Open('Progressing.....');
    //     if PaymentTranHdr."API Platform" = PaymentTranHdr."API Platform"::SCB then begin
    //         DebitAccount.Reset;
    //         DebitAccount.SetRange(Id, PaymentTranHdr."Debit Account Id");
    //         DebitAccount.SetRange("Account Number", PaymentTranHdr."Bank Account Number");
    //         DebitAccount.SetRange("Bank Code", PaymentTranHdr."Bank CBN Code");
    //         if not DebitAccount.FindFirst() then
    //             Error(NotFoundErr, PaymentTranHdr."Bank Account Number", PaymentTranHdr."Bank CBN Code");
    //         JObject.Add('title', DelChr(PaymentTranHdr.Description, '=', '&'));
    //         JObject.Add('debitAccountId', DebitAccount.Id);
    //         JObject.Add('debitDescription', DelChr(PaymentTranHdr.Description, '=', '&'));
    //         JObject.Add('externalScheduleId', PaymentTranHdr."Batch Number");
    //         PaymentTranLine.Reset();
    //         PaymentTranLine.SetRange("Batch Number", PaymentTranHdr."Batch Number");
    //         if PaymentTranLine.FindSet() then begin
    //             repeat
    //                 Clear(JsonObject);
    //                 JsonObject.Add('accountName', DelChr(PaymentTranLine.Payee, '=', '&'));
    //                 JsonObject.Add('accountNumber', PaymentTranLine."To Account Number");
    //                 JsonObject.Add('bankCode', PaymentTranLine."Bank CBN Code");
    //                 JsonObject.Add('narration', DelChr(PaymentTranLine.Description, '=', '&'));
    //                 JsonObject.Add('amount', PaymentTranLine.Amount);
    //                 JsonObject.Add('externalLineId', Format(PaymentTranLine."Line No."));
    //                 JsonArray.Add(JsonObject);
    //             until PaymentTranLine.Next() = 0;
    //         end;
    //         JObject.Add('transactions', JsonArray)
    //     end;
    //     JObject.WriteTo(json);
    //     MyOwnJObject := JObject;
    //     StringContent.WriteFrom(json);
    //     StringContent.ReadAs(json);
    //     BearerToken := PmtTranSetup."Secret Key";
    //     BaseUrl := PmtTranSetup."Create Schedule URL";
    //     RequestType := 'POST';
    //     CallPaymentWebService(BaseUrl, RequestType, StringContent, HttpResponseMessage, BearerToken);
    //     HttpResponseMessage.Content().ReadAs(ServiceResult);
    //     Result := ServiceResult;
    //     JsonObject.ReadFrom(Result);
    //     JsonObject.get('success', MyJsonToken);
    //     Success := UpperCase(MyJsonToken.AsValue().AsText()) = TrueTxt;
    //     if Success then begin
    //         if JsonObject.Get('data', MyJsonToken) then
    //             JObject2 := MyJsonToken.AsObject();
    //         if JObject2.Get('scheduleId', MyJsonToken) then
    //             PaymentTranHdr."Schedule Id" := Format(MyJsonToken.AsValue().AsText());
    //         if JObject2.Get('transactions', MyJsonToken) then
    //             MyArray := MyJsonToken.AsArray();
    //         PaymentTranHdr."Submission Response Code" := 'REQUEST ACCEPTED';
    //         PaymentTranHdr."Create Schedule Status" := 'REQUEST ACCEPTED';
    //         PaymentTranHdr."Check Status Response" := 'REQUEST ACCEPTED';
    //         PaymentTranHdr."Date Submitted" := CurrentDatetime;
    //         PaymentTranHdr."Submitted by" := Format(UserId);
    //         PaymentTranHdr.Submitted := Success;
    //         PaymentTranHdr.Modify();
    //         foreach MyJsonToken2 in MyArray do begin
    //             JObject := MyJsonToken2.AsObject();
    //             JObject.Get('externalLineId', MyJsonToken2);
    //             Evaluate(LineNo, MyJsonToken2.AsValue().AsText());
    //             PaymentTranLine.Reset;
    //             PaymentTranLine.SetRange("Batch Number", PaymentTranHdr."Batch Number");
    //             PaymentTranLine.SetRange("Line No.", LineNo);
    //             if PaymentTranLine.FindFirst() then begin
    //                 PaymentTranLine."Status Description" := 'IN PROGRESS';
    //                 PaymentTranLine.Modify();
    //             end;
    //         end;
    //     end;
    //     JsonObject.get('message', MyJsonToken);
    //     ;
    //     MessageText := MyJsonToken.AsValue().AsText();
    //     Message(MessageText);
    //     Window.Close();
    // end;



    // procedure CreateSchedule(var PaymentTranHdr: Record "Payment Schedule Header")
    // var
    //     PaymentTranLine: Record "Payment Schedule Line";
    //     DebitAccount: Record "Payment-DebitAccounts";
    //     HttpResponseMessage: HttpResponseMessage;
    //     MyJsonToken: JsonToken;
    //     json: Text;
    //     Myjson: Text;
    //     MyJsonToken2: JsonToken;
    //     Contact: Record Contact;
    //     RequestType: Text;
    //     BaseUrl: Text;
    //     ServiceResult: Text;
    //     BearerToken: Text;
    //     CashLitSetup: Record "Payment Trans Setup";
    //     SubResult: Text;
    //     JObject: JsonObject;
    //     JsonArray: JsonArray;
    //     StringContent: HttpContent;
    //     JsonObject: JsonObject;
    // begin
    //     PmtTranSetup.Get();
    //     Window.Open('Progressing.....');
    //     if PaymentTranHdr."API Platform" = PaymentTranHdr."API Platform"::SCB then begin
    //         DebitAccount.Reset;
    //         DebitAccount.SetRange(Id, PaymentTranHdr."Debit Account Id");
    //         DebitAccount.SetRange("Account Number", PaymentTranHdr."Bank Account Number");
    //         DebitAccount.SetRange("Bank Code", PaymentTranHdr."Bank CBN Code");
    //         if not DebitAccount.FindFirst() then
    //             Error(NotFoundErr, PaymentTranHdr."Bank Account Number", PaymentTranHdr."Bank CBN Code");
    //         JObject.Add('title', DelChr(PaymentTranHdr.Description, '=', '&'));
    //         JObject.Add('debitAccountId', DebitAccount.Id);
    //         JObject.Add('debitDescription', DelChr(PaymentTranHdr.Description, '=', '&'));
    //         JObject.Add('externalScheduleId', PaymentTranHdr."Batch Number");
    //         PaymentTranLine.Reset();
    //         PaymentTranLine.SetRange("Batch Number", PaymentTranHdr."Batch Number");
    //         if PaymentTranLine.FindSet() then begin
    //             repeat
    //                 Clear(JsonObject);
    //                 JsonObject.Add('accountName', DelChr(PaymentTranLine.Payee, '=', '&'));
    //                 JsonObject.Add('accountNumber', PaymentTranLine."To Account Number");
    //                 JsonObject.Add('bankCode', PaymentTranLine."Bank CBN Code");
    //                 JsonObject.Add('narration', DelChr(PaymentTranLine.Description, '=', '&'));
    //                 JsonObject.Add('amount', PaymentTranLine.Amount);
    //                 JsonObject.Add('externalLineId', Format(PaymentTranLine."Line No."));
    //                 JsonArray.Add(JsonObject);
    //             until PaymentTranLine.Next() = 0;
    //         end;
    //         JObject.Add('transactions', JsonArray)
    //     end;
    //     JObject.WriteTo(json);
    //     MyOwnJObject := JObject;
    //     StringContent.WriteFrom(json);
    //     StringContent.ReadAs(json);
    //     BearerToken := PmtTranSetup."Secret Key";
    //     BaseUrl := PmtTranSetup."Create Schedule URL";
    //     RequestType := 'POST';
    //     CallPaymentWebService(BaseUrl, RequestType, StringContent, HttpResponseMessage, BearerToken);
    //     HttpResponseMessage.Content().ReadAs(ServiceResult);
    //     Result := ServiceResult;
    //     JsonObject.ReadFrom(Result);
    //     JsonObject.get('success', MyJsonToken);
    //     Success := UpperCase(MyJsonToken.AsValue().AsText()) = TrueTxt;
    //     if Success then begin
    //         if JsonObject.Get('data', MyJsonToken) then
    //             JObject2 := MyJsonToken.AsObject();
    //         if JObject2.Get('scheduleId', MyJsonToken) then
    //             PaymentTranHdr."Schedule Id" := Format(MyJsonToken.AsValue().AsText());
    //         if JObject2.Get('transactions', MyJsonToken) then
    //             MyArray := MyJsonToken.AsArray();
    //         PaymentTranHdr."Submission Response Code" := 'REQUEST ACCEPTED';
    //         PaymentTranHdr."Create Schedule Status" := 'REQUEST ACCEPTED';
    //         PaymentTranHdr."Check Status Response" := 'REQUEST ACCEPTED';
    //         PaymentTranHdr."Date Submitted" := CurrentDatetime;
    //         PaymentTranHdr."Submitted by" := Format(UserId);
    //         PaymentTranHdr.Submitted := Success;
    //         PaymentTranHdr.Modify();
    //         foreach MyJsonToken2 in MyArray do begin
    //             JObject := MyJsonToken2.AsObject();
    //             JObject.Get('externalLineId', MyJsonToken2);
    //             Evaluate(LineNo, MyJsonToken2.AsValue().AsText());
    //             PaymentTranLine.Reset;
    //             PaymentTranLine.SetRange("Batch Number", PaymentTranHdr."Batch Number");
    //             PaymentTranLine.SetRange("Line No.", LineNo);
    //             if PaymentTranLine.FindFirst() then begin
    //                 PaymentTranLine."Status Description" := 'IN PROGRESS';
    //                 PaymentTranLine.Modify();
    //             end;
    //         end;
    //     end;
    //     JsonObject.get('message', MyJsonToken);
    //     ;
    //     MessageText := MyJsonToken.AsValue().AsText();
    //     Message(MessageText);
    //     Window.Close();
    // end;



    procedure CreateSchedule(var PaymentTranHdr: Record "Payment Schedule Header")
    var
        PaymentTranLine: Record "Payment Schedule Line";
        DebitAccount: Record "Payment-DebitAccounts";
        HttpResponseMessage: HttpResponseMessage;
        BearerToken: Text;
        BaseUrl: Text;
        RequestType: Text;
        ServiceResult: Text;

        // JSON objects
        json: Text;
        RootObj: JsonObject;
        PayloadObj: JsonObject;
        HeaderObj: JsonObject;
        InstructionObj: JsonObject;

        AmountObj: JsonObject;
        DebtorObj: JsonObject;
        DebtorAccountObj: JsonObject;
        DebtorAgentObj: JsonObject;
        FinInstObj: JsonObject;
        PostalAddressObj: JsonObject;

        CreditorObj: JsonObject;
        CreditorAgentObj: JsonObject;
        CreditorFinInstObj: JsonObject;
        CreditorAccountObj: JsonObject;

        RemittanceObj: JsonObject;
        MultiUnstructuredArr: JsonArray;

        StringContent: HttpContent;
        MyJsonToken: JsonToken;
        JsonResponseObj: JsonObject;
        JObject2: JsonObject;
        MyArray: JsonArray;
        LineNo: Integer;
        Success: Boolean;
        MessageText: Text;
    begin
        Window.Open('Progressing.....');
        PmtTranSetup.Get();

        if PaymentTranHdr."API Platform" = PaymentTranHdr."API Platform"::SCB then begin
            // Validate debit account
            /*  DebitAccount.Reset;
              DebitAccount.SetRange(Id, PaymentTranHdr."Debit Account Id");
              DebitAccount.SetRange("Account Number", PaymentTranHdr."Bank Account Number");
              DebitAccount.SetRange("Bank Code", PaymentTranHdr."Bank CBN Code");
              if not DebitAccount.FindFirst() then
                  Error(NotFoundErr, PaymentTranHdr."Bank Account Number", PaymentTranHdr."Bank CBN Code");

              // ===== Root claims =====
              // RootObj.Add('iat', CurrentDateTime()); 
              // RootObj.Add('exp', CurrentDateTime() + 30000); 
              // RootObj.Add('aud', 'CLIENT');
              // RootObj.Add('jti', CreateGuid());
              // RootObj.Add('iss', 'SCB');

              // // ===== Header =====
              // HeaderObj.Add('messageSender', PaymentTranHdr."Message Sender");
              // HeaderObj.Add('messageId', PaymentTranHdr."Batch Number");
              // HeaderObj.Add('countryCode', PaymentTranHdr."Country Code");
              // HeaderObj.Add('timestamp', CurrentDateTime()); 

              // // ===== Instruction =====
              // InstructionObj.Add('paymentTimestamp', CurrentDateTime());
              // InstructionObj.Add('requiredExecutionDate', Format(Today, 0, 9)); // yyyy-mm-dd

              // // Amount
              // PaymentTranLine.Reset;
              // PaymentTranLine.SetRange("Batch Number", PaymentTranHdr."Batch Number");
              // if PaymentTranLine.FindFirst() then begin
              //     AmountObj.Add('currencyCode', PaymentTranLine."Currency Code");
              //     AmountObj.Add('amount', PaymentTranLine.Amount);
              // end else begin
              //     AmountObj.Add('currencyCode', PaymentTranHdr."Currency Code");
              //     AmountObj.Add('amount', PaymentTranHdr."Total Amount");
              // end;
              // InstructionObj.Add('amount', AmountObj);

              // InstructionObj.Add('referenceId', PaymentTranHdr."Reference Id");
              // InstructionObj.Add('paymentType', PaymentTranHdr."Payment Type");

              // // Debtor
              // DebtorObj.Add('name', PaymentTranHdr."Debtor Name");
              // InstructionObj.Add('debtor', DebtorObj);

              // // Debtor Account
              // DebtorAccountObj.Add('id', DebitAccount."Account Number");
              // DebtorAccountObj.Add('identifierType', DebitAccount."Identifier Type");
              // InstructionObj.Add('debtorAccount', DebtorAccountObj);

              // // Debtor Agent -> Financial Institution -> Postal Address
              // PostalAddressObj.Add('country', DebitAccount."Country Code");
              // FinInstObj.Add('postalAddress', PostalAddressObj);
              // FinInstObj.Add('name', DebitAccount."Bank Name");
              // FinInstObj.Add('BIC', DebitAccount."BIC");
              // DebtorAgentObj.Add('financialInstitution', FinInstObj);
              // InstructionObj.Add('debtorAgent', DebtorAgentObj);

              // // Creditor (from PaymentTranLine)
              // CreditorObj.Add('name', PaymentTranLine."Beneficiary Name");
              // InstructionObj.Add('creditor', CreditorObj);

              // // Creditor Agent
              // CreditorFinInstObj.Add('name', PaymentTranLine."Beneficiary Bank Name");
              // CreditorFinInstObj.Add('BIC', PaymentTranLine."Beneficiary BIC");
              // CreditorAgentObj.Add('financialInstitution', CreditorFinInstObj);
              // CreditorAgentObj.Add('branchCode', PaymentTranLine."Beneficiary Branch Code");
              // CreditorAgentObj.Add('clearingSystemId', PaymentTranLine."Beneficiary Bank Code");
              // InstructionObj.Add('creditorAgent', CreditorAgentObj);

              // // Creditor Account
              // CreditorAccountObj.Add('id', PaymentTranLine."To Account Number");
              // CreditorAccountObj.Add('identifierType', PaymentTranLine."Beneficiary Identifier Type");
              // InstructionObj.Add('creditorAccount', CreditorAccountObj);

              // // Remittance Info
              // MultiUnstructuredArr.Add(PaymentTranLine."Remittance Information");
              // RemittanceObj.Add('multiUnstructured', MultiUnstructuredArr);
              // InstructionObj.Add('remittanceInfo', RemittanceObj);

              // // ===== Payload =====
              // PayloadObj.Add('header', HeaderObj);
              // PayloadObj.Add('instruction', InstructionObj);
              // RootObj.Add('payload', PayloadObj);
              */
            PmtTranSetup.Get;
            json := '{ "header": { "messageSender": "RENGAS", "messageId": "RNG8778935909761832025", "countryCode": "NG", "timestamp": 1742300390 }, "instruction":         { "paymentTimestamp": 1742296796, "requiredExecutionDate": "2025-03-18", "amount": { "currencyCode": "NGN", "amount": 60 }, "referenceId": "REN00060285", "paymentType": "ACH", "debtor": { "name": "RENGAS SCB" }, "debtorAccount": { "id": "2402126942", "identifierType": "Other" }, "debtorAgent": { "financialInstitution": { "postalAddress": { "country": "NG" }, "name": "STANDARD CHARTERED BK", "BIC": "SCBLNGLAXXX" } }, "creditor": { "name": "Test Creditor" }, "creditorAgent": { "financialInstitution": { "name": "GUARANTY TRUST BANK PLC", "BIC": "GTBINGLAXXX" }, "branchCode": "52146", "clearingSystemId": "058" }, "creditorAccount": { "id": "0242700347", "identifierType": "Other" }, "remittanceInfo": { "multiUnstructured": [ "Payment to " ] } } }';
            // ===== Convert to text and send =====
            // RootObj.WriteTo(json);
            StringContent.WriteFrom(json);
            BearerToken := PmtTranSetup."Secret Key";
            BaseUrl := PmtTranSetup."Create Schedule URL";
            RequestType := 'POST';
            CallPaymentWebService(BaseUrl, RequestType, StringContent, HttpResponseMessage, BearerToken);

            // ===== Response handling =====
            HttpResponseMessage.Content().ReadAs(ServiceResult);
            JsonResponseObj.ReadFrom(ServiceResult);
            Message(ServiceResult);
            if JsonResponseObj.Get('success', MyJsonToken) then
                Success := UpperCase(MyJsonToken.AsValue().AsText()) = 'TRUE';
            if Success then begin
                if JsonResponseObj.Get('data', MyJsonToken) then
                    JObject2 := MyJsonToken.AsObject();
                if JObject2.Get('scheduleId', MyJsonToken) then
                    PaymentTranHdr."Schedule Id" := Format(MyJsonToken.AsValue().AsText());

                PaymentTranHdr."Submission Response Code" := 'REQUEST ACCEPTED';
                PaymentTranHdr."Create Schedule Status" := 'REQUEST ACCEPTED';
                PaymentTranHdr."Check Status Response" := 'REQUEST ACCEPTED';
                PaymentTranHdr."Date Submitted" := CurrentDateTime;
                PaymentTranHdr."Submitted by" := Format(UserId);
                PaymentTranHdr.Submitted := Success;
                PaymentTranHdr.Modify();

                if JObject2.Get('transactions', MyJsonToken) then
                    MyArray := MyJsonToken.AsArray();
                foreach MyJsonToken in MyArray do begin
                    JObject2 := MyJsonToken.AsObject();
                    if JObject2.Get('externalLineId', MyJsonToken) then
                        Evaluate(LineNo, MyJsonToken.AsValue().AsText());
                    PaymentTranLine.Reset;
                    PaymentTranLine.SetRange("Batch Number", PaymentTranHdr."Batch Number");
                    PaymentTranLine.SetRange("Line No.", LineNo);
                    if PaymentTranLine.FindFirst() then begin
                        PaymentTranLine."Status Description" := 'IN PROGRESS';
                        PaymentTranLine.Modify();
                    end;
                end;
            end;

            if JsonResponseObj.Get('message', MyJsonToken) then
                MessageText := MyJsonToken.AsValue().AsText();
            Message(MessageText);
        end;

        Window.Close();
    end;


    //     // procedure GetDebitAccount()
    //     // var
    //     //     PaymentTranLine: Record "Payment Schedule Line";
    //     //     DebitAccount: Record "Payment-DebitAccounts";
    //     //     HttpResponseMessage: HttpResponseMessage;
    //     //     MyJsonToken: JsonToken;
    //     //     StringContent: HttpContent;
    //     //     json: Text;
    //     //     Myjson: Text;
    //     //     MyJsonToken2: JsonToken;
    //     //     Contact: Record Contact;
    //     //     RequestType: Text;
    //     //     BaseUrl: Text;
    //     //     ServiceResult: Text;
    //     //     BearerToken: Text;
    //     //     CashLitSetup: Record "Payment Trans Setup";
    //     // begin
    //     //     CashLitSetup.Get();
    //     //     BearerToken := CashLitSetup."Secret Key";
    //     //     BaseUrl := CashLitSetup."Get Debit Account";
    //     //     RequestType := 'GET';
    //     //     CallPaymentWebService(BaseUrl, RequestType, StringContent, HttpResponseMessage, BearerToken);
    //     //     HttpResponseMessage.Content().ReadAs(ServiceResult);
    //     //     Result := ServiceResult;
    //     //     ServiceResult := Result;
    //     //     JObject.ReadFrom(Result);
    //     //     JObject2 := JObject;
    //     //     if JObject.Get('data', MyJsonToken) then
    //     //         MyArray := MyJsonToken.AsArray();
    //     //     foreach MyJsonToken2 in MyArray do begin
    //     //         JObject := MyJsonToken2.AsObject();
    //     //         DebitAccounts.Init();
    //     //         JObject.Get('id', MyJsonToken2);
    //     //         DebitAccounts.Id := Format(MyJsonToken2.AsValue().AsText());
    //     //         JObject.Get('accountName', MyJsonToken2);
    //     //         DebitAccounts."Account Name" := Format(MyJsonToken2.AsValue().AsText());
    //     //         JObject.Get('accountNumber', MyJsonToken2);
    //     //         DebitAccounts."Account Number" := Format(MyJsonToken2.AsValue().AsText());
    //     //         JObject.Get('bankName', MyJsonToken2);
    //     //         DebitAccounts."Bank Name" := Format(MyJsonToken2.AsValue().AsText());
    //     //         JObject.Get('commonName', MyJsonToken2);
    //     //         DebitAccounts."Common Name" := Format(MyJsonToken2.AsValue().AsText());
    //     //         JObject.Get('bankCode', MyJsonToken2);
    //     //         DebitAccounts."Bank Code" := Format(MyJsonToken2.AsValue().AsText());
    //     //         JObject.Get('active', MyJsonToken2);
    //     //         DebitAccounts.Active := UpperCase(MyJsonToken2.AsValue().AsText()) = 'TRUE';
    //     //         JObject.Get('authorized', MyJsonToken2);
    //     //         DebitAccounts.Authorized := UpperCase(MyJsonToken2.AsValue().AsText()) = 'TRUE';
    //     //         JObject.Get('allowDebit', MyJsonToken2);
    //     //         DebitAccounts."Allow Debit" := UpperCase(MyJsonToken2.AsValue().AsText()) = 'TRUE';
    //     //         JObject.Get('hasDebitMandate', MyJsonToken2);
    //     //         DebitAccounts."Has Debit Mandate" := UpperCase(MyJsonToken2.AsValue().AsText()) = 'TRUE';
    //     //         JObject.Get('mandateRefEncrypted', MyJsonToken2);
    //     //         DebitAccounts."Mandate Ref Encrypted" := Format(MyJsonToken2.AsValue().AsText());
    //     //         JObject.Get('syncedToNibss', MyJsonToken2);
    //     //         DebitAccounts."Synced To Nibss" := UpperCase(MyJsonToken2.AsValue().AsText()) = 'TRUE';
    //     //         JObject.Get('createdAt', MyJsonToken2);
    //     //         DebitAccounts."Created At" := Format(MyJsonToken2.AsValue().AsText());
    //     //         JObject.Get('modifiedAt', MyJsonToken2);
    //     //         DebitAccounts."Modified At" := Format(MyJsonToken2.AsValue().AsText());
    //     //         JObject.Get('deletedAt', MyJsonToken2);
    //     //         if not MyJsonToken2.AsValue().IsNull then
    //     //             DebitAccounts."Deleted At" := Format(MyJsonToken2.AsValue().AsText());
    //     //         JObject.Get('serviceMerchantId', MyJsonToken2);
    //     //         DebitAccounts."Service Merchant Id" := Format(MyJsonToken2.AsValue().AsText());
    //     //         JObject.Get('merchantId', MyJsonToken2);
    //     //         DebitAccounts."Merchant Id" := Format(MyJsonToken2.AsValue().AsText());
    //     //         JObject.Get('nibssAccountId', MyJsonToken2);
    //     //         DebitAccounts."Nibss Account Id" := Format(MyJsonToken2.AsValue().AsText());
    //     //         if not DebitAccounts.Insert() then
    //     //             DebitAccounts.Modify()
    //     //     end;
    //     //     JObject2.get('message', MyJsonToken);
    //     //     MessageText := MyJsonToken.AsValue().AsText();
    //     //     Message(MessageText);
    //     // end;

    //     // procedure GetPaymentUpdate(var PaymentScheduleHdr: Record "Payment Schedule Header")
    //     // var
    //     //     //PFACode: Record "PFA Code";
    //     //     HttpResponseMessage: HttpResponseMessage;
    //     //     MyJsonToken: JsonToken;
    //     //     StringContent: HttpContent;
    //     //     json: Text;
    //     //     Myjson: Text;
    //     //     MyJsonToken2: JsonToken;
    //     //     Contact: Record Contact;
    //     //     RequestType: Text;
    //     //     BaseUrl: Text;
    //     //     ServiceResult: Text;
    //     //     BearerToken: Text;
    //     //     Result: Text;
    //     //     JObject: JsonObject;
    //     //     JObject2: JsonObject;
    //     //     MyArray: JsonArray;
    //     //     LineNo: Integer;
    //     //     PaymentScheduleLine: Record "Payment Schedule Line";
    //     //     BankCode: Code[20];
    //     //     AccountNumber: Code[20];
    //     // begin
    //     //     PmtTranSetup.Get();
    //     //     if not PmtTranSetup."Use Pmt Authomation" then
    //     //         exit;
    //     //     BearerToken := PmtTranSetup."Secret Key";
    //     //     BaseUrl := PmtTranSetup."Get Payment Schedule URL" + '/' + PaymentScheduleHdr."Schedule Id";
    //     //     RequestType := 'GET';
    //     //     CallPaymentUpdateWebService(BaseUrl, RequestType, StringContent, HttpResponseMessage, BearerToken);
    //     //     HttpResponseMessage.Content().ReadAs(ServiceResult);
    //     //     Result := ServiceResult;
    //     //     ServiceResult := Result;
    //     //     //Message(ServiceResult);
    //     //     JObject.ReadFrom(Result);
    //     //     JObject2 := JObject;
    //     //     JObject.Get('message', MyJsonToken);
    //     //     MessageText := MyJsonToken.AsValue().AsText();
    //     //     JObject.Get('data', MyJsonToken);
    //     //     JObject := MyJsonToken.AsObject();
    //     //     JObject.Get('status', MyJsonToken);
    //     //     PaymentScheduleHdr."Check Status Response" := UpperCase(MyJsonToken.AsValue().AsText());
    //     //     PaymentScheduleHdr.Modify();
    //     //     if JObject.Get('scheduleLines', MyJsonToken) then
    //     //         MyArray := MyJsonToken.AsArray();
    //     //     foreach MyJsonToken2 in MyArray do begin
    //     //         JObject := MyJsonToken2.AsObject();
    //     //         JObject.Get('externalLineId', MyJsonToken2);
    //     //         Evaluate(LineNo, MyJsonToken2.AsValue().AsText());
    //     //         JObject.Get('bankCode', MyJsonToken2);
    //     //         BankCode := MyJsonToken2.AsValue().AsText();
    //     //         JObject.Get('accountNumber', MyJsonToken2);
    //     //         AccountNumber := MyJsonToken2.AsValue().AsText();
    //     //         PaymentScheduleLine.Reset();
    //     //         PaymentScheduleLine.SetRange("Batch Number", PaymentScheduleHdr."Batch Number");
    //     //         PaymentScheduleLine.SetRange("Bank CBN Code", BankCode);
    //     //         PaymentScheduleLine.SetRange("To Account Number", AccountNumber);
    //     //         PaymentScheduleLine.SetRange("Line No.", LineNo);
    //     //         IF PaymentScheduleLine.FindFirst() THEN BEGIN
    //     //             JObject.Get('status', MyJsonToken2);
    //     //             PaymentScheduleLine."Status Description" := UpperCase(MyJsonToken2.AsValue().AsText());
    //     //             PaymentScheduleLine.MODIFY();
    //     //         END;
    //     //     end;
    //     //     Message(MessageText);
    //     // end;




    local procedure CallPaymentWebService(BaseUrl: Text; RestMethod: Text; var HttpContent: HttpContent; var HttpResponseMessage: HttpResponseMessage; Bearer: Text)
    var
        HttpClient: HttpClient;
        HttpRequestMessage: HttpRequestMessage;
        myHttpRequestMessage: HttpRequestMessage;
        ContentHeaders: HttpHeaders;
        HttpClientHandler: Codeunit "Http Client Handler";
        RestClient: Codeunit "Rest Client";
        json: Text;
        JsonArray: JsonArray;
        myContent: HttpContent;
    begin
        HttpClient.SetBaseAddress(BaseUrl);
        case RestMethod of
            'GET':
                begin
                    myHttpRequestMessage.Method := RestMethod;
                    HttpClient.DefaultRequestHeaders.Add('api-key', Bearer);
                    HttpClient.DefaultRequestHeaders.Add('Accept', 'application/json');
                    HttpClient.Send(myHttpRequestMessage, HttpResponseMessage);
                end;
            'POST':
                begin
                    HttpContent.GetHeaders(ContentHeaders);
                    if ContentHeaders.Contains('Content-Type') then ContentHeaders.Remove('Content-Type');
                    ContentHeaders.Add('Content-Type', 'text/plain');
                    HttpContent.GetHeaders(ContentHeaders);
                    HttpClient.DefaultRequestHeaders.Add('Routing-Identifier', 'IN');
                    //HttpClient.DefaultRequestHeaders.Add('Accept', 'application/json');
                    HttpClient.Post('', HttpContent, HttpResponseMessage);
                end;
            'PUT':
                HttpClient.Put('', HttpContent, HttpResponseMessage);
            'DELETE':
                HttpClient.Delete('', HttpResponseMessage);
        end;
    end;

    //     //     local procedure CallPaymentUpdateWebService(BaseUrl: Text; RestMethod: Text; var HttpContent: HttpContent; var HttpResponseMessage: HttpResponseMessage; Bearer: Text)
    //     //     var
    //     //         HttpClient: HttpClient;
    //     //         HttpRequestMessage: HttpRequestMessage;
    //     //         myHttpRequestMessage: HttpRequestMessage;
    //     //         ContentHeaders: HttpHeaders;
    //     //         HttpClientHandler: Codeunit "Http Client Handler";
    //     //         RestClient: Codeunit "Rest Client";
    //     //         json: Text;
    //     //         JsonArray: JsonArray;
    //     //         myContent: HttpContent;
    //     //     begin
    //     //         HttpClient.SetBaseAddress(BaseUrl);
    //     //         case RestMethod of
    //     //             'GET':
    //     //                 begin
    //     //                     myHttpRequestMessage.Method := RestMethod;
    //     //                     HttpClient.DefaultRequestHeaders.Add('api-key', Bearer);
    //     //                     HttpClient.DefaultRequestHeaders.Add('Accept', 'application/json');
    //     //                     HttpClient.Send(myHttpRequestMessage, HttpResponseMessage);
    //     //                 end;
    //     //             'POST':
    //     //                 begin

    //     //                     HttpContent.GetHeaders(ContentHeaders);
    //     //                     if ContentHeaders.Contains('Content-Type') then ContentHeaders.Remove('Content-Type');
    //     //                     ContentHeaders.Add('Content-Type', 'application/json');
    //     //                     HttpContent.GetHeaders(ContentHeaders);
    //     //                     HttpClient.DefaultRequestHeaders.Add('api-key', Bearer);
    //     //                     HttpClient.DefaultRequestHeaders.Add('Accept', 'application/json');
    //     //                     HttpClient.Post('', HttpContent, HttpResponseMessage);
    //     //                 end;
    //     //             'PUT':
    //     //                 HttpClient.Put('', HttpContent, HttpResponseMessage);
    //     //             'DELETE':
    //     //                 HttpClient.Delete('', HttpResponseMessage);
    //     //         end;
    //     //     end;

    // }
}