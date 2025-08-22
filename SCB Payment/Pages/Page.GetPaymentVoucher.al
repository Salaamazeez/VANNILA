Page 90211 "Get Payment Voucher"
{
    CardPageID = "Payment Voucher Card";
    PageType = List;
    SourceTable = "Payment Voucher Header";
    //SourceTableView = where(Type = const(""));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(PostingDescription; Rec. "Detailed Pay Description")
                {
                    ApplicationArea = Basic;
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentDate; Rec.Date)
                {
                    ApplicationArea = Basic;
                }
                field(PaymentMethod; Rec."Payment Method")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec."Status")
                {
                    ApplicationArea = Basic;
                }
                // field(PaymentRequestNo; Rec."Payment Request No.")
                // {
                //     ApplicationArea = Basic;
                // }
                field(ShortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field(CreationDate; Rec.Date)
                {
                    ApplicationArea = Basic;
                }
                field(PayeeNo; Rec."Payee No.")
                {
                    ApplicationArea = Basic;
                    
                }
                // field(Payee; Rec.pay)
                // {
                //     ApplicationArea = Basic;
                // }
            }
        }
        area(factboxes)
        {
            systempart(Control29; Links)
            {
                Visible = false;
            }
            systempart(Control28; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Dimensions)
            {
                ApplicationArea = Basic;
                Image = Dimensions;

                trigger OnAction()
                begin
                    Rec.ShowDocDim;
                    CurrPage.SaveRecord;
                end;
            }
            // action(Comments)
            // {
            //     ApplicationArea = Basic;
            //     Image = ViewComments;
            //     RunObject = Page "Payment Comment Sheet";
            //     RunPageLink = "Table Name" = const("Payment Voucher"),
            //                   "No." = field("No.");
            // }
            action(Approvals)
            {
                ApplicationArea = Basic;
                Image = Approvals;

                trigger OnAction()
                var
                    ApprovalEntries: Page "Approval Entries";
                begin
                    ApprovalEntries.SetRecordfilters(Database::"Payment Voucher Header", 6, Rec."No.");
                    ApprovalEntries.Run;
                end;
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CloseAction in [Action::OK, Action::LookupOK] then
            CreateLines;
    end;

    var
        PaymentCheck: Codeunit "Payment Export Gen. Jnl Check";
        PaymentHeader: Record "Payment Window Header";


    procedure SetPaymentHeader(var PaymentHeader2: Record "Payment Window Header")
    begin
        PaymentHeader.Get(PaymentHeader2."Batch Number");
    end;

    procedure CreateLines()
    var
        GetPaymentVoucher: Codeunit "Payment - Get Payment";
    begin
        CurrPage.SetSelectionFilter(Rec);
        GetPaymentVoucher.SetPaymentTranHeader(PaymentHeader);
        GetPaymentVoucher.CreatePaymentLines(Rec);
    end;

}

