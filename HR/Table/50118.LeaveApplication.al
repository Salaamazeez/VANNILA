table 50118 LeaveApplication
{
    Caption = 'Leave Application';
    DataClassification = ToBeClassified;
    LookupPageId = 50123;

    fields
    {
        field(1; "Leave Code"; Code[20])
        {
            Caption = 'Leave Code';
            Editable = false;

            trigger OnValidate()
            begin
                if ("Leave Code" <> xRec."Leave Code") then begin
                    HRMSetup.GET;
                    NoSeriesMgt.TestManual(HRMSetup."Leave Nos");
                    //NoSeries.TestManual(HRMSetup."Leave Nos");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            NotBlank = true;
            TableRelation = Employee."No.";

            trigger OnValidate()
            begin

                IF "Employee No." = '' THEN BEGIN
                    CLEAR("Global Dimension 1 Code");
                    CLEAR("Global Dimension 2 Code");
                    CLEAR("Employee Zone");
                    CLEAR("Employee Category");
                    CLEAR("Employee Type");
                    CLEAR("Employee Name");
                    CLEAR("Supervisor Name");
                    CLEAR("Leave Setup Code");
                    CLEAR("User Id");
                    CLEAR("Mgr UserId");
                    Clear("Applying Type");


                    VALIDATE("First Day of Vacation", 0D);
                    VALIDATE("Leave End Date", 0D);
                    VALIDATE("Leave Type", '');
                END;
                TestStatusOpen;
                TESTFIELD("Applying Type");


                IF EmployeeRec.GET("Employee No.") THEN BEGIN
                    //EmployeeRec.TESTFIELD(Zone);
                    EmployeeRec.TESTFIELD("Manager No.");
                    EmployeeRec.TESTFIELD("Leave Setup Code");
                    //EmployeeRec.TESTFIELD("Approval Status", EmployeeRec."Approval Status"::Approved);

                    IF SupervisorEmp.GET(EmployeeRec."Manager No.") THEN
                        "Supervisor Name" := SupervisorEmp."First Name" + ' ' + SupervisorEmp."Middle Name" + ' ' + SupervisorEmp."Last Name"
                    ELSE
                        "Supervisor Name" := '';

                    "Global Dimension 1 Code" := EmployeeRec."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := EmployeeRec."Global Dimension 2 Code";
                    //"Shortcut Dimension 3 Code" := EmployeeRec."Shortcut Dimension 3 Code";
                    //"Shortcut Dimension 4 Code" := EmployeeRec."Shortcut Dimension 4 Code";
                    //"Employee Category" := EmployeeRec."Employee Category";
                    //"Employee Type" := EmployeeRec."Employee Type";
                    //"Employee Zone" := EmployeeRec.Zone;
                    //"Leave Setup Code" := EmployeeRec."Leave Setup Code";
                    "Employee Name" := EmployeeRec."First Name" + ' ' + EmployeeRec."Middle Name" + ' ' + EmployeeRec."Last Name";
                    "Current Residential Address" := EmployeeRec.Address;

                    "Mgr UserId" := UserSetup."Approver ID";
                end;
            end;
        }
        field(3; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
        }
        field(4; "First Day of Vacation"; Date)
        {
            Caption = 'First Day of Vacation';

            trigger OnValidate()
            begin
                TestStatusOpen;

                if ("First Day of Vacation" <> 0D) then
                    if (DATE2DMY("First Day of Vacation", 3) <> DATE2DMY(TODAY, 3)) then
                        ERROR(Text004, FIELDCAPTION("First Day of Vacation"), DATE2DMY(TODAY, 3), FIELDCAPTION("First Day of Vacation"));

                CLEAR("Leave End Date");
                CLEAR("Requested Days");
                CLEAR("Leave Type");
                CLEAR(Description);
                CLEAR("Resumption Date");

                if "First Day of Vacation" = 0D then begin
                    "Effective Date" := 0D;
                    "Days Processed" := 0;
                    "Resumption Date" := 0D;

                    "No. of Leave Days Entitled" := 0;
                    "No. of Days Taken" := 0;
                    "Current Leave Balance" := 0;
                    "Requested Days" := 0;
                    "Balance After Current Leave" := 0;
                end;
            end;
        }
        field(5; "Leave End Date"; Date)
        {
            Caption = 'Leave End Date';
            trigger OnValidate()
            begin
                TestStatusOpen;

                TESTFIELD("First Day of Vacation");
                if "Leave End Date" <> 0D then
                    IF (DATE2DMY("Leave End Date", 3) <> DATE2DMY(TODAY, 3)) then
                        ERROR(Text004, FIELDCAPTION("Leave End Date"), DATE2DMY(TODAY, 3), FIELDCAPTION("Leave End Date"));

                CLEAR("Leave Type");
                CLEAR("Requested Days");
                CLEAR(Description);
                CLEAR("Resumption Date");

                if ("Leave End Date" <> 0D) then begin
                    if ("Leave End Date" < "First Day of Vacation") then
                        ERROR(Text001);
                end;

                if ("Leave End Date" = 0D) then begin
                    "Effective Date" := 0D;
                    "Days Processed" := 0;
                    "Resumption Date" := 0D;

                    "No. of Leave Days Entitled" := 0;
                    "No. of Days Taken" := 0;
                    "Current Leave Balance" := 0;
                    "Requested Days" := 0;
                    "Balance After Current Leave" := 0;
                end;

            end;
        }
        field(6; "Leave Type"; Code[10])
        {
            Caption = 'Leave Type';
            TableRelation = "Cause of Absence";

            trigger OnValidate()
            begin
                TestStatusOpen;

                if ("Leave Type" <> '') then begin
                    IF EmployeeRec.GET("Employee No.") THEN BEGIN
                        EmployeeRec.TestField("Leave Setup Code");
                    END;

                    LeaveApp.RESET;
                    LeaveApp.SETRANGE("Employee No.", "Employee No.");
                    LeaveApp.SETRANGE("Leave Type", "Leave Type");
                    //LeaveApp.SETFILTER("Approval Status", '%1', LeaveApp.Status::Open);
                    LeaveApp.SETFILTER(Status, '%1|%2|%3', LeaveApp.Status::Open, LeaveApp.Status::"Pending Approval", LeaveApp.Status::Approved);
                    if LeaveApp.FINDFIRST then begin
                        if (LeaveApp.Status = LeaveApp.Status::Open) then
                            ERROR(Text012, LeaveApp."Leave Type", LeaveApp."Leave Code");
                        if (LeaveApp.Status = LeaveApp.Status::"Pending Approval") THEN
                            ERROR(Text017, LeaveApp."Leave Type", LeaveApp."Leave Code");
                        if (LeaveApp.Status = LeaveApp.Status::Approved) THEN
                            ERROR(Text018, LeaveApp."Leave Type", LeaveApp."Leave Code");
                    end;

                    TESTFIELD("First Day of Vacation");
                    TESTFIELD("Leave End Date");

                    HRMSetup.GET;
                    if (EmpLvSetup.get("Employee No.")) then begin
                        EmpLvSetup.TestField("Leave Entitled");

                    end else if (NOT LeaveSetupLine.GET(EmployeeRec."Leave Setup Code", "Leave Type")) then
                            ERROR(Text007, EmployeeRec."Leave Setup Code")
                    else begin
                        if ("Leave Type" <> HRMSetup."Day-Off Leave Code") then
                            if ("Leave Type" <> HRMSetup."Sick Leave Code") then
                                if ("Leave Type" <> HRMSetup."Out-Duty Leave Code") then
                                    //if ("Leave Type" <> HRMSetup."Company Leave Code") then
                                        LeaveSetupLine.TESTFIELD(Duration);
                    END;

                    CauseOfAbsence.Get("Leave Type");
                    Description := CauseOfAbsence.Description;
                    VALIDATE("Unit of Measure Code", CauseOfAbsence."Unit of Measure Code");
                    "Leave Year" := DATE2DMY("First Day of Vacation", 3);

                    //To check if leve already exit within the specify dates
                    CheckExistLeaveWithinPeriod;

                    //Get Requested Days
                    EmployeeRec.RESET;
                    EmployeeRec.SETRANGE("No.", "Employee No.");
                    EmployeeRec.SETFILTER(Status, '<>%1', EmployeeRec.Status::Terminated);
                    //EmployeeRec.SETRANGE("Approval Status",EmployeeRec."Approval Status" ::Approved);
                    if EmployeeRec.FINDFIRST then begin
                        //EmployeeRec.TESTFIELD(Zone);
                        "Requested Days" := GetNoOfDays;

                        //"Leave Code":=FORMAT("Leave Type")+FORMAT("First Day of Vacation");
                        "Effective Date" := "First Day of Vacation";
                        "Days Processed" := NoOfDays;
                        "Resumption Date" := "Leave End Date" + 1;

                        if (NOT EmpLvSetup.GET(EmployeeRec."No.")) then
                            "No. of Leave Days Entitled" := LeaveSetupLine.Duration
                        else begin
                            EmpLvSetup.TESTFIELD("Leave Entitled");
                            "No. of Leave Days Entitled" := EmpLvSetup."Leave Entitled";
                        end;
                        "No. of Days Taken" := LeaveUtilised;
                        IF (NOT EmpLvSetup.GET(EmployeeRec."No.")) then begin
                            "Current Leave Balance" := LeaveSetupLine.Duration - LeaveUtilised;
                        end else begin
                            "Current Leave Balance" := EmpLvSetup."Leave Entitled" - LeaveUtilised;
                        end;

                        "Requested Days" := NoOfDays;
                        IF (NOT EmpLvSetup.GET(EmployeeRec."No.")) then begin
                            "Balance After Current Leave" := LeaveSetupLine.Duration - (LeaveUtilised + NoOfDays);
                        end else begin
                            "Balance After Current Leave" := EmpLvSetup."Leave Entitled" - (LeaveUtilised + NoOfDays);
                        end;

                        "No. of Public Holiday" := NoOfPHs;
                        "No. of Saturdays" := NoOfSaturdays;
                        "No. of Sundays" := NoOfSundays;

                        //MODIFY;
                    end else
                        ERROR(Text003, "Employee Name");
                end;

                IF ("Leave Type" = '') then begin
                    "Effective Date" := 0D;
                    "Days Processed" := 0;
                    "Resumption Date" := 0D;

                    "No. of Leave Days Entitled" := 0;
                    "No. of Days Taken" := 0;
                    "Current Leave Balance" := 0;
                    "Requested Days" := 0;
                    "Balance After Current Leave" := 0;
                end;
            end;
        }
        field(7; "Requested Days"; Integer)
        {
            Caption = 'Requested Days';
            Editable = false;
        }
        field(8; Description; Text[100])
        {
            Caption = 'Description';
            Editable = true;
        }
        field(9; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            Editable = false;
            TableRelation = "Human Resource Unit of Measure";
        }
        field(10; "Supervisor Comment"; Text[150])
        {
            Caption = 'Supervisor Comment';
        }
        field(11; "Leave Setup Code"; Code[20])
        {
            Caption = 'Leave Setup Code';
            TableRelation = LeaveSetup."Leave Setup Code";
        }
        field(12; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            CaptionClass = '1,1,1';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(13; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
            CaptionClass = '1,1,2';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(14; "Employee Type"; Option)
        {
            Caption = 'Employee Type';
            OptionMembers = " ",Permanent,Contract;
            Editable = false;
        }
        field(15; "Employee Category"; Option)
        {
            Caption = 'Employee Category';
            OptionMembers = " ",Local,Expatriate;
            Editable = false;
        }
        field(16; "Employee Zone"; Code[10])
        {
            Caption = 'Employee Zone';
            //TableRelation = EmployeeBandHeader."Employee Zone";
            Editable = false;
        }
        field(17; "Employee Branch"; Code[20])
        {
            Caption = 'Employee Branch';
            Editable = false;
        }
        field(18; "Leave Year"; Integer)
        {
            Caption = 'Leave Year';
            Editable = false;
        }
        field(19; Status; Option)
        {
            Caption = 'Approval Status';
            OptionMembers = Open,"Pending Approval",Approved,Posted;
            Editable = false;
        }
        field(20; "Resumption Date"; Date)
        {
            Caption = 'Resumption Date';
            Editable = false;
        }
        field(21; "Effective Date"; Date)
        {
            Caption = 'Effective Date';
            Editable = false;
        }
        field(22; "Days Processed"; Integer)
        {
            Caption = 'Days Processed';
            Editable = false;
        }
        field(23; "HR Comment"; Text[150])
        {
            Caption = 'HR Comment';
        }
        field(24; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            Editable = false;
        }
        field(25; "Supervisor Name"; Text[100])
        {
            Caption = 'Supervisor Name';
            NotBlank = true;

            trigger OnValidate()
            begin
                TestStatusOpen();
                ;
            end;
        }
        field(26; "No. of Leave Days Entitled"; Integer)
        {
            Caption = 'No. of Leave Days Entitled';
            Editable = false;
        }
        field(27; "No. of Days Taken"; Integer)
        {
            Caption = 'No. of Days Taken';
            Editable = false;
        }
        field(28; "Current Leave Balance"; Integer)
        {
            Caption = 'Current Leave Balance';
            Editable = false;
        }
        field(29; "Balance After Current Leave"; Integer)
        {
            Caption = 'Balance After Current Leave';
            Editable = false;
        }
        field(30; "Supervisor Approval Date"; Date)
        {
            Caption = 'Supervisor Approval Date';
            Editable = false;
        }
        field(31; "Current Residential Address"; Text[150])
        {
            Caption = 'Current Residential Address';
            trigger OnValidate()
            begin
                TestStatusOpen;
            end;
        }
        field(32; "On Leave Contact Address"; Text[150])
        {
            Caption = 'On Leave Contact Address';
            trigger OnValidate()
            begin
                TestStatusOpen;
            end;
        }
        field(33; "Employee ID"; Code[50])
        {
            Caption = 'Employee ID';
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(34; "No. of Public Holiday"; Integer)
        {
            Caption = 'No. of Public Holiday';
            Editable = false;
        }
        field(35; "No. of Sundays"; Integer)
        {
            Caption = 'No. of Sundays';
            Editable = false;
        }
        field(36; "No. of Saturdays"; Integer)
        {
            Caption = 'No. of Saturdays';
            Editable = false;
        }
        field(37; "Leave Posted"; Boolean)
        {
            Caption = 'Leave Posted';
            Editable = false;
        }
        field(38; "No. of Days Recalled"; Integer)
        {
            Caption = 'No. of Days Recalled';
            Editable = false;

            FieldClass = FlowField;
            CalcFormula = Count(LeaveRecall WHERE("Employee Code" = FIELD("Employee No."), "Leave Code" = field("Leave Code"), "Date Recalled" = FILTER(<> '')));

        }
        field(39; "Total Days Recalled to Date"; Integer)
        {
            Caption = 'Total Days Recalled to Date';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Count(LeaveRecall WHERE("Employee Code" = FIELD("Employee No."), "Leave Year" = FIELD("Leave Year"), "Leave Type" = FIELD("Leave Type")));
        }
        field(40; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
        }
        field(41; "Created By"; Code[50])
        {
            Caption = 'Created By';
            Editable = false;
        }
        field(42; "Created Date"; Date)
        {
            Caption = 'Created Date';
            Editable = false;
        }
        field(43; "Created Time"; Time)
        {
            Caption = 'Created Time';
            Editable = false;
        }
        field(44; "Mgr UserID"; Code[50])
        {
            Caption = 'Mgr UserID';
            TableRelation = "User Setup"."User ID";
        }
        field(45; "User ID"; Code[50])
        {
            Caption = 'User ID';
            TableRelation = "User Setup"."User ID";
        }
        field(46; "Applying Type"; Option)
        {
            Caption = 'Applying Type';
            OptionMembers = " ",Self,Surbodinate;

        }
        field(47; "Shortcut Dimension 3 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 3 Code';
            CaptionClass = '1,2,3';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
        }
        field(48; "Shortcut Dimension 4 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 4 Code';
            CaptionClass = '1,2,4';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));
        }
        field(49; JC; Code[10])
        {
            Caption = 'JC';
        }
        field(50; "JC Week"; Code[10])
        {
            Caption = 'JC Week';
        }
    }
    keys
    {
        key(PK; "Leave Code")
        {
            Clustered = true;
        }
        key(Seckey1; "Entry No.")
        { }
        key(SecKey2; "Employee No.", "First Day of Vacation")
        { }

        Key(Seckey3; "Employee No.", "Leave Type", "First Day of Vacation")
        { }
        Key(Seckey4; "Leave Type", "First Day of Vacation")
        { }
        Key(Seckey5; "First Day of Vacation", "Leave End Date")
        { }

    }
    trigger OnInsert()
    begin
        /*
        LeaveApp.SETCURRENTKEY("Entry No.");
        IF LeaveApp.FINDLAST THEN
            "Entry No." := LeaveApp."Entry No." + 1
        ELSE
            "Entry No." := 1;
        */
        IF "Leave Code" = '' THEN BEGIN
            HRMSetup.GET;
            HRMSetup.TESTFIELD("Leave Nos");
            NoSeriesMgt.InitSeries(HRMSetup."Leave Nos", xRec."No. Series", 0D, "Leave Code", "No. Series");
            //NoSeries.AreRelated(HRMSetup."Leave Nos", xRec."No. Series", 0D, "Leave Code", "No. Series");
        END;

        "Created By" := UserId;
        "Created Date" := Today;
        "Created Time" := Time;
        "User Id" := UserId;
    end;

    var
        HRMSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeries: Codeunit "No. Series";
        EmployeeRec: Record employee;
        SupervisorEmp: Record employee;
        UserSetup: Record "User Setup";
        LeaveApp: Record LeaveApplication;
        LeaveSetupLine: Record LeaveSetupLine;
        CauseOfAbsence: Record "Cause of Absence";
        EmpLvSetup: Record EmployeeLeaveSetup;
        CauseAbsAppRec: Record "Employee Absence";
        LeavAppRec: Record LeaveApplication;

        NoOfDays: Integer;
        LeaveUtilised: Integer;
        NoOfSundays: Integer;
        NoOfSaturdays: Integer;
        NoOfPHs: Integer;
        LeaveMonth: Integer;
        StartDate: date;
        YearOfJoin: Integer;
        CurrYear: Integer;
        LeaveYear: Integer;
        DaysEngaged: Integer;
        PoratedDuration: Integer;
        FirstDateOfYear: Date;
        JCWeek: Code[10];

        Text004: label '%1 must be in current year %2 and not previous years or future year, re-enter %3';
        Text001: Label 'Date To must not be lesser Date From';
        Text002: Label 'Employee %1 hase already taken %2 within the specify %3 and %4 in leave application code %5, your need to revise the %6 and %7';
        Text003: label 'The employee %1 is either not Approved or has been terminated, please check the employee Approval and Terminated status in the employee card';
        Text005: label 'Journey Calendar not found, hence No. Of Public Holidays could not be determine';
        Text006: label 'The %1 day(s) %2 apply for cannot be greater than the maximum leave setup of %3 day(s) for %4';
        Text007: label 'There is no Leave Setup for employees with Leave Setup Code %1, contact the system administrator or Human Resource if you wish to continue';
        Text008: label 'Employee already gone for %1 this year.';
        Text009: label 'Only %1 employees can apply for %2';
        Text010: label 'Leave applied for must equal %1 day(s) for %2, todays applied excluding Saturdays, Sundays and Public Holidays is %3';
        Text011: label 'The %1 day(s) leave apply for cannot be greater than leave balance of %2 day(s) as employee has already utilised %3 day(s) from the %4';
        Text012: label 'A pending %1 Leave application with Leave Code %2 already exist for the employee, search for the Leave code ans use it to continue the current leave';
        Text013: label 'The Leave Application with Leave code %1 already posted';
        Text014: label 'The Leave application with Leave code %1 for employee %2 was posted successfully';
        Text015: label 'The Leave application with Leave code %1 for employee %2 need to be approved before it can be posted';
        Text016: label 'The employee %1 is only entitled for %2  days annual leave as he join on %3';
        Text017: label 'The leave application cannot be conpleted as a previous pending %1 leave application with Leave Code %2 already exist for the employee, approved and post the previous leave to continue.';
        Text018: label 'The leave application cannot be conpleted as a previous Approved %1 leave application with Leave Code %2 already exist for the employee, Posted the previous leave application to continue.';

    procedure CheckExistLeaveWithinPeriod()
    var
    begin
        CLEAR(LeaveMonth);
        CLEAR(StartDate);
        CauseOfAbsence.GET("Leave Type");

        LeavAppRec.RESET;
        LeavAppRec.SETRANGE("Employee No.", "Employee No.");
        LeavAppRec.SETRANGE("Leave Type", CauseOfAbsence.Code);
        LeavAppRec.SETRANGE("Leave Year", "Leave Year");
        LeavAppRec.SETFILTER(Status, '%1|%2|%3', LeavAppRec.Status::"Pending Approval", LeavAppRec.Status::Approved, LeavAppRec.Status::Posted);
        if (LeavAppRec.findlast) then begin
            LeaveMonth := DATE2DMY(LeavAppRec."First Day of Vacation", 2); //For casual Leave
            StartDate := "First Day of Vacation";
            while (StartDate <= "Leave End Date") do begin
                ;
                if (StartDate >= LeavAppRec."First Day of Vacation") AND (StartDate <= LeavAppRec."Leave End Date") then
                    error(
                      Text002, LeavAppRec."Employee Name", LeavAppRec.Description, LeavAppRec.FIELDCAPTION("First Day of Vacation"), LeavAppRec.FIELDCAPTION("Leave End Date"),
                      LeavAppRec."Leave Code", LeavAppRec.FIELDCAPTION("First Day of Vacation"), LeavAppRec.FIELDCAPTION("Leave End Date"));
                StartDate := CALCDATE('+1D', StartDate);
            end;
        end;
    end;

    procedure AssistEdit(OldLeaveApp: Record LeaveApplication): Boolean
    begin
        with LeavAppRec do begin
            LeavAppRec := Rec;
            HRMSetup.GET;
            HRMSetup.TESTFIELD(HRMSetup."Leave Nos");
            if NoSeriesMgt.SelectSeries(HRMSetup."Leave Nos", OldLeaveApp."No. Series", "No. Series") then begin
                NoSeriesMgt.SetSeries("Leave Code");
                Rec := LeavAppRec;
                exit(true);
            end;
        end;
    end;

    procedure TestStatusOpen()
    begin
        TestField(Status, Rec.Status::Open);
    end;

    procedure GetNoOfDays(): Integer
    var
        CalenderDate: Record Date;
        JCalendar: Record JourneyCalendar;
    begin
        NoOfDays := 0;
        NoOfPHs := 0;
        NoOfSaturdays := 0;
        NoOfSundays := 0;

        YearOfJoin := 0;
        CurrYear := 0;
        LeaveYear := 0;
        DaysEngaged := 0;
        PoratedDuration := 0;

        CLEAR(JC);
        CLEAR(JCWeek);

        EmployeeRec.TESTFIELD("Employment Date");

        YearOfJoin := DATE2DMY(EmployeeRec."Employment Date", 3);
        CurrYear := DATE2DMY(TODAY, 3);
        LeaveYear := DATE2DMY("First Day of Vacation", 3);
        FirstDateOfYear := DMY2DATE(1, 1, CurrYear);

        DaysEngaged := EmployeeRec."Employment Date" - FirstDateOfYear;
        PoratedDuration := ROUND((((365 - DaysEngaged) / 365) * LeaveSetupLine.Duration), 1, '=');

        //Determine the number of days, Sundays & Saturday between Leave start Date and Leave End Date
        CalenderDate.RESET;
        CalenderDate.SETRANGE("Period Type", CalenderDate."Period Type"::Date);
        CalenderDate.SETRANGE("Period Start", "First Day of Vacation", "Leave End Date");
        if CalenderDate.FINDSET then
            repeat
                //NoOfDays :=CalenderDate.COUNT
                NoOfDays := NoOfDays + 1;
                if (CalenderDate."Period Name" = 'Sunday') then
                    NoOfSundays := NoOfSundays + 1;
                if (CalenderDate."Period Name" = 'Saturday') then
                    NoOfSaturdays := NoOfSaturdays + 1;
            until CalenderDate.NEXT = 0;

        //Determine the number of Public Holidays between Leave start Date and Leave End Date usinf Journey Calendar Setup
        JCalendar.RESET;
        JCalendar.SETRANGE("Period Type", JCalendar."Period Type"::Date);
        JCalendar.SETFILTER("Start Date", '%1..%2', "First Day of Vacation", "Leave End Date");
        JCalendar.SETRANGE("Public Holiday", TRUE);
        if (JCalendar.FINDSET) then
            NoOfPHs := JCalendar.COUNT;
        //ELSE
        //ERROR(Text0005);

        //Recalculate Actual Leave Days Taken by subtracting Saturdays, Sundays and Public Holidays
        if ("Leave Type" = HRMSetup."Annaul Leave Code") OR ("Leave Type" = HRMSetup."Exam Leave Code") OR
           ("Leave Type" = HRMSetup."Maternity Leave Code") OR ("Leave Type" = HRMSetup."Paternity Leave Code") OR
           ("Leave Type" = HRMSetup."Compasonate Leave Code") THEN
            NoOfDays := NoOfDays - (NoOfSaturdays + NoOfSundays + NoOfPHs);

        //Check that Requested Days is not more than the Leave Entitled Days
        //It also Porate for employees that Join on current year as 365-(days join)/365 * Leave duration for that Zone  
        if (CurrYear > YearOfJoin) then begin
            if ("Leave Type" <> HRMSetup."Day-Off Leave Code") then
                if ("Leave Type" <> HRMSetup."Sick Leave Code") then
                    if ("Leave Type" <> HRMSetup."Out-Duty Leave Code") then begin
                        //if ("Leave Type" <> HRMSetup."Company Leave Code") then begin
                        if (NOT EmpLvSetup.GET(EmployeeRec."No.")) then begin
                            if (NoOfDays > LeaveSetupLine.Duration) then
                                ERROR(Text006, NoOfDays, Description, LeaveSetupLine.Duration, Description);
                        end else begin
                            ;
                            if (NoOfDays > EmpLvSetup."Leave Entitled") then
                                ERROR(Text006, NoOfDays, Description, EmpLvSetup."Leave Entitled", Description);
                        end;
                    end;
        end else begin
            /* 
            {No more poration
            IF "Leave Type" = HRMSetup."Annaul Leave Code" then begin
               IF (NoOfDays > PoratedDuration) THEN
                  ERROR(Text016,EmployeeRec."No.",PoratedDuration,EmployeeRec."Employment Date");
            end}
            */
        end;

        //CurrMonth:=0;
        //Check for Maternity Leave
        if "Leave Type" = HRMSetup."Maternity Leave Code" then begin
            GetMaternityLeaveUtilised;
            if (LeaveUtilised > 0) then
                ERROR(Text008, Description);

            if (EmployeeRec.Gender <> LeaveSetupLine.Sex) then
                ERROR(Text009, LeaveSetupLine.Sex, Description);

            if (NoOfDays <> LeaveSetupLine.Duration) then
                ERROR(Text010, LeaveSetupLine.Duration, Description, NoOfDays);
        end;

        //Check for Paternity Leave
        if ("Leave Type" = HRMSetup."Paternity Leave Code") then begin
            GetPaternityLeaveUtilised;
            if LeaveUtilised > 0 then
                ERROR(Text008);

            if (EmployeeRec.Gender <> LeaveSetupLine.Sex) then
                ERROR(Text009, LeaveSetupLine.Sex, Description);

            if (NoOfDays <> LeaveSetupLine.Duration) then
                ERROR(Text010, LeaveSetupLine.Duration, Description, NoOfDays);
        end;

        if ("Leave Type" <> HRMSetup."Day-Off Leave Code") AND ("Leave Type" <> HRMSetup."Out-Duty Leave Code") AND
           ("Leave Type" <> HRMSetup."Paternity Leave Code") AND ("Leave Type" <> HRMSetup."Maternity Leave Code") AND
          ("Leave Type" <> HRMSetup."Sick Leave Code") //AND ("Leave Type" <> HRMSetup."Company Leave Code") 
          then begin
            GetLeaveUtilised;
            //Check if days applied for is not more than balance
            if (NOT EmpLvSetup.GET(EmployeeRec."No.")) then begin
                if (NoOfDays > (LeaveSetupLine.Duration - LeaveUtilised)) then
                    ERROR(Text011, NoOfDays, (LeaveSetupLine.Duration - LeaveUtilised), LeaveUtilised, Description);
            end else begin
                if (NoOfDays > (EmpLvSetup."Leave Entitled" - LeaveUtilised)) then
                    ERROR(Text011, NoOfDays, (EmpLvSetup."Leave Entitled" - LeaveUtilised), LeaveUtilised, Description);
            end;
        end;
    end;

    procedure GetMaternityLeaveUtilised()
    begin
        LeaveUtilised := 0;

        CauseAbsAppRec.RESET;
        CauseAbsAppRec.SETRANGE("Employee No.", "Employee No.");
        CauseAbsAppRec.SETRANGE("Cause of Absence Code", HRMSetup."Maternity Leave Code");
        CauseAbsAppRec.SETRANGE("Leave Year", "Leave Year");
        //CauseAbsAppRec.SETRANGE("Approval Status", CauseAbsAppRec."Approval Status" ::Approved);
        if CauseAbsAppRec.FINDSET then begin
            repeat
                LeaveUtilised += CauseAbsAppRec.Quantity;
            until CauseAbsAppRec.NEXT = 0
        end;
    end;

    procedure GetPaternityLeaveUtilised()
    begin
        LeaveUtilised := 0;

        CauseAbsAppRec.RESET;
        CauseAbsAppRec.SETRANGE("Employee No.", "Employee No.");
        CauseAbsAppRec.SETRANGE("Cause of Absence Code", HRMSetup."Paternity Leave Code");
        CauseAbsAppRec.SETRANGE("Leave Year", "Leave Year");
        //CauseAbsAppRec.SETRANGE("Approval Status", CauseAbsAppRec."Approval Status" ::Approved);
        if CauseAbsAppRec.FINDSET then begin
            repeat
                LeaveUtilised += CauseAbsAppRec.Quantity;
            until CauseAbsAppRec.NEXT = 0
        end;

    end;

    procedure GetLeaveUtilised()
    begin
        LeaveUtilised := 0;

        CauseAbsAppRec.RESET;
        CauseAbsAppRec.SETRANGE("Employee No.", "Employee No.");
        CauseAbsAppRec.SETRANGE("Cause of Absence Code", "Leave Type");
        /*
        CauseAbsAppRec.SETFILTER(
                 CauseAbsAppRec."Cause of Absence Code",'%1|%2|%3|%4|%5|%6|%7|%8|%9',HRMSetup."Annaul Leave Code",HRMSetup."Exam Leave Code",
                 HRMSetup."Comp-Brother Leave Code",HRMSetup."Comp-Daugther Leave Code",HRMSetup."Comp-Father Leave Code",HRMSetup."Comp-Mother Leave Code",
                 HRMSetup."Comp-Sister Leave Code",HRMSetup."Comp-Son Leave Code",HRMSetup."Comp-Spouse Leave Code");
        */
        CauseAbsAppRec.SETRANGE("Leave Year", "Leave Year");
        //CauseAbsAppRec.SETRANGE("Approval Status", CauseAbsAppRec."Approval Status" ::Approved);
        if CauseAbsAppRec.FINDSET then begin
            repeat
                LeaveUtilised += CauseAbsAppRec.Quantity;
            until CauseAbsAppRec.NEXT = 0
        end;

    end;

    procedure PostLeaveApplication()
    var
        RecordInsert: Boolean;
    begin
        if ("Leave Posted") then
            error(Text013, "Leave Code");

        LeaveApp.RESET;
        LeaveApp.SETRANGE("Employee No.", "Employee No.");
        LeaveApp.SETRANGE("Leave Type", "Leave Type");
        LeaveApp.SETFILTER(Status, '%1', LeaveApp.Status::Approved);
        if (LeaveApp.FINDFIRST) then begin
            CauseAbsAppRec.INIT;
            CauseAbsAppRec.VALIDATE("Employee No.", "Employee No.");
            CauseAbsAppRec.VALIDATE("Cause of Absence Code", "Leave Type");
            CauseAbsAppRec."From Date" := "First Day of Vacation";
            CauseAbsAppRec."To Date" := "Leave End Date";
            CauseAbsAppRec.VALIDATE(Quantity, "Requested Days");
            CauseAbsAppRec."Leave Year" := "Leave Year";
            CauseAbsAppRec."Leave Code" := "Leave Code";
            CauseAbsAppRec."Recalled/Adjustment Reason" := Description;
            CauseAbsAppRec."Global Dimension 1 Code" := "Global Dimension 1 Code";
            CauseAbsAppRec."Global Dimension 2 Code" := "Global Dimension 2 Code";
            CauseAbsAppRec."Shortcut Dimension 3 Code" := "Shortcut Dimension 3 Code";
            CauseAbsAppRec."Shortcut Dimension 4 Code" := "Shortcut Dimension 4 Code";
            CauseAbsAppRec."Leave Application" := TRUE;
            CauseAbsAppRec.INSERT(TRUE);
            RecordInsert := TRUE;
            LeaveApp."Leave Posted" := TRUE;
            LeaveApp.Status := LeaveApp.Status::Posted;
            LeaveApp.MODIFY;
        end else
            ERROR(Text015, "Leave Code", "Employee Name");

        if RecordInsert then
            Message(Text014, "Leave Code", "Employee Name")
    end;

    procedure CheckMandatoryFileds()
    begin
        TestField(Rec.Status, Rec.Status::Open);
        TestField(Rec."Applying Type");
        TestField(Rec."First Day of Vacation");
        TestField(Rec."Leave End Date");
        TestField(Rec."Leave Type");
        TestField(Rec."On Leave Contact Address");
        TestField(Rec."Current Residential Address");
        //TestField("Supervisor Name");
    end;

    procedure PerformManualReopen()
    var

    begin
        LeaveApp.SetRange("Employee No.", Rec."Employee No.");
        IF LeaveApp.FindFirst() then begin
            LeaveApp.Status := LeaveApp.Status::Open;
            LeaveApp.Modify();
        end;
    end;

    procedure PerformManualRelease()
    var

    begin
        LeaveApp.SetRange("Employee No.", Rec."Employee No.");
        IF LeaveApp.FindFirst() then begin
            CheckMandatoryFileds();
            LeaveApp.Status := LeaveApp.Status::Approved;
            LeaveApp.Modify();
        end;
    end;


}
