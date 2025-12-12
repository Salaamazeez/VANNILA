Page 90241 "Payment Subform"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Payment Schedule Line";

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
                field("Branch Code"; Rec."Branch Code")
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

                field("Creditor BIC"; Rec."Creditor BIC")
                {
                    ToolTip = 'Specifies the value of the Credit BIC field.';
                    ApplicationArea = All;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    ApplicationArea = All;
                }
                field("Creditor Identifier Type"; Rec."Creditor Identifier Type") { ApplicationArea = All; }
                field("Reason Information Text"; Rec."Reason Information Text")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Status Description"; Rec."Status Description")
                {
                    ApplicationArea = All;
                }

            }
        }
    }
    // trigger OnDeleteRecord(): Boolean
    // var
    //     FindGenJnl: Boolean;
    //     PaymentLine: Record "Payment Schedule Line";
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

    trigger OnDeleteRecord(): Boolean
    var
        FindGenJnl: Boolean;
        PaymentLine: Record "Payment Schedule Line";
        FindCashLine: Boolean;
        PScheduleHeader: Record "Payment Schedule Header";
        PVoucherHeader: Record "Payment Voucher Header";
    begin
        PaymentLine := Rec;
        PaymentLine.SetRecFilter();
        PaymentLine.TestStatusOpen;
        PScheduleHeader.Get(PaymentLine."Batch Number");
        if PScheduleHeader.Submitted then
            Error('%1 already submitted', PScheduleHeader."Batch Number");
        PVoucherHeader.Get(Rec."Source No.");
        PVoucherHeader."Payment ID" := '';
        PVoucherHeader.Modify();
        PaymentLine.Reset();
        PaymentLine.SetRange("Batch Number", Rec."Batch Number");
        PaymentLine.SetRange("Source No.", Rec."Source No.");
        PaymentLine.DeleteAll();

    end;

    // var
    //     Txt002: label 'Batch Number %1 already submitted, Transaction cannot be deleted';
    //     TransHeader: Record "Payment Schedule Header";
    //     GeneralJournalLine: Record "Gen. Journal Line";
    //     PaymentTransLines: Record "Payment Schedule Line";
}

