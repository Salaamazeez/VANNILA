report 50102 PayrollPeriodSetup
{
    ApplicationArea = All;
    Caption = 'Payroll Periods Setup';
    UsageCategory = Tasks;
    ProcessingOnly = true;

    requestpage
    {
        layout
        {
            area(content)
            {
                group(ReportFilter)
                {
                    field(FiscalYearStartDate; FiscalYearStartDate)
                    {
                        Caption = 'Fiscal Year Start Date';
                        ApplicationArea = All;
                    }
                    field(NoOfPeriods; NoOfPeriods)
                    {
                        Caption = 'No. of Periods';
                        Editable = false;
                        ApplicationArea = All;
                    }
                    field(PeriodLength; PeriodLength)
                    {
                        Caption = 'Period Lenght';
                        Editable = false;
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
        trigger OnInit()
        begin

        end;

        trigger OnOpenPage()
        begin
            IF NoOfPeriods = 0 THEN BEGIN
                NoOfPeriods := 12;
                EVALUATE(PeriodLength, '<1M>');
            END;
            IF PayPeriod.FIND('+') THEN
                FiscalYearStartDate := PayPeriod."Start Date";
        end;
    }
    trigger OnInitReport()
    begin
        //PeriodCode := 'p1';
    end;

    trigger OnPreReport()
    begin
        PayPeriod."Start Date" := FiscalYearStartDate;
        PayPeriod.TESTFIELD("Start Date");

        IF NOT PayPeriod.FIND('-') THEN BEGIN
            FirstPeriodStartDate := PayPeriod."Start Date";

            FOR i := 1 TO NoOfPeriods + 1 DO BEGIN
                IF (FiscalYearStartDate <= FirstPeriodStartDate) AND (i = NoOfPeriods + 1) THEN
                    EXIT;

                IF (FirstPeriodStartDate <> 0D) THEN
                    IF (FiscalYearStartDate >= FirstPeriodStartDate) AND (FiscalYearStartDate < LastPeriodStartDate) THEN
                        ERROR(FiscalYearError);
                PayPeriod.INIT;
                dd := DATE2DMY(FiscalYearStartDate, 1);
                mm := DATE2DMY(FiscalYearStartDate, 2);
                yy := DATE2DMY(FiscalYearStartDate, 3);
                IF STRPOS(PeriodLength, 'D') <> 0 THEN
                    ww := dd
                ELSE
                    ww := DATE2DWY(FiscalYearStartDate, 2);
                IF STRPOS(PeriodLength, 'M') <> 0 THEN
                    ww := 0;
                IF mm <= 9 THEN
                    PayPeriod."Period Code" := FORMAT(yy) + '-0' + FORMAT(mm)
                ELSE
                    PayPeriod."Period Code" := FORMAT(yy) + '-' + FORMAT(mm);
                IF (ww > 0) AND (ww <= 9) THEN
                    PayPeriod."Period Code" := PayPeriod."Period Code" + '-0' + FORMAT(ww)
                ELSE
                    IF ww > 9 THEN
                        PayPeriod."Period Code" := PayPeriod."Period Code" + '-' + FORMAT(ww);
                PayPeriod."Start Date" := FiscalYearStartDate;
                PayPeriod."End Date" := CALCDATE(PeriodLength, PayPeriod."Start Date") - 1;
                PayPeriod.VALIDATE("Start Date");
                PayPeriod."Period Name" := STRSUBSTNO('%1 %2',
                       FormatMonth(DATE2DMY(FiscalYearStartDate, 2)),
                       DATE2DMY(FiscalYearStartDate, 3));
                IF NOT PayPeriod.FIND('=') THEN
                    PayPeriod.INSERT;
                FiscalYearStartDate := CALCDATE(PeriodLength, FiscalYearStartDate);
            END;
        END ELSE BEGIN
            IF PayPeriod.FIND('-') THEN BEGIN
                FirstPeriodStartDate := PayPeriod."Start Date";

                FOR i := 1 TO NoOfPeriods + 1 DO BEGIN
                    IF (FiscalYearStartDate <= FirstPeriodStartDate) AND (i = NoOfPeriods + 1) THEN
                        EXIT;

                    IF (FirstPeriodStartDate <> 0D) THEN
                        IF (FiscalYearStartDate >= FirstPeriodStartDate) AND (FiscalYearStartDate < LastPeriodStartDate) THEN
                            ERROR(FiscalYearError);
                    PayPeriod.INIT;
                    dd := DATE2DMY(FiscalYearStartDate, 1);
                    mm := DATE2DMY(FiscalYearStartDate, 2);
                    yy := DATE2DMY(FiscalYearStartDate, 3);
                    IF STRPOS(PeriodLength, 'D') <> 0 THEN
                        ww := dd
                    ELSE
                        ww := DATE2DWY(FiscalYearStartDate, 2);
                    IF STRPOS(PeriodLength, 'M') <> 0 THEN
                        ww := 0;
                    IF mm <= 9 THEN
                        PayPeriod."Period Code" := FORMAT(yy) + '-0' + FORMAT(mm)
                    ELSE
                        PayPeriod."Period Code" := FORMAT(yy) + '-' + FORMAT(mm);
                    IF (ww > 0) AND (ww <= 9) THEN
                        PayPeriod."Period Code" := PayPeriod."Period Code" + '-0' + FORMAT(ww)
                    ELSE
                        IF ww > 9 THEN
                            PayPeriod."Period Code" := PayPeriod."Period Code" + '-' + FORMAT(ww);
                    PayPeriod."Start Date" := FiscalYearStartDate;
                    PayPeriod."End Date" := CALCDATE(PeriodLength, PayPeriod."Start Date") - 1;
                    PayPeriod.VALIDATE("Start Date");
                    PayPeriod."Period Name" := STRSUBSTNO('%1 %2',
                           FormatMonth(DATE2DMY(FiscalYearStartDate, 2)),
                           DATE2DMY(FiscalYearStartDate, 3));
                    IF NOT PayPeriod.FIND('=') THEN
                        PayPeriod.INSERT;
                    FiscalYearStartDate := CALCDATE(PeriodLength, FiscalYearStartDate);
                END;
            END;
        END;
    end;

    trigger OnPostReport()
    begin

    end;

    var
        FiscalYearStartDate: Date;
        FiscalYearStartDate2: Date;
        FiscalYearEndDate: Date;
        FirstPeriodStartDate: Date;
        LastPeriodStartDate: Date;
        FirstPeriodLocked: Boolean;
        NoOfPeriods: integer;
        PayrollPeriod: code[20];
        PeriodLength: Code[20];
        PeriodLength1: DateFormula;
        PayPeriod: Record PayrollPeriods;
        dd: Integer;
        mm: Integer;
        yy: Integer;
        ww: Integer;
        I: Integer;


        FiscalYearError: Label 'It is only possible to create new fiscal years before or after the existing ones.';
        Text000: Label 'The new payroll year begins before an existing payroll year, so the new year will be closed automatically.';
        Text001: Label 'Do you want to create and close the payroll year?';
        text002: Label 'Once you create the new payroll year you cannot change its starting date.';
        Text003: Label 'Do you want to create the payroll year?';
        Text004: Label 'It is only possible to create new payroll years before or after the existing ones.';

    procedure FormatMonth(mMonth: Integer): Code[20]
    begin
        CASE mMonth OF
            1:
                EXIT('JAN');
            2:
                EXIT('FEB');
            3:
                EXIT('MAR');
            4:
                EXIT('APR');
            5:
                EXIT('MAY');
            6:
                EXIT('JUN');
            7:
                EXIT('JUL');
            8:
                EXIT('AUG');
            9:
                EXIT('SEP');
            10:
                EXIT('OCT');
            11:
                EXIT('NOV');
            12:
                EXIT('DEC');
        END;

    end;
}
