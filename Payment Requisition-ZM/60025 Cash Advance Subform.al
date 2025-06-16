page 50000 "Cash Advance Subform"
{
    //Created by Akande
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Cash Advance Line";
    DelayedInsert = true;
    // MultipleNewLines = true;
    AutoSplitKey = true;
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Expense Code"; Rec."Expense Code")
                {
                    ApplicationArea = All;
                }
                field("Payment Details"; REC."Payment Details")
                {
                    Caption = 'Purpose';
                    ApplicationArea = All;

                }

                field("Account Type"; REC."Account Type") { Editable = false; }
                // field("Expense Code"; "Expense Code")
                // {

                // }
                field("Account Name"; REC."Account Name")
                {
                    Editable = false;
                }
                field("Account No."; REC."Account No.")
                {
                    Editable = false;
                }
                field("Currency Code"; Rec."Currency Code") { }
                field(Amount; REC.Amount)
                {
                    ApplicationArea = All;

                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {

                }

                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code") { ApplicationArea = All; }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code") { ApplicationArea = All; }
            }
        }

    }

    actions
    {
        area(Processing)
        {

            action(Dimensions)
            {
                AccessByPermission = TableData Dimension = R;
                ApplicationArea = Dimensions;
                Caption = 'Dimensions';
                Image = Dimensions;
                ShortCutKey = 'Alt+D';
                ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                trigger OnAction()
                begin
                    Rec.ShowDimensions();
                end;
            }

        }
    }

    var
        AmountEditable: Boolean;
        InvoiceNoEditable: Boolean;
        PaymentRequisition: Record "Payment Requisition";
        PaymentRequisitionLine: Record "Payment Requisition Line";

    trigger OnInit()
    begin
        //AmountEditable := FALSE;
        InvoiceNoEditable := FALSE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin

    end;

}


