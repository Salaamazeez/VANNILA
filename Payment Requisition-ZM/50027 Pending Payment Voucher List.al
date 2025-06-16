page 50027 "Pending Payment Voucher List"
{
    //Created by Akande
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Payment Voucher Header";
    SourceTableView = WHERE(Posted = filter(false), Status = FILTER(= "Pending Approval"));
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    CardPageId = "Pending Payment Voucher Card";


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
                field("Currency Code"; Rec."Currency Code")
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
    trigger OnOpenPage()
    begin
        UserSetup.Get(UserId);

        if not UserSetup."Finance Admin" then begin
            Rec.FilterGroup(2);
            Rec.SetRange(Requester, UserSetup."User ID");
            Rec.FilterGroup(0);
        end else
            Rec.SetRange(Requester);
    end;

    var
        UserSetup: Record "User Setup";
}