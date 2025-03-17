page 50119 EmployeeLeaveSetup
{
    ApplicationArea = All;
    Caption = 'Employee Leave Setup';
    PageType = List;
    SourceTable = EmployeeLeaveSetup;
    UsageCategory = Tasks;
    Editable = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No.';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Employee Name';
                }
                field("Leave Entitled"; Rec."Leave Entitled")
                {
                    ToolTip = 'Specifies the value of the Leave Entitled';
                }
                field("Employment Date"; Rec."Employment Date")
                {
                    ToolTip = 'Specifies the value of the Employee Employment Date';
                }
                field("Year Employed"; Rec."Year Employed")
                {
                    ToolTip = 'Specifies the value of the Employee was Employed';
                }
                field("Employee Band"; Rec."Employee Band")
                {
                    ToolTip = 'Specifies the value of the Employee Band';
                }
                field("Employee Zone"; Rec."Employee Zone")
                {
                    ToolTip = 'Specifies the value of the Employee Zone';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code';
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code';
                }
                field("Shortcut Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ImportleaveEntiled)
            {
                ApplicationArea = All;
                Caption = 'Import Leave Entitled';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Import;

                trigger OnAction()
                begin
                    Report.Run(50110, true, false);
                end;
            }
        }
    }
}
