page 60002 "Payment Voucher Card"
{
    //Created by Akande
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Payment Voucher Header";
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                // field("User Code";Rec."User Code")
                // {
                //     ApplicationArea = All;
                // }
                field("No."; Rec."No.")
                {
                    Editable = false;
                    ApplicationArea = All;

                }
                field("Transaction type"; Rec."Transaction type")
                {
                    ApplicationArea = All;
                    Editable = Rec."Former PR No." = '';
                    Visible = false;
                }
                field("Loan ID"; Rec."Loan ID")
                {
                    ApplicationArea = All;
                    Editable = Rec."Former PR No." = '';
                    Visible = false;
                }
                field("Applies-to Invoice No."; Rec."Applies-to Invoice No.")
                {
                    ApplicationArea = All;
                }
                field("Date"; Rec."Date")
                {
                    ApplicationArea = All;
                    Editable = Rec."Former PR No." = '';
                }
                field(Requester; Rec.Requester)
                {
                    ApplicationArea = All;
                    Editable = Rec."Former PR No." = '';
                }
                field("Request Description"; Rec."Request Description")
                {
                    ApplicationArea = All;
                    Editable = Rec."Former PR No." = '';

                }
                field(Beneficiary; Rec.Beneficiary)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Beneficiary Name"; Rec."Beneficiary Name")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Bal Account Type"; Rec."Bal Account Type")
                {
                    Editable = Rec."Former PR No." = '';

                }
                field("Bal Account No."; Rec."Bal Account No.")
                {
                }
                field("Bal Account Name"; Rec."Bal Account Name")
                {

                }
                field("Suspense/Clearing"; Rec."Suspense/Clearing")
                {
                    ApplicationArea = All;
                }
                // field("Purchase Requisition Amount";Rec."Purchase Requisition Amount")
                // {
                //     ApplicationArea = All;

                // }
                field("Request Amount"; Rec."Request Amount")
                {
                    //Editable = Rec."Former PR No." = '';
                    ApplicationArea = All;
                }
                field("Former PR No."; Rec."Former PR No.")
                {
                    Visible = false;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;

                }
                field("Payment Method"; Rec."Payment Method") { ApplicationArea = All; }
                field(Posted; Rec.Posted)
                {

                }
                field("Journal Template Name"; Rec."Journal Template Name")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    //Editable = Rec."Former PR No." = '';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    //Editable = Rec."Former PR No." = '';
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    Editable = Rec."Former PR No." = '';
                    ApplicationArea = All;
                }

                // field("Actual User";Rec."Actual User")
                // {
                //     ApplicationArea = All;
                // }

            }
            // group(Control)
            // {



            //     field("Request Amount";Rec."Request Amount")
            //     {
            //         ApplicationArea = All;

            //     }
            //     field("Request Amount (LCY)";Rec."Request Amount (LCY)")
            //     {
            //         ApplicationArea = All;

            //     }



            // }

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


            action("Post Payment")
            {
                Visible = false;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Rec.PostPayment();
                end;
            }

            group("&Payments")
            {
                Caption = '&Payments';
                Image = Payment;
                action(SuggestVendorPayments)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Suggest Vendor Payments';
                    Ellipsis = true;
                    Image = SuggestVendorPayments;
                    ToolTip = 'Create payment suggestions as lines in the payment journal.';

                    trigger OnAction()
                    var
                        SuggestVendorPayments: Report "KBS Suggest Vendor Payments";
                        IsHandled: Boolean;
                        PaymentVoucherLine: Record "Payment Voucher Line";
                        PaymentVoucherHeader: Record "Payment Voucher Header";
                    begin
                        IsHandled := false;
                        if IsHandled then
                            exit;
                        //PaymentVoucherLine.SetRange("Document No.", Rec."No.");
                        Clear(SuggestVendorPayments);
                        CreateJnlLine();
                        SuggestVendorPayments.SetGenJnlLine(GenJournalLine);
                        SuggestVendorPayments.SetPaymentHdr(Rec);
                        SuggestVendorPayments.RunModal();
                    end;
                }

            }


            // action(Print){
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     var
            //         PurRequisition: Record "Purch. Requistion";
            //     begin
            //         PurRequisition.SetRange("No.", "No.");
            //         if PurRequisition.FindFirst() then
            //             //Report.Run(50130,);
            //             Report.Run(50102, true, true, PurRequisition);
            //     end;
            // }
            action("Preview Posting")
            {
                Visible = true;
                ApplicationArea = All;
                trigger OnAction()

                begin
                    Rec.PreviewPosting();
                end;
            }
            action("Test Report")
            {
                Visible = false;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    Rec.TestReport();
                end;
            }

            action("Post Print")
            {
                ApplicationArea = All;
                Visible = false;
                trigger OnAction()
                begin
                    // TestField("User Code");
                    Rec.PostPrint();
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
                            TestMandatoryFields;
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

            group("Request Approval")
            {
                action("Send &Approval Request")
                {
                    ApplicationArea = Basic;
                    Enabled = not OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        RecRef: RecordRef;
                        ApprovalsMgmt: Codeunit "Approval Mgt";
                    begin
                        TestMandatoryFields;
                        RecRef.GetTable(Rec);
                        if ApprovalsMgmt.CheckGenericApprovalsWorkflowEnabled(RecRef) then
                            ApprovalsMgmt.OnSendGenericDocForApproval(RecRef);
                    end;
                }

                action("Cancel Approval Re&quest")
                {
                    ApplicationArea = Basic;
                    Enabled = OpenApprovalEntriesExist;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        RecRef: RecordRef;
                        ApprovalsMgmt: Codeunit "Approval Mgt";
                    begin
                        RecRef.GetTable(Rec);
                        ApprovalsMgmt.OnCancelGenericDocForApproval(RecRef);
                    end;
                }

            }

            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        ApprovalMgt: Codeunit "Approval Mgt";

                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId);
                        if ApprovalMgt.ApproveDoc(Rec."No.") then begin
                            Rec.Status := Rec.Status::Approved;
                            Rec.Modify()
                        end;
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = Basic;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        MyApprovalMgt: Codeunit "Approval Mgt";
                        RecRef: RecordRef;
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RecordId);
                        RecRef.GetTable(Rec);
                        MyApprovalMgt.CheckAndRejectDoc(RecRef)
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Process;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = Basic;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Approval Comments";
                    RunPageLink = "Table ID" = const(60202),
                                  "Document No." = field("No.");
                    Visible = false;
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Sales Comment Sheet";
                    RunPageLink = "Document Type" = const(0),
                                  "No." = field("No."),
                                  "Document Line No." = const(0);
                    ToolTip = 'View or add comments for the record.';
                }
            }
            action(Print)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    //    TestField("User Code");
                    PaymentVoucherHeader.SETRANGE("No.", Rec."No.");
                    IF PaymentVoucherHeader.FINDFIRST THEN
                        REPORT.RUNMODAL(60000, TRUE, TRUE, PaymentVoucherHeader);
                end;
            }

        }
        area(Navigation)
        {
            action(Dimensions)
            {
                AccessByPermission = TableData Dimension = R;
                ApplicationArea = Dimensions;
                Caption = 'Dimensions';
                Enabled = Rec."No." <> '';
                Image = Dimensions;
                ShortCutKey = 'Alt+D';
                ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                trigger OnAction()
                begin
                    Rec.ShowDocDim();
                    CurrPage.SaveRecord();
                end;
            }

            action(Approvals)
            {
                ApplicationArea = Basic;
                Image = Approvals;

                trigger OnAction()
                var
                    ApprovalEntries: Page "Approval Entries";
                begin
                    ApprovalEntries.SetRecordFilters(Database::"Payment Voucher Header", 6, Rec."No.");
                    ApprovalEntries.Run;
                end;
            }


        }

    }
    trigger OnOpenPage()
    var
        PaymentMgtSetup: Record "Payment Mgt Setup";
    begin
        PaymentMgtSetup.Get();
        Rec."Journal Template Name" := PaymentMgtSetup."Journal Template Name";
        Rec."Journal Batch Name" := PaymentMgtSetup."Journal Batch Name";
    end;

    trigger OnAfterGetRecord()
    var
        PaymentMgtSetup: Record "Payment Mgt Setup";
    begin
        EnableFields;
        SetControlAppearance;
        PaymentMgtSetup.Get();
        Rec."Journal Template Name" := PaymentMgtSetup."Journal Template Name";
        Rec."Journal Batch Name" := PaymentMgtSetup."Journal Batch Name";
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
    end;

    procedure EnableFields()
    begin
        CurrPage.Editable(Rec.Status <> Rec.Status::"Pending Approval");
        //CurrPage.Editable(Rec."Former PR No." = '');

    end;

    procedure TestMandatoryFields()
    var
        PmtVoucherLine: Record "Payment Voucher Line";
        Error001: Label '%1 cannot be empty on line no. %2';
        Error002: Label '%1 cannot be 0';
        Err001: Label 'Kindly select a %1 value';
        Err002: Label 'Kindly input a %1 value';
    begin
        Rec.TestField(Status, Rec.Status::Open);
        // if Rec."Transaction type" = Rec."Transaction type"::" " then
        //     Error(Err001, Rec.FieldCaption("Transaction type"));
        if Rec."Transaction type" = Rec."Transaction type"::Loan then
            Rec.TestField("Loan ID");
        Rec.TestField("Request Description");
        // Rec.TestField(Beneficiary);
        Rec.TestField("Payment Method");
        Rec.TestField("Bal Account No.");
        Rec.TestField("Shortcut Dimension 1 Code");
        Rec.TestField("Shortcut Dimension 2 Code");
        Rec.CalcFields("Request Amount (LCY)");
        if Rec."Request Amount (LCY)" = 0 then
            Error(Error002, Rec.FieldCaption("Request Amount (LCY)"));
        PmtVoucherLine.SetRange("Document No.", Rec."No.");
        PmtVoucherLine.FindFirst();
        repeat
            if PmtVoucherLine."Account No." = '' then
                Error(Error001, PmtVoucherLine.FieldCaption("Account No."), PmtVoucherLine.FieldCaption("Line No."));
            if PmtVoucherLine."Shortcut Dimension 1 Code" = '' then
                Error(Error001, PmtVoucherLine.FieldCaption("Shortcut Dimension 1 Code"), PmtVoucherLine.FieldCaption("Line No."));
            if PmtVoucherLine."Shortcut Dimension 2 Code" = '' then
                Error(Error001, PmtVoucherLine.FieldCaption("Shortcut Dimension 2 Code"), PmtVoucherLine.FieldCaption("Line No."));
            if PmtVoucherLine."Payment Details" = '' then
                Error(Error001, PmtVoucherLine.FieldCaption("Payment Details"), PmtVoucherLine.FieldCaption("Line No."));
        until PmtVoucherLine.Next() = 0;

    end;

    local procedure CreateJnlLine()
    begin
        GenJournalLine.Init();
        GenJournalLine."Journal Template Name" := Rec."Journal Template Name";
        GenJournalLine."Journal Batch Name" := Rec."Journal Batch Name";
    end;

    var
        PaymentVoucherHeader: Record "Payment Voucher Header";
        RecRef: RecordRef;
        RecID: RecordID;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        EnableControl: Boolean;
        GenJournalLine: Record "Gen. Journal Line";
}