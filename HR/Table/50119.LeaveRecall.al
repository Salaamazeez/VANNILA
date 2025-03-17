table 50119 LeaveRecall
{
    Caption = 'Leave Recall';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Employee Code"; Code[20])
        {
            Caption = 'Employee Code';
        }
        field(2; "Leave Code"; Code[20])
        {
            Caption = 'Leave Code';
        }
        field(3; "Date Recalled"; Date)
        {
            Caption = 'Date Recalled';

            trigger OnValidate()
            begin
                TESTFIELD("Recalled Reason");
                DateIn := FALSE;
                DateRecalled2 := xRec."Date Recalled";

                IF "Date Recalled" <> 0D THEN BEGIN
                    LeaveRec.RESET;
                    LeaveRec.SETRANGE("Employee No.", "Employee Code");
                    LeaveRec.SETRANGE("Leave Code", "Leave Code");
                    //LeaveRec.SETRANGE("Cause of Absence Code","Leave Type");
                    LeaveRec.SETFILTER("Leave Recalled", '%1', FALSE);
                    IF LeaveRec.FINDFIRST THEN BEGIN
                        DateRec.RESET;
                        DateRec.SETRANGE("Period Type", DateRec."Period Type"::Date);
                        DateRec.SETFILTER("Period Start", '%1..%2', LeaveRec."From Date", LeaveRec."To Date");
                        IF DateRec.FINDSET THEN
                            REPEAT
                                IF DateRec."Period Start" = "Date Recalled" THEN BEGIN
                                    DateIn := TRUE;
                                    DateRecalled := "Date Recalled";
                                END;
                            UNTIL DateRec.NEXT = 0;
                        IF DateIn = FALSE THEN
                            ERROR(Text001, FIELDCAPTION("Date Recalled"), "Date Recalled")
                        ELSE BEGIN
                            //Create a Leave credit by Adding by crediting the Utilised days
                            CauseAbsAppRec.INIT;
                            CauseAbsAppRec.VALIDATE("Employee No.", "Employee Code");
                            CauseAbsAppRec.VALIDATE("Cause of Absence Code", LeaveRec."Cause of Absence Code");
                            CauseAbsAppRec."From Date" := "Date Recalled";
                            CauseAbsAppRec."To Date" := "Date Recalled";
                            CauseAbsAppRec."Recalled Date" := "Date Recalled";
                            CauseAbsAppRec.VALIDATE(Quantity, -1);
                            CauseAbsAppRec."Leave Year" := LeaveRec."Leave Year";
                            CauseAbsAppRec."Leave Code" := LeaveRec."Leave Code";
                            CauseAbsAppRec."Adjustment Type" := CauseAbsAppRec."Adjustment Type"::"Positive Adjustment";
                            CauseAbsAppRec."Leave Recalled" := TRUE;
                            CauseAbsAppRec."Recalled/Adjustment Reason" := "Recalled Reason";
                            CauseAbsAppRec."Global Dimension 1 Code" := LeaveRec."Global Dimension 1 Code";
                            CauseAbsAppRec."Global Dimension 2 Code" := LeaveRec."Global Dimension 2 Code";
                            CauseAbsAppRec."Shortcut Dimension 3 Code" := LeaveRec."Shortcut Dimension 3 Code";
                            CauseAbsAppRec."Shortcut Dimension 4 Code" := LeaveRec."Shortcut Dimension 4 Code";
                            CauseAbsAppRec.INSERT(TRUE);
                            "Leave Type" := LeaveRec."Cause of Absence Code";
                            "Leave Year" := LeaveRec."Leave Year";
                            "last Modified By" := USERID;
                            "Last Modified Date" := TODAY;
                        END;
                    END;
                END ELSE BEGIN
                    IF "Date Recalled" = 0D THEN BEGIN
                        LeaveRec.SETRANGE("Employee No.", "Employee Code");
                        LeaveRec.SETRANGE("Leave Code", "Leave Code");
                        //LeaveRec.SETRANGE("Cause of Absence Code","Leave Type");
                        LeaveRec.SETRANGE("Recalled Date", DateRecalled2);
                        IF LeaveRec.FINDFIRST THEN BEGIN
                            LeaveRec.DELETE;
                        END;
                    END;
                END;
            end;
        }
        field(4; "Recalled Reason"; Text[150])
        {
            Caption = 'Recalled Reason';
        }
        field(5; "Days Credited"; Integer)
        {
            Caption = 'Days Credited';
        }
        field(6; "Leave Type"; Code[20])
        {
            Caption = 'Leave Type';
        }
        field(7; "Recalled Posted"; Boolean)
        {
            Caption = 'Recalled Posted';
        }
        field(8; "Leave Year"; Integer)
        {
            Caption = 'Leave Year';
        }
        field(9; "Created By"; Code[50])
        {
            Caption = 'Created By';
        }
        field(10; "Created Date"; Date)
        {
            Caption = 'Created Date';
        }
        field(11; "Last Modified By"; Code[50])
        {
            Caption = 'Last Modified By';
        }
        field(12; "Last Modified Date"; Date)
        {
            Caption = 'Last Modified Date';
        }
    }
    keys
    {
        key(PK; "Employee Code", "Leave Code", "Date Recalled")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        "Created By" := UserId;
        "Created Date" := Today;
    end;

    trigger OnModify()
    begin
        "Last Modified By" := UserId;
        "Last Modified Date" := Today;
    end;

    trigger OnDelete()
    begin
        TestField("Date Recalled", 0D);
    end;

    var
        Text001: Label 'The %1 %2 entered is not within the approved Leave dates';


        CauseAbsAppRec: Record "Employee Absence";

        DateRec: Record Date;
        DateIn: Boolean;
        WorkLeave: Record LeaveRecall;
        NoofDays: Integer;
        DateRecalled: Date;
        LeaveRec: Record "Employee Absence";
        DateRecalled2: Date;
}
