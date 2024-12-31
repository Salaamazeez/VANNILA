page 50023 "Cash Advance List Dummy"
{
    //Created by Salaam Azeez
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Cash Advance";
    CardPageId = "Cash Advance Card Dummy";
    // SourceTableView = where(Status = const(Open));

    layout
    {
        area(Content)
        {
            repeater("Group")
            {
                field("No."; rec."No.")
                {
                    ApplicationArea = All;

                }

                field("Date"; rec."Date")
                {
                    ApplicationArea = All;

                }
                field(Requester; rec.Requester)
                {
                    ApplicationArea = All;

                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;

                }
                field(Purpose; Rec.Description)
                {
                    ApplicationArea = All;

                }
                // field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                // {
                //     ApplicationArea = All;

                // }
                // field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                // {
                //     ApplicationArea = All;

                // }
                field("No. Series"; rec."No. Series")
                {
                    ApplicationArea = All;

                }
                field(Status; rec.Status)
                {
                    ApplicationArea = All;

                }
                field(Treated; rec.Treated)
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
                field(Retired; rec.Retired)
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
}