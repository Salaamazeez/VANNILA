
//Created by Akande
page 60015 "Pay Mode"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Pay Mode";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Pay Mode"; Rec."Pay Mode")
                {
                    ApplicationArea = All;

                }

                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ApplicationArea = All;

                }
                field(Description; Rec.Description)
                {

                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ApplicationArea = All;

                }
                field("Bal. Account Name"; Rec."Bal. Account Name")
                {

                }

                field("Payment to"; Rec."Payment to")
                {
                    ApplicationArea = All;

                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}

