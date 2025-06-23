page 60009 "Payment Voucher Subform"
{
    //Created by Akande
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Payment Voucher Line";
    DelayedInsert = true;
    // MultipleNewLines = true;
    // AutoSplitKey = true;
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Payment Details"; Rec."Payment Details")
                {
                    ApplicationArea = All;
                    //Editable = IsFormerPRNoEmpty;
                }
                field("Account Type"; Rec."Account Type")
                {
                    // Editable = false;
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        IF Rec."Account Type" = Rec."Account Type"::Staff THEN BEGIN
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
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;

                }
                field("Applies-to Doc. Type"; Rec."Applies-to Doc. Type")
                {
                    ApplicationArea = All;
                }
                field("Applies-to Invoice No."; Rec."Applies-to Invoice No.")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Editable = false;
                    ApplicationArea = All;

                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Editable = false;
                    ApplicationArea = All;

                }
                // field("WHT %"; "WHT %")
                // {
                //     ApplicationArea = All;

                // }
                // field("Vendor Invoice No."; "Vendor Invoice No.")
                // {
                //     ApplicationArea = All;

                // }
                // field("Vendor Invoice Amount"; "Vendor Invoice Amount")
                // {
                //     ApplicationArea = All;
                //     trigger OnValidate()
                //     begin
                //         //IF System Generated, warn on additional entry
                //         IF "Document No." <> '' THEN BEGIN
                //             PaymentRequisition.GET("Document No.");
                //             IF PaymentRequisition."System-Generated" THEN BEGIN
                //                 IF xRec."Vendor Invoice Amount" <> "Vendor Invoice Amount" THEN
                //                     MESSAGE('NOTE!: You are about to modify Payment Requisition for Trade Activation. This change would update the record on Trade Activation Line.');

                //             END;

                //         END;
                //     end;
                // }
                //    field("Net Amount to Pay"; "Net Amount to Pay")
                //     {
                //         ApplicationArea = All;

                //     }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;

                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field("FA Posting Type"; Rec."FA Posting Type")
                {
                    ApplicationArea = All;
                }
                field("Depreciation Book Code"; Rec."Depreciation Book Code")
                {
                    ApplicationArea = All;
                }
                field("Maintenance Code"; Rec."Maintenance Code")
                {
                    ApplicationArea = All;
                }
                field("Preferred Bank Account Code"; Rec."Preferred Bank Account Code")
                {
                    ApplicationArea = All;
                }
                // }
                // field("VAT Amount"; "VAT Amount")
                // {
                //     ApplicationArea = All;

                // }
                // field("WHT Amount"; "WHT Amount")
                // {
                //     ApplicationArea = All;

                // }
                // field("1% NCDF Amount"; "1% NCDF Amount")
                // {
                //     ApplicationArea = All;

                // }
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
        PaymentVoucher: Record "Payment Voucher Header";
        PaymentRequisitionLine: Record "Payment Requisition Line";
        IsFormerPRNoEmpty: Boolean;

    trigger OnOpenPage()
    begin
        if PaymentVoucher.GET(Rec."Document No.") then
            IsFormerPRNoEmpty := PaymentVoucher."Former PR No." = '';
    end;

    trigger OnAfterGetRecord()
    begin
        if PaymentVoucher.GET(Rec."Document No.") then
            IsFormerPRNoEmpty := PaymentVoucher."Former PR No." = '';
        //Message('IsFormerPRNoEmpty = %1', IsFormerPRNoEmpty);

    end;

    trigger OnInit()
    begin
        //AmountEditable := FALSE;
        InvoiceNoEditable := FALSE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        // IF Rec."Document No." <> '' THEN BEGIN
        //     PaymentRequisition.GET(Rec."Document No.");
        //     //  IF PaymentRequisition."System-Generated" THEN BEGIN
        //     PaymentRequisitionLine.SETFILTER("Document No.", Rec."Document No.");
        //     IF PaymentRequisitionLine.FINDFIRST THEN
        //         MESSAGE('NOTE!: You are about to modify Payment Requisition for Trade Activation. This change would update the record on Trade Activation Line.');

        //  END;

        //END;
    end;
}



