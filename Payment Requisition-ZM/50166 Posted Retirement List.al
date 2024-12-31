page 50166 "Posted Retirement List"
{
    //Created by Salaam Azeez
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Retirement;
    SourceTableView = WHERE(Posted = CONST(true));
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    CardPageId = "Posted Retirement Card";

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
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;

                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;

                }
                field("Currency Code"; Rec."Currency Code")
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
    trigger OnOpenPage()
    begin
        Rec.MarkAllWhereUserisUserIDOrDepartment()
    end;
}