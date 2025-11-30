page 50900 "SWIFT/BIC Directory List"
{
    PageType = List;
    SourceTable = "SWIFT/BIC Directory";
    Caption = 'SWIFT/BIC Directory';
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = All;
                }
                field("Country Code"; Rec."Country Code")
                {
                    ApplicationArea = All;
                }
                field("City"; Rec."City")
                {
                    ApplicationArea = All;
                }
                field("Full SWIFT/BIC"; Rec."Full SWIFT/BIC")
                {
                    ApplicationArea = All;
                }
                field("Branch Code"; Rec."Branch Code")
                {
                    ApplicationArea = All;
                }
                field("Is Active"; Rec."Is Active")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    
}
