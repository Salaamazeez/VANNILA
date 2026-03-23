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
        addafter(Name)
        {
             field("Name 2";Rec."Name 2")
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