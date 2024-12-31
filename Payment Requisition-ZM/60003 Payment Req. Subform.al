page 60003 "Payment Req. Subform"
{
    //Created by Salaam Azeez
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Payment Requisition Line";
    DelayedInsert = true;
    // MultipleNewLines = true;
    AutoSplitKey = true;
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field("Expense Code"; Rec."Expense Code") { }

                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        IF Rec."Account Type" = Rec."Account Type"::Vendor THEN BEGIN
                            InvoiceNoEditable := TRUE;
                            // AmountEditable := FALSE;
                        END ELSE BEGIN
                            InvoiceNoEditable := FALSE;
                            //AmountEditable := TRUE;
                        END;
                    end;
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;

                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = All;

                }
                field("Payment Details"; Rec."Payment Details")
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





                // field("Bal. Account Type"; "Bal. Account Type")
                // {
                //     ApplicationArea = All;

                // }
                // field("Bal. Account No."; "Bal. Account No.")
                // {
                //     ApplicationArea = All;

                // }
                // field("Bal. Account Name"; "Bal. Account Name")
                // {
                //     ApplicationArea = All;

                // }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;

                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;

                }

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
        IF Rec."Document No." <> '' THEN BEGIN
            PaymentRequisition.GET(Rec."Document No.");
            // IF PaymentRequisition."System-Generated" THEN BEGIN
            PaymentRequisitionLine.SETFILTER("Document No.", Rec."Document No.");
            IF PaymentRequisitionLine.FINDFIRST THEN
                MESSAGE('NOTE!: You are about to modify Payment Requisition for Trade Activation. This change would update the record on Trade Activation Line.');

            // END;

        END;
    end;
}


