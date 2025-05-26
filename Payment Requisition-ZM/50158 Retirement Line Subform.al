page 50158 "Retirement Line Subform"
{
    //Created by Akande
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Retirement Line";
    AutoSplitKey = true;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(Group1)
            {
                field("Expense Code"; Rec."Expense Code")
                {
                    ApplicationArea = All;
                }
                field("Transaction Details"; Rec."Transaction Details")
                {
                    ApplicationArea = All;

                }
                field("Account Type"; Rec."Account Type") { }
                field("Account No."; Rec."Account No.") { }
                field("Account Name"; Rec."Account Name") { }
                // field("Document No."; "Document No.")
                // {
                //     ApplicationArea = All;
                // }
                // field("Line No."; "Line No.")
                // {
                //     ApplicationArea = All;
                // }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }

            }
            group(group2)
            {
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }
                field("Total Amount (LCY)"; Rec."Total Amount (LCY)")
                {
                    ApplicationArea = All;
                }
            }

        }
        // area(Factboxes)
        // {

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
    trigger OnAfterGetRecord()
    begin
        Rec.CalculateTotals;
    end;
}