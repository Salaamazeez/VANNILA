pageextension 50041 BankAccountListExt extends "Bank Account List"
{
    layout
    {
        addafter(Name)
        {
            field("Bank Account No. ";Rec."Bank Account No.")
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