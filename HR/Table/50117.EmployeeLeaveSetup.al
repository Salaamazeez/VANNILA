table 50117 EmployeeLeaveSetup
{
    Caption = 'Employee Leave Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee;

            trigger OnValidate()
            begin
                IF EmployeeRec.GET("Employee No.") THEN BEGIN
                    // EmployeeRec.TESTFIELD("Approval Status",EmployeeRec."Approval Status"::Approved);
                    EmployeeRec.TESTFIELD("Employment Date");

                    "Shortcut Dimension 1 Code" := EmployeeRec."Global Dimension 1 Code";
                    "Shortcut Dimension 2 Code" := EmployeeRec."Global Dimension 2 Code";
                    //"Shortcut Dimension 3 Code" := EmployeeRec."Shortcut Dimension 3 Code";
                    //"Shortcut Dimension 4 Code" := EmployeeRec."Shortcut Dimension 4 Code";
                    //"Employee Band" := EmployeeRec.Band;
                    //"Employee Zone" := EmployeeRec.Zone;
                    Name := EmployeeRec."First Name" + ' ' + EmployeeRec."Middle Name" + ' ' + EmployeeRec."Last Name";
                    "Employment Date" := EmployeeRec."Employment Date";
                    EVALUATE("Year Employed", FORMAT(DATE2DMY("Employment Date", 3)));
                END;

                IF "Employee No." = '' THEN BEGIN
                    CLEAR(Name);
                    CLEAR("Employee Band");
                    CLEAR("Employee Zone");
                    CLEAR("Year Employed");
                    CLEAR("Employment Date");
                    CLEAR("Shortcut Dimension 1 Code");
                    CLEAR("Shortcut Dimension 2 Code");
                    CLEAR("Shortcut Dimension 3 Code");
                    CLEAR("Shortcut Dimension 4 Code");
                END;

            end;
        }
        field(2; Name; Text[150])
        {
            Caption = 'Name';
            Editable = false;
        }
        field(3; "Leave Entitled"; Integer)
        {
            Caption = 'Leave Entitled';
        }
        field(4; "Employment Date"; Date)
        {
            Caption = 'Employment Date';
            Editable = false;
        }
        field(5; "Year Employed"; Integer)
        {
            Caption = 'Year Employed';
            Editable = false;
        }
        field(6; "Employee Band"; Code[10])
        {
            Caption = 'Employee Band';
            Editable = false;
        }
        field(7; "Employee Zone"; Code[10])
        {
            Caption = 'Employee Zone';
            Editable = false;
        }
        field(8; "Shortcut Dimension 1 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 1 Code';
            CaptionClass = '1,1,1';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(9; "Shortcut Dimension 2 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 2 Code';
            CaptionClass = '1,1,2';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(10; "Shortcut Dimension 3 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 3 Code';
            CaptionClass = '1,2,3';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
        }
        field(11; "Shortcut Dimension 4 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 4 Code';
            CaptionClass = '1,2,4';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));
        }
    }
    keys
    {
        key(PK; "Employee No.")
        {
            Clustered = true;
        }
    }
    var
        EmployeeRec: Record Employee;
}
