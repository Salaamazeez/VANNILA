pageextension 50018 CashRcptJournalExt extends "Cash Receipt Journal"
{
    layout
    {
        modify(Amount)
        {
            Editable = false;
        }
        modify("Amount (LCY)")
        {
            Editable = false;
        }
        modify("Account No.")
        {
            Visible = false;
    
        }
        addafter("Account Type")
        {
            field("Suspense/Clearing"; Rec."Suspense/Clearing")
            {
                ApplicationArea = All;
            }
            field("KBS-Account No."; Rec."KBS-Account No.")
            {
                ApplicationArea = All;
            }
        }
        addbefore(Amount)
        {
            field("Credit Amount "; Rec."Credit Amount") { ApplicationArea = All; }
            field("Debit Amount "; Rec."Debit Amount") { ApplicationArea = All; }
        }

    }


    actions
    {
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                Rec.TestMandatoryFields()
            end;
        }
        modify("Post and &Print")
        {
            trigger OnBeforeAction()
            begin
                Rec.TestMandatoryFields()
            end;
        }
    }
}