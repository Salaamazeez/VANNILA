table 50112 JourneyCalendar
{
    Caption = 'Journey Calender';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Period Type"; Option)
        {
            Caption = 'Period Type';
            OptionMembers = Date,Week,Month,Year;
            Editable = false;
        }
        field(3; "Start Date"; Date)
        {
            Caption = 'Date';
            Editable = false;
        }
        field(4; "Period Name"; Text[30])
        {
            Caption = 'Period Name';
            Editable = false;
        }
        field(5; "Public Holiday"; Boolean)
        {
            Caption = 'Public Holiday';
        }
        field(6; Sunday; Boolean)
        {
            Caption = 'Sunday';
        }
        field(7; Saturday; Boolean)
        {
            Caption = 'Saturday';
        }
        field(8; "Sanitation Day"; Boolean)
        {
            Caption = 'Sanitation Day';
        }
        field(9; Remarks; Text[200])
        {
            Caption = 'Remarks';
        }
        field(10; Week; Code[10])
        {
            Caption = 'Week';
        }
        field(11; Year; Code[10])
        {
            Caption = 'Year';
        }
        field(12; "Journey Code"; Code[10])
        {
            Caption = 'Journey Code';
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

}