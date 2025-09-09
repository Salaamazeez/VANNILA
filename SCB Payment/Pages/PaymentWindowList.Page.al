Page 90238 "Payment Window List"
{
    CardPageID = "Payment Window Card";
    Editable = false;
    PageType = List;
    SourceTable = "Payment Window Header";
    ApplicationArea = All;
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(BatchNumber; Rec."Batch Number")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(SubmissionResponseCode; Rec."Submission Response Code")
                {
                    ApplicationArea = All;
                }
                field(BankCBNCode; Rec."Bank CBN Code")
                {
                    ApplicationArea = All;
                }
                field(BankName; Rec."Bank Name")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Caption = 'Approval for Submission';
                }
                field(TotalAmount; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }
                field("Date Created"; Rec."Date Created")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {

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
                    PmtTranSetup: Record "Payment Trans Setup";
                    PaymentIntegrHook: Codeunit "Payment-Integr. Hook";
                begin
                    // UserSetup.Get(UserId);
                    // if not (UserSetup."Send Payment Batch") then
                    //     Error(AdmTxt);
                    // UserSetup.TestField("Send Payment Batch");
                    // Rec.TestField(Status, Rec.Status::Approved);
                    PaymentIntegrHook.CreateSchedule(Rec)
                end;

            }

            action(SendBatch2)
            {
                ApplicationArea = All;
                Caption = 'Send Batch js';
                Image = SendElectronicDocument;
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'F9';
                ToolTip = 'Send the approved Payment batch to oktopus payment platform';
                trigger OnAction()
                var
                    UserSetup: Record "User Setup";
                    EnableErr: Label 'Kindly enable %1 on %2', Comment = '%1 is Use , %2 is Payment Setup';
                    PmtTranSetup: Record "Payment Trans Setup";
                    PaymentIntegrHook: Codeunit CreateSchedule;
                begin
                    // UserSetup.Get(UserId);
                    // if not (UserSetup."Send Payment Batch") then
                    //     Error(AdmTxt);
                    // UserSetup.TestField("Send Payment Batch");
                    // Rec.TestField(Status, Rec.Status::Approved);
                    PaymentIntegrHook.CreateSchedule(Rec)
                end;

            }

        }
    }

    var
        UserSetup: Record "User Setup";
    //PayrollPeriods: Page "Payroll Periods";
    //PayrollPeriodRec: Record "Payroll-Period";
}

