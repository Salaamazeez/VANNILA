Page 90231 "Archived Payment Subform"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Posted Payment Trans Line";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(ReferenceNumber; Rec."Reference Number")
                {
                    ApplicationArea = All;
                }
                field(BankCBNCode; Rec."Bank CBN Code")
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

    actions
    {
    }

    var
        Text001: label 'Are you sure you want to process the %1 selected records';
        Text002: label 'Function Cancelled';
        TransRec: Record "Payment Window Header";
}

