page 50173 "Posted Cash Receipt Card"
{
    //Created by Akande
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Cash Receipt";
    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;

                }
                field("Retiring Officer"; Rec."Retiring Officer")
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
                field("Retirement No."; Rec."Retirement No.")
                {

                }
                field("Debit Account No."; Rec."Debit Account No.")
                {
                    ApplicationArea = All;

                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;

                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;

                }
                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = All;

                }
                field(Status; Rec.Status)
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
                //  field("Retirement No.";"Retirement No."){

                // }

            }
            group(ListPart)
            {
                part("Retirement Line Subform"; "Retirement Line Subform")
                {
                    CaptionML = ENU = 'Lines';
                    SubPageLink = "Document No." = FIELD("No.");

                }
            }
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

    var
        myInt: Integer;
}