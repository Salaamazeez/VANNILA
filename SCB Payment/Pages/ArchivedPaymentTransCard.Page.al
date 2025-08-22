Page 90229 "Archived Payment Trans Card"
{
    Editable = false;
    PageType = Document;
    SourceTable = "Posted Payment Trans Hdr";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(BatchNumber; Rec."Batch Number")
                {
                    ApplicationArea = All;
                }
                field(DateCreated; Rec."Date Created")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Submitted; Rec.Submitted)
                {
                    ApplicationArea = All;
                }
                field(SubmissionResponse; Rec."Submision Response")
                {
                    ApplicationArea = All;
                    Caption = 'Submission Response';
                }
                field(CheckStatusResponse; Rec."Check Status Response")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Caption = 'Approval for Submission';
                }
            }
            part(PaymentSubform; "Archived Payment Trans Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Batch Number" = field("Batch Number");
            }
            group(DebitBank)
            {
                Caption = 'Debit Bank';
                field(BankAccountCode; Rec."Bank Account Code")
                {
                    ApplicationArea = All;
                }
                field(BankCBNCode; Rec."Bank CBN Code")
                {
                    ApplicationArea = All;
                }
                field(BankAccountNumber; Rec."Bank Account Number")
                {
                    ApplicationArea = All;
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = All;
                }
                field(BankName; Rec."Bank Name")
                {
                    ApplicationArea = All;
                }
            }
            group(Statistics)
            {
                Caption = 'Statistics';
                field(Createdby; Rec."Created by")
                {
                    ApplicationArea = All;
                }
                field(Lastmodifiedby; Rec."Last modified by")
                {
                    ApplicationArea = All;
                }
                field(LastModifiedDate; Rec."Last Modified Date")
                {
                    ApplicationArea = All;
                }
                field(Submittedby; Rec."Submitted by")
                {
                    ApplicationArea = All;
                }
                field(DateSubmitted; Rec."Date Submitted")
                {
                    ApplicationArea = All;
                }
                field(RecordCount; Rec."Record Count")
                {
                    ApplicationArea = All;
                }
                field(TotalAmount; Rec."Total Amount")
                {
                    ApplicationArea = All;
                }
                field(OldBatchNumber; Rec."Old Batch Number")
                {
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
                    ApplicationArea = All;
                }
                label(Control1000000029)
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = true;
                }
            }
        }
    }

    actions
    {
    }
}

