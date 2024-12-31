pageextension 50010 CustomerExt extends "Customer Card"
{
    layout
    {
        addafter("No.")
        {
            field("No. 2"; Rec."No. 2")
            {
                ApplicationArea = All;
            }
        }
        addbefore(Blocked)
        {
            field(Type; Rec.Type)
            {
                ApplicationArea = Basic;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}