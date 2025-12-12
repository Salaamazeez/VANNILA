Page 90230 "Archived Payment Schedule List"
{
    CardPageID = "Archived Payment Schedule Card";
    Editable = false;
    PageType = List;
    SourceTable = "Posted Payment Schedule Hdr";
    UsageCategory = Lists;
    ApplicationArea = All;
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
                field(SubmisionResponse; Rec."Submision Response")
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
            }
        }
    }

    actions
    {
    }
}

