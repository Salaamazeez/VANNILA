window.SCBHttpClient = {
    SendRequest: async function (url, method, body, routingIdentifier) {
        try {
            const response = await fetch(url, {
                method: method,
                headers: {
                    "Routing-Identifier": routingIdentifier,
                    "Content-Type": "text/plain"
                },
                body: body
            });

            const text = await response.text();
            Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("OnResponse", [text]);
        } catch (err) {
            Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("OnResponse", ["ERROR: " + err.message]);
        }
    }
};
