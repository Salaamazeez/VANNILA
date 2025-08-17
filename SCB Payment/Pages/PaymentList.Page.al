Page 90238 "Payment List"
{
    CardPageID = "Payment Card";
    Editable = false;
    PageType = List;
    SourceTable = "Payment Window Header";

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

        }
    }

    var
        UserSetup: Record "User Setup";
    //PayrollPeriods: Page "Payroll Periods";
    //PayrollPeriodRec: Record "Payroll-Period";
}

