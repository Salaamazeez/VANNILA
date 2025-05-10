report 50148 DailyAllocationOilReport
{
    //ApplicationArea = All;
    Caption = 'Daily Allocation Oil & Cond (bbl)';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'DailyAllocationOil.rdl';
    //ApplicationArea = All;

    dataset
    {
        dataitem(DailyAllocationOil; DailyAllocationOil)

        {
            RequestFilterFields = "Production Date";
            column(Facility; Facility)
            {
            }
            column(Fields; "Fields")
            {
            }
            column(OML; OML)
            {
            }
            column(Well; Well)
            {
            }
            column(WellType; "Well Type")
            {
            }
            column(TransactionDate; "Production Date")
            {
            }
            column(DailyAllocated; "Daily Allocated")
            {
            }
            trigger OnPreDataItem()
            begin
                DateFilters := GetFilter("Production Date");
                Evaluate(StartDate, FORMAT(CopyStr(DateFilters, 1, 8)));
                Evaluate(EndDate, FORMAT(CopyStr(DateFilters, 11, 8)));
                //error('%1                %2', StartDate, EndDate);
                //EVALUATE(CurrYear,FORMAT(DATE2DMY(DateFilter,3)));

                //If (Not Periods.Get(PeriodCode)) then
                //  Error('Period %1 does not exit, please contact the system administrator to create the period ');

                DateArray[1] := StartDate;
                for I := 2 to 31 do begin
                    DateArray[I] := CalcDate('1D', StartDate);
                end;
            end;

            trigger OnAfterGetRecord()
            begin
                if (PeriodCode = '') then
                    Error('Period must not be empty in the Request Filter Page');

                DailyAllocOil.RESET;
                DailyAllocOil.SetCurrentKey(Well, "Well Type", "Production Date");
                DailyAllocOil.SetRange(Well, Well);
                DailyAllocOil.SetRange("Production Date", DateArray[1], DateArray[31]);
                IF DailyAllocOil.FindSet() then
                    repeat
                        valueArray[J] := DailyAllocOil."Daily Allocated";
                        J += 1;
                    until DailyAllocOil.Next = 0;
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
                group(Filter)
                {
                    Caption = 'Request Filters';
                    field(PeriodCodes; PeriodCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Period';
                        ToolTip = 'Specifies the period to be use to filter the report, field must be filled in.';
                        TableRelation = PayrollPeriods."Period Code";
                    }
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
        PeriodCode: Code[50];
        Periods: Record PayrollPeriods;
        DailyAllocOil: Record DailyAllocationOil;
        CurrYear: Integer;
        CurrMonth: Integer;
        StartDate: date;
        EndDate: date;
        DateFilters: Text[50];

        I: Integer;
        J: Integer;
        DateArray: array[30] of Date;
        valueArray: array[30] of Decimal;


}
