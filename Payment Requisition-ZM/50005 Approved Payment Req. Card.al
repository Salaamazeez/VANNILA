page 50007 "Approved Payment Req. Card"
{
    //Created by Akande
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Payment Requisition";
    SourceTableView = WHERE(Posted = CONST(false), Status = CONST(Approved));
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    layout
    {
        area(Content)
        {
            group(General)
            {

                field("No. "; Rec."No.")
                {
                    ApplicationArea = All;
                }

                field("Date"; Rec."Date")
                {
                    ApplicationArea = All;
                }
                field(Requester; Rec.Requester)
                {
                    ApplicationArea = All;
                }
                field("Request Description"; Rec."Request Description")
                {
                    ApplicationArea = All;
                }
                field("Transaction type"; Rec."Transaction type")
                {
                    ApplicationArea = All;
                }
                field("Loan ID"; Rec."Loan ID")
                {
                    ApplicationArea = All;
                }
                field("Purchase Requisition No."; Rec."Purchase Requisition No.")
                {
                    Visible = false;
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
                field(Beneficiary; Rec.Beneficiary)
                {
                    Visible = true;
                    ApplicationArea = All;
                }
                field("Beneficiary Name"; Rec."Beneficiary Name")
                {
                    Visible = true;
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
                field("Voucher Created?"; Rec."Voucher Created?")
                {
                    ApplicationArea = All;
                }

            }
            group(ListPart)
            {
                part("Payment Req. Subform"; "Payment Req. Subform")
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
                SubPageLink = "Table ID" = CONST(60000),
                              "No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Action13)
            {
                Caption = 'ReOpen';
                Image = ReleaseDoc;
                group(ReOpen)
                {

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
                            if Rec."Voucher Created?" then
                                Error('Voucher already has been created for this PR');
                            RecRef.GetTable(Rec);
                            ReleaseDocument.PerformManualReopen(RecRef);
                            CurrPage.Update;
                        end;
                    }
                }
            }

            action("Create Voucher")
            {
                Visible = financeAdmin;
                trigger OnAction()// var
                begin
                    Rec.TestMandatoryFields();
                    Rec.TestField(Status, Rec.Status::Approved);
                    if Rec."Transaction type" = Rec."Transaction type"::Loan then
                        Rec.TestField("Loan ID");
                    if Rec."Voucher Created?" then
                        Error('Voucher cannot be created more than once for each Payment Requisition');
                    //Transfer Payment Requisition Header to Payment Voucher Header
                    CustSetup.GET;
                    CustSetup.TESTFIELD("Payment Voucher No.");
                    PRHeader.SetRange("No.", Rec."No.");
                    if PRHeader.FindFirst() then begin
                        PVHeader.TransferFields(PRHeader);
                        PVHeaderNo := NoSeriesMgt.GetNextNo(CustSetup."Payment Voucher No.", TODAY, TRUE);
                        PVHeader."Former PR No." := PRHeader."No.";
                        PVHeader."No." := PVHeaderNo;
                        PVHeader.Status := PVHeader.Status::Open;
                        PVHeader."Transaction type" := Rec."Transaction type";
                        PVHeader."Loan ID" := Rec."Loan ID";
                        PVHeader.Beneficiary := Rec.Beneficiary;
                        PVHeader."Beneficiary Name" := Rec."Beneficiary Name";
                        PVHeader.Insert();
                        Rec."Voucher Created?" := true;

                        Rec.Modify();
                    end;
                    //Transfer Payment Requisition Line to Payment Voucher Line
                    PRLine.SetRange("Document No.", Rec."No.");
                    if PRLine.FindFirst() then begin
                        repeat
                            PVLine.TransferFields(PRLine);
                            PVLine."Document No." := PVHeaderNo;
                            PVLine.Validate("Account No.");
                            PVLine.Insert();
                        until PRLine.Next() = 0;
                    end;
                    IF CONFIRM('Do you want to open Payment Voucher %1?', FALSE, PVHeaderNo) THEN
                        page.Run(60002, PVHeader)
                    ELSE
                        EXIT;

                end;
            }
            // action(SendApprovalRequest)
            // {
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     begin
            //         CALCFIELDS("Request Amount (LCY)");
            //         IF Status = Status::Approved THEN ERROR('The document is already approved!');
            //         CALCFIELDS("Request Amount (LCY)");
            //         PaymentRequisition.SETRANGE("No.", "No.");
            //         IF PaymentRequisition.FINDFIRST THEN RecID := PaymentRequisition.RECORDID;
            //         DocumentApprovalWorkflow.SendApprovalRequest(RecID.TABLENO, "No.", RecID, 0);
            //         Status := Status::"Pending Approval";
            //         MODIFY;
            //     end;
            // }
            action("Send Approval Request")
            {
                Visible = false;
                ApplicationArea = All;


                // trigger OnAction()
                // begin
                //     //TestField("User Code 3");
                //     TotalAmount := Rec."Request Amount";
                //     PaymentRequisition.SETRANGE("No.", Rec."No.");
                //     IF PaymentRequisition.FINDFIRST THEN
                //         RecID := PaymentRequisition.RECORDID;
                //     // CALCFIELDS("Requisition Amount");
                //     LimDocumentApprovalWorkflow.SendApprovalRequest(RecID.TABLENO, Rec."No.", RecID, TotalAmount);
                //     // DocumentApprovalWorkflow.SendApprovalRequest(RecID.TABLENO,"No.",RecID,"Requisition Amount");
                //     //MESSAGE('Approval request has been sent');
                //     Rec.Status := Rec.Status::"Pending Approval";
                //     Rec.MODIFY;

                // end;
            }
            action(CancelApprovalRequest)
            {
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF Rec.Status = Rec.Status::Approved THEN ERROR('The document is already approved!');
                    PaymentRequisition.SETRANGE("No.", Rec."No.");
                    IF PaymentRequisition.FINDFIRST THEN RecID := PaymentRequisition.RECORDID;
                    //DocumentApprovalWorkflow.CancelApprovalRequest(RecID.TABLENO, Rec."No.");
                    Rec.Status := Rec.Status::Open;
                    Rec.MODIFY;
                end;
            }
            action(Approve)
            {
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF Rec.Status = Rec.Status::Approved THEN ERROR('The document is already approved!');
                    // DocumentApprovalWorkflow.ApproveDocument(Rec."No."); // I removed RecID.TABLENO and RecID to match the code unit
                    // IF DocumentApprovalWorkflow.ApprovalStatusCheck(RecID.TABLENO, Rec."No.", RecID) THEN BEGIN
                    //     Rec.Status := Rec.Status::Approved;
                    //     Rec.MODIFY;
                    // END;
                end;
            }
            action(Reject)
            {
                Visible = false;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    // IF Rec.Status = Rec.Status::Approved THEN ERROR('The document is already approved!');
                    // DocumentApprovalWorkflow.RejectDocument("No.");
                    // IF NOT DocumentApprovalWorkflow.ApprovalStatusCheck(RecID.TABLENO, "No.", RecID) THEN BEGIN
                    //     Rec.Status := Rec.Status::Rejected;
                    //     MODIFY;
                    // END;
                end;
            }
            action(Print)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    PaymentRequisition.SETRANGE("No.", Rec."No.");
                    IF PaymentRequisition.FINDFIRST THEN
                        REPORT.RUNMODAL(60022, TRUE, TRUE, PaymentRequisition);
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        // IF Rec.Status = Rec.Status::"Pending Approval" THEN BEGIN
        //     DocumentApprovalEntry.RESET;
        //     DocumentApprovalEntry.SETCURRENTKEY(Sequence, "Document No.");
        //     DocumentApprovalEntry.SETRANGE("Document No.", Rec."No.");
        //     DocumentApprovalEntry.SETRANGE("Table No.", 50011); //check 
        //     DocumentApprovalEntry.SETFILTER(DocumentApprovalEntry.Status, '%1', DocumentApprovalEntry.Status::Pending);
        //     IF DocumentApprovalEntry.FINDFIRST THEN BEGIN
        //         Rec."Current Pending Approver" := DocumentApprovalEntry.Approver;
        //         Rec.MODIFY(TRUE);
        //     END;
        // END;
    end;

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.Get(UserId);
        financeAdmin := UserSetup."Finance Admin";
    end;

    var
        NoSeriesMgt: Codeunit "No. Series";
        CustSetup: Record "Payment Mgt Setup";
        PVHeaderNo: Code[20];
        PRHeader: Record "Payment Requisition";
        PRLine: Record "Payment Requisition Line";
        PVHeader: Record "Payment Voucher Header";
        PVLine: Record "Payment Voucher Line";
        //DocumentApprovalWorkflow: Codeunit "Document Approval Workflow"; //50001 Document Approval Workflow
        PaymentRequisition: Record "Payment Requisition";
        RecRef: RecordRef;
        RecID: RecordID;
        PaymentRequisitionLine: Record "Payment Requisition Line";
        //DocumentApprovalEntry: Record "Document Approval Entry";
        TotalAmount: Decimal;
        financeAdmin: boolean;
}
