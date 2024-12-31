page 50026 "Retirement Card"
{
    //Created by Salaam Azeez
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Retirement;
    SourceTableView = WHERE(Posted = CONST(false), Status = FILTER(<> Approved));

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("No."; Rec."No.")
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
                field("Date"; Rec."Date")
                {

                }
                field("Retiring Officer"; Rec."Retiring Officer")
                {
                    ApplicationArea = All;
                }
                field("Retirement Ref."; Rec."Retirement Ref.")
                {
                    ApplicationArea = All;
                }
                field("Debit  Account Type"; Rec."Debit  Account Type") { }
                field("Debit Account No."; Rec."Debit Account No.")
                {
                    ApplicationArea = All;
                }
                field("Debit Account Name"; Rec."Debit Account Name")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
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
                field(Balance; Rec.Balance)
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
                field("Total Line Amount"; Rec."Total Line Amount")
                {
                    ApplicationArea = All;
                }
                field("Posted Balance"; Rec."Posted Balance")
                {

                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                }
                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = All;
                }
                field("Cash Recpt No./Pmt Voucher"; Rec."Cash Recpt No./Pmt Voucher")
                {
                    ApplicationArea = All;
                }
            }
            // group(ListPart)
            // {
            part("Retirement Line Subform"; "Retirement Line Subform")

            {
                CaptionML = ENU = 'Lines';
                SubPageLink = "Document No." = FIELD("No.");
                ApplicationArea = Basic, Suite;
                UpdatePropagation = Both;

            }

            // }
            // group(ListParts)
            // {
            //     // part("Document Approval Entries"; "Document Approval Entries")
            //     // {
            //     //     CaptionML = ENU = 'Approvals';
            //     //     SubPageLink = "Document No." = FIELD("No.");
            //     // }
            // }


        }

        area(factboxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(50155),
                              "No." = FIELD("No.");
            }
        }

    }

    actions
    {
        area(Processing)
        {
            group(Approv)
            {
                Caption = 'Approve';
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

            group(group001)
            {
                Caption = 'Functions';

                action("Create Bal. Voucher")
                {
                    Visible = false;
                    Image = Voucher;
                    trigger OnAction()
                    var
                        CustSetup: Record "Payment Mgt Setup";
                        Retirement: Record Retirement;
                        PVHeader: Record "Payment Voucher Header";
                        PVHeaderNo: Code[20];
                        NoSeriesMgt: Codeunit NoSeriesManagement;
                        RetirementLine: Record "Retirement Line";
                        PVLine: Record "Payment Voucher Line";
                        LineNo: Integer;
                        "Balance Amount": Decimal;
                        PurposeVar: Text[50];

                    begin
                        If Rec.Balance > 0 then
                            Error('You cannot create a Voucher');
                        LineNo := 1;
                        //Transfer Payment Requisition Header to Payment Voucher Header
                        CustSetup.GET;
                        CustSetup.TESTFIELD("Payment Voucher No.");

                        Retirement.SetRange("No.", Rec."No.");
                        if Retirement.FindFirst() then begin
                            // if Retirement.Treated = true then
                            //    Error('Voucher as been Created already');
                            // PVHeader.TransferFields(CAdvHeader);

                            PVHeaderNo := NoSeriesMgt.GetNextNo(CustSetup."Payment Voucher No.", TODAY, TRUE);
                            PVHeader."No." := PVHeaderNo;
                            "Balance Amount" := Rec.Balance;
                            PVHeader."Request Description" := Rec.Purpose;
                            PVHeader.Date := Rec.Date;
                            PVHeader."Bal Account Type" := Rec."Debit  Account Type";
                            PVHeader."Bal Account No." := Rec."Debit Account No.";
                            PVHeader."Bal Account Name" := Rec."Debit Account Name";
                            PVHeader."Request Description" := Rec.Purpose;
                            PVHeader.Requester := Rec."Retiring Officer";
                            PVHeader."No. Series" := Rec."No. Series";
                            PVHeader.Status := Rec.Status;
                            PVHeader.Type := Rec.Type;
                            PVHeader."Former PR No." := Rec."Retirement Ref.";
                            PurposeVar := Rec.Purpose;
                            PVHeader."Retirement No" := Rec."No.";
                            PVHeader."Balance Posted" := true;
                            PVHeader."Shortcut Dimension 1 Code" := Rec."Shortcut Dimension 1 Code";
                            PVHeader."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                            PVHeader."Dimension Set ID" := Rec."Dimension Set ID";
                            PVHeader."Transaction type" := Rec."Transaction type";
                            PVHeader."Loan ID" := Rec."Loan ID";
                            PVHeader.Insert();
                        end;

                        //Transfer Payment Requisition Line to Payment Voucher Line
                        RetirementLine.SetRange("Document No.", Rec."No.");
                        if RetirementLine.FindFirst() then begin
                            // repeat
                            //Message('%1', PVHeaderNo);
                            //+ PVLine.TransferFields(RetirementLine);
                            // PVLine."Document No." := NoSeriesMgt.GetNextNo(CustSetup."Payment Voucher No.", TODAY, TRUE);
                            PVLine."Document No." := PVHeaderNo;
                            PVLine."Line No." := RetirementLine."Line No.";
                            PVLine."Payment Details" := PurposeVar;
                            PVLine."Account Type" := RetirementLine."Account Type"::"Bank Account";
                            PVLine."Account No." := '';
                            PVLine.Amount := Abs(Rec.Balance);

                            PVLine.Insert();
                            // LineNo += 1;
                            //  until RetirementLine.Next() = 0;
                            //Retirement.Insert();
                        end;
                        // Retirement.Treated := true;
                        // Retirement."Voucher No" := PVHeaderNo
                        page.Run(60002, PVHeader);

                    end;
                }
                action("Create Cash Rcpt")
                {
                    Visible = false;
                    Image = Receipt;
                    trigger OnAction()
                    var
                        CustSetup: Record "Payment Mgt Setup";
                        CRcptHeader: Record "Cash Receipt";
                        RetmntHeader: Record Retirement;
                        CRcptHdrNo: Code[20];
                        NoSeriesMgt: Codeunit NoSeriesManagement;
                        CRcptLine: Record "Cash Receipt Line";
                        RetmntLine: Record "Retirement Line";

                    begin
                        If Rec.Balance < 0 then
                            Error('You cannot create a Cash Receipt');
                        //Transfer Payment Requisition Header to Payment Voucher Header
                        CustSetup.GET;
                        CustSetup.TESTFIELD("Cash Receipt Nos.");
                        RetmntHeader.SetRange("No.", Rec."No.");
                        if RetmntHeader.FindFirst() then begin
                            CRcptHeader.TransferFields(RetmntHeader);
                            CRcptHeader."Credit Account Type" := CRcptHeader."Credit Account Type"::Staff;
                            CRcptHeader."Credit Account No." := RetmntHeader."Debit Account No.";
                            CRcptHdrNo := NoSeriesMgt.GetNextNo(CustSetup."Cash Receipt Nos.", TODAY, TRUE);
                            CRcptHeader."No." := CRcptHdrNo;
                            CRcptHeader."Debit  Account Type" := Rec."Credit Account Type"::"Bank Account";
                            CRcptHeader."Debit Account No." := '';
                            CRcptHeader."Retirement No." := Rec."No.";
                            CRcptHeader."Balance Posted" := true;
                            CRcptHeader.Validate(Balance);

                            CRcptHeader.Treated := true;
                            CRcptHeader.Purpose := Rec.Purpose;
                            CRcptHeader.Insert();
                        end;
                        page.Run(50169, CRcptHeader);
                    end;
                }
                action("Test Report")
                {
                    ApplicationArea = Basic, Suite;
                    Ellipsis = true;
                    Image = TestReport;
                    CaptionML = ENU = 'Test Report';
                    ToolTipML = ENU = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';

                    trigger OnAction()
                    begin
                        Rec.TestReport;
                    end;
                }
                action(Preview)
                {
                    ApplicationArea = Basic, Suite;
                    CaptionML = ENU = 'Preview Posting';
                    ToolTipML = ENU = 'Review the different types of entries that will be created when you post the document or journal.';
                    Image = ViewPostedOrder;

                    trigger OnAction()
                    var
                        GenJnlPost: Codeunit 231;
                    begin
                        Rec.PreviewPosting;
                    end;
                }
                action(Post)
                {
                    Visible = false;
                    ApplicationArea = Basic, Suite;
                    CaptionML = ENU = 'Post';
                    Image = PostOrder;
                    ToolTipML = ENU = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                    trigger OnAction()
                    begin
                        if Rec.Balance <> 0 then
                            Error('You cannot post until the Balance is 0');
                        if Rec.Posted <> false then
                            Error('This Retirement Card has been posted');
                        Rec.PostRetirement;
                    end;
                }
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
                        //Promoted = true;
                        ////PromotedCategory = Process;
                        ShortCutKey = 'Ctrl+F9';

                        trigger OnAction()
                        var
                            RecRef: RecordRef;
                            ReleaseDocument: Codeunit "Release Documents";
                        begin
                            Rec.TestMandatoryFields();
                            RecRef.GetTable(Rec);
                            ReleaseDocument.PerformanualManualDocRelease(RecRef);
                            CurrPage.Update;
                        end;
                    }
                    action("Re&open")
                    {
                        ApplicationArea = Basic;
                        Image = ReOpen;
                        //Promoted = true;
                        ////PromotedCategory = Process;

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
                        Rec.TestMandatoryFields();
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
                // action(CancelApprovalRequest)
                // {
                //     ApplicationArea = All;

                //     trigger OnAction()
                //     begin
                //         IF Status = Status::Approved THEN
                //             ERROR('The document is already approved!');

                //         CAImprestMgt.SETRANGE("No.", "No.");
                //         IF CAImprestMgt.FINDFIRST THEN
                //             RecID := CAImprestMgt.RECORDID;
                //         DocumentApprovalWorkflow.CancelApprovalRequest(RecID.TABLENO, "No.");
                //         Status := Status::Open;
                //         MODIFY;
                //     end;

                // }
                // action(Approve)
                // {
                //     ApplicationArea = All;

                //     trigger OnAction()
                //     begin
                //         IF Status = Status::Approved THEN
                //             ERROR('The document is already approved!');

                //         //DocumentApprovalWorkflow.ApproveDocument(RecID.TABLENO,"No.",RecID);
                //         DocumentApprovalWorkflow.ApproveDocument("No.");
                //         IF DocumentApprovalWorkflow.ApprovalStatusCheck(RecID.TABLENO, "No.", RecID) THEN BEGIN
                //             Status := Status::Approved;
                //             MODIFY;
                //         END;
                //         IF CONFIRM('Do you want to open Cash Advance %1?', FALSE, "No.") THEN
                //             Page.Run(60023, CashAdvHr)
                //         ELSE
                //             EXIT;
                //     end;

                // }
                // action(Reject)
                // {
                //     ApplicationArea = All;

                //     trigger OnAction()
                //     begin
                //         IF Status = Status::Approved THEN
                //             ERROR('The document is already approved!');

                //         DocumentApprovalWorkflow.RejectDocument("No.");
                //         IF NOT DocumentApprovalWorkflow.ApprovalStatusCheck(RecID.TABLENO, "No.", RecID) THEN BEGIN
                //             Status := Status::Rejected;
                //             MODIFY;
                //         END;
                //     end;

                // }
                // action("Test Report")
                // {
                //     ApplicationArea = All;

                //     trigger OnAction()
                //     begin
                //         TestReport;
                //     end;

                // }
                // action(Preview)
                // {
                //     ApplicationArea = All;

                //     trigger OnAction()
                //     begin
                //         PreviewPosting;
                //     end;

                // }
                // action(Post)
                // {
                //     ApplicationArea = All;

                //     trigger OnAction()
                //     begin
                //         IF Posted = TRUE THEN
                //             ERROR('The Document has been posted previuosly!');
                //         PostCashAdavanceImprest;
                //     end;

                // }
                // action("Post and Print")
                // {
                //     ApplicationArea = All;

                //     trigger OnAction()
                //     begin
                //         IF Posted = TRUE THEN
                //             ERROR('The Document has been posted previuosly!');
                //         PostPrint;
                //     end;

                // }
            }

            action("Post and Print")
            {
                Visible = false;
                ApplicationArea = Basic, Suite;
                CaptionML = ENU = 'Post and Print';
                ToolTipML = ENU = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';
                Image = PostPrint;
                trigger OnAction()
                begin
                    Rec.PostPrint;
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
            action(Navigate)
            {
                Image = Navigate;
                ShortCutKey = 'Alt+D';
                ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                trigger OnAction()
                begin
                    Rec.Navigate();
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
                    ApprovalEntries.SetRecordFilters(Database::Retirement, 6, Rec."No.");
                    ApprovalEntries.Run;
                end;
            }
        }
    }


    trigger OnOpenPage()
    begin
        Rec.Balance := 0;
        IF Rec."No." <> '' THEN BEGIN
            Rec.CALCFIELDS("Total Line Amount");
            IF (Rec."Total Line Amount" <> 0) THEN
                Rec.Balance := Rec.Amount - Rec."Posted Balance" - Rec."Total Line Amount";
            Rec.MODIFY;
        END;
        EnableControl := true;
        if Rec.Status <> Rec.Status::Open then begin
            EnableControl := false;
        end;
    end;

    trigger OnClosePage()
    begin
        Rec.Balance := 0;
        IF Rec."No." <> '' THEN BEGIN
            Rec.CALCFIELDS("Total Line Amount");
            IF Rec."Total Line Amount" <> 0 THEN
                Rec.Balance := Rec.Amount - Rec."Posted Balance" - Rec."Total Line Amount";
            Rec.MODIFY;
        END;
    end;

    trigger OnAfterGetRecord()
    begin
        EnableFields;
        SetControlAppearance;
        IF Rec."No." <> '' THEN BEGIN
            Rec.CALCFIELDS("Total Line Amount");
            IF Rec."Total Line Amount" <> 0 THEN
                Rec.Balance := Rec.Amount - Rec."Posted Balance" - Rec."Total Line Amount";
            //Rec.MODIFY;
        END;
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
    end;

    var
        myInt: Integer;
        Text0001: TextConst ENU = 'The Document %1 has already been sent for approval!';
        //DocumentApprovalWorkflow: Codeunit "Document Approval Workflow";
        Retirement: Record Retirement;
        RecRef: RecordRef;
        RecID: RecordID;
        DocumentApprovalEntryS: Record "Document Approval Entry";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        EnableControl: Boolean;


}