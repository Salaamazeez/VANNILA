Codeunit 90211 "Post E-Payment"
{
    TableNo = "Payment Window Header";

    trigger OnRun()
    var
        EPaymentLine: Record "Payment Window Line";
        PostedEPayHeader: Record "Posted Payment Trans Hdr";
        PostedEPayLine: Record "Posted Payment Trans Line";

    begin

        if not Confirm(PostingTxt, false) then
            exit;
        EPaymentHeader.Get(Rec."Batch Number");
        Rec.TestField(Status, Rec.Status::Approved);
        Rec.TestField("Date Submitted");
        if EPaymentHeader."API Platform" = EPaymentHeader."API Platform"::SCB then
            Rec.TestField("Process Completed");
        EPaymentLine.SetRange("Batch Number", Rec."Batch Number");
        EPaymentLine.FindSet();
        repeat
            CreateEntryBuffer(EPaymentLine);
        until EPaymentLine.Next() = 0;
        PostEpayment();
        EPaymentLine.Find('-');
        repeat
            PostedEPayLine.TransferFields(EPaymentLine);
            PostedEPayLine.Posted := true;
            PostedEPayLine.Insert();
        until EPaymentLine.Next() = 0;
        PostedEPayHeader.TransferFields(Rec);
        PostedEPayHeader.Processed := 1;
        PostedEPayHeader.Insert();
        EPaymentLine.DeleteAll();
        Rec.Delete()
    end;

    var
        EPaymentHeader: Record "Payment Window Header";
        EntryAmountBuffer: array[2] of Record "Entry No. Amount Buffer" temporary;
        PostingTxt: label 'Do you want to post the E-Payment?';

    procedure CreateEntryBuffer(EPaymentLine: Record "Payment Window Line")
    begin
        EntryAmountBuffer[1]."Business Unit Code" := EPaymentLine."Source No.";
        EntryAmountBuffer[1]."Entry No." := 0;
        EntryAmountBuffer[1]."Record ID" := EPaymentLine."Record ID";
        EntryAmountBuffer[2] := EntryAmountBuffer[1];
        if EntryAmountBuffer[2].Find() then
            EntryAmountBuffer[2].Modify()
        else
            EntryAmountBuffer[2].Insert();
    end;

    procedure PostEpayment()
    var
        GenJnlLine: Record "Gen. Journal Line";
        RecdRef: RecordRef;
    begin
        EntryAmountBuffer[1].FindSet();
        RecdRef.Open(Database::"Gen. Journal Line");
        repeat
            if RecdRef.Get(EntryAmountBuffer[1]."Record ID") then begin
                RecdRef.SetTable(GenJnlLine);
                GenJnlLine."Posting Date" := Dt2Date(EPaymentHeader."Date Submitted");
                PostPaymentJournal(GenJnlLine);
                UpdateScheduleLineToPaid(GenJnlLine)
            end;
        until EntryAmountBuffer[1].Next() = 0;
        RecdRef.Close()

    end;

    procedure PostPVEpayment()
    var
        PaymentHeader: Record "Payment Voucher Header";
        GenJnlLine: Record "Gen. Journal Line";
        RecdRef: RecordRef;
        //PaymentPost: Codeunit "Payment Post (Yes/No)";
    begin
        EntryAmountBuffer[1].FindSet;
        RecdRef.Open(Database::"Payment Voucher Header");
        repeat
            if RecdRef.Get(EntryAmountBuffer[1]."Record ID") then begin
                RecdRef.SetTable(PaymentHeader);
                PaymentHeader."Date" := Dt2Date(EPaymentHeader."Date Submitted");
                /*//This is for public sector am yet to add the payment type to  standard payment header
                IF PaymentHeader."Payment Type" = PaymentHeader."Payment Type"::Remittance THEN
                  CreateRemittanceGenJnln(PaymentHeader);
                */
                UpdatePVScheduleLineToPaid(PaymentHeader);
                PaymentHeader.PostPayment();
                //PaymentPost.Run(PaymentHeader);

            end;
        until EntryAmountBuffer[1].Next = 0;
        RecdRef.Close

    end;

    procedure UpdateScheduleLineToPaid(GenJournalLine: Record "Gen. Journal Line")
    var
        PaymentSchedule: Record "Payment Schedule";
    begin
        PaymentSchedule.SetRange(PaymentSchedule."Source Document No.", GenJournalLine."Document No.");
        if PaymentSchedule.FindSet() then
            repeat
                PaymentSchedule.Paid := true;
                PaymentSchedule.Modify();
            until PaymentSchedule.Next() = 0;

    end;

    procedure UpdatePVScheduleLineToPaid(PaymentVoucher: Record "Payment Voucher Header")
    var
        PaymentSchedule: Record "Payment Schedule";
    begin
        PaymentSchedule.SetRange(PaymentSchedule."Source Document No.", PaymentVoucher."No.");
        if PaymentSchedule.FindSet then begin
            repeat
                PaymentSchedule.Paid := true;
                PaymentSchedule.Modify;
            until PaymentSchedule.Next = 0;
        end;
    end;

    procedure PostPaymentJournal(var GeneralJournalLine: Record "Gen. Journal Line")
    var
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
    begin
        GenJnlPostLine.RunWithCheck(GeneralJournalLine);
        GeneralJournalLine.Delete()
    end;
}


