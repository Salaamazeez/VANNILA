page 60001 "Payment Req. List Dummy"
{
    //Created by Akande
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Payment Requisition";
    //SourceTableView = WHERE(Status = FILTER(Open));
    Editable = false;
    CardPageId = "Payment Req. Card Dummy";


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
                field("Date"; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field(Requester; Rec.Requester)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Request Amount"; Rec."Request Amount")
                {
                    ApplicationArea = All;
                }
                field("Request Amount (LCY)"; Rec."Request Amount (LCY)")
                {
                    ApplicationArea = All;
                }
            }




            // group(FactBoxArea)
            // {
            //     part("Workflow Approval FactBox";Rec. "Approval FactBox")
            //     {
            //         SubPageLink = "Document No." = FIELD("No.");
            //     }
            // }
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
    var
        UserSetup: Record "User Setup";
}
