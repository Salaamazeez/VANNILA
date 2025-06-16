page 50125 ApproveLeaveApplicationList
{
    ApplicationArea = All;
    Caption = 'Approved Leave Application List';
    PageType = List;
    SourceTable = LeaveApplication;
    UsageCategory = Lists;
    CardPageId = LeaveApplicationCard;
    SourceTableView = where(Status = const(Approved));
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;

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
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Leave Description.';
                }
                field("Leave Year"; Rec."Leave Year")
                {
                    ToolTip = 'Specifies the value of the Leave Year';
                }
                field("Approval Status"; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Leave Approval Status.';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code.';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code.';
                }
                field("Employee Zone"; Rec."Employee Zone")
                {
                    ToolTip = 'Specifies the value of the Employee Zone.';
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        /*
                IF UserSetup.GET(USERID) THEN
                    IF (NOT UserSetup."HR Leave Administrator") THEN BEGIN
                        FILTERGROUP(2);
                        SETFILTER("Approval Status", '%1', "Approval Status"::Approved);
                        SETRANGE("User Id", USERID);
                        FILTERGROUP(0);
                    END ELSE BEGIN
                        FILTERGROUP(2);
                        SETFILTER("Approval Status", '%1', "Approval Status"::Approved);
                        FILTERGROUP(0);
                    END;
        */
    end;

}
