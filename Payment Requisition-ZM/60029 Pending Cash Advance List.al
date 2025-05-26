page 60029 "Pending Cash Advance List"
{
    //Created by Akande
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Cash Advance";
    CardPageId = "Pending Cash Advance Card";
    SourceTableView = where(Status = const("Pending Approval"));
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    //SourceTableView = where(Treated = const(true));
    // SourceTableView = WHERE(Posted = CONST(true));

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
                field("Date"; Rec."Date")
                {
                    ApplicationArea = All;

                }
                field(Requester; Rec.Requester)
                {
                    ApplicationArea = All;

                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;

                }
                // field()
                // field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                // {
                //     ApplicationArea = All;

                // }
                // field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                // {
                //     ApplicationArea = All;

                // }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;

                }
                // field("Bank Name"; "Bank Name")
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
            action(Print)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    CashAdvanceTbl: Record "Cash Advance";
                begin
                    CashAdvanceTbl.SetRange("No.", Rec."No.");
                    if CashAdvanceTbl.FindFirst() then
                        Report.RunModal(60027, true, true, CashAdvanceTbl);
                end;
            }
        }
    }
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