Page 90234 "Payment Bank List"
{
    Caption = 'Payment Bank Mapping';
    Editable = false;
    PageType = Card;
    SourceTable = "Payment Bank Mapping";
    CardPageId = "Payment Bank Mapping";
    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
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
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        if CurrPage.LookupMode then CurrPage.Editable := false;
    end;
}

