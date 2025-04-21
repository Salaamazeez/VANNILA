pageextension 50016 GeneralJournalExt extends "General Journal"
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