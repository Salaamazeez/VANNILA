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

        CreditorObj: JsonObject;
        CreditorAgentObj: JsonObject;
        CreditorFinInstObj: JsonObject;
        CreditorAccountObj: JsonObject;

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
    begin
        Success := false;
        CompanyInfo.Get();
        Window.Open('Progressing.....');
        PmtTranSetup.Get();
        if PaymentTranHdr."API Platform" = PaymentTranHdr."API Platform"::SCB then begin
            // Validate debit account
            //===== Root claims =====
            RootObj.Add('iat', CurrentDateTime());
            RootObj.Add('exp', CurrentDateTime() + 30000);
            RootObj.Add('aud', 'CLIENT');
            RootObj.Add('jti', DelChr(CreateGuid(), '=', '{}'));
            RootObj.Add('iss', 'SCB');

            // ===== Header =====
            HeaderObj.Add('messageSender', CompanyInfo.Name);
            HeaderObj.Add('messageId', DelChr(CreateGuid(), '=', '{}'));
            HeaderObj.Add('countryCode', CompanyInfo."Country/Region Code");
            HeaderObj.Add('timestamp', CurrentDateTime());

            // ===== Instruction =====
            InstructionObj.Add('paymentTimestamp', CurrentDateTime());
            InstructionObj.Add('requiredExecutionDate', Format(Today, 0, 9)); // yyyy-mm-dd
            if PaymentTranLine."Currency Code" <> '' then
                CurrCode := PaymentTranLine."Currency Code"
            else
                CurrCode := 'NG';
            // Amount
            PaymentTranLine.Reset;
            PaymentTranLine.SetRange("Batch Number", PaymentTranHdr."Batch Number");
            if PaymentTranLine.FindFirst() then begin
                AmountObj.Add('currencyCode', CurrCode);
                AmountObj.Add('amount', PaymentTranLine.Amount);
            end else begin
                if PaymentTranHdr."Currency Code" <> '' then
                    CurrCode := PaymentTranHdr."Currency Code"
                else
                    CurrCode := 'NG';
                AmountObj.Add('currencyCode', CurrCode);
                AmountObj.Add('amount', PaymentTranHdr."Total Amount");
            end;
            InstructionObj.Add('amount', AmountObj);
            InstructionObj.Add('referenceId', PaymentTranHdr."Batch Number");
            InstructionObj.Add('paymentType', Format(PaymentTranHdr."Payment Type"));

            // Debtor
            BankAccount.Get(PaymentTranHdr."Bank Account Code");
            DebtorObj.Add('name', BankAccount.Name);
            InstructionObj.Add('debtor', DebtorObj);

            // Debtor Account
            DebtorAccountObj.Add('id', BankAccount."Bank Account No.");
            DebtorAccountObj.Add('identifierType', '');//DebitAccount."Identifier Type"
            InstructionObj.Add('debtorAccount', DebtorAccountObj);

            // Debtor Agent -> Financial Institution -> Postal Address
            PostalAddressObj.Add('country', BankAccount."Country/Region Code");
            FinInstObj.Add('postalAddress', PostalAddressObj);
            FinInstObj.Add('name', BankAccount.Name);
            FinInstObj.Add('BIC', '');
            DebtorAgentObj.Add('financialInstitution', FinInstObj);
            InstructionObj.Add('debtorAgent', DebtorAgentObj);

            // Creditor (from PaymentTranLine)
            CreditorObj.Add('name', PaymentTranLine.Payee);
            InstructionObj.Add('creditor', CreditorObj);

            // Creditor Agent
            CreditorFinInstObj.Add('name', PaymentTranLine.Payee);
            CreditorFinInstObj.Add('BIC', '');
            CreditorAgentObj.Add('financialInstitution', CreditorFinInstObj);
            CreditorAgentObj.Add('branchCode', '');
            CreditorAgentObj.Add('clearingSystemId', '');
            InstructionObj.Add('creditorAgent', CreditorAgentObj);

            // Creditor Account
            CreditorAccountObj.Add('id', PaymentTranLine."To Account Number");
            CreditorAccountObj.Add('identifierType', '');
            InstructionObj.Add('creditorAccount', CreditorAccountObj);

            // Remittance Info
            MultiUnstructuredArr.Add(PaymentTranLine.Description);
            RemittanceObj.Add('multiUnstructured', MultiUnstructuredArr);
            InstructionObj.Add('remittanceInfo', RemittanceObj);

            // ===== Payload =====
            PayloadObj.Add('header', HeaderObj);
            PayloadObj.Add('instruction', InstructionObj);
            RootObj.Add('payload', PayloadObj);
            //Message(Format(PayloadObj));
            PmtTranSetup.Get;
            PayloadObj.WriteTo(json);
            //json := '{ "header": { "messageSender": "RENGAS", "messageId": "RNG8778935909761832025", "countryCode": "NG", "timestamp": 1742300390 }, "instruction":         { "paymentTimestamp": 1742296796, "requiredExecutionDate": "2025-03-18", "amount": { "currencyCode": "NGN", "amount": 60 }, "referenceId": "REN00060285", "paymentType": "ACH", "debtor": { "name": "RENGAS SCB" }, "debtorAccount": { "id": "2402126942", "identifierType": "Other" }, "debtorAgent": { "financialInstitution": { "postalAddress": { "country": "NG" }, "name": "STANDARD CHARTERED BK", "BIC": "SCBLNGLAXXX" } }, "creditor": { "name": "Test Creditor" }, "creditorAgent": { "financialInstitution": { "name": "GUARANTY TRUST BANK PLC", "BIC": "GTBINGLAXXX" }, "branchCode": "52146", "clearingSystemId": "058" }, "creditorAccount": { "id": "0242700347", "identifierType": "Other" }, "remittanceInfo": { "multiUnstructured": [ "Payment to " ] } }}';
            //Message(json);            
            //json := '{ "header": { "messageSender": "RENGAS", "messageId": "RNG8778935909761832025", "countryCode": "NG", "timestamp": 1742300390 }, "instruction":         { "paymentTimestamp": 1742296796, "requiredExecutionDate": "2025-03-18", "amount": { "currencyCode": "NGN", "amount": 60 }, "referenceId": "REN00060285", "paymentType": "ACH", "debtor": { "name": "RENGAS SCB" }, "debtorAccount": { "id": "2402126942", "identifierType": "Other" }, "debtorAgent": { "financialInstitution": { "postalAddress": { "country": "NG" }, "name": "STANDARD CHARTERED BK", "BIC": "SCBLNGLAXXX" } }, "creditor": { "name": "Test Creditor" }, "creditorAgent": { "financialInstitution": { "name": "GUARANTY TRUST BANK PLC", "BIC": "GTBINGLAXXX" }, "branchCode": "52146", "clearingSystemId": "058" }, "creditorAccount": { "id": "0242700347", "identifierType": "Other" }, "remittanceInfo": { "multiUnstructured": [ "Payment to " ] } } }';
            // ===== Convert to text and send =====
            // RootObj.WriteTo(json);
            //StringContent.WriteFrom(json);
            //BearerToken := PmtTranSetup."Secret Key";
            WebhookUrl := PmtTranSetup."Create Schedule URL";
            RequestType := 'POST';
            //CallPaymentWebService(BaseUrl, RequestType, StringContent, HttpResponseMessage, BearerToken);
            HttpContent.WriteFrom(json);
            HttpContent.GetHeaders(Headers);
            Headers.Clear();
            Headers.Add('Content-Type', 'application/json');
            // 🔹 Send POST request
            if HttpClient.Post(WebhookUrl, HttpContent, HttpResponse) then begin
                HttpResponse.Content().ReadAs(ServiceResult);
                Message('Webhook POST succeeded:\%1', ServiceResult);
                JsonResponseObj.ReadFrom(ServiceResult);
                if JsonResponseObj.Get('status', MyJsonToken) then
                    if not MyJsonToken.AsValue().IsNull then
                        Success := MyJsonToken.AsValue().AsBoolean();
            end else
                Error('Failed to send webhook payload to %1', WebhookUrl);
            // ===== Response handling =====
            JsonResponseObj.ReadFrom(ServiceResult);
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
                if JsonResponseObj.Get('statusString', MyJsonToken) then
                    if not MyJsonToken.AsValue().IsNull then
                        PaymentTranHdr."Check Status Response" := MyJsonToken.AsValue().AsText();
                Message('Schedule created!!');
                Window.Close();
                exit
            end;
        end;

        PaymentTranHdr.Modify();
        Message('No schedule created!!');
        Window.Close();
    end;


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