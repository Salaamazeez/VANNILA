page 50120 LeaveSetup
{
    ApplicationArea = All;
    Caption = 'Leave Setup';
    PageType = Document;
    SourceTable = LeaveSetup;
    Editable = true;
    InsertAllowed = true;
    ModifyAllowed = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Leave Setup Code"; Rec."Leave Setup Code")
                {
                    ToolTip = 'Specifies the value of the Employee Zone';
                }

                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description of the Leave';
                }


                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the value of the Created By';
                }
                field("Created Date"; Rec."Created Date")
                {
                    ToolTip = 'Specifies the value of the Created Date';
                }
                field("Created Time"; Rec."Created Time")
                {
                    ToolTip = 'Specifies the value of the Created Time';
                }
            }
            part(LeaveSetupform; LeaveSetupSubform)
            {
                ApplicationArea = All;
                Caption = 'Leave Setup Subform';
                SubPageLink = "Employee Zone" = field("Leave Setup Code");
                UpdatePropagation = Both;
            }
        }
    }
}
