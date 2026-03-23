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