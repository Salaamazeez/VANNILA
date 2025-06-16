page 60010 "Payment Voucher List"
{
    //Created by Akande
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Payment Voucher Header";
    SourceTableView = WHERE(Posted = CONST(false), Status = FILTER(<> Approved));
    Editable = false;
    CardPageId = "Payment Voucher Card";


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
                field(Requester; Rec.Requester) { ApplicationArea = All; }
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
                field("Currency Code"; Rec."Currency Code")
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

    trigger OnOpenPage()
    begin
        Rec.MarkAllWhereUserisUserIDOrDepartment()
    end;

    var
        UserSetup: Record "User Setup";
}

