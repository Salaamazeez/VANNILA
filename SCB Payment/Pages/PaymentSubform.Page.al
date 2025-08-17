Page 90241 "Payment Subform"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Payment Window Line";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(SourceNo; Rec."Source No.")
                {
                    ApplicationArea = All;
                }
                field(SourceType; Rec."Source Type")
                {
                    ApplicationArea = All;
                }
                field(ReferenceType; Rec."Reference Type")
                {
                    ApplicationArea = All;
                }
                field(ReferenceNumber; Rec."Reference Number")
                {
                    ApplicationArea = All;
                }
                field(BankCBNCode; Rec."Bank CBN Code")
                {
                    ApplicationArea = All;
                }
                field(PayeeNo; Rec."Payee No.")
                {
                    ApplicationArea = All;
                }
                field(BankName; Rec."Bank Name")
                {
                    ApplicationArea = All;
                }
                field(Payee; Rec.Payee)
                {
                    ApplicationArea = All;
                }
                field(ToAccountNumber; Rec."To Account Number")
                {
                    ApplicationArea = All;
                }
                field(PayeeBVN; Rec."Payee BVN")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(ReasonCode; Rec."Reason Code")
                {
                    ApplicationArea = All;
                }
                field(UploadedStatusText; Rec."Uploaded Status Text")
                {
                    ApplicationArea = All;
                }
                field(UploadedStatusCode; Rec."Uploaded Status Code")
                {
                    ApplicationArea = All;
                }
                field(NIBSSStatus; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field(NIBSSStatusDescription; Rec."Status Description")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    // trigger OnDeleteRecord(): Boolean
    // var
    //     FindGenJnl: Boolean;
    //     PaymentLine: Record "Payment Window Line";
    //     FindCashLine: Boolean;
    // begin
    //     PaymentLine := Rec;
    //     PaymentLine.SetRecFilter();
    //     PaymentLine.TestStatusOpen;
    //     TransHeader.Get(PaymentLine."Batch Number");
    //     if TransHeader.Submitted then
    //         Error(Txt002, TransHeader."Batch Number");
    //     GeneralJournalLine.Reset();
    //     GeneralJournalLine.SetRange("Document Type", GeneralJournalLine."document type"::Payment);
    //     GeneralJournalLine.SetRange("Document No.", PaymentLine."Source No.");
    //     GeneralJournalLine.SetRange("Account No.", PaymentLine."Payee No.");
    //     FindGenJnl := GeneralJournalLine.FindFirst();
    //     if not FindGenJnl then begin
    //         GeneralJournalLine.Reset();
    //         GeneralJournalLine.SetRange("Document Type", GeneralJournalLine."document type"::Payment);
    //         GeneralJournalLine.SetRange("Document No.", PaymentLine."Source No.");
    //         if GeneralJournalLine.FindFirst() then begin
    //             //Commit();
    //             PaymentTransLines.SetRange("Source No.", GeneralJournalLine."Document No.");
    //             FindCashLine := PaymentTransLines.FindFirst();
    //             if FindCashLine then begin
    //                 GeneralJournalLine."Payment ID" := '';
    //                 GeneralJournalLine.Modify();
    //                 PaymentTransLines.DeleteAll();
    //             end;
    //         end;
    //     end;
    //     if not FindCashLine then begin
    //         PaymentTransLines.Reset();
    //         PaymentTransLines.SetRange("Source No.", GeneralJournalLine."Document No.");
    //         if PaymentTransLines.FindFirst() then begin
    //             GeneralJournalLine.Reset();
    //             GeneralJournalLine.SetRange("Document Type", GeneralJournalLine."document type"::Payment);
    //             GeneralJournalLine.SetRange("Document No.", Rec."Source No.");
    //             GeneralJournalLine."Payment ID" := '';
    //             GeneralJournalLine.Modify();
    //         end;
    //     end;
    // end;
    //end;

    // trigger OnDeleteRecord2(): Boolean
    // begin
    //     Rec.TestStatusOpen;
    //     TransHeader.Get(Rec."Batch Number");
    //     if TransHeader.Submitted then
    //         Error(Txt002, TransHeader."Batch Number");
    //     if GeneralJournalLine.Get(GeneralJournalLine."document type"::Payment, GeneralJournalLine."Source No.") then begin
    //         GeneralJournalLine."Payment ID" := '';
    //         GeneralJournalLine.Modify();
    //         PaymentTransLines.SetRange("Source No.", GeneralJournalLine."Source No.");
    //         PaymentTransLines.DeleteAll();
    //     end;
    // end;

    trigger OnModifyRecord(): Boolean
    begin
        Rec.TestField("Source Type", Rec."source type"::Import);
    end;

    // var
    //     Txt002: label 'Batch Number %1 already submitted, Transaction cannot be deleted';
    //     TransHeader: Record "Payment Window Header";
    //     GeneralJournalLine: Record "Gen. Journal Line";
    //     PaymentTransLines: Record "Payment Window Line";
}

