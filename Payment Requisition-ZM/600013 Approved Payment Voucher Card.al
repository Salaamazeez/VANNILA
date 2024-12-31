page 50004 "Approved Payment Voucher Card"
{//Created by Salaam Azeez
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Payment Voucher Header";
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    SourceTableView = WHERE(Posted = filter(false), Status = FILTER(= Approved));
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
                field("Transaction type"; Rec."Transaction type")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Loan ID"; Rec."Loan ID")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
                field("Applies-to Invoice No."; Rec."Applies-to Invoice No.")
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
                field(Beneficiary; Rec.Beneficiary)
                {
                    ApplicationArea = All;
                }
                field("Beneficiary Name"; Rec."Beneficiary Name")
                {
                    ApplicationArea = All;
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
                    Editable = false;
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
        area(factboxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(60009),
                              "No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(PreviewPosting)
            {
                Caption = 'Preview Posting';
                Visible = financeAdmin;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Rec.PreviewPosting();
                end;
            }
            action("Post Payment")
            {
                Visible = financeAdmin;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Rec.PostPayment();
                end;
            }
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
            group(Action13)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                group(Release)
                {
                    action("Re&lease")
                    {
                        ApplicationArea = Basic;
                        Image = ReleaseDoc;
                        Promoted = true;
                        PromotedCategory = Process;
                        ShortCutKey = 'Ctrl+F9';

                        trigger OnAction()
                        var
                            RecRef: RecordRef;
                            ReleaseDocument: Codeunit "Release Documents";
                        begin
                            Rec.TestField(Status, Rec.Status::Open);
                            if Rec."Transaction type" = Rec."Transaction type"::Loan then
                                Rec.TestField("Loan ID");
                            RecRef.GetTable(Rec);
                            ReleaseDocument.PerformanualManualDocRelease(RecRef);
                            CurrPage.Update;
                        end;
                    }
                    action("Re&open")
                    {
                        ApplicationArea = Basic;
                        Image = ReOpen;
                        Promoted = true;
                        PromotedCategory = Process;

                        trigger OnAction()
                        var
                            RecRef: RecordRef;
                            ReleaseDocument: Codeunit "Release Documents";
                        begin
                            RecRef.GetTable(Rec);
                            ReleaseDocument.PerformManualReopen(RecRef);
                            CurrPage.Update;
                        end;
                    }
                }
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

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId);
        financeAdmin := UserSetup."Finance Admin";
    end;

    var
        financeAdmin: boolean;
}