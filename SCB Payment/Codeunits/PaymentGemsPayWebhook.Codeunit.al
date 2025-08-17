#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
codeunit 90209 "Payment-_Webhook"
{

    trigger OnRun()
    begin
    end;

    var

        BankAccount: Record "Bank Account";
        PmtTranSetup: Record "Payment Trans Setup";
        PaymentHdr: Record "Payment Window Header";
        PaymentLine: Record "Payment Window Line";
        PostEPayment: Codeunit "Post E-Payment";
        MyArray: JsonArray;
        BeneficiariesResult: Text;
        ValidBeneficiaries: Text[150];
        scheduleIdvar: Text[150];
        success: Boolean;
        ErrorMsg: Text[20];
        ExtScheduleId: Code[20];


    procedure CallbackURL(eventName: Text[100]; scheduleId: Text[100]; paymentReference: Text[100]; createdOn: Text[100]; status: Text[50]; merchantId: Text[100]; beneficiaries: Text; externalScheduleId: Code[20]; ProcessCompleted: Boolean): Text
    var
        JToken: JsonToken;
        JTokenWriter: JsonToken;
        JObject2: JsonObject;
        JsonArray: JsonArray;
        MyJObject: JsonObject;
        LineNo: Integer;
        chargeAmount: Decimal;
        MyJsonToken: JsonToken;
        JsonObject: JsonObject;
        MyJsonToken2: JsonToken;
        BeneficiaryTxt: Label 'Schedule Id does not exist', Comment = '%1';
        ValidBeneficiariesTxt: Label 'Schedule successfully updated', Comment = '%1';
    begin
        PmtTranSetup.Get();
        success := false;
        ExtScheduleId := externalScheduleId;
        scheduleIdvar := scheduleId;
        ValidBeneficiaries := StrSubstNo(BeneficiaryTxt);
        PaymentHdr.Reset;
        PaymentHdr.SetRange(PaymentHdr."Batch Number", ExtScheduleId);
        if not PaymentHdr.FindFirst() then begin
            exit(ReturnPaymentData);
        end;
        PaymentHdr."Payment Reference" := paymentReference;
        PaymentHdr."Check Status Response" := status;
        PaymentHdr."Process Completed" := ProcessCompleted;
        MyArray.ReadFrom(beneficiaries);
        PaymentHdr.Modify();
        foreach MyJsonToken2 in MyArray do begin
            MyJObject := MyJsonToken2.AsObject();
            MyJObject.Get('isPaymentChargeLine', MyJsonToken2);
            if UpperCase(MyJsonToken2.AsValue().AsText()) = 'FALSE' then begin
                MyJObject.Get('externalLineId', MyJsonToken2);
                Evaluate(LineNo, MyJsonToken2.AsValue().AsText());
                PaymentLine.Reset();
                PaymentLine.SetRange("Batch Number", PaymentHdr."Batch Number");
                PaymentLine.SetRange("Line No.", LineNo);
                if PaymentLine.FindFirst() then begin
                    MyJObject.Get('status', MyJsonToken2);
                    PaymentLine.Status := Format(MyJsonToken2.AsValue().AsText());
                    MyJObject.Get('statusDescription', MyJsonToken2);
                    if not MyJsonToken2.AsValue().IsNull then
                        PaymentLine."Status Description" := Format(MyJsonToken2.AsValue().AsText());
                    MyJObject.Get('chargeAmount', MyJsonToken2);
                    Evaluate(chargeAmount, MyJsonToken2.AsValue().AsText());
                    PaymentLine."Line Charge Amount" := chargeAmount;
                    MyJObject.Get('paymentSuccessful', MyJsonToken2);
                    PaymentLine."Payment Successful" := UpperCase(MyJsonToken2.AsValue().AsText()) = 'TRUE';
                    MyJObject.Get('paymentProcessingRef', MyJsonToken2);
                    if not MyJsonToken2.AsValue().IsNull then
                        PaymentLine."External Document No." := Format(MyJsonToken2.AsValue().AsText());
                    PaymentLine.Modify();
                    ValidBeneficiaries := StrSubstNo(ValidBeneficiariesTxt);
                    success := true;
                end;
            end else
                if PmtTranSetup."Charges Auto Post" then
                    UpdateBankCharges(MyJObject, PaymentHdr);
        end;
        if PmtTranSetup."Payment Auto Post" then begin
            PaymentHdr.SetRecfilter;
            PostEPayment.Run(PaymentHdr);
        end;
        exit(ReturnPaymentData);
    end;


    local procedure ReturnPaymentData(): Text
    var
        JObject: JsonObject;
        JToken: JsonToken;
        json: Text;
    begin
        JObject.Add('message', ValidBeneficiaries);
        JObject.Add('scheduleId', scheduleIdvar);
        JObject.Add('success', success);
        JObject.WriteTo(json);
        exit(json)
    end;

    procedure GetBankAccBalance(cbnBankCode: Text[100]; accountNumber: Text[50]): Text
    var
        Text001Lbl: label 'valid bank account';
        Text002Lbl: label 'invalid bank account';
    begin
        success := false;
        BankAccount.Reset();
        BankAccount.SetRange("Bank Account No.", accountNumber);
        BankAccount.SetRange("Bank Code", cbnBankCode);
        if BankAccount.FindFirst() then begin
            success := true;
            ErrorMsg := Text001Lbl;
            BankAccount.CalcFields(Balance);
            exit(ReturnBankBalData);
        end;
        success := false;
        ErrorMsg := Text002Lbl;
        exit(ReturnBankBalData())
    end;

    local procedure ReturnBankBalData(): Text
    var
        JToken: JsonToken;
        JObject: JsonObject;
        json: Text;
    begin
        JObject.Add('success', success);
        JObject.Add('message', ErrorMsg);
        JObject.Add('balance', BankAccount.Balance);
        JObject.WriteTo(json);
        exit(json)
    end;

    local procedure UpdateBankCharges(MyJObject: JsonObject; PaymentHdr: Record "Payment Window Header")
    var
        PaymentLine2: Record "Payment Window Line";
        NextLineNo: Integer;
        Amount: Decimal;
        PaymentNotification: Record "Payment Trans Notification";
        JsonToken: JsonToken;
    begin
        PaymentNotification.Init();
        PaymentNotification."Batch Number" := PaymentHdr."Batch Number";
        PaymentNotification."Schedule Id" := PaymentHdr."Schedule Id";
        PaymentNotification."Created On" := Format(Today);
        MyJObject.get('amount', JsonToken);
        Evaluate(Amount, JsonToken.AsValue().AsText());
        PaymentNotification.Amount := Amount;
        MyJObject.get('narration', JsonToken);
        PaymentNotification.Narration := JsonToken.AsValue().AsText();
        ;
        PaymentNotification."Debit Account" := PaymentHdr."Bank Account Code";
        MyJObject.get('status', JsonToken);
        PaymentNotification.Status := JsonToken.AsValue().AsText();
        MyJObject.get('statusDescription', JsonToken);
        PaymentNotification."Transaction Status" := JsonToken.AsValue().AsText();
        MyJObject.get('paymentSuccessful', JsonToken);
        PaymentNotification."Payment Successful" := UpperCase(JsonToken.AsValue().AsText()) = 'TRUE';
        MyJObject.get('paymentProcessingRef', JsonToken);
        PaymentNotification."External Document No." := JsonToken.AsValue().AsText();
        if not PaymentNotification.Insert() then
            PaymentNotification.Modify();
        PostBankCharges(PaymentNotification)
    end;

    procedure PostBankCharges(PaymentTransNotification: Record "Payment Trans Notification")
    var
        GeneralJournalLine: Record "Gen. Journal Line";
        GeneralJournalPosting: Codeunit "Gen. Jnl.-Post Line";
    begin
        PmtTranSetup.Get();
        //create journal for the charges
        GeneralJournalLine.Init();
        GeneralJournalLine."Document No." := '';
        GeneralJournalLine."Document Type" := GeneralJournalLine."document type"::Payment;
        GeneralJournalLine."Account Type" := GeneralJournalLine."Account Type"::"G/L Account";
        GeneralJournalLine.Validate("Account No.", PmtTranSetup."Charges Account");
        GeneralJournalLine.Description := PaymentTransNotification.Narration;
        GeneralJournalLine."Payment Method Code" := 'OKTOPUS';
        GeneralJournalLine.Validate(Amount, PaymentTransNotification.Amount);
        GeneralJournalLine."Bal. Account Type" := GeneralJournalLine."Bal. Account Type"::"Bank Account";
        GeneralJournalLine.Validate("Bal. Account No.", PaymentHdr."Bank Account Code");
        GeneralJournalLine."External Document No." := PaymentTransNotification."External Document No.";
        GeneralJournalLine.Validate("Shortcut Dimension 1 Code", PaymentHdr."Global Dimension 1 Code");
        PaymentTransNotification."Posting Status" := true;
        PaymentTransNotification.Modify();
        GeneralJournalPosting.RunWithCheck(GeneralJournalLine)
    end;
}

