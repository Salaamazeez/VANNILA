page 90237 "Payment Window Card"
{
    PageType = Document;
    SourceTable = "Payment Schedule Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(BatchNumber; Rec."Batch Number")
                {
                    ToolTip = 'Specifies the value of the Batch Number field.';
                    ApplicationArea = All;
                }
                field(DateCreated; Rec."Date Created")
                {
                    ToolTip = 'Specifies the value of the Date Created field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field(CreateScheduleStatus; Rec."Create Schedule Status")
                {
                    ToolTip = 'Specifies the value of the Create Schedule Status field.';
                    ApplicationArea = All;
                }
                field(Submitted; Rec.Submitted)
                {
                    ToolTip = 'Specifies the value of the Submitted field.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(SubmissionResponse; Rec."Submission Response Code")
                {
                    ToolTip = 'Specifies the value of the Submission Response Code field.';
                    ApplicationArea = All;
                    Caption = 'Submission Response';
                    Editable = false;
                }
                field(CheckStatusResponse; Rec."Check Status Response")
                {
                    ToolTip = 'Specifies the value of the Check Status Response field.';
                    ApplicationArea = All;
                }
                field(APIPlatform; Rec."API Platform")
                {
                    ToolTip = 'Specifies the value of the API Platform field.';
                    ApplicationArea = All;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ToolTip = 'Specifies the value of the Total Amount field.';
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    ApplicationArea = All;
                    Caption = 'Approval for Submission';
                }
                field("Process Completed"; Rec."Process Completed")
                {
                    ToolTip = 'Specifies the value of the Process Completed field.';
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

            group("Payroll Details")
            {
                Visible = GetPayrollIsEnable;
                field(PayrollPayment; Rec."Payroll Payment")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        PensionRemittance := Rec."Payroll Payment" = Rec."Payroll Payment"::"Pension Remitance";
                    end;
                }
                field(MultipleRemittancePeriod; Rec."Multiple Remittance Period")
                {
                    ApplicationArea = Basic;
                    Editable = PensionRemittance;
                    Enabled = PensionRemittance;

                    trigger OnValidate()
                    begin
                        IsMultipleRemittancePeriod := Rec."Multiple Remittance Period" = true;
                    end;
                }
                field(PayrollPeriod; Rec."Payroll Period")
                {
                    ApplicationArea = Basic;
                    Enabled = not IsMultipleRemittancePeriod;
                }
                field(StartPeriod; Rec."Start Period")
                {
                    ApplicationArea = Basic;
                    Enabled = IsMultipleRemittancePeriod;
                }
                field(EndPeriod; Rec."End Period")
                {
                    ApplicationArea = Basic;
                    Enabled = IsMultipleRemittancePeriod;
                }
                field(PayrollEDCode; Rec."Payroll-E/DCode")
                {
                    ApplicationArea = Basic;
                }
                field(PayrollEDDescription; Rec."Payroll E/D Description")
                {
                    ApplicationArea = Basic;
                }
            }

            part(PaymentSubform; "Payment Subform")
            {
                Editable = PaymentSubformEditable;
                SubPageLink = "Batch Number" = field("Batch Number");
                ApplicationArea = Basic, Suite;
            }
            group(DebitBank)
            {
                Caption = 'Debit Bank';
                field(BankAccountCode; Rec."Bank Account Code")
                {
                    ToolTip = 'Specifies the value of the Bank Account Code field.';
                    ApplicationArea = All;
                }
                field(BankCBNCode; Rec."Bank CBN Code")
                {
                    ToolTip = 'Specifies the value of the Bank Account Code field.';
                    ApplicationArea = All;
                }
                field(BankAccountNumber; Rec."Bank Account Number")
                {
                    ToolTip = 'Specifies the value of the Bank Account Number field.';
                    ApplicationArea = All;
                }
                field(Balance; Rec.Balance)
                {
                    ToolTip = 'Specifies the value of the Balance field.';
                    Caption = 'Bank Account Balance';
                    ApplicationArea = All;
                }
                field(BankName; Rec."Bank Name")
                {
                    ToolTip = 'Specifies the value of the Bank Name field.';
                    ApplicationArea = All;
                }
                field("Debit Account Id"; Rec."Debit Account Id")
                {
                    ToolTip = 'Specifies the value of the Debit Account Id field.';
                    Editable = false;
                    Visible = true;
                    ApplicationArea = All;
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the value of the Currency Code field.';
                    ApplicationArea = All;
                }
                field(GlobalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                    ApplicationArea = All;
                }
                field(GlobalDimension1CodeDesc; Rec."Global Dimension 1 Code Desc")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code Desc field.';
                    ApplicationArea = All;
                }
            }
            group(Statistics)
            {
                Caption = 'Statistics';
                field(Createdby; Rec."Created by")
                {
                    ToolTip = 'Specifies the value of the Created by field.';
                    ApplicationArea = All;
                }
                field(Lastmodifiedby; Rec."Last modified by")
                {
                    ToolTip = 'Specifies the value of the Batch Number field.';
                    ApplicationArea = All;
                }
                field(LastModifiedDate; Rec."Last Modified Date")
                {
                    ToolTip = 'Specifies the value of the Batch Number field.';
                    ApplicationArea = All;
                }
                field(Submittedby; Rec."Submitted by")
                {
                    ToolTip = 'Specifies the value of the Batch Number field.';
                    ApplicationArea = All;
                }
                field(DateSubmitted; Rec."Date Submitted")
                {
                    ToolTip = 'Specifies the value of the Batch Number field.';
                    ApplicationArea = All;
                }
                field(RecordCount; Rec."Record Count")
                {
                    ToolTip = 'Specifies the value of the Batch Number field.';
                    ApplicationArea = All;
                }
                field(TotalAmount; Rec."Total Amount")
                {
                    ToolTip = 'Specifies the value of the Batch Number field.';
                    ApplicationArea = All;
                }
                field(OldBatchNumber; Rec."Old Batch Number")
                {
                    ToolTip = 'Specifies the value of the Batch Number field.';
                    ApplicationArea = All;
                    Visible = false;
                }
            }
            group(Notification)
            {
                Caption = 'Notification';
                Visible = false;
                field(RecipientEmail; Rec."Recipient Email")
                {
                    ToolTip = 'Specifies the value of the Batch Number field.';
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            part(Control66; "Pending Approval FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Table ID" = const(52092309),
                              "Document Type" = const(6),
                              "Document No." = field("Batch Number");
                Visible = OpenApprovalEntriesExistForCurrUser;
            }
            part(Control65; "Approval FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Table ID" = const(52092309),
                              "Document Type" = const(6),
                              "Document No." = field("Batch Number");
                Visible = false;
            }
            part(WorkflowStatus; "Workflow Status FactBox")
            {
                ApplicationArea = All;
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                Visible = ShowWorkflowStatus;
            }
            systempart(Control60; Links)
            {
                ApplicationArea = All;
                Visible = false;
            }
            systempart(Control34; Notes)
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Function")
            {
                Caption = '&Function';
                action(GetGLJournal)
                {
                    ApplicationArea = All;
                    Caption = 'Get Payment Journal';
                    Image = GetEntries;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'To view and get journal lines';
                    trigger OnAction()
                    var
                        GetGLJournal: Codeunit "Payment - Get Payment";
                    begin
                        Rec.TestField(Status, Rec.Status::Open);
                        if Rec.Submitted then
                            Error(BatchNoTxt, Rec."Batch Number");
                        GetGLJournal.Run(Rec)
                    end;
                }
                action(GetPaymentVouchers)
                {
                    ApplicationArea = Basic;
                    Caption = 'Get Payment Vouchers';
                    Image = GetEntries;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        PaymentPayment: Codeunit "Payment - Get Payment";
                    begin
                        Rec.TestField(Status, Rec.Status::Open);
                        if Rec.Submitted then
                            Error(Text004, Rec."Batch Number");

                        PaymentPayment.GetPaymentVoucher(Rec);
                    end;
                }
                action(GetPayrollEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Get Payroll Entries';
                    Enabled = GetPayrollIsEnable;
                    Image = GetEntries;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        UserSetup: Record "User Setup";
                    //ClosedPayrollPayslipHeader: Record "Closed Payroll-PayslipHder";
                    begin
                        Rec.TestField(Status, Rec.Status::Open);
                        if Rec.Submitted then
                            Error(Text004, Rec."Batch Number");
                        // TestField("Payroll-E/DCode");
                        // TestField("Payroll Payment");
                        //GetPayrollEntries.CreatePayrollEntries(ClosedPayrollPayslipHeader)
                        //GetPayrollEntries.Run(Rec)
                    end;
                }

                action(SendBatch)
                {
                    ApplicationArea = All;
                    Caption = 'Send Batch';
                    Image = SendElectronicDocument;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'F9';
                    ToolTip = 'Send the approved Payment batch to oktopus payment platform';
                    trigger OnAction()
                    var
                        UserSetup: Record "User Setup";
                        EnableErr: Label 'Kindly enable %1 on %2', Comment = '%1 is Use , %2 is Payment Setup';
                    begin
                        PmtTranSetup.Get();
                        if PmtTranSetup."Use Pmt Authomation" then begin
                            if CONFIRM('Do you want to send batch', TRUE, false) then
                                PaymentIntegrHook.CreateSchedule(Rec)
                        end else
                            Error(EnableErr, PmtTranSetup.FieldCaption("Use Pmt Authomation"), PmtTranSetup.TableCaption);
                    end;

                }
                action(UpdateSchedule)
                {
                    ApplicationArea = All;
                    Caption = 'Update Schedule';
                    Image = SendElectronicDocument;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'F7';
                    ToolTip = 'Send the approved Payment batch to oktopus payment platform';
                    trigger OnAction()
                    var
                        UserSetup: Record "User Setup";
                        EnableErr: Label 'Kindly enable %1 on %2', Comment = '%1 is Use , %2 is Payment Setup';
                    begin
                        UserSetup.Get(UserId);
                        if not (UserSetup."Send Payment Batch") then
                            Error(AdmTxt);
                        UserSetup.TestField("Send Payment Batch", true);
                        Rec.TestField(Status, Rec.Status::Approved);
                        //PaymentIntegrHook.GetPaymentUpdate(Rec);

                    end;

                }
                separator(Action30)
                {
                }
                separator(Action28)
                {
                }
                action(RecreateScheduleArchive)
                {
                    ApplicationArea = All;
                    Caption = 'Recreate Schedule & Archive';
                    Image = CreateDocument;
                    ToolTip = 'To recreate schedule and archive';
                    trigger OnAction()
                    begin
                        if not Confirm(CreateScheduleTxt) then
                            Error(StopCreateTxt);
                        if StrMenu('Recreate,Archive Only', 1, 'Select an action') = 1 then
                            Rec.Recreate()
                        else
                            Rec.ArchiveOnly();
                    end;
                }
                action(Post)
                {
                    ApplicationArea = All;
                    Image = Post;
                    ToolTip = 'To post the ';
                    trigger OnAction()
                    var
                        PostEPayment: Codeunit "Post E-Payment";
                    begin
                        PostEPayment.RUN(Rec);
                    end;
                }
            }
            group(Release)
            {

                action("Re&lease")
                {
                    ApplicationArea = All;
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    ShortCutKey = 'Ctrl+F9';
                    ToolTip = 'Release the document to the next stage of processing. You must reopen the document before you can make changes to it.';
                    trigger OnAction()
                    var
                        ReleaseDocument: Codeunit "Release Documents";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        ReleaseDocument.PerformanualManualDocRelease(RecRef);
                        CurrPage.Update();
                    end;
                }
                action("Re&open")
                {
                    ApplicationArea = All;
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.';
                    trigger OnAction()
                    var
                        ReleaseDocument: Codeunit "Release Documents";
                        RecRef: RecordRef;
                    begin
                        Rec.TestField(Submitted, false);
                        RecRef.GetTable(Rec);
                        ReleaseDocument.PerformManualReopen(RecRef);
                        CurrPage.Update();
                    end;
                }

            }

        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        ShowWorkflowStatus := CurrPage.WorkflowStatus.Page.SetFilterOnWorkflowRecord(Rec.RecordId);
    end;



    trigger OnDeleteRecord(): Boolean
    begin
        Rec.TestField(Status, Rec.Status::Open);
        Rec.TestField(Submitted, false);
        TransLine.SetRange("Batch Number", Rec."Batch Number");
        TransLine.DeleteAll();
        //GeneralJournalLine.SetRange("Payment ID", Rec."Batch Number");
        // if GeneralJournalLine.Find('-') then
        //     repeat
        //         GeneralJournalLine."Payment ID" := '';
        //         GeneralJournalLine.Modify();
        //     until GeneralJournalLine.Next() = 0;
    end;

    trigger OnInit()
    begin
        PaymentSubformEditable := true;
        PmtTranSetup.Get;
        GetPayrollIsEnable := PmtTranSetup."Get Payroll on Payment";
        EditPeriod := PmtTranSetup."Get Payroll on Payment";
    end;

    trigger OnModifyRecord(): Boolean
    begin
        Rec.TestField(Status, Rec.Status::Open);

    end;

    trigger OnAfterGetRecord()
    begin
        //SetControlAppearance;
        PensionRemittance := Rec."Payroll Payment" = Rec."Payroll Payment"::"Pension Remitance";
        IsMultipleRemittancePeriod := Rec."Multiple Remittance Period" = true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        PmtTranSetup.Get();
        Rec."General Journal Template" := PmtTranSetup."General Journal Template";
        Rec."General Journal Batch" := PmtTranSetup."General Journal Batch";
        Rec."Payment Method" := PmtTranSetup."Payment Method";
    end;

    trigger OnOpenPage()
    begin
    end;

    var
        TransLine: Record "Payment Schedule Line";
        PmtTranSetup: Record "Payment Schedule Setup";
        GeneralJournalLine: Record "Gen. Journal Line";
        PaymentIntegrHook: Codeunit "Payment-Integr. Hook";
        BatchNoTxt: label 'Batch Number %1 has already been submitted', comment = '%1 is the Batch Numbe';
        PaymentSubformEditable: Boolean;
        CreateScheduleTxt: label 'Do you want to recreate this schedule?';
        StopCreateTxt: label 'Recreation stopped';
        AdmTxt: label 'This function can only be performed by the MD \\ Kindly contact your Administrator';
        OpenApprovalEntriesExistForCurrUser: Boolean;
        ShowWorkflowStatus: Boolean;
        GetPayrollIsEnable: Boolean;
        //GetPayrollEntries: Codeunit "Payment - Get Payroll Entries";
        EditPeriod: Boolean;
        Text004: label 'Batch Number %1 has already been submitted';
        PensionRemittance: Boolean;
        IsMultipleRemittancePeriod: Boolean;
    //PensionRemittanceReport: Report "Pension Remittance";

}