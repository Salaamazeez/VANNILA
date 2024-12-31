page 60021 "Cash Advance List"
{
    //Created by Salaam Azeez
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Cash Advance";
    CardPageId = "Cash Advance Card";
    SourceTableView = WHERE(Posted = CONST(false), Status = FILTER(<> Approved));
    layout
    {
        area(Content)
        {
            repeater("Group")
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Date"; Rec."Date")
                {
                    ApplicationArea = All;

                }
                field(Requester; Rec.Requester)
                {
                    ApplicationArea = All;

                }
                // field(Purpose; Purpose)
                // {
                //     ApplicationArea = All;

                // }
                // field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                // {
                //     ApplicationArea = All;

                // }
                // field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                // {
                //     ApplicationArea = All;

                // }
                field("No. Series"; Rec."No. Series")
                {
                    ApplicationArea = All;

                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;

                }
                field(Treated; Rec.Treated)
                {
                    ApplicationArea = All;

                }

                // field("Type"; "Type")
                // {
                //     ApplicationArea = All;

                // }
                // field(Amount; Amount)
                // {
                //     ApplicationArea = All;

                // }
                // field("Bank No."; "Bank No.")
                // {
                //     ApplicationArea = All;

                // }
                // field("Bank Name"; "Bank Name")
                // {
                //     ApplicationArea = All;

                // }
                // field("Amount (LCY)"; "Amount (LCY)")
                // {
                //     ApplicationArea = All;

                // }
                // field("Currency Code"; "Currency Code")
                // {
                //     ApplicationArea = All;

                // }
                // field("Currency Factor"; "Currency Factor")
                // {
                //     ApplicationArea = All;

                // }
                // field("Exchange Rate"; "Exchange Rate")
                // {
                //     ApplicationArea = All;

                // }
                // field("Debit Account No."; "Debit Account No.")
                // {
                //     ApplicationArea = All;

                // }
                // field("Debit Account Name"; "Debit Account Name")
                // {
                //     ApplicationArea = All;

                // }
                // field(Posted; Posted)
                // {
                //     ApplicationArea = All;

                // }
                field(Retired; Rec.Retired)
                {
                    ApplicationArea = All;

                }
                // field("Dimension Set ID"; "Dimension Set ID")
                // {
                //     ApplicationArea = All;

                // }
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
}