page 50114 LeaveCalendar
{
    ApplicationArea = All;
    Caption = 'Leave Calendar';
    PageType = List;
    SourceTable = JourneyCalendar;
    UsageCategory = Tasks;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            group(DateFilter)
            {
                Caption = 'Date Filter';
                field(JCStartDate; JCStartDate)
                {
                    Caption = 'Start Date';

                }
                field(JCEndDate; JCEndDate)
                {
                    Caption = 'End Date';
                }
            }
            repeater(General)
            {
                field("Journey Code"; Rec."Journey Code")
                {
                    ToolTip = 'Specifies the value of the Journey Code';
                    Editable = false;
                }
                field(Week; Rec.Week)
                {
                    ToolTip = 'Specifies the value of the Journey Week';
                    Editable = false;
                }
                field("Period Type"; Rec."Period Type")
                {
                    ToolTip = 'Specifies the value of the Period Type';
                    Editable = false;
                }
                field("Period Name"; Rec."Period Name")
                {
                    ToolTip = 'Specifies the value of the Period Name';
                    Editable = false;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'Specifies the value of the Journey Date';
                    Editable = false;
                }
                field(Year; Rec.Year)
                {
                    ToolTip = 'Specifies the value of the Year';
                    Editable = false;
                }
                field("Public Holiday"; Rec."Public Holiday")
                {
                    ToolTip = 'Specifies the value if Date is a Public Holiday';
                }
                field(Sunday; Rec.Sunday)
                {
                    ToolTip = 'Specifies the value if Date is a Sunday';
                    Editable = false;
                }
                field(Saturday; Rec.Saturday)
                {
                    ToolTip = 'Specifies the value if Date is a Saturday';
                    Editable = false;
                }
                field("Sanitation Day"; Rec."Sanitation Day")
                {
                    ToolTip = 'Specifies the value if Date is Sanitation Day';
                }
                field(Remarks; Rec.Remarks)
                {
                    ToolTip = 'Specifies the value for Remarks';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(CreateCalendar)
            {
                Caption = 'Create Calendar';
                ApplicationArea = All;
                Image = Calendar;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    CalendarYear := DATE2DMY(TODAY, 3);

                    IF ((DATE2DMY(JCStartDate, 3)) <> CalendarYear) OR
                       ((DATE2DMY(JCEndDate, 3)) <> CalendarYear) THEN
                        ERROR(ErrorJCYear, JCStartDate, JCEndDate, CalendarYear);

                    StartingDate := JCStartDate;
                    EndDate := JCEndDate;

                    CreateJourneyCalendar;
                end;
            }
        }
    }
    var
        JCStartDate: Date;
        JCEndDate: Date;
        StartingDate: Date;
        EndDate: Date;
        WeekCount: Integer;
        Counter: Integer;
        CalendarYear: Integer;
        JCCounter: Integer;
        JCCount: Integer;
        Lineno: Integer;
        ErrorDateFilter: Label 'Start Date filter %1 cannot be more than End Date filter %2';
        ErrorStartDate: Label 'Start Date filter must be specify';
        ErrorEndDate: Label 'End Date filter must be specify';
        errorJCYear: Label 'The Start Date Filter %1 and End Date Filter %2  must be within the current Year %3';

    procedure CreateJourneyCalendar()
    var
        CalenderDate: Record Date;
        AttendCalender: Record JourneyCalendar;
        AttendCalender2: Record JourneyCalendar;
    begin
        if (JCStartDate = 0D) then
            Error(ErrorStartDate);

        if (JCEndDate = 0D) then
            Error(ErrorEndDate);

        if (JCStartDate > JCEndDate) then
            error(ErrorDateFilter, JCStartDate, JCEndDate);

        IF StartingDate = 0D THEN
            EXIT;

        AttendCalender2.RESET;
        AttendCalender2.SETRANGE("Start Date", StartingDate, EndDate);
        IF AttendCalender2.FINDFIRST THEN
            EXIT;
        AttendCalender2.SETRANGE("Start Date");

        WeekCount := 1;
        Counter := 1;

        JCCount := 1;
        JCCounter := 1;

        CalenderDate.RESET;
        CalenderDate.SETRANGE("Period Type", CalenderDate."Period Type"::Date);
        CalenderDate.SETRANGE("Period Start", StartingDate, EndDate);
        IF CalenderDate.FINDFIRST THEN
            REPEAT
                IF AttendCalender2.FINDLAST THEN
                    LineNo := AttendCalender2."Entry No." + 1000;

                AttendCalender.INIT;
                AttendCalender."Entry No." := LineNo;
                AttendCalender."Period Type" := CalenderDate."Period Type";
                AttendCalender."Start Date" := CalenderDate."Period Start";
                AttendCalender."Period Name" := CalenderDate."Period Name";
                AttendCalender.Year := FORMAT(CalendarYear);

                IF (Counter <= 7) THEN BEGIN
                    AttendCalender.Week := FORMAT('WEEK ') + FORMAT(WeekCount);
                    Counter := Counter + 1;
                END ELSE BEGIN
                    Counter := 2;
                    WeekCount := WeekCount + 1;
                    AttendCalender.Week := FORMAT('WEEK ') + FORMAT(WeekCount);
                END;

                IF (JCCounter <= 35) THEN BEGIN
                    AttendCalender."Journey Code" := FORMAT('JC ') + FORMAT(JCCount);
                    JCCounter := JCCounter + 1;
                END ELSE BEGIN
                    JCCounter := 2;
                    JCCount := JCCount + 1;
                    AttendCalender."Journey Code" := FORMAT('JC ') + FORMAT(JCCount);
                END;

                IF (CalenderDate."Period Name" = FORMAT('Sunday')) THEN
                    AttendCalender.Sunday := TRUE;

                IF (CalenderDate."Period Name" = FORMAT('Saturday')) THEN
                    AttendCalender.Saturday := TRUE;

                AttendCalender.Insert();
            UNTIL CalenderDate.Next() = 0;
    end;

    procedure SetStartingDate(StartingDatePara: Date)
    var
    begin
        StartingDate := JCStartDate;
        EndDate := JCEndDate;
    end;

    procedure SetDate()
    var
    Begin

        StartingDate := JCStartDate;
        EndDate := JCEndDate;

    End;

}