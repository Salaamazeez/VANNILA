report 50112 LeaveDeatil
{
    ApplicationArea = All;
    Caption = 'Leave Detail Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'Leave Detail.rdl';

    dataset
    {
        dataitem(EmployeeAbsence; "Employee Absence")
        {
            DataItemTableView = sorting("Employee No.", "Cause of Absence Code", "From Date");
            RequestFilterFields = "Employee No.", "Leave Year", "Cause of Absence Code";
            column(EmployeeNo; "Employee No.")
            { }
            column(LeaveYear; "Leave Year")
            { }
            column(LeaveCode; "Leave Code")
            { }
            column(ToDate; "To Date")
            { }
            column(FromDate; "From Date")
            { }
            column(Description; Description)
            { }
            column(Quantity; Quantity)
            { }
            column(RecalledAdjustmentReason; "Recalled/Adjustment Reason")
            { }
            column(LeaveRecalled; "Leave Recalled")
            { }
            column(LeaveApplication; "Leave Application")
            { }
            column(LeaveAdjustment; "Leave Adjustment")
            { }
            column(RecalledDate; "Recalled Date")
            { }
            column(AdjustmentType; "Adjustment Type")
            { }
            column(CauseofAbsenceCode; "Cause of Absence Code")
            { }
            column(GlobalDimension1Code; "Global Dimension 1 Code")
            { }
            column(GlobalDimension2Code; "Global Dimension 2 Code")
            { }
            column(EmpName; EmpName)
            { }
            column(CompInfoLogo; CompInfo.Picture)
            { }
            column(CompInfoName; CompInfo.Name)
            { }

            column(ReportFilter; ReportFilter)
            { }
            column(Sn; Sn)
            { }
            column(LeaveEntitled; LeaveEntitled)
            { }
            column(Total_Utilized; Total_Utilized)
            { }
            column(LeaveBal; LeaveBal)
            { }

            trigger OnPreDataItem()
            begin
                //CLEARALL;
                ReportFilter := EmployeeAbsence.GetFilters;

                EmpNo := EmployeeAbsence.GETFILTER("Employee No.");
                CAbsent := EmployeeAbsence.GETFILTER("Cause of Absence Code");
                LeaveYr := EmployeeAbsence.GETFILTER("Leave Year");

                IF (EmpNo = '') THEN
                    ERROR(ErrorEmpNo);

                IF (CAbsent = '') THEN
                    ERROR(ErroCAbs);

                IF (LeaveYr = '') THEN
                    ERROR(ErrorLeaveYear);

            end;

            trigger OnAfterGetRecord()
            begin
                Sn += 1;


                IF EmployeeRec.GET(EmployeeAbsence."Employee No.") THEN BEGIN
                    EmpName := EmployeeRec."Last Name" + ' ' + EmployeeRec."First Name" + ' ' + EmployeeRec."Middle Name";
                    //Department := EmployeeRec."Global Dimension 1 Code";
                    //branch := EmployeeRec."Global Dimension 2 Code";

                    LeaveSetupLn.RESET;
                    LeaveSetupLn.SETRANGE("Employee Zone", EmployeeRec."Leave Setup Code");
                    LeaveSetupLn.SETRANGE("Leave Code", CAbsent);
                    IF LeaveSetupLn.FINDFIRST THEN BEGIN
                        LeaveSetupLn.TESTFIELD(Duration);
                        //LeaveEntitled := LeaveSetupLn.Duration;
                    END;

                    EmpLeaveSetup.Reset();
                    EmpLeaveSetup.SetRange("Employee No.", EmployeeRec."No.");
                    If EmpLeaveSetup.FindFirst() then
                        LeaveEntitled := EmpLeaveSetup."Leave Entitled"
                    else
                        LeaveEntitled := LeaveSetupLn.Duration;

                END ELSE
                    CurrReport.SKIP;


                EmpAbs.RESET;
                EmpAbs.SETRANGE("Employee No.", "Employee No.");
                EmpAbs.SETRANGE("Cause of Absence Code", "Cause of Absence Code");
                EmpAbs.SETRANGE("Leave Year", "Leave Year");
                IF EmpAbs.FINDSET THEN
                    REPEAT
                        Total_Utilized += EmpAbs.Quantity;
                    UNTIL EmpAbs.NEXT = 0;

                LeaveBal := LeaveEntitled - ABS(Total_Utilized);
                //Total_Utilized:=Total_Utilized + Quantity;
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
        LeaveBal: Decimal;
        LeaveEntitled: Decimal;
        Total_Utilized: Decimal;
        Sn: Integer;
        EmpName: Text[200];
        CompInfo: Record "Company Information";
        EmployeeRec: Record Employee;
        ReportFilter: Text[200];
        LeaveSetupLn: Record LeaveSetupLine;
        EmpAbs: Record "Employee Absence";
        EmpLeaveSetup: Record EmployeeLeaveSetup;
        EmpNo: Code[50];
        CAbsent: Code[50];
        LeaveYr: Code[10];

        ErrorEmpNo: Label 'You must specify Employee No.';
        ErroCAbs: Label 'You must specify Cause of Absence Code';
        ErrorLeaveYear: Label 'You must specify Leave Year';

    trigger OnInitReport()
    begin

    end;

    trigger OnPreReport()
    begin
        CompInfo.GET;
        CompInfo.CALCFIELDS(Picture);
    end;
}