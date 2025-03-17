table 50122 PerformanceAppraisalHeader
{
    Caption = 'Performance Appraisal Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Employee No."; Code[50])
        {
            Caption = 'Employee No.';
            TableRelation = Employee;

            trigger OnValidate()
            begin
                HRSetup.Get();
                HRSetup.TestField("Appraisal Year");
                HRSetup.TestField("Objective Setting Start Date");
                HRSetup.TestField("Objective Setting End Date");
                HRSetup.TestField("Mid-Year Review Start Date");
                HRSetup.TestField("Mid-Year Review End Date");
                HRSetup.TestField("Year End Evaluation Start Date");
                HRSetup.TestField("Year End Evaluation End Date");

                Evaluate(AppraiserYear, FORMAT(Date2DMY(Today, 3)));

                IF (AppraiserYear <> HRSetup."Appraisal Year") then
                    ERROR(ErrorAppraiserYear, HRSetup."Appraisal Year", AppraiserYear);

                "Appraisal Year" := AppraiserYear;

                if EmpRec.get("Employee No.") then begin
                    "Employee Name" := EmpRec."Last Name" + ' ' + EmpRec."First Name";
                    "Line Manager No." := EmpRec."Manager No.";
                    If EmpRecMgr.get(EmpRec."Manager No.") then
                        "Line Manager Name" := EmpRecMgr."Last Name" + ' ' + EmpRecMgr."First Name";
                    "Shortcut Dimension 1 Code" := EmpRec."Global Dimension 1 Code";
                    "Shortcut Dimension 2 Code" := EmpRec."Global Dimension 2 Code";
                    "Job Title" := EmpRec."Job Title"

                end;

                if "Employee No." = '' then begin
                    Clear("Appraisal Year");
                    Clear("Employee Name");
                    Clear("Line Manager No.");
                    Clear("Line Manager Name");
                    Clear("Shortcut Dimension 1 Code");
                    Clear("Shortcut Dimension 2 Code");
                    Clear("Job Title");
                end;

            end;
        }
        field(2; "Appraisal Year"; Integer)
        {
            Caption = 'Appraisal Year';
            Editable = false;
        }
        field(3; "Employee Name"; Text[150])
        {
            Caption = 'Employee Name';
            Editable = false;
        }
        field(4; "Line Manager No."; Code[50])
        {
            Caption = 'Line Manager No.';
            TableRelation = Employee;
        }
        field(5; "Line Manager Name"; Text[150])
        {
            Caption = 'Line Manager Name';
            Editable = false;
        }
        field(6; "Job Title"; Text[100])
        {
            Caption = 'Job Title';
            Editable = false;
        }
        field(7; "Shortcut Dimension 1 Code"; Code[50])
        {
            Caption = 'Shortcut Dimension 1 Code';
            Editable = false;
        }
        field(8; "Shortcut Dimension 2 Code"; Code[50])
        {
            Caption = 'Shortcut Dimension 2 Code';
            Editable = false;
        }
        field(9; Status; Option)
        {
            Caption = 'Approval Status';
            OptionMembers = Open,"Pending Approval",Approved;
            Editable = false;
        }
        field(10; "Area"; Text[100])
        {
            Caption = 'Area';
        }
        field(11; "Actions"; Text[200])
        {
            Caption = 'Actions';
        }
        field(12; "Expected Completon Date"; Date)
        {
            Caption = 'Expected Completon Date';
        }
        field(13; "No. of Objectives"; Integer)
        {
            Caption = 'No. of Objectives';
            Editable = false;

            FieldClass = FlowField;
            CalcFormula = count(PerformanceAppraiserLine where("Employee No." = field("Employee No."), "Appraisaer Year" = field("Appraisal Year")));
        }
        field(14; Closed; Boolean)
        {
            Caption = 'Closed';
            Editable = false;
        }
        field(15; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
            Editable = false;

        }
        field(16; "Creation Time"; Time)
        {
            Caption = 'Creation Time';
            Editable = false;
        }
        field(17; "Last Modified Date"; Date)
        {
            Caption = 'Last Modified Date';
            Editable = false;
        }
        field(18; "Last Modified time"; Time)
        {
            Caption = 'Last Modified time';
            Editable = false;
        }
        field(19; "Created By"; Code[50])
        {
            Caption = 'Created By';
            Editable = false;
        }
        field(20; "Last Modified By"; Code[50])
        {
            Caption = 'Last Modified By';
            Editable = false;
        }
        field(21; "Employee Progress update"; Text[200])
        {
            Caption = 'Employee Progress update';

            trigger OnValidate()
            begin
                rec.TestField("Area");
                Rec.TestField("Actions");
                rec.TestField("Expected Completon Date");
            end;

        }
        field(22; "Manager Progress Update"; Text[200])
        {
            Caption = 'Manager Progress Update';
            trigger OnValidate()
            begin
                rec.TestField("Employee Progress update");
                Rec.TestField("Emp. Mid-Year Dev. Plan Update");
            end;
        }
        field(23; "Emp. Mid-Year Dev. Plan Update"; Text[200])
        {
            Caption = 'Emp. Mid-Year Dev. Plan Update';

        }
        field(24; "Mgr. Mid-Year Dev. Plan Update"; Text[200])
        {
            Caption = 'Mgr. Mid-Year Dev. Plan Update';

            trigger OnValidate()
            begin
                rec.TestField("Manager Progress Update");
            end;

        }
        field(25; "Employee Final Rating"; Option)
        {
            Caption = 'Employee Final Rating';
            OptionMembers = ,Successful,"Meet Expectations","Exceed Expectations","Role Model";


        }
        field(26; "Employee Final Comment"; Text[200])
        {
            Caption = 'Employee Final Comment';

        }
        field(27; "Employee Sign-off"; Option)
        {
            Caption = 'Employee Sign-off';
            OptionMembers = ,Accepted,Rejected;
            trigger OnValidate()
            begin
                rec.TestField("Manager Final Comment");
            end;

        }
        field(28; "Manager Final Rating"; Option)
        {
            Caption = 'Manager Final Rating';
            OptionMembers = ,Successful,"Meet Expectations","Exceed Expectations","Role Model";

            trigger OnValidate()
            begin
                rec.TestField("Employee Final Rating");
                rec.TestField("Employee Final Comment");
            end;
        }
        field(29; "Manager Final Comment"; Text[200])
        {
            Caption = 'Manager Final Comment';
            trigger OnValidate()
            begin
                rec.TestField("Manager Final Rating");
            end;

        }
        field(30; "Employee Rating%"; Decimal)
        {
            Caption = 'Employee Rating (%)';
            Editable = false;

            trigger OnValidate()
            begin
                rec.TestField("Mgr. Mid-Year Dev. Plan Update");
            end;
        }
        field(31; "manager Rating%"; Decimal)
        {
            Caption = 'Manager Rating (%)';
            Editable = false;
        }

    }

    keys
    {
        key(PK; "Employee No.", "Appraisal Year")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        "Created By" := UserId;
        "Creation Date" := Today;
        "Creation Time" := Time;
    end;

    trigger OnModify()
    begin
        "Last Modified By" := UserId;
        "Last Modified Date" := today;
        "Last Modified time" := Time;
    end;

    var
        HRsetup: Record "Human Resources Setup";
        AppraiserYear: Integer;
        EmpRec: Record Employee;
        EmpRecMgr: Record Employee;
        PerformanceHead: record PerformanceAppraisalHeader;
        PerformanceLine: record PerformanceAppraiserLine;

        ErrorAppraiserYear: label 'The Appraiser year %1 is not same as the Appraiser Yesr in the Human Resource Setup %2. Please contact system Administrator to enter the correct Appraiser year in the Human Resource Setup ';

    procedure CheckMandatoryFileds()
    begin
        Rec.TestField(Rec.Status, Rec.Status::Open);
        rec.TestField("Employee No.");
        Rec.TestField("Actions");
        rec.TestField("Area");
        Rec.TestField("Appraisal Year");
        Rec.TestField("Expected Completon Date");


        PerformanceLine.Reset();
        PerformanceLine.SetRange("Employee No.", "Employee No.");
        PerformanceLine.SetRange("Appraisaer Year", "Appraisal Year");
        if PerformanceLine.FindSet() then
            repeat
                PerformanceLine.TestField("Objective Settings");
                PerformanceLine.TestField("Objective Summary");
                PerformanceLine.TestField(Measure);
                PerformanceLine.TestField(Weight);
                PerformanceLine.TestField("By When");

            until PerformanceLine.Next() = 0;

    end;


    procedure PerformManualReopen()
    var

    begin
        PerformanceHead.SetRange("Employee No.", Rec."Employee No.");
        PerformanceHead.SetRange("Appraisal Year", "Appraisal Year");
        IF PerformanceHead.FindFirst() then begin
            PerformanceHead.Status := PerformanceHead.Status::Open;
            PerformanceHead.Modify();
        end;
    end;

    procedure PerformManualRelease()
    var

    begin
        PerformanceHead.SetRange("Employee No.", Rec."Employee No.");
        PerformanceHead.SetRange("Appraisal Year", "Appraisal Year");
        IF PerformanceHead.FindFirst() then begin
            CheckMandatoryFileds();
            PerformanceHead.Status := PerformanceHead.Status::Approved;
            PerformanceHead.Modify();
        end;
    end;

    procedure PerformManualclose()
    var
    begin
        PerformanceHead.SetRange("Employee No.", Rec."Employee No.");
        PerformanceHead.SetRange("Appraisal Year", "Appraisal Year");
        IF PerformanceHead.FindFirst() then begin

            PerformanceHead.TestField(Status, PerformanceHead.Status::Approved);
            PerformanceHead.TestField("Employee Sign-off");
            PerformanceHead.Closed := true;
            PerformanceHead.Modify();
        end;
    end;

}
