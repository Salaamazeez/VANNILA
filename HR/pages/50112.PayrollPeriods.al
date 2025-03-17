page 50112 PayrollPeriods
{
    ApplicationArea = All;
    Caption = 'Payroll Periods';
    PageType = List;
    SourceTable = 50111;
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Period Code"; Rec."Period Code")
                {
                    ToolTip = 'Specifies the value of the Period Code';
                }
                field("Period Name"; Rec."Period Name")
                {
                    ToolTip = 'Specifies the value of the Period Name';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Period Start Date';
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'Specifies the value of the Period End Date';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(CreatePeriods)
            {
                Caption = 'Create Payroll Periods';
                ApplicationArea = All;
                Image = Period;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                RunObject = Report 50102;
            }
        }
    }
}
