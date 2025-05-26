page 50002 "Payment Mgt Setup"
{

    //Created by Akande
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Payment Mgt Setup";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {

                field("Payment Requisition Nos."; Rec."Payment Requisition Nos.")
                {
                    ApplicationArea = All;

                }
                field("Payment Voucher No."; Rec."Payment Voucher No.")
                {
                    ApplicationArea = All;

                }
                field("Payment Advice Voucher No."; Rec."Payment Advice Voucher No.")
                {
                    ApplicationArea = All;
                    // FieldPropertyName = FieldPropertyValue;
                }
                field("Cash Advance Nos."; Rec."Cash Advance Nos.") { ApplicationArea = All; }
                field("Purchase Requisition Nos."; Rec."Purchase Requisition Nos.") { ApplicationArea = All; }
                field("Store Requisition Nos."; Rec."Store Requisition Nos.") { ApplicationArea = All; }
                field("Store Return Nos."; Rec."Store Return Nos.") { ApplicationArea = All; }
                field("Retirement Nos."; Rec."Retirement Nos.") { ApplicationArea = All; }
                field("Cash Receipt Nos."; Rec."Cash Receipt Nos.") { ApplicationArea = All; }
                field("Dummy Vendor"; Rec."Dummy Vendor")
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
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}