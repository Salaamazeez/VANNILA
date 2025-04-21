pageextension 50040 BankAccountExt extends "Bank Account Card"
{
    layout
    {
        addafter(Blocked)
        {
            field("Suspense/Clearing"; Rec."Suspense/Clearing")
            {
                ApplicationArea = All;
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