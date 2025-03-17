report 50113 LeaveApplication
{
    ApplicationArea = All;
    Caption = 'LeaveApplication';
    UsageCategory = History;
    DefaultLayout = RDLC;
    RDLCLayout = 'LeaveApplication.rdl';

    dataset
    {
        dataitem(LeaveApplication; LeaveApplication)
        {
            DataItemTableView = sorting("Employee No.", "Leave Type", "First Day of Vacation");
            RequestFilterFields = "Leave Code", "Employee No.", "Leave Type", "Leave Year";

            column(Employee_No_; "Employee No.")
            { }
            column(Employee_Name; "Employee Name")
            { }
            column(Employee_Zone; "Employee Zone")
            { }
            column(DateOfEmp; DateOfEmp)
            { }
            column(ManagerName; ManagerName)
            { }
            column(First_Day_of_Vacation; "First Day of Vacation")
            { }
            column(Leave_End_Date; "Leave End Date")
            { }
            column(Leave_Type; "Leave Type")
            { }
            column(Requested_Days; "Requested Days")
            { }
            column(Leave_Year; "Leave Year")
            { }
            column(Resumption_Date; "Resumption Date")
            { }
            column(No__of_Leave_Days_Entitled; "No. of Leave Days Entitled")
            { }
            column(Current_Leave_Balance; "Current Leave Balance")
            { }
            column(On_Leave_Contact_Address; "On Leave Contact Address")
            { }
            column(Created_By; "Created By")
            { }
            column(CompInfoLogo; CompInfo.Picture)
            { }
            column(CompInfoName; CompInfo.Name)
            { }
            column(Leave_Code; "Leave Code")
            { }
            column(Supervisor_Name; "Supervisor Name")
            { }

            column(Balance_After_Current_Leave; "Balance After Current Leave")
            { }
            column(No__of_Days_Taken; "No. of Days Taken")
            { }

            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin
                IF EmployeeRec.GET("Employee No.") THEN
                    DateOfEmp := EmployeeRec."Employment Date";

                /*
                IF EmployeeRec2.GET(EmployeeRec."Manager No.") THEN  
                 Manager_name:= EmployeeRec2."Last Name"+' '+EmployeeRec2."First Name"
                ELSE
                  Manager_name:='';
                */
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }

    var
        DateOfEmp: Date;
        EmployeeRec: Record Employee;
        CompInfo: Record "Company Information";
        ManagerName: Text[200];

    trigger OnInitReport()
    begin

    end;

    trigger OnPreReport()
    begin
        CompInfo.get;
        CompInfo.CalcFields(Picture);
    end;
}
