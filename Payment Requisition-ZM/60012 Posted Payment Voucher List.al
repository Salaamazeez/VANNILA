page 60012 "Posted Payment Voucher List"
{
    //Created by Salaam Azeez
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Payment Voucher Header";
    SourceTableView = WHERE(Posted = filter(true), Status = FILTER(= Approved));
    Editable = false;
    CardPageId = "Posted Payment Voucher Card";


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
                field("Date"; Rec.Date)
                {
                    ApplicationArea = All;
                }
                field(Requester; Rec.Requester)
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Request Amount"; Rec."Request Amount")
                {
                    ApplicationArea = All;
                }
                field("Request Amount (LCY)"; Rec."Request Amount (LCY)")
                {
                    ApplicationArea = All;
                }

            }




            // group(FactBoxArea)
            // {
            //     part("Workflow Approval FactBox"; "Approval FactBox")
            //     {
            //         SubPageLink = "Document No." = FIELD("No.");
            //     }
            // }
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
                    PaymentVoucherTbl: Record "Payment Voucher Header";
                begin
                    PaymentVoucherTbl.SetRange("No.", Rec."No.");
                    if PaymentVoucherTbl.FindFirst() then
                        Report.RunModal(60000, true, true, PaymentVoucherTbl);
                end;
            }
        }
    }
    var
        UserSetup: Record "User Setup";
}