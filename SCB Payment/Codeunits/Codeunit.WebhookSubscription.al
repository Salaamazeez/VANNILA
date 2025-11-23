// codeunit 50120 "Send BC Webhook Payload"
// {
//     trigger OnRun()
//     var
//         HttpClient: HttpClient;
//         HttpContent: HttpContent;
//         HttpResponse: HttpResponseMessage;
//         Headers: HttpHeaders;
//         WebhookUrl: Text;
//         JsonBody: Text;
//         ResponseText: Text;
//     begin
//         WebhookUrl := 'https://sbcware.azurewebsites.net/api/BCWebhook';

//         // 🔹 Construct JSON body exactly like your sample
//         //JsonBody :='{ "iat": "2025-10-26T21:38:47.2360000Z", "exp": "2025-10-26T21:39:17.2360000Z", "aud": "CLIENT", "jti": "8E524C23-20DD-41FD-8134-B892E95A11FB", "iss": "SCB", "payload": { "header": { "messageSender": "DEMO", "messageId": "9D3D0047-27BE-484A-8240-440551193440", "countryCode": "NG", "timestamp": "2025-10-26T21:38:47.2360000Z" }, "instruction": { "paymentTimestamp": "2025-10-26T21:38:47.2360000Z", "requiredExecutionDate": "2025-10-26", "amount": { "currencyCode": "NG", "amount": 5000 }, "referenceId": "PSC000001", "paymentType": " ", "debtor": { "name": "REONL SCB NIG USD A/C (Main)" }, "debtorAccount": { "id": "0227809123", "identifierType": "" }, "debtorAgent": { "financialInstitution": { "postalAddress": { "country": "NG" }, "name": "", "BIC": "" } }, "creditor": { "name": "Descasio Nig Ltd" }, "creditorAgent": { "financialInstitution": { "name": "Descasio Nig Ltd", "BIC": "" }, "branchCode": "", "clearingSystemId": "" }, "creditorAccount": { "id": "01167865439", "identifierType": "" }, "remittanceInfo": { "multiUnstructured": [ "Payment for vendor" ] } } } }'       ;
//         JsonBody := '{"header":{"messageSender":"DEMO","messageId":"7B6112BF-8153-49D2-9A27-D4797E99C0AB","countryCode":"NG","timestamp":"2025-10-29T17:08:58.7890000Z"},"instruction":{"paymentTimestamp":"2025-10-29T17:08:58.7890000Z","requiredExecutionDate":"2025-10-29","amount":{"currencyCode":"NG","amount":5000.0},"referenceId":"PSC000001","paymentType":" ","debtor":{"name":"REONL SCB NIG USD A/C (Main)"},"debtorAccount":{"id":"0227809123","identifierType":""},"debtorAgent":{"financialInstitution":{"postalAddress":{"country":"NG"},"name":"REONL SCB NIG USD A/C (Main)","BIC":""}},"creditor":{"name":"Descasio Nig Ltd"},"creditorAgent":{"financialInstitution":{"name":"Descasio Nig Ltd","BIC":""},"branchCode":"","clearingSystemId":""},"creditorAccount":{"id":"01167865439","identifierType":""},"remittanceInfo":{"multiUnstructured":["Payment for vendor"]}}}';
//         Message(JsonBody);
//         // 🔹 Set content and headers
//         HttpContent.WriteFrom(JsonBody);
//         HttpContent.GetHeaders(Headers);
//         Headers.Clear();
//         Headers.Add('Content-Type', 'application/json');

//         // 🔹 Send POST request
//         if HttpClient.Post(WebhookUrl, HttpContent, HttpResponse) then begin
//             HttpResponse.Content().ReadAs(ResponseText);
//             Message('Webhook POST succeeded:\%1', ResponseText);
//         end else
//             Error('Failed to send webhook payload to %1', WebhookUrl);
//     end;
// }
