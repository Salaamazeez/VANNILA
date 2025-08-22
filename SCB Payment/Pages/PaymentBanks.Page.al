Page 90236 "Payment Window Banks"
{
    CardPageID = "Payment Bank Mapping";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "Payment Bank Mapping";

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
                field("Debit Account Id"; Rec."Debit Account Id")
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

