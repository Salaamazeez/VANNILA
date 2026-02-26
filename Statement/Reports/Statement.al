report 50200 "Bank Statement"
{
    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = Tasks;

    dataset
    {
        
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(stmtDate; stmtDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Statement Date';
                        ToolTip = 'Select the date for which the bank statement should be retrieved.';
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    var
        Stmt: Codeunit "Statement";
    begin
        if stmtDate = 0D then
            Error('Please specify a statement date.');

        Stmt.GetStatement(stmtDate);
        Message('Bank statement for %1 retrieved successfully.', stmtDate);
    end;

    var
        stmtDate: Date;
}