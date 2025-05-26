page 50010 "Approved Retirement Card"
{//Created by Akande
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Retirement;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    SourceTableView = WHERE(Posted = CONST(false), Status = FILTER(Approved));

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
                // field("Credit Account No."; Rec."Credit Account No.")
                // {
                //     ApplicationArea = All;
                // }
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

            part("Retirement Line Subform"; "Retirement Line Subform")

            {
                CaptionML = ENU = 'Lines';
                SubPageLink = "Document No." = FIELD("No.");
                ApplicationArea = Basic, Suite;
                UpdatePropagation = Both;

            }



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
            group(Action13)
            {
                Caption = 'Re&Open';
                Image = ReOpen;
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
                            RecRef.GetTable(Rec);
                            ReleaseDocument.PerformManualReopen(RecRef);
                            CurrPage.Update;
                        end;
                    }
                }
            }

            action("Create Bal. Voucher")
            {
                Visible = financeAdmin;
                Image = Create;
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
                    Rec.TestField(Status, Rec.Status::Approved);
                    Rec.TestMandatoryFields();
                    If Rec.Balance > 0 then
                        Error('You cannot create a Voucher');
                    if Rec."Cash Recpt No./Pmt Voucher" <> '' then
                        Error('vourcher already created');
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
                        PVHeader."Transaction type" := Rec."Transaction type";
                        PVHeader."Loan ID" := Rec."Loan ID";
                        PVHeader."Bal Account Type" := Rec."Debit  Account Type";
                        PVHeader."Bal Account No." := Rec."Debit Account No.";
                        PVHeader."Bal Account Name" := Rec."Debit Account Name";
                        PVHeader."Request Description" := Rec.Purpose;
                        PVHeader.Requester := Rec."Retiring Officer";
                        PVHeader."No. Series" := Rec."No. Series";
                        PVHeader.Status := Rec.Status::Open;
                        PVHeader.Type := Rec.Type;
                        PVHeader."Former PR No." := Rec."Retirement Ref.";
                        PurposeVar := Rec.Purpose;
                        PVHeader."Retirement No" := Rec."No.";
                        Rec."Cash Recpt No./Pmt Voucher" := PVHeaderNo;
                        PVHeader."Balance Posted" := true;
                        PVHeader."Shortcut Dimension 1 Code" := Rec."Shortcut Dimension 1 Code";
                        PVHeader."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
                        PVHeader."Dimension Set ID" := Rec."Dimension Set ID";
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
                        PVLine."Account Type" := PVLine."Account Type"::"Bank Account";
                        PVLine."Account No." := '';
                        PVLine.Validate(Amount, Abs(Rec.Balance));

                        PVLine.Insert();
                        // LineNo += 1;
                        //  until RetirementLine.Next() = 0;
                        //Retirement.Insert();
                    end;
                    // Retirement.Treated := true;
                    // Retirement."Voucher No" := PVHeaderNo
                    Rec.Modify();
                    page.Run(60002, PVHeader);

                end;
            }
            action("Create Cash Rcpt")
            {

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
                    if Rec."Cash Recpt No./Pmt Voucher" <> '' then
                        Error('Cash Receipt already created');
                    //Transfer Payment Requisition Header to Payment Voucher Header
                    CustSetup.GET;
                    CustSetup.TESTFIELD("Cash Receipt Nos.");
                    RetmntHeader.SetRange("No.", Rec."No.");
                    if RetmntHeader.FindFirst() then begin
                        CRcptHeader.TransferFields(RetmntHeader);
                        CRcptHdrNo := NoSeriesMgt.GetNextNo(CustSetup."Cash Receipt Nos.", TODAY, TRUE);
                        CRcptHeader."No." := CRcptHdrNo;
                        CRcptHeader."Transaction type" := Rec."Transaction type";
                        CRcptHeader."Loan ID" := Rec."Loan ID";
                        CRcptHeader."Credit Account Type" := CRcptHeader."Credit Account Type"::Staff;
                        CRcptHeader."Credit Account No." := RetmntHeader."Debit Account No.";
                        CRcptHeader."Debit  Account Type" := Rec."Credit Account Type"::"Bank Account";
                        CRcptHeader."Debit Account No." := '';
                        CRcptHeader."Retirement No." := Rec."No.";
                        CRcptHeader."Balance Posted" := true;
                        CRcptHeader.Status := CRcptHeader.Status::Open;
                        CRcptHeader.Validate(Balance);
                        RetmntLine.SetRange("Document No.", Rec."No.");
                        Rec."Cash Recpt No./Pmt Voucher" := CRcptHdrNo;
                        CRcptHeader.Treated := true;
                        CRcptHeader.Purpose := Rec.Purpose;
                        CRcptHeader.Insert();
                        Rec.Modify();

                    end;

                    // RetmntLine.SetRange("Document No.", Rec."No.");
                    // if RetmntLine.FindFirst() then begin
                    //     //  repeat
                    //     CRcptHeader."Credit Account Type" := RetmntLine."Account Type";
                    //     CRcptHeader."Credit Account No." := RetmntLine."Account No.";
                    //     CRcptHeader."Credit Account Name" := RetmntLine."Account Name";
                    //     CRcptHeader.Validate("Currency Code", RetmntLine."Currency Code");
                    //     //CRcptHeader.Validate(Amount, RetmntLine.Amount);
                    //     //CRcptLine.TransferFields(RetmntLine);
                    //     // PVLine."Document No." := NoSeriesMgt.GetNextNo(CustSetup."Payment Voucher No.", TODAY, TRUE);
                    //     //CRcptLine."Document No." := RetmntHdrNo;
                    //     //CRcptHeader.Modify();
                    //     //   until RetmntLine.Next() = 0;
                    // end;
                    page.Run(50169, CRcptHeader);
                    //  CAdvHeader.Modify();50169
                end;
            }



            action("Test Report")
            {
                ApplicationArea = Basic, Suites;
                Ellipsis = true;
                Image = TestReport;
                CaptionML = ENU = 'Test Report';
                ToolTipML = ENU = 'View a test report so that you can find and correct any errors before you perform the actual posting of the journal or document.';
                Visible = false;

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
                Visible = false;
                trigger OnAction()
                var
                    GenJnlPost: Codeunit 231;
                begin
                    Rec.PreviewPosting;
                end;
            }
            action(Post)
            {
                ApplicationArea = Basic, Suite;
                CaptionML = ENU = 'Post';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = PostOrder;
                ToolTipML = ENU = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';

                trigger OnAction()
                begin
                    CheckRetirementBalance();
                    Rec.PostRetirement;
                end;
            }
            action("Post and Print")
            {
                ApplicationArea = Basic, Suite;
                CaptionML = ENU = 'Post and Print';
                ToolTipML = ENU = 'Finalize and prepare to print the document or journal. The values and quantities are posted to the related accounts. A report request window where you can specify what to include on the print-out.';
                Promoted = true;
                PromotedIsBig = true;
                Image = PostPrint;
                PromotedCategory = Process;
                Visible = false;
                trigger OnAction()
                begin
                    CheckRetirementBalance();
                    Rec.PostPrint;
                end;
            }

        }
    }
    local procedure CheckRetirementBalance()
    var
        myInt: Integer;
        Err001: Label 'This Retirement Card has been posted';
        Err002: Label 'For non-loan retirement, you cannot post until the Balance is 0';
    begin
        if Rec.Posted <> false then
            Error(Err001);
        if (Rec.Balance <> 0) and (Rec."Loan ID" = '') then
            Error(Err002);
    end;

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin


        financeAdmin := UserSetup."Finance Admin";
        Rec.Balance := 0;
        IF Rec."No." <> '' THEN BEGIN
            Rec.CALCFIELDS("Total Line Amount");
            IF (Rec."Total Line Amount" <> 0) THEN
                Rec.Balance := Rec.Amount - Rec."Posted Balance" - Rec."Total Line Amount";
            Rec.MODIFY;
        END;
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
        IF Rec."No." <> '' THEN BEGIN
            Rec.CALCFIELDS("Total Line Amount");
            IF Rec."Total Line Amount" <> 0 THEN
                Rec.Balance := Rec.Amount - Rec."Posted Balance" - Rec."Total Line Amount";
            Rec.MODIFY;
        END;
    end;



    var
        myInt: Integer;
        Text0001: TextConst ENU = 'The Document %1 has already been sent for approval!';
        //DocumentApprovalWorkflow: Codeunit "Document Approval Workflow";
        Retirement: Record Retirement;
        RecRef: RecordRef;
        RecID: RecordID;
        DocumentApprovalEntryS: Record "Document Approval Entry";
        financeAdmin: boolean;
}