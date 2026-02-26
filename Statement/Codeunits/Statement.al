codeunit 50105 "Statement"
{
    procedure GetStatement(StmtDate: Date)
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        JsonTxt: Text;
        JsonObject, DataObj, DocObj, BkObj, StmtObj : JsonObject;
        JsonToken, JsonToken1, JsonToken2, JsonToken3 : JsonToken;
        BaseUrl: Text[300];
        Statement: Record "Bank Statement";
        Setup: Record "Statement Setup";
        Id: Text[100];
    begin
        Setup.Get();
        BaseUrl := Setup."Base URL" + '?date=' + Format(StmtDate, 0, '<Year4>-<Month,2>-<Day,2>');
        Request.Method := 'GET';
        Request.SetRequestUri(BaseUrl);
        if Client.Send(Request, Response) then begin
            Response.Content.ReadAs(JsonTxt);
            JsonObject.ReadFrom(JsonTxt);

            if Response.IsSuccessStatusCode() then begin
                if JsonObject.Get('data', JsonToken) then
                    DataObj := JsonToken.AsObject();
                DataObj.Get('Document', JsonToken);
                DocObj := JsonToken.AsObject();
                DocObj.Get('BkToCstmrStmt', JsonToken);
                BkObj := JsonToken.AsObject();
                BkObj.Get('Stmt', JsonToken);
                StmtObj := JsonToken.AsObject();
                StmtObj.Get('Id', JsonToken);
                Id := JsonToken.AsValue().AsText();
                if not Statement.Get(Id) then begin
                    Statement.Init();
                    Statement."Statement Id" := JsonToken.AsValue().AsText();
                    if StmtObj.Get('ElctrncSeqNb', JsonToken) then
                        Statement."Electronic Seq. No." := JsonToken.AsValue().AsInteger();
                    if StmtObj.Get('CreDtTm', JsonToken) then
                        Statement."Created DateTime" := JsonToken.AsValue().AsDateTime();
                    if StmtObj.Get('FrToDt', JsonToken) then begin
                        JsonToken.AsObject().Get('FrDtTm', JsonToken1);
                        Statement."From Date" := DT2Date(JsonToken1.AsValue().AsDateTime());
                        JsonToken.AsObject().Get('ToDtTm', JsonToken1);
                        Statement."To Date" := DT2Date(JsonToken1.AsValue().AsDateTime());
                    end;
                    if StmtObj.Get('Acct', JsonToken) then begin
                        JsonToken.AsObject().Get('Nm', JsonToken1);
                        Statement."Account Name" := JsonToken1.AsValue().AsText();
                        JsonToken.AsObject().Get('Ccy', JsonToken1);
                        Statement."Currency Code" := JsonToken1.AsValue().AsText();
                        JsonToken.AsObject().Get('Id', JsonToken1);
                        JsonToken1.AsObject().Get('Othr', JsonToken2);
                        JsonToken2.AsObject().Get('Id', JsonToken3);
                        Statement."Account No." := JsonToken3.AsValue().AsCode();
                    end;



                    // if StmtObj.Get('TxsSummry', JsonToken) then begin
                    //     JsonToken.AsObject().Get('TtlNtries', JsonToken1);

                    //     JsonToken.AsObject().Get('NbOfNtries', JsonToken1);
                    //     Statement."Total Entries" := JsonToken1.AsValue().AsInteger();
                    //     JsonToken.AsObject().Get('Sum', JsonToken1);
                    //     Statement."Total Amount" := JsonToken1.AsValue().AsDecimal();
                    //     JsonToken.AsObject().Get('TtlNetNtryAmt', JsonToken1);
                    //     Statement."Net Amount" := JsonToken1.AsValue().AsDecimal();
                    //     JsonToken.AsObject().Get('CdtDbtInd', JsonToken1);
                    //     Statement."Credit/Debit" := JsonToken1.AsValue().AsText();
                    // end;

                    if StmtObj.Get('TxsSummry', JsonToken) then begin
                        if JsonToken.AsObject().Get('TtlNtries', JsonToken1) then begin
                            JsonToken1.AsObject().Get('NbOfNtries', JsonToken2);
                            Statement."Total Entries" := JsonToken2.AsValue().AsInteger();

                            JsonToken1.AsObject().Get('Sum', JsonToken2);
                            Statement."Total Amount" := JsonToken2.AsValue().AsDecimal();

                            JsonToken1.AsObject().Get('TtlNetNtryAmt', JsonToken2);
                            Statement."Net Amount" := JsonToken2.AsValue().AsDecimal();

                            JsonToken1.AsObject().Get('CdtDbtInd', JsonToken2);
                            Statement."Credit/Debit" := JsonToken2.AsValue().AsText();
                        end;
                    end;

                    Statement.Insert(true);
                end;
            end;
        end;
    end;
}

