pageextension 50028 SalesJournalExt extends "Sales Journal"
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