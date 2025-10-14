// SCBHttpClient.js
function SendRequest(url, method, body, routingIdentifier) {
    fetch(url, {
        method: method,
        headers: {
            "Routing-Identifier": routingIdentifier,
            "Content-Type": "text/plain"
        },
        body: body
    })
    .then(response => response.text())
    .then(text => {
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("OnResponse", [text]);
    })
    .catch(err => {
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("OnResponse", ["ERROR: " + err.message]);
    });
}

// Alternative: Keep your original structure but ensure it's properly exposed
window.SCBHttpClient = {
    SendRequest: function (url, method, body, routingIdentifier) {
        fetch(url, {
            method: method,
            headers: {
                "Routing-Identifier": routingIdentifier,
                "Content-Type": "text/plain"
            },
            body: body
        })
        .then(response => response.text())
        .then(text => {
            Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("OnResponse", [text]);
        })
        .catch(err => {
            Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("OnResponse", ["ERROR: " + err.message]);
        });
    }
};