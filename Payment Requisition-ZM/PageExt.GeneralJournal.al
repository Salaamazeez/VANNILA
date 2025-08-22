pageextension 50016 GeneralJournalExt extends "General Journal"
{
    layout
    {
        modify("Gen. Posting Type")
        {
            Visible = false;
        }
        modify("Gen. Bus. Posting Group")
        {
            Visible = false;
        }
        modify("Bal. Gen. Posting Type")
        {
            Visible = false;
        }
        modify("Bal. Gen. Bus. Posting Group")
        {
            Visible = false;
        }
        modify("Bal. Gen. Prod. Posting Group")
        {
            Visible = false;
        }
        modify("Deferral Code")
        {
            Visible = false;
        }
        modify(Correction)
        {
            Visible = false;
        }


        modify(Amount)
        {
            Editable = true;
        }
        modify("Amount (LCY)")
        {
            Editable = false;
        }
        addbefore(Amount)
        {
            field("Credit Amount "; Rec."Credit Amount") { ApplicationArea = All; }
            field("Debit Amount "; Rec."Debit Amount") { ApplicationArea = All; }
        }
        addbefore(Comment)
        {
            field("KBS Open"; Rec."KBS Closed") { ApplicationArea = All; }
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
        modify(PostAndPrint)
        {
            trigger OnBeforeAction()
            begin
                Rec.TestMandatoryFields()
            end;
        }
    }
}