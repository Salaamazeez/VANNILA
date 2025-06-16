page 50123 LeaveApplicationList
{
    ApplicationArea = All;
    Caption = 'Leave Application List';
    PageType = List;
    SourceTable = LeaveApplication;
    SourceTableView = where(Status = const(Open));
    UsageCategory = Lists;
    CardPageId = LeaveApplicationCard;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Leave Code"; Rec."Leave Code")
                {
                    ToolTip = 'Specifies the value of the Leave Code.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description.';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ToolTip = 'Specifies the value of the Employee No.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name.';
                }
                field("Leave Type"; Rec."Leave Type")
                {
                    ToolTip = 'Specifies the value of the Leave Type.';
                }
                field("Leave Year"; Rec."Leave Year")
                {
                    ToolTip = 'Specifies the value of the Leave Year';
                }
                field("Approval Status"; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Approval Status.';
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        /*
        IF UserSetup.GET(USERID) THEN BEGIN
            IF (NOT UserSetup."HR Leave Administrator") THEN BEGIN
                FILTERGROUP(2);
                SETFILTER("Approval Status", '%1', "Approval Status"::Open);
                SETRANGE("User Id", USERID);
                FILTERGROUP(0);
            END ELSE BEGIN
                FILTERGROUP(2);
                SETFILTER("Approval Status", '%1', "Approval Status"::Open);
                FILTERGROUP(0);
            END;
        END;
        */
    end;
}
