Table 90214 Bank
{
    DrillDownPageID = Banks;
    LookupPageID = Banks;

    fields
    {
        field(1; "Code"; Code[20])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(2; Name; Text[30])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(3; "Search Name"; Text[30])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(4; "Branch Code"; Code[20])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(5; "Sort Code"; Code[20])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(60000; "Default Payment Platform"; Option)
        {
            DataClassification = EndUserIdentifiableInformation;
            OptionCaption = 'NIBSSPayPlus,RTGS,UBA';
            OptionMembers = NIBSSPayPlus,RTGS,UBA;
        }
        field(60001; "Mode Upload to Platform"; Option)
        {
            DataClassification = EndUserIdentifiableInformation;
            OptionCaption = 'API,E-Mail';
            OptionMembers = API,"E-Mail";
        }
        field(60002; "Lead Bank Code"; Code[20])
        {
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = "Bank".Code;
        }
        field(60003; "Lead Bank ID"; Code[20])
        {
            DataClassification = EndUserIdentifiableInformation;
        }
        field(60004; "Lead Bank Description"; Text[100])
        {
            //DataClassification = EndUserIdentifiableInformation;
            FieldClass = FlowField;
            CalcFormula = lookup("Bank".Name where("Code" = field("Lead Bank Code")));
        }
        field(60005; "Lead Bank Account Code"; Code[20])
        {
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = "Bank Account";
        }


    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

