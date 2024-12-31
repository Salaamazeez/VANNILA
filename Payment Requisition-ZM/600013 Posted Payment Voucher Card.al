page 60013 "Posted Payment Voucher Card"
{//Created by Salaam Azeez
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Payment Voucher Header";
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    SourceTableView = WHERE(Posted = filter(true), Status = FILTER(= Approved));
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; REC."No.")
                {
                    ApplicationArea = All;

                }
                field("Date"; REC."Date")
                {
                    ApplicationArea = All;

                }
                field(Requester; REC.Requester)
                {
                    ApplicationArea = All;

                }
                field("Request Description"; REC."Request Description")
                {
                    ApplicationArea = All;

                }
                field("Pay Mode"; REC."Pay Mode")
                {
                    Visible = false;
                }
                // field("Account Type"; "Account Type")
                // {

                // }
                field("Bal Account No."; REC."Bal Account No.")
                {

                }
                field("Bal Account Name"; REC."Bal Account Name")
                {

                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code") { }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code") { }

            }
            group(Control)
            {
                // field("Purchase Requisition No."; "Purchase Requisition No.")
                // {
                //     ApplicationArea = All;

                // }
                // field("Purchase Requisition Amount"; "Purchase Requisition Amount")
                // {
                //     ApplicationArea = All;

                // }

                field("Request Amount"; REC."Request Amount")
                {
                    ApplicationArea = All;

                }
                field("Request Amount (LCY)"; REC."Request Amount (LCY)")
                {
                    ApplicationArea = All;

                }

                field(Status; REC.Status)
                {
                    ApplicationArea = All;

                }
                field("Former PR No."; REC."Former PR No.")
                {
                }
                field(Posted; REC.Posted)
                {

                }
            }


            group(ListPart)
            {
                part("Payment Voucher Subform"; "Payment Voucher Subform")
                {
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
                    PaymentVoucherTbl: Record "Payment Voucher Header";
                begin
                    PaymentVoucherTbl.SetRange("No.", REC."No.");
                    if PaymentVoucherTbl.FindFirst() then
                        Report.RunModal(60000, true, true, PaymentVoucherTbl);
                end;
            }
        }
        area(Navigation)
        {
            action(Navigate)
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Rec.Navigate
                end;
            }
        }
    }




}