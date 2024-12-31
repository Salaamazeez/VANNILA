page 50174 "Posted Cash Receipt List"
{
    //Created by Salaam Azeez
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Cash Receipt";
    SourceTableView = WHERE(Posted = CONST(true));
    CardPageId = "Posted Cash Receipt Card";

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
            action(Print)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    CashReceiptTbl: Record "Cash Receipt";
                begin
                    CashReceiptTbl.SetRange("No.", Rec."No.");
                    if CashReceiptTbl.FindFirst() then
                        Report.RunModal(50100, true, true, CashReceiptTbl);
                end;
            }
        }
    }
}