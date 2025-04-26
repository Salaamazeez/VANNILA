report 50110 ImportLeaveEntitled
{
    //Excel to have two column EMPLOYEE NO, LEAVE ENTITLED
    ApplicationArea = All;
    Caption = 'Update Leave Entitled';
    UsageCategory = Tasks;
    ProcessingOnly = true;
    //DefaultLayout = RDLC;
    //RDLCLayout = 'Import Employee Data.rdl';
    dataset
    {
        dataitem(Integer; "Integer")
        {

            trigger OnAfterGetRecord()
            begin
                ImportSheet(Number);

                EmployeeLeaveSetup.Init();
                EmployeeLeaveSetup.VALIDATE("Employee No.", ColText[1]);
                Evaluate(EmployeeLeaveSetup."Leave Entitled", ColText[2]);
                IF (NOT EmployeeLeaveSetup.INSERT(True)) then
                    EmployeeLeaveSetup.Modify();
            end;

            trigger OnPreDataItem()
            begin
                /*
                        ExcelBuf.RESET;
                        ExcelBuf.DELETEALL;
                        //ExcelBuf.OpenBook(ServerFileName, SheetName);
                        ExcelBuf.OpenBookStream(ServerFileName, SheetName);
                        ExcelBuf.ReadSheet;
                        IF ExcelBuf.FINDLAST THEN
                            SETRANGE(Number, 2, ExcelBuf."Row No.");
                            */
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
            area(content)
            {
                group(Option)
                {
                    group("Import From")
                    {
                        field(FileName; FileName)
                        {
                            Caption = 'Workbook Filename';
                            ApplicationArea = All;
                            trigger OnAssistEdit()
                            begin
                                RequestFile;
                                // SheetName := ExcelBuf.SelectSheetsName(ServerFileName);
                            end;
                        }
                        field(SheetName; SheetName)
                        {
                            Caption = 'Sheet Name';
                            ApplicationArea = All;
                            trigger OnAssistEdit()
                            begin
                                IF ServerFileName = '' THEN BEGIN
                                    RequestFile;
                                END;

                                // SheetName := ExcelBuf.SelectSheetsName(ServerFileName);
                            end;
                        }
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
        end;
    }
    trigger OnInitReport()
    begin
    end;

    trigger OnPreReport()
    begin
    end;

    trigger OnPostReport()
    begin
        Message(msgfinishUpdate);
    end;

    var

        ExcelBuf: Record "Excel Buffer" temporary;
        ColText: array[100] of Text[250];
        FileMgt: Codeunit "File Management";
        EmployeeLeaveSetup: Record EmployeeLeaveSetup;

        FileName: Text[250];
        ServerFileName: Text[250];
        SheetName: Text[250];

        Text005: Label 'Imported from Excel';
        Text006: Label 'Import Excel File';
        msgfinishUpdate: label 'Leave Entitled successfully updated';

    Procedure ImportSheet(RowNumber: Integer)
    var
    begin
        CLEAR(ColText);
        ExcelBuf.SETRANGE(ExcelBuf."Row No.", RowNumber);
        IF ExcelBuf.FINDFIRST THEN BEGIN
            REPEAT
                ColText[ExcelBuf."Column No."] := ExcelBuf."Cell Value as Text";
            UNTIL ExcelBuf.NEXT = 0;
        END;
    end;

    procedure RequestFile()
    begin
        /*
        IF FileName <> '' THEN
            ServerFileName := FileMgt.UploadFile(Text006, FileName)

        ELSE
            ServerFileName := FileMgt.UploadFile(Text006, '.xlsx');

        FileName := FileMgt.GetFileName(ServerFileName);
        */
    end;
}