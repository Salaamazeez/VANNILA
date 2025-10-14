controladdin "SCB HTTP Client"
{
    RequestedHeight = 1;
    RequestedWidth = 1;
    MinimumHeight = 1;
    MinimumWidth = 1;
    VerticalStretch = false;
    VerticalShrink = false;
    HorizontalStretch = false;
    HorizontalShrink = false;

    Scripts = 'SCBHttpClient.js';
    
    procedure SendRequest(url: Text; method: Text; body: Text; routingIdentifier: Text);
    event OnResponse(response: Text);
}