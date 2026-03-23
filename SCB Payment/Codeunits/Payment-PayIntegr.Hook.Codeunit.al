// #pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 90208 "Payment-Integr. Hook"
{


    var
        Window: Dialog;
        PmtTranSetup: Record "Payment Schedule Setup";


    procedure CreateSchedule(var PaymentTranHdr: Record "Payment Schedule Header")
    var
        PaymentTranLine: Record "Payment Schedule Line";
        DebitAccount: Record "Payment-DebitAccounts";
        HttpResponseMessage: HttpResponseMessage;
        BearerToken: Text;
        BaseUrl: Text;
        RequestType: Text;
        ServiceResult: Text;
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
        Vendor: Record Vendor;
        CreditorObj: JsonObject;
        CreditorAgentObj: JsonObject;
        CreditorFinInstObj: JsonObject;
        CreditorAccountObj: JsonObject;
        postalAddress: JsonObject;

        HttpResponse: HttpResponseMessage;
        RemittanceObj: JsonObject;
        MultiUnstructuredArr: JsonArray;
        Headers: HttpHeaders;
        HttpContent: HttpContent;
        MyJsonToken: JsonToken;
        JsonResponseObj: JsonObject;
        JObject2: JsonObject;
        MyArray: JsonArray;
        LineNo: Integer;
        Success: Boolean;
        MessageText: Text;
        CompanyInfo: Record "Company Information";
        CustomerRec: Record Customer;
        CurrCode: Code[20];
        BankAccount: Record "Bank Account";
        HttpClient: HttpClient;
        WebhookUrl: Text;
        Description: Text[100];
        Purpose: Code[20];
        SectorialPurpose: Record "Sectoral Purpose Code";
        PaymentCategory: Record "Payment Category Code";
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        Success := false;
        CompanyInfo.Get();
        Window.Open('Progressing.....');
        PmtTranSetup.Get();
        GeneralLedgerSetup.Get();
        if PaymentTranHdr."API Platform" = PaymentTranHdr."API Platform"::SCB then begin
            PaymentTranLine.Reset;
            PaymentTranLine.SetRange("Batch Number", PaymentTranHdr."Batch Number");
            PaymentTranLine.SetFilter("Status Description", '%1', '');
            if PaymentTranLine.FindFirst() then begin
                repeat
                    // clear the objects
                    Clear(RootObj);
                    Clear(PayloadObj);
                    Clear(HeaderObj);
                    Clear(InstructionObj);
                    Clear(AmountObj);
                    Clear(DebtorObj);
                    Clear(DebtorAccountObj);
                    Clear(DebtorAgentObj);
                    Clear(FinInstObj);
                    Clear(PostalAddressObj);

                    Clear(CreditorObj);
                    Clear(CreditorAgentObj);
                    Clear(CreditorFinInstObj);
                    Clear(CreditorAccountObj);

                    Clear(RemittanceObj);

                    // JSON Arrays
                    Clear(MultiUnstructuredArr);
                    Clear(MyArray);

                    // Http-related objects (optional, if reusing)
                    Clear(Headers);
                    Clear(HttpContent);
                    Clear(JsonResponseObj);
                    Clear(JObject2);
                    Clear(MyJsonToken);
                    //===== Root claims =====

                    RootObj.Add('iat', CurrentDateTime());
                    RootObj.Add('exp', CurrentDateTime() + 30000);
                    RootObj.Add('aud', 'CLIENT');
                    RootObj.Add('jti', DelChr(CreateGuid(), '=', '{}'));
                    RootObj.Add('iss', 'SCB');

                    // ===== Header =====
                    //HeaderObj.Add('messageSender', CompanyInfo.Name);
                    HeaderObj.Add('messageId', DelChr(CreateGuid(), '=', '-{}'));
                    HeaderObj.Add('countryCode', CopyStr(CompanyInfo."Country/Region Code", 1, 2));
                    HeaderObj.Add('timestamp', ToUnixTimestamp(Format(CurrentDateTime())));

                    // ===== Instruction =====
                    InstructionObj.Add('paymentTimestamp', ToUnixTimestamp(Format(CurrentDateTime())));
                    if PaymentTranHdr."Payment Type Preference" = PaymentTranHdr."Payment Type Preference"::Explicit then
                        InstructionObj.Add('paymentTypePreference', Format(PaymentTranHdr."Payment Type Preference"));
                    InstructionObj.Add('requiredExecutionDate', Format(Today, 0, 9));
                    // yyyy-mm-dd
                    // if PaymentTranLine."Currency Code" <> '' then
                    //     CurrCode := PaymentTranLine."Currency Code"
                    // else
                    //     CurrCode := 'NGN';
                    // Amount
                    // PaymentTranLine.Reset;
                    // PaymentTranLine.SetRange("Batch Number", PaymentTranHdr."Batch Number");
                    // if PaymentTranLine.FindFirst() then begin
                    //     repeat
                    if PaymentTranHdr."Currency Code" <> '' then
                        CurrCode := PaymentTranHdr."Currency Code"
                    else
                        CurrCode := GeneralLedgerSetup."LCY Code";
                    AmountObj.Add('currencyCode', CurrCode);
                    AmountObj.Add('amount', PaymentTranLine.Amount);
                    InstructionObj.Add('amount', AmountObj);
                    InstructionObj.Add('referenceId', PaymentTranLine."Reference Number");
                    InstructionObj.Add('paymentType', Format(PaymentTranHdr."Payment Type"));//
                    InstructionObj.Add('chargerBearer', Format(PaymentTranHdr."Charger Bearer"));//
                    // Debtor   
                    BankAccount.Get(PaymentTranHdr."Bank Account Code");
                    DebtorObj.Add('name', BankAccount.Name);
                    InstructionObj.Add('debtor', DebtorObj);

                    // Debtor Account
                    DebtorAccountObj.Add('id', BankAccount."Bank Account No.");
                    DebtorAccountObj.Add('identifierType', Format(PaymentTranHdr."Debtor Identifier Type"));//DebitAccount."Identifier Type"
                    if BankAccount."Currency Code" <> '' then
                        DebtorAccountObj.Add('currency', BankAccount."Currency Code")
                    else begin                        
                        DebtorAccountObj.Add('currency', GeneralLedgerSetup."LCY Code");
                    end;
                    InstructionObj.Add('debtorAccount', DebtorAccountObj);

                    // Debtor Agent -> Financial Institution -> Postal Address
                    PostalAddressObj.Add('country', CopyStr(BankAccount."Country/Region Code", 1, 2));
                    FinInstObj.Add('postalAddress', PostalAddressObj);
                    FinInstObj.Add('name', BankAccount."Name 2");
                    FinInstObj.Add('BIC', Format(PaymentTranHdr."Debtor BIC"));

                    DebtorAgentObj.Add('financialInstitution', FinInstObj);
                    // if BankAccount."Bank Clearing Standard" <> '' then
                    //     DebtorAgentObj.Add('clearingSystemId', BankAccount."Bank Clearing Standard");
                    InstructionObj.Add('debtorAgent', DebtorAgentObj);
                    //if PaymentTranHdr."Payment Type Preference" = PaymentTranHdr."Payment Type Preference"::Explicit then begin
                        Clear(PostalAddressObj);
                        Vendor.Get(PaymentTranLine."Payee No.");
                        Vendor.TestField("Country/Region Code");
                        Vendor.TestField(City);
                        PostalAddressObj.Add('country', CopyStr(Vendor."Country/Region Code", 1, 2));
                        PostalAddressObj.Add('city', Vendor.City);
                    //end;
                    CreditorObj.Add('name', CopyStr(PaymentTranLine.Payee, 1, 35));
                    //if PaymentTranHdr."Payment Type Preference" = PaymentTranHdr."Payment Type Preference"::Explicit then
                        CreditorObj.Add('postalAddress', PostalAddressObj);
                    InstructionObj.Add('creditor', CreditorObj);

                    // Creditor Agent
                    CreditorFinInstObj.Add('name', CopyStr(PaymentTranLine."Bank Name", 1, 35));
                    CreditorFinInstObj.Add('BIC', Format(PaymentTranLine."Creditor BIC"));
                    if PaymentTranHdr."Payment Type Preference" = PaymentTranHdr."Payment Type Preference"::Explicit then
                        CreditorFinInstObj.Add('postalAddress', PostalAddressObj);
                    CreditorAgentObj.Add('financialInstitution', CreditorFinInstObj);
                    if not (PaymentTranHdr."Payment Type Preference" = PaymentTranHdr."Payment Type Preference"::Explicit) then begin
                        CreditorAgentObj.Add('branchCode', PaymentTranLine."Branch Code");
                        CreditorAgentObj.Add('clearingSystemId', PaymentTranLine."Bank CBN Code");
                    end;
                    InstructionObj.Add('creditorAgent', CreditorAgentObj);

                    // Creditor Account 
                    CreditorAccountObj.Add('id', PaymentTranLine."To Account Number");
                    if (PaymentTranHdr."Payment Type Preference" = PaymentTranHdr."Payment Type Preference"::Explicit) then
                        CreditorAccountObj.Add('currency', PaymentTranLine."Currency Code");
                    CreditorAccountObj.Add('identifierType', Format(PaymentTranLine."Creditor Identifier Type"));
                    InstructionObj.Add('creditorAccount', CreditorAccountObj);
                    //if (PaymentTranHdr."Payment Type Preference" = PaymentTranHdr."Payment Type Preference"::Explicit) then
                    PaymentCategory.Get(PaymentTranHdr."Payment Category Code");
                    Purpose := PaymentCategory."Category Code";
                    //Purpose := 'OTHR';
                    //else
                    //     Purpose := CopyStr(PaymentTranLine.Description, 1, 10);
                    InstructionObj.Add('purpose', Purpose);
                    // Remittance Info
                    if (PaymentTranHdr."Payment Type Preference" = PaymentTranHdr."Payment Type Preference"::Explicit) then begin
                        SectorialPurpose.Get(PaymentTranLine."Sectorial Purpose Code");
                        Description := DelChr(SectorialPurpose."Purpose Code" + SectorialPurpose.Description)
                        //Description := 'HF120OtherBusinessServicesOther'
                    end else begin
                        Description := DelChr(PaymentTranLine.Description);
                        Description := DelChr(Description, '=', '->');
                    end;
                    MultiUnstructuredArr.Add(DelChr(Description, '=', ' '));
                    RemittanceObj.Add('multiUnstructured', MultiUnstructuredArr);
                    InstructionObj.Add('remittanceInfo', RemittanceObj);

                    // ===== Payload =====
                    PayloadObj.Add('header', HeaderObj);
                    PayloadObj.Add('instruction', InstructionObj);
                    RootObj.Add('payload', PayloadObj);
                    //Message(Format(PayloadObj));
                    PmtTranSetup.Get;
                    PayloadObj.WriteTo(json);
                    //json := '{ "header": { "messageId": "RNG8778935909761832025", "countryCode": "NG", "timestamp": 1742300390 }, "instruction":         { "paymentTimestamp": 1742296796, "paymentTypePreference": "Explicit", "requiredExecutionDate": "2025-03-18", "amount": { "currencyCode": "USD", "amount": 60 }, "referenceId": "REN00060285", "paymentType": "TT", "chargerBearer": "SHAR", "debtor": { "name": "RENGAS SCB" }, "debtorAccount": { "id": "91701015012", "identifierType": "Other" }, "debtorAgent": { "financialInstitution": { "postalAddress": { "country": "NG" }, "name": "STANDARD CHARTERED BK", "BIC": "SCBLNGLAXXX" } }, "creditor": { "name": "Test Creditor" }, "creditorAgent": { "financialInstitution": { "name": "STANDARD CHARTERED BK", "BIC": "SCBLNGLAXXX" } }, "creditorAccount": { "id": "91701015012", "currency": "USD", "identifierType": "Other" }, "purpose": "MSC", "remittanceInfo": { "multiUnstructured": [ "Payment to " ] } } }';
                    //json := '{ "header": { "messageId": "RNG8778935909761832025", "countryCode": "NG", "timestamp": 1742300390 }, "instruction":         { "paymentTimestamp": 1742296796, "paymentTypePreference": "Explicit", "requiredExecutionDate": "2025-03-18", "amount": { "currencyCode": "USD", "amount": 60 }, "referenceId": "REN00060285", "paymentType": "TT", "chargerBearer": "SHAR", "debtor": { "name": "RENGAS SCB" }, "debtorAccount": { "id": "0001901885", "identifierType": "Other" }, "debtorAgent": { "financialInstitution": { "postalAddress": { "country": "NG" }, "name": "STANDARD CHARTERED BK", "BIC": "SCBLNGLAXXX" } }, "creditor": { "name": "Test Creditor" }, "creditorAgent": { "financialInstitution": { "name": "STANDARD CHARTERED BK", "BIC": "SCBLNGLAXXX" } }, "creditorAccount": { "id": "91701015012", "currency": "USD", "identifierType": "Other" }, "purpose": "MSC", "remittanceInfo": { "multiUnstructured": [ "Payment to " ] } } }';
                    //json :='{ "header": { "messageId": "RNG8778935909761832025", "countryCode": "NG", "timestamp": 1742300390 }, "instruction":         { "paymentTimestamp": 1742296796, "paymentTypePreference": "Explicit", "requiredExecutionDate": "2025-03-18", "amount": { "currencyCode": "USD", "amount": 60 }, "referenceId": "REN00060285", "paymentType": "TT", "chargerBearer": "SHAR", "debtor": { "name": "RENGAS SCB" }, "debtorAccount": { "id": "2402126942 ", "identifierType": "Other" }, "debtorAgent": { "financialInstitution": { "postalAddress": { "country": "US" }, "name": "STANDARD CHARTERED BK", "BIC": "SCBLNGLAXXX" } }, "creditor": { "name": "Test Creditor" }, "creditorAgent": { "financialInstitution": { "name": "STANDARD CHARTERED BK", "BIC": "SCBLNGLAXXX" } }, "creditorAccount": { "id": "91701015012", "currency": "USD", "identifierType": "Other" }, "purpose": "MSC", "remittanceInfo": { "multiUnstructured": [ "Payment to " ] } } }';
                    //json := '{ "header": { "messageId": "RNG8778935909761832025", "countryCode": "NG", "timestamp": 1742300390 }, "instruction":        { "paymentTimestamp": 1742296796, "paymentTypePreference": "Explicit", "requiredExecutionDate": "2025-03-18", "amount": { "currencyCode": "USD", "amount": 60 }, "referenceId": "REN_00060285", "paymentType": "TT", "chargerBearer": "SHAR", "debtor": { "name": "RENGAS SCB" }, "debtorAccount": { "id": "0006579807", "identifierType": "Other", "currency": "USD" }, "debtorAgent": { "financialInstitution": { "postalAddress": { "country": "NG" }, "name": "STANDARD CHARTERED BK", "BIC": "SCBLNGLAXXX" } }, "creditor": { "name": "Test Creditor" }, "creditorAgent": { "financialInstitution": { "name": "STANDARD CHARTERED BK", "BIC": "SCBLNGLAXXX" } }, "creditorAccount": { "id": "91701015012", "currency": "USD", "identifierType": "Other" }, "purpose": "MSC", "remittanceInfo": { "multiUnstructured": [ "Payment to " ] } } }';
                    //json   := '{ "header": { "messageId": "RNG8778935909761832025", "countryCode": "NG", "timestamp": 1742300390 }, "instruction":        { "paymentTimestamp": 1742296796, "paymentTypePreference": "Explicit", "requiredExecutionDate": "2025-03-18", "amount": { "currencyCode": "USD", "amount": 60 }, "referenceId": "REN__00060285", "paymentType": "TT", "chargerBearer": "SHAR", "debtor": { "name": "RENGAS SCB" }, "debtorAccount": { "id": "0006579807", "identifierType": "Other", "currency": "USD" }, "debtorAgent": { "financialInstitution": { "postalAddress": { "country": "NG" }, "name": "STANDARD CHARTERED BK", "BIC": "SCBLNGLAXXX" } }, "creditor": { "name": "Test Creditor" }, "creditorAgent": { "financialInstitution": { "name": "STANDARD CHARTERED BK", "BIC": "SCBLNGLAXXX" } }, "creditorAccount": { "id": "91701015012", "currency": "GBP", "identifierType": "Other" }, "purpose": "MSC", "remittanceInfo": { "multiUnstructured": [ "Payment to " ] } } }';
                    //Message(json);  //json := '{ "header": { "messageSender": "RENGAS", "messageId": "RNG8778935909761832025", "countryCode": "NG", "timestamp": 1742300390 }, "instruction":         { "paymentTimestamp": 1742296796, "requiredExecutionDate": "2025-03-18", "amount": { "currencyCode": "NGN", "amount": 60 }, "referenceId": "REN00060285", "paymentType": "ACH", "debtor": { "name": "RENGAS SCB" }, "debtorAccount": { "id": "2402126942", "identifierType": "Other" }, "debtorAgent": { "financialInstitution": { "postalAddress": { "country": "NG" }, "name": "STANDARD CHARTERED BK", "BIC": "SCBLNGLAXXX" } }, "creditor": { "name": "Test Creditor" }, "creditorAgent": { "financialInstitution": { "name": "GUARANTY TRUST BANK PLC", "BIC": "GTBINGLAXXX" }, "branchCode": "52146", "clearingSystemId": "058" }, "creditorAccount": { "id": "0242700347", "identifierType": "Other" }, "remittanceInfo": { "multiUnstructured": [ "Payment to " ] } } }';
                    //json :=  '{ "header": { "messageId": "EEC8EC9A-0BFD-4417-99DD-F395485D8C41", "countryCode": "NG", "timestamp": 1769725080 }, "instruction": { "paymentTimestamp": 1769725080, "requiredExecutionDate": "2026-01-29", "amount": { "currencyCode": "NGN", "amount": 45000 }, "referenceId": "PEF000019", "paymentType": "ACH", "chargerBearer": "DEBT", "debtor": { "name": "REONL SCB NIG NGN A/C (Pymt)" }, "debtorAccount": { "id": "2402126942", "identifierType": "Other" }, "debtorAgent": { "financialInstitution": { "postalAddress": { "country": "NG" }, "name": "REONL SCB NIG NGN A/C (Pymt)", "BIC": "SCBLNGLAXXX" } }, "creditor": { "name": "RG02- 0000153986" }, "creditorAgent": { "financialInstitution": { "name": "RG02- 0000153986", "BIC": "GTBINGLAXXX" }, "branchCode": "52146", "clearingSystemId": "058" }, "creditorAccount": { "id": "0000153986", "identifierType": "Other" }, "remittanceInfo": { "multiUnstructured": [ "" ] } } }';
                    //json := '{"header":{"messageId":"96951A6A-01D0-454A-B4BA-EB66376B8097","countryCode":"NG","timestamp":1770416160},"instruction":{"paymentTimestamp":1770416160,"requiredExecutionDate":"2026-02-06","amount":{"currencyCode":"NGN","amount":45000.0},"referenceId":"PREF000031","paymentType":"ACH","chargerBearer":"DEBT","debtor":{"name":"REONL SCB NIG NGN A/C (Pymt)"},"debtorAccount":{"id":"2402126942","identifierType":"Other"},"debtorAgent":{"financialInstitution":{"postalAddress":{"country":"NG"},"name":"REONL SCB NIG NGN A/C (Pymt)","BIC":"SCBLNGLAXXX"}},"creditor":{"name":"RG02- 0000153986"},"creditorAgent":{"financialInstitution":{"name":"RG02- 0000153986","BIC":"GTBINGLAXXX"},"branchCode":"52146","clearingSystemId":"058"},"creditorAccount":{"id":"0000153986","identifierType":"Other"},"purpose":"OTHR","remittanceInfo":{"multiUnstructured":["Multipledomesticpayment"]}}}';

                    // ===== Convert to text and send =====
                    // RootObj.WriteTo(json);
                    //StringContent.WriteFrom(json);
                    //BearerToken := PmtTranSetup."Secret Key";
                    WebhookUrl := PmtTranSetup."Create Schedule URL";
                    RequestType := 'POST';
                    //CallPaymentWebService(BaseUrl, RequestType, StringContent, HttpResponseMessage, BearerToken);
                    HttpContent.WriteFrom(json);
                    if PmtTranSetup."Print Payload" then
                        Message(json);
                    HttpContent.GetHeaders(Headers);
                    Headers.Clear();
                    Headers.Add('Content-Type', 'application/json');
                    //  Send POST request
                    //exit;
                    if HttpClient.Post(WebhookUrl, HttpContent, HttpResponse) then begin
                        HttpResponse.Content().ReadAs(ServiceResult);
                        if PmtTranSetup."Print Payload" then
                            Message(ServiceResult);
                        //Message('Webhook POST succeeded:\%1', ServiceResult);
                        //ServiceResult := '{"status":1etrue,"data":"¦ùä-GWÀÒâ44dier\":\"PSC000004\",\"internalTrackingId\":\"48a549de-7b03-4b54-be9f-be9fd36c1156\",\"clientReferenceId\":\"PSC000004\",\"referenceId\":\"PSC000004\",\"statusString\":\"Pending\",\"timestamp\":\"2025-11-29T15:43:32.294Z\"}"}';
                        JsonResponseObj.ReadFrom(ServiceResult);
                        //Message(ServiceResult);
                        if JsonResponseObj.Get('status', MyJsonToken) then
                            if not MyJsonToken.AsValue().IsNull then
                                Success := MyJsonToken.AsValue().AsBoolean();
                    end else
                        Error('Failed to send webhook payload to %1', WebhookUrl);
                    // ===== Response handling =====
                    //JsonResponseObj.ReadFrom(ServiceResult);
                    //Message(ServiceResult);
                    //if StrPos(ServiceResult, 'Received') > 0 then
                    //    Success := true;
                    PaymentTranHdr."Date Submitted" := CurrentDateTime;
                    if Success then begin
                        PaymentTranHdr."Submission Response Code" := 'REQUEST ACCEPTED';
                        PaymentTranHdr."Create Schedule Status" := 'REQUEST ACCEPTED';
                        PaymentTranHdr."Date Submitted" := CurrentDateTime;
                        PaymentTranHdr."Submitted by" := Format(UserId);
                        PaymentTranHdr.Submitted := Success;
                        // if JsonResponseObj.Get('data', MyJsonToken) then
                        //     ServiceResult := MyJsonToken.AsValue().AsText();
                        // JsonResponseObj.ReadFrom(ServiceResult);
                        if JsonResponseObj.Get('statusString', MyJsonToken) then
                            if not MyJsonToken.AsValue().IsNull then begin
                                PaymentTranLine."Status Description" := MyJsonToken.AsValue().AsText();
                                //PaymentTranHdr."Check Status Response" := MyJsonToken.AsValue().AsText();
                            end;
                        if JsonResponseObj.Get('statusCode', MyJsonToken) then
                            if not MyJsonToken.AsValue().IsNull then
                                PaymentTranLine."Uploaded Status Code" := MyJsonToken.AsValue().AsText();
                        if JsonResponseObj.Get('reasonCode', MyJsonToken) then
                            if not MyJsonToken.AsValue().IsNull then
                                PaymentTranLine."Reason Code" := MyJsonToken.AsValue().AsText();
                        if JsonResponseObj.Get('reasonInformation', MyJsonToken) then
                            if not MyJsonToken.AsValue().IsNull then
                                PaymentTranLine."Reason Information Text" := MyJsonToken.AsValue().AsText();
                        //PaymentTranHdr."Check Status Response" := MyJsonToken.AsValue().AsText();
                        Commit();
                        if PaymentTranLine.Modify() then;

                    end;
                //end;
                until PaymentTranLine.Next() = 0;
                PaymentTranHdr.Modify();
                Message('Schedule created!!');
                exit
            end;
            PaymentTranHdr.Modify();
            Message('No schedule created!!');
            Window.Close();
        end;
    end;

    procedure UpdatePaymentStatus(var PaymentTranHdr: Record "Payment Schedule Header")
    var
        PaymentTranLine: Record "Payment Schedule Line";
        PayloadObj: JsonObject;
        InnerPayloadObj: JsonObject;
        ClientRefArray: JsonArray;
        Timestamp: Integer;
        ResultJson: Text;
        Headers: HttpHeaders;
        HttpContent: HttpContent;
        MyJsonToken: JsonToken;
        MyJsonToken2: JsonToken;
        JsonResponseObj: JsonObject;
        JObject2: JsonObject;
        MyArray: JsonArray;
        LineNo: Integer;
        HttpClient: HttpClient;
        HttpResponse: HttpResponseMessage;
        WebhookUrl: Text;
        ServiceResult: Text;
        Success: Boolean;
        ReferenceId: Text[35];
    begin
        // Current Unix timestamp
        PaymentTranLine.Reset;
        PaymentTranLine.SetRange("Batch Number", PaymentTranHdr."Batch Number");
        //PaymentTranLine.SetFilter("Status Description", '%1', 'Pending Status');
        if PaymentTranLine.FindFirst() then begin
            repeat
                ClientRefArray.Add(PaymentTranLine."Reference Number");
            until PaymentTranLine.Next() = 0;
        end;
        PmtTranSetup.Get();
        Timestamp := ToUnixTimestamp(Format(CurrentDateTime()));
        //Root SCB Payload
        // ---- Inner "payload" object ----
        // <-- Add more if you wantREN00060301
        //ClientRefArray.Add('REN00060303');
        // Convert to text
        WebhookUrl := PmtTranSetup."Update Schedule URL";
        ClientRefArray.WriteTo(ResultJson);
        HttpContent.WriteFrom(ResultJson);
        HttpContent.GetHeaders(Headers);
        //Message(ResultJson);
        Headers.Clear();
        Headers.Add('Content-Type', 'application/json');
        // 🔹 Send POST request
        if HttpClient.Post(WebhookUrl, HttpContent, HttpResponse) then begin
            HttpResponse.Content().ReadAs(ServiceResult);
            //Message('Webhook POST succeeded:\%1', ServiceResult);
            //ServiceResult := '{"status":true,"data":"¦ùä-GWÀÒâ44dier\":\"PSC000004\",\"internalTrackingId\":\"48a549de-7b03-4b54-be9f-be9fd36c1156\",\"clientReferenceId\":\"PSC000004\",\"referenceId\":\"PSC000004\",\"statusString\":\"Pending\",\"timestamp\":\"2025-11-29T15:43:32.294Z\"}"}';
            //DecodeSCBData(ServiceResult);
            ServiceResult := DelChr(ServiceResult, '=', '\');
            //Message(ServiceResult);
            ServiceResult := ServiceResult.Replace('"{', '{');
            ServiceResult := ServiceResult.Replace('}"', '}');

            //Message(ServiceResult);
            JsonResponseObj.ReadFrom(ServiceResult);
            if JsonResponseObj.Get('status', MyJsonToken) then
                if not MyJsonToken.AsValue().IsNull then
                    Success := MyJsonToken.AsValue().AsBoolean();
        end else
            Error('Failed to send webhook payload to %1', WebhookUrl);
        PaymentTranHdr."Date Submitted" := CurrentDateTime;

        if Success then begin
            PaymentTranHdr."Submission Response Code" := 'REQUEST ACCEPTED';
            PaymentTranHdr."Create Schedule Status" := 'REQUEST ACCEPTED';
            PaymentTranHdr."Date Submitted" := CurrentDateTime;
            PaymentTranHdr."Submitted by" := Format(UserId);
            PaymentTranHdr.Submitted := Success;
            // if JsonResponseObj.Get('data', MyJsonToken) then
            //     ServiceResult := MyJsonToken.AsValue().AsText();
            // JsonResponseObj.ReadFrom(ServiceResult);
            if JsonResponseObj.Get('data', MyJsonToken) then
                JsonResponseObj := MyJsonToken.AsObject();
            if JsonResponseObj.Get('statuses', MyJsonToken) then
                MyArray := MyJsonToken.AsArray();

            //PaymentTranHdr."Check Status Response" := MyJsonToken.AsValue().AsText();
            foreach MyJsonToken in MyArray do begin
                JsonResponseObj := MyJsonToken.AsObject();
                if JsonResponseObj.Get('referenceId', MyJsonToken) then
                    if not MyJsonToken.AsValue().IsNull then
                        ReferenceId := MyJsonToken.AsValue().AsText();
                PaymentTranLine.Reset();
                PaymentTranLine.SetRange("Batch Number", PaymentTranHdr."Batch Number");
                PaymentTranLine.SetRange("Reference Number", ReferenceId);
                PaymentTranLine.FindFirst();
                if JsonResponseObj.Get('statusCode', MyJsonToken) then
                    if not MyJsonToken.AsValue().IsNull then
                        PaymentTranLine."Uploaded Status Code" := MyJsonToken.AsValue().AsText();
                if JsonResponseObj.Get('reasonCode', MyJsonToken) then
                    if not MyJsonToken.AsValue().IsNull then
                        PaymentTranLine."Reason Code" := MyJsonToken.AsValue().AsText();
                if JsonResponseObj.Get('reasonInformation', MyJsonToken) then
                    if not MyJsonToken.AsValue().IsNull then
                        PaymentTranLine."Reason Information Text" := MyJsonToken.AsValue().AsText();
                //statusString
                if JsonResponseObj.Get('statusString', MyJsonToken) then
                    if not MyJsonToken.AsValue().IsNull then
                        PaymentTranLine."Status Description" := MyJsonToken.AsValue().AsText();
                //PaymentTranHdr."Check Status Response" := MyJsonToken.AsValue().AsText();

                PaymentTranLine.Modify();
            end;
            Message('Batch updated');
        end;
    end;

    // local procedure CallPaymentWebService(BaseUrl: Text; RestMethod: Text; var HttpContent: HttpContent; var HttpResponseMessage: HttpResponseMessage; Bearer: Text)
    // var
    //     HttpClient: HttpClient;
    //     HttpRequestMessage: HttpRequestMessage;
    //     myHttpRequestMessage: HttpRequestMessage;
    //     ContentHeaders: HttpHeaders;
    //     HttpClientHandler: Codeunit "Http Client Handler";
    //     RestClient: Codeunit "Rest Client";
    //     json: Text;
    //     JsonArray: JsonArray;
    //     myContent: HttpContent;
    // begin
    //     HttpClient.SetBaseAddress(BaseUrl);
    //     case RestMethod of
    //         'GET':
    //             begin
    //                 myHttpRequestMessage.Method := RestMethod;
    //                 HttpClient.DefaultRequestHeaders.Add('api-key', Bearer);
    //                 HttpClient.DefaultRequestHeaders.Add('Accept', 'application/json');
    //                 HttpClient.Send(myHttpRequestMessage, HttpResponseMessage);
    //             end;
    //         'POST':
    //             begin
    //                 HttpContent.GetHeaders(ContentHeaders);
    //                 if ContentHeaders.Contains('Content-Type') then ContentHeaders.Remove('Content-Type');
    //                 ContentHeaders.Add('Content-Type', 'text/plain');
    //                 HttpContent.GetHeaders(ContentHeaders);
    //                 HttpClient.DefaultRequestHeaders.Add('Routing-Identifier', 'IN');
    //                 //HttpClient.DefaultRequestHeaders.Add('Accept', 'application/json');
    //                 HttpClient.Post('', HttpContent, HttpResponseMessage);


    //             end;
    //         'PUT':
    //             HttpClient.Put('', HttpContent, HttpResponseMessage);
    //         'DELETE':
    //             HttpClient.Delete('', HttpResponseMessage);
    //     end;
    // end;


    procedure ToUnixTimestamp(IsoString: Text): BigInteger
    var
        DT: DateTime;
        UnixEpoch: DateTime;
        MilliSeconds: Duration;
    begin
        // Convert ISO string to DateTime
        Evaluate(DT, IsoString);

        // Unix epoch: 1970-01-01T00:00:00Z
        UnixEpoch := CreateDateTime(19700101D, 000000T);

        // Duration between timestamp and epoch
        MilliSeconds := DT - UnixEpoch;

        // Convert from milliseconds → seconds
        exit(Round(MilliSeconds / 1000, 1, '='));
    end;


    // procedure DecodeSCBData(DataEncoded: Text): Text
    // var
    //     Base64: Codeunit "Base64 Convert";
    //     Bytes: List of [Byte];
    //     DecodedText: Text;
    // begin
    //     // Convert Base64 string into bytes
    //     DecodedText := Base64.FromBase64(DataEncoded);

    //     // Convert bytes into UTF-8 string
    //     //DecodedText := Base64.ToText(Bytes);
    //     Message(DataEncoded);
    //     exit(DecodedText);
    // end;

}