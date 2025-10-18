// procedure CreateSchedule(var PaymentTranHdr: Record "Payment Schedule Header")
// var
//     PaymentTranLine: Record "Payment Schedule Line";
//     PmtTranSetup: Record "Payment Transaction Setup";
//     ResponseText: Text;
//     JsonResponseObj: JsonObject;
//     MyJsonToken: JsonToken;
//     JObject2: JsonObject;
//     MyArray: JsonArray;
//     LineNo: Integer;
//     Success: Boolean;
//     MessageText: Text;
//     Json: Text;
// begin
//     Window.Open('Progressing.....');
//     PmtTranSetup.Get();

//     if PaymentTranHdr."API Platform" = PaymentTranHdr."API Platform"::SCB then begin
//         // Build JSON payload
//         Json := '{ "header": { "messageSender": "RENGAS", "messageId": "RNG8778935909761832025", "countryCode": "NG", "timestamp": 1742300390 }, "instruction": { "paymentTimestamp": 1742296796, "requiredExecutionDate": "2025-03-18", "amount": { "currencyCode": "NGN", "amount": 60 }, "referenceId": "REN00060285", "paymentType": "ACH", "debtor": { "name": "RENGAS SCB" }, "debtorAccount": { "id": "2402126942", "identifierType": "Other" }, "debtorAgent": { "financialInstitution": { "postalAddress": { "country": "NG" }, "name": "STANDARD CHARTERED BK", "BIC": "SCBLNGLAXXX" } }, "creditor": { "name": "Test Creditor" }, "creditorAgent": { "financialInstitution": { "name": "GUARANTY TRUST BANK PLC", "BIC": "GTBINGLAXXX" }, "branchCode": "52146", "clearingSystemId": "058" }, "creditorAccount": { "id": "0242700347", "identifierType": "Other" }, "remittanceInfo": { "multiUnstructured": [ "Payment to " ] } } }';

//         // Instead of HttpClient, call JS control add-in
//         CurrPage.SCBHttpClient.SendRequest(
//             PmtTranSetup."Create Schedule URL",
//             'POST',
//             '{{assertionToken}}', // or use Json if API expects full JSON
//             'IN'
//         );
//     end;

//     Window.Close();
// end;


// local procedure CallPaymentWebService(BaseUrl: Text; RestMethod: Text; var HttpContent: HttpContent; var HttpResponseMessage: HttpResponseMessage; Bearer: Text)
// var
//     ContentHeaders: HttpHeaders;
//     BodyText: Text;
// begin
//     if BaseUrl = '' then
//         Error('BaseUrl parameter is empty');

//     case RestMethod of
//         'GET':
//             begin
//                 // For GET we could still use AL HttpClient,
//                 // or also push to JS if you want consistency
//             end;
//         'POST':
//             begin
//                 // Extract body text from HttpContent
//                 HttpContent.ReadAs(BodyText);

//                 // Instead of HttpClient.Post, call JS add-in
//                 CurrPage.SCBHttpClient.SendRequest(
//                     BaseUrl,
//                     RestMethod,
//                     BodyText,
//                     'IN' // Routing-Identifier
//                 );
//             end;
//         'PUT', 'DELETE':
//             begin
//                 // You can extend SendRequest in JS to handle these too
//                 Error('Not implemented yet in JS bridge');
//             end;
//     end;
// end;
