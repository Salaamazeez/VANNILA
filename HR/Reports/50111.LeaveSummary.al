report 50111 LeaveSummary
{
    ApplicationArea = All;
    Caption = 'Leave Summary Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Leave Summary.rdl';

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";

            column(No; "No.")
            {
            }
            column(LastName; "Last Name")
            {
            }
            column(FirstName; "First Name")
            {
            }
            column(GlobalDimension1Code; "Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code; "Global Dimension 2 Code")
            {
            }
            column(Gender; Gender)
            {
            }
            column(LeaveEntitled; LeaveEntitled)
            {

            }
            column(LeaveBal; LeaveBal)
            {

            }
            column(LeaveUtilized; LeaveUtilized)
            {

            }
            column(LeaveYear; LeaveYear)
            {

            }
            column(LeaveType; LeaveType)
            {

            }
            column(CompInfoLogo; CompInfo.Picture)
            {

            }
            column(compInfoName; compInfo.Name)
            {

            }

            trigger OnPreDataItem()
            begin
                IF LeaveType = '' THEN
                    ERROR(ErrorType);

                IF LeaveYear = 0 THEN
                    ERROR(ErrorYear);

            end;

            trigger OnAfterGetRecord()
            begin
                CLEAR(LeaveBal);
                CLEAR(LeaveEntitled);
                CLEAR(LeaveUtilized);
                //CLEAR(EmpName);

                //EmpName := "Last Name" + ' ' + "First Name" + ' ' + "Middle Name";
                LeaveSetupLine.RESET;
                LeaveSetupLine.SETRANGE("Employee Zone", "Leave Setup Code");
                LeaveSetupLine.SETRANGE("Leave Code", LeaveType);
                IF LeaveSetupLine.FINDFIRST THEN BEGIN
                    LeaveSetupLine.TESTFIELD(Duration);
                END;

                EmpLeaveSetup.Reset();
                EmpLeaveSetup.SetRange("Employee No.", "No.");
                If EmpLeaveSetup.FindFirst() then
                    LeaveEntitled := EmpLeaveSetup."Leave Entitled"
                else
                    LeaveEntitled := LeaveSetupLine.Duration;

                EmpAbs.RESET;
                EmpAbs.SETRANGE("Employee No.", "No.");
                EmpAbs.SETRANGE("Cause of Absence Code", LeaveType);
                EmpAbs.SETRANGE("Leave Year", LeaveYear);
                IF EmpAbs.FINDSET THEN
                    REPEAT
                        LeaveUtilized += EmpAbs.Quantity;
                    UNTIL EmpAbs.NEXT = 0;

                LeaveBal := LeaveEntitled - LeaveUtilized;

            end;

            trigger OnPostDataItem()
            begin

            end;
        }

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Leave)
                {
                    field(LeaveYear; LeaveYear)
                    {
                        Caption = 'Leave Year';
                        ApplicationArea = All;
                    }
                    field(LeaveType; LeaveType)
                    {
                        Caption = 'Leave Type';
                        TableRelation = LeaveSetupLine."Leave Code";
                        ApplicationArea = All;
                    }

                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }

    }
    trigger OnInitReport()
    begin

    end;

    trigger OnPreReport()
    begin
        CompInfo.GET;
        CompInfo.CALCFIELDS(picture);

        //compName := CompInfo.Name;
    end;

    trigger OnPostReport()
    begin


    end;

    var
        LeaveEntitled: Integer;
        LeaveBal: Integer;
        LeaveUtilized: Integer;
        LeaveYear: Integer;
        LeaveType: Code[50];
        compName: Text[150];
        CompInfo: Record "Company Information";

        ErrorYear: Label 'Leave year must not be blank';
        ErrorType: Label 'Leave Type must not be blank';

        LeaveSetupLine: Record LeaveSetupLine;
        EmpLeaveSetup: Record EmployeeLeaveSetup;
        EmpAbs: Record "Employee Absence";

}
