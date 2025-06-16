page 50008 "Approved Payment Req. List"
{
    //Created by Akande
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Payment Requisition";
    SourceTableView = WHERE(Posted = CONST(false), Status = CONST(Approved));
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    CardPageId = "Approved Payment Req. Card";


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
                field("Currency Code"; Rec."Currency Code")
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
            //     part("Workflow Approval FactBox"; "Approval FactBox")
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

    // trigger OnOpenPage()
    // begin
    //     Rec.MarkAllWhereUserisUserIDOrDepartment()
    // end;
    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId);

        if not UserSetup."Finance Admin" then begin
            Rec.FilterGroup(2);
            Rec.SetRange(Requester, UserSetup."User ID");
            Rec.FilterGroup(0);
        end else
            Rec.SetRange(Requester);
    end;



    var
        UserSetup: Record "User Setup";
}
