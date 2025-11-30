Page 90240 "Payment Schedule Setup"
{
    //DeleteAllowed = false;
    //InsertAllowed = false;
    PageType = Card;
    SourceTable = "Payment Schedule Setup";
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {

            group("Gate Way")
            {
                field("Use "; Rec."Use Pmt Authomation")
                {
                    ToolTip = 'Specifies the value of the Use field.';
                    ApplicationArea = All;
                }
                field(PaymentPlatform; Rec."Payment Platform")
                {
                    ToolTip = 'Specifies the value of the Payment Platform field.';
                    ApplicationArea = All;
                }
                field("Create Schedule URL"; Rec."Create Schedule URL")
                {
                    ToolTip = 'Specifies the value of the Create Schedule URL field.';
                    ApplicationArea = All;
                }
                field("Get Payment Schedule URL"; Rec."Get Payment Schedule URL")
                {
                    ToolTip = 'Specifies the value of the Get Payment Schedule URL field.';
                    ApplicationArea = All;
                }
                field("Update Schedule URL";Rec."Update Schedule URL")
                {
                    ApplicationArea = Basic;
                }
                // field("Get Debit Account"; Rec."Get Debit Account")
                // {
                //     ToolTip = 'Specifies the value of the Get Debit Account field.';
                //     ApplicationArea = All;
                // }
                field("Secret Key"; Rec."Secret Key")
                {
                    ToolTip = 'Specifies the value of the Secret Key field.';
                    ApplicationArea = All;
                }
                field("Charges Account"; Rec."Charges Account")
                {
                    ToolTip = 'Specifies the value of the Charges Account field.';
                    ApplicationArea = All;
                }
                field("Payment Auto Post"; Rec."Payment Auto Post")
                {
                    ToolTip = 'Specifies the value of the Payment Auto Post field.';
                    ApplicationArea = All;
                }
                field("Charges Auto Post"; Rec."Charges Auto Post")
                {
                    ToolTip = 'Specifies the value of the Charges Auto Post field.';
                    ApplicationArea = All;
                }
                field(GetPayrollonPayment; Rec."Get Payroll on Payment")
                {
                    ApplicationArea = Basic;
                }

            }
            group(Numbering)
            {
                Caption = 'Numbering';
                field(BatchNoSeries; Rec."Batch No. Series")
                {
                    ToolTip = 'Specifies the value of the Batch No. Series field.';
                    ApplicationArea = All;
                }
                field(ReferenceNoSeries; Rec."Reference No. Series")
                {
                    ToolTip = 'Specifies the value of the Reference No. Series field.';
                    ApplicationArea = All;
                }
                field(SingleViewRequestNoSeries; Rec."Single View Request No. Series")
                {
                    ToolTip = 'Specifies the value of the Single View Request No. Series field.';
                    ApplicationArea = All;
                }
                field("General Journal Template"; Rec."General Journal Template")
                {
                    ToolTip = 'Specifies the value of the General Journal Template field.';
                    ApplicationArea = All;
                }
                field("General Journal Batch"; Rec."General Journal Batch")
                {
                    ToolTip = 'Specifies the value of the General Journal Batch field.';
                    ApplicationArea = All;
                }
                field("Payment Method"; Rec."Payment Method")
                {
                    ToolTip = 'Specifies the value of the Payment Method field.';
                    ApplicationArea = All;
                }
            }

        }
    }

    actions
    {
        area(Navigation)
        {
            action("Banks")
            {
                RunObject = page "Banks";
                Image = Bank;
                ToolTip = 'This contains the list of banks';
                Caption = 'Banks';
                ApplicationArea = All;

            }
        }
    }

}

