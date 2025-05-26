page 50172 "Cash Receipt List"
{
    //Created by Akande
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Cash Receipt";
    CardPageId = "Cash Receipt Card";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                }

                field("Debit Account Name"; Rec."Debit Account Name")
                {
                    ApplicationArea = All;
                }
                field("Debit Account No."; Rec."Debit Account No.")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                }

            }
        }
        // area(Factboxes)
        // {
        //     part("Document Approval Entries"; "Document Approval Entries")
        //     {
        //         CaptionML = ENU = 'Approvals';
        //         SubPageLink = "Document No." = FIELD("No.");

        //     }

        // }
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

    var
        UserSetup: Record 91;
}