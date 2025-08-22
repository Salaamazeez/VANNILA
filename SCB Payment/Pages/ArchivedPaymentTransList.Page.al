Page 90230 "Archived Payment Trans List"
{
    CardPageID = "Archived Payment Trans Card";
    Editable = false;
    PageType = List;
    SourceTable = "Posted Payment Trans Hdr";

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

