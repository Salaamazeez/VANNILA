page 50100 "SCB Http Helper"
{
    PageType = CardPart;
    ApplicationArea = All;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            usercontrol(SCBHttpClient; "SCB HTTP Client")
            {
                ApplicationArea = All;

                trigger OnResponse(response: Text)
                begin
                    HandleSCBResponse(response);
                end;
            }
        }
    }

    procedure DoSendRequest(url: Text; method: Text; body: Text; routingIdentifier: Text)
    begin
        CurrPage.SCBHttpClient.SendRequest(url, method, body, routingIdentifier);
    end;
    local procedure HandleSCBResponse(response: Text)
    begin
        if response.StartsWith('ERROR:') then
            Message('HTTP Request failed: %1', response)
        else
            Message('SCB Response: %1', response);

        // Raise integration event so codeunit can subscribe
        OnResponseReceived(response);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnResponseReceived(response: Text);
    begin
    end;
}
