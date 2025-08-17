Page 90235 "Payment Bank Mapping"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Payment Bank Mapping";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(BankCode; Rec."Bank Code")
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(BankAccountNo; Rec."Bank Account No.")
                {
                    ApplicationArea = All;
                }
                field(BankCBNCode; Rec."Bank CBN Code")
                {
                    ApplicationArea = All;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                }
                field(CreatedBy; Rec."Created By")
                {
                    ApplicationArea = All;
                }
                field(LastModifiedBy; Rec."Last Modified By")
                {
                    ApplicationArea = All;
                }
            }
            group(SingleViewBankDetails)
            {
                Caption = 'Single View Bank Details';
                field(Submitted; Rec.Submitted)
                {
                    ApplicationArea = All;
                }
                field(SubmissionResponseCode; Rec."Submission Response Code")
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
                field(SubmissionStatusCode; Rec."Submission Status Code")
                {
                    ApplicationArea = All;
                }
                field(AccountBalance; Rec."Account Balance")
                {
                    ApplicationArea = All;
                }
                field(NibbsBank; Rec."Nibbs Bank")
                {
                    ApplicationArea = All;
                }
            }
            group(CardDetails)
            {
                Caption = 'Card Details';
                field(CardPAN; Rec.CardPAN)
                {
                    ApplicationArea = All;
                }
                field(CardPINBlock; Rec.CardPINBlock)
                {
                    ApplicationArea = All;
                }
                field(CardExpiryDay; Rec.CardExpiryDay)
                {
                    ApplicationArea = All;
                }
                field(CardExpiryMonth; Rec.CardExpiryMonth)
                {
                    ApplicationArea = All;
                }
                field(CardExpiryYear; Rec.CardExpiryYear)
                {
                    ApplicationArea = All;
                }
                field(CardSequenceNumber; Rec.CardSequenceNumber)
                {
                    ApplicationArea = All;
                }
                field(CardTerminalId; Rec.CardTerminalId)
                {
                    ApplicationArea = All;
                }
                field(PaymentCurrencyCode; Rec."Payment Currency Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}

