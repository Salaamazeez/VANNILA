table 50123 PerformanceAppraiserLine
{
    Caption = 'PerformanceAppraiserLine';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Employee No."; Code[50])
        {
            Caption = 'Employee No.';
        }
        field(2; "Appraisaer Year"; Integer)
        {
            Caption = 'Appraisaer Year';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Objective Settings"; Text[200])
        {
            Caption = 'Objective Settings';
        }
        field(5; "Objective Summary"; Text[250])
        {
            Caption = 'Objective Summary';
        }
        field(6; Measure; Text[250])
        {
            Caption = 'Measure';
        }
        field(7; "By When"; Option)
        {
            Caption = 'By When';
            OptionMembers = ,Ongoing,Q1,Q2,Q3,Q4;
        }
        field(8; Weight; Integer)
        {
            Caption = 'Weight';

            trigger OnValidate()
            begin
                SumWeight := 0;

                performanceLine.SetRange("Employee No.", "Employee No.");
                performanceLine.SetRange("Appraisaer Year", "Appraisaer Year");
                performanceLine.SetFilter(Weight, '>%1', 0);
                IF performanceLine.FindSet() then
                    repeat
                        SumWeight += performanceLine.Weight;
                    until performanceLine.next = 0;

                if ((SumWeight + Weight) > 100) then
                    Error(ErrorWeighttotal, SumWeight + Weight);
            end;
        }
        field(9; "Employee Score"; Integer)
        {
            Caption = 'Employee Score';

            trigger OnValidate()
            begin
                if "Employee Score" > Weight then
                    Error(ErrorEmpScore, "Employee Score", Weight);
            end;
        }
        field(10; "Manager Score"; Integer)
        {
            Caption = 'Manager Score';

            trigger OnValidate()
            begin
                Rec.TestField("Employee Score");

                if "Manager Score" > Weight then
                    Error(ErrorMgrScore, "Manager Score", Weight);
            end;

        }
    }
    keys
    {
        key(PK; "Employee No.", "Appraisaer Year", "Line No.")
        {
            Clustered = true;
        }
    }
    var
        performanceLine: Record PerformanceAppraiserLine;
        SumWeight: Integer;

        ErrorAppraiserYear: Label 'The Appraiser Year in the Human Resource Setup %1 is not same as the current year %2. contact the system Administrator to update the Appraiser year in the Human Resource Setup.';
        ErrorEmpScore: label 'Employee Score %1 cannot be more than the Weight value of %2';
        ErrorMgrScore: label 'Manager Score %1 cannot be more than the Weight value of %2';
        ErrorWeighttotal: label 'The sum total of the Weight enter %1 in the line for all the Objectives cannot be more than 100';
}
