page 50012 "Pending Retirement List"
{
    //Created by Akande
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Retirement;
    CardPageId = "Pending Retirement Card";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    SourceTableView = WHERE(Posted = CONST(false), Status = FILTER("Pending Approval"));


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
                field("Retirement Ref."; Rec."Retirement Ref.")
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
                field("Retiring Officer"; Rec."Retiring Officer")
                {
                    ApplicationArea = All;
                }
            }
        }
        // area(Factboxes)
        // {
        //     part("Document Approval Entries";Rec. "Document Approval Entries")
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

    trigger OnOpenPage()
    begin
        UserSetup.Get(UserId);

        if not UserSetup."Finance Admin" then begin
            Rec.FilterGroup(2);
            Rec.SetRange("Retiring Officer", UserSetup."User ID");
            Rec.FilterGroup(0);
        end else
            Rec.SetRange("Retiring Officer");
        //Rec.MarkAllWhereUserisUserIDOrDepartment()
    end;

    var
        UserSetup: Record 91;

}