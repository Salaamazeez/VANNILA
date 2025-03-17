tableextension 50139 ExtHumanResourceSetup extends "Human Resources Setup"
{
    fields
    {
        field(50100; "Leave Nos"; Code[20])
        {
            Caption = 'Leave Nos';
            DataClassification = ToBeClassified;
            TableRelation = "No. series";
        }
        field(50101; "Leave Adjustment Nos"; Code[20])
        {
            Caption = 'Leave Adjustment Nos';
            DataClassification = ToBeClassified;
            TableRelation = "No. series";
        }
        field(50102; "Annaul Leave Code"; Code[20])
        {
            Caption = 'Annaul Leave Code';
            DataClassification = ToBeClassified;
            TableRelation = "Cause of Absence".Code;
        }
        field(50103; "Maternity Leave Code"; Code[20])
        {
            Caption = 'Maternity Leave Code';
            DataClassification = ToBeClassified;
            TableRelation = "Cause of Absence".Code;
        }
        field(50104; "Paternity Leave Code"; Code[20])
        {
            Caption = 'Paternity Leave Code';
            DataClassification = ToBeClassified;
            TableRelation = "Cause of Absence".Code;
        }
        field(50105; "Compasonate Leave Code"; Code[20])
        {
            Caption = 'Compansonate Leave Code';
            DataClassification = ToBeClassified;
            TableRelation = "Cause of Absence".Code;
        }

        field(50113; "Exam Leave Code"; Code[20])
        {
            Caption = 'Exam Leave Code';
            DataClassification = ToBeClassified;
            TableRelation = "Cause of Absence".Code;
        }
        field(50114; "Sick Leave Code"; Code[20])
        {
            Caption = 'Sick Leave Code';
            DataClassification = ToBeClassified;
            TableRelation = "Cause of Absence".Code;
        }
        field(50115; "Day-Off Leave Code"; Code[20])
        {
            Caption = 'Day-Off Leave Code';
            DataClassification = ToBeClassified;
            TableRelation = "Cause of Absence".Code;
        }
        field(50116; "Out-Duty Leave Code"; Code[20])
        {
            Caption = 'Out-Duty Leave Code';
            DataClassification = ToBeClassified;
            TableRelation = "Cause of Absence".Code;
        }

        field(50125; "Objective Setting Start Date"; Date)
        {
            Caption = 'Objective Setting Start Date';
            DataClassification = ToBeClassified;
        }
        field(50126; "Objective Setting End Date"; Date)
        {
            Caption = 'Objective Setting End Date';
            DataClassification = ToBeClassified;
        }
        field(50127; "Mid-Year Review Start Date"; Date)
        {
            Caption = 'Mid-Year Review Start Date';
            DataClassification = ToBeClassified;
        }
        field(50128; "Mid-Year Review End Date"; Date)
        {
            Caption = 'Mid-Year Review End Date';
            DataClassification = ToBeClassified;
        }
        field(50129; "Year End Evaluation Start Date"; Date)
        {
            Caption = 'Year End Evaluation Start Date';
            DataClassification = ToBeClassified;
        }
        field(50130; "Year End Evaluation End Date"; Date)
        {
            Caption = 'Year End Evaluation End Date';
            DataClassification = ToBeClassified;
        }
        field(50131; "Appraisal Year"; Integer)
        {
            Caption = 'Appraisal Year';
            DataClassification = ToBeClassified;
        }
    }

}