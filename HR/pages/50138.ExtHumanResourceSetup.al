pageextension 50138 ExtHumanResourceSetup extends "Human Resources Setup"
{
    layout
    {


        addafter("Base Unit of Measure")
        {
            field("Leave Nos"; Rec."Leave Nos")
            {
                Caption = 'Leave Nos.';
                ApplicationArea = ALL;
            }
            field("Leave Adjustment Nos"; Rec."Leave Adjustment Nos")
            {
                Caption = 'Leave Adjustment Nos.';
                ApplicationArea = ALL;
            }
        }
        addafter(Numbering)
        {

            group(LeaveCode)
            {
                Caption = 'Leave Code';
                field("Annaul Leave Code"; Rec."Annaul Leave Code")
                {
                    Caption = 'Annual Leave Code';
                    ApplicationArea = ALL;
                }
                field("Maternity Leave Code"; Rec."Maternity Leave Code")
                {
                    Caption = 'Maternity Leave Code';
                    ApplicationArea = ALL;
                }
                field("Paternity Leave Code"; Rec."Paternity Leave Code")
                {
                    Caption = 'Paternity Leave Code';
                    ApplicationArea = ALL;
                }
                field("Company Leave Code"; Rec."Compasonate Leave Code")
                {
                    Caption = 'Compasonate Leave Code';
                    ApplicationArea = ALL;
                }
                field("Exam Leave Code"; Rec."Exam Leave Code")
                {
                    Caption = 'Exam Leave Code';
                    ApplicationArea = ALL;
                }
                field("Sick Leave Code"; Rec."Sick Leave Code")
                {
                    Caption = 'Sick Leave Code';
                    ApplicationArea = ALL;
                }
                field("Day-Off Leave Code"; Rec."Day-Off Leave Code")
                {
                    Caption = 'Day-Off Leave Code';
                    ApplicationArea = ALL;
                }
                field("Out-Duty Leave Code"; Rec."Out-Duty Leave Code")
                {
                    Caption = 'Out-Duty Leave Code';
                    ApplicationArea = ALL;
                }

            }
            group(PerformanceAppraiser)
            {
                Caption = 'Performance Appraiser Window';
                field("Appraisal Year"; Rec."Appraisal Year")
                {
                    Caption = 'Appraiser Year';
                    ApplicationArea = All;
                }
                field("Objective Setting Start Date"; Rec."Objective Setting Start Date")
                {
                    Caption = 'Objective Setting Start Date';
                    ApplicationArea = All;
                }
                field("Objective Setting End Date"; Rec."Objective Setting End Date")
                {
                    Caption = 'Objective Setting End Date';
                    ApplicationArea = All;
                }
                field("Mid-Year Review Start Date"; Rec."Mid-Year Review Start Date")
                {
                    Caption = 'Mid-Year Review Start Date';
                    ApplicationArea = All;
                }
                field("Mid-Year Review End Date"; Rec."Mid-Year review End Date")
                {
                    Caption = 'Mid-Year Review End Date';
                    ApplicationArea = All;
                }
                field("Year End Evaluation Start Date"; Rec."Year End Evaluation Start Date")
                {
                    Caption = 'Year End Evaluation Start Date';
                    ApplicationArea = All;
                }
                field("Year End Evaluation End Date"; Rec."Year End Evaluation End Date")
                {
                    Caption = 'Year End Evaluation End Date';
                    ApplicationArea = All;
                }
            }

        }
    }
}