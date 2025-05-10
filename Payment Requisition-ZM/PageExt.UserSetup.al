pageextension 50006 UserSetupExt extends "User Setup"
{
    layout
    {
        addafter("Register Time")
        {
            field("Finance Admin"; Rec."Finance Admin")
            {
                ApplicationArea = All;
            }
            field("G/L Account Admin"; Rec."G/L Account Admin")
            {
                ApplicationArea = All;
            }
            field("HR Admin"; Rec."HR Admin")
            {
                ApplicationArea = All;
            }
            field("Master Record Admin"; Rec."Master Record Admin")
            {
                ApplicationArea = All;
            }
            field("Procurement Admin"; Rec."Procurement Admin")
            {
                ApplicationArea = All;
            }

            field("Appraiser Line Manager"; Rec."Appraiser Line Manager")
            {
                ApplicationArea = All;
            }
            field("HR Administrator"; Rec."HR Administrator")
            {
                ApplicationArea = All;
            }

            field("OilGas Data Admin"; Rec."OilGas Data Admin")
            {
                ApplicationArea = All;
            }
            field("OilGas Data Upload"; Rec."OilGas Data Upload")
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