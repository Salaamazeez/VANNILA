Table 90215 "Payment Bank CBN Code"
{

    fields
    {
        field(1; "Code"; Code[10])
        {
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[50])
        {
            DataClassification = CustomerContent;
        }
        field(3; "Sort Code"; Text[30])
        {
            DataClassification = CustomerContent;
        }
        field(4; "Pen-Legacy Bank"; Text[100])
        {
            DataClassification = CustomerContent;
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

    var
        BankCodes: Record "Bank";


    procedure ImportAllBankCodes()
    begin
        BankCodes.Init();
        BankCodes."Code" := '044';
        BankCodes."Name" := 'Access Bank';
        if not BankCodes.Insert() then BankCodes.Modify();

        BankCodes.Init();
        BankCodes."Code" := '014';
        BankCodes."Name" := 'Afri Bank';
        if not BankCodes.Insert() then BankCodes.Modify();

        BankCodes.Init();
        BankCodes."Code" := '023';
        BankCodes."Name" := 'Citi Bank';
        if not BankCodes.Insert() then BankCodes.Modify();

        BankCodes.Init();
        BankCodes."Code" := '063';
        BankCodes."Name" := 'Diamond Bank';
        if not BankCodes.Insert() then BankCodes.Modify();

        BankCodes.Init();
        BankCodes."Code" := '050';
        BankCodes."Name" := 'Ecobank';
        if not BankCodes.Insert() then BankCodes.Modify();

        BankCodes.Init();
        BankCodes."Code" := '040';
        BankCodes."Name" := 'Equitorial Trust Bank';
        if not BankCodes.Insert() then BankCodes.Modify();

        BankCodes.Init();
        BankCodes."Code" := '214';
        BankCodes."Name" := 'FCMB';
        if not BankCodes.Insert() then BankCodes.Modify();

        BankCodes.Init();
        BankCodes."Code" := '070';
        BankCodes."Name" := 'Fidelity Bank';
        if not BankCodes.Insert() then BankCodes.Modify();

        BankCodes.Init();
        BankCodes."Code" := '085';
        BankCodes."Name" := 'First Inland Bank';
        if not BankCodes.Insert() then BankCodes.Modify();

        BankCodes.Init();
        BankCodes."Code" := '011';
        BankCodes."Name" := 'First Bank of Nigeria';
        if not BankCodes.Insert() then BankCodes.Modify();

        BankCodes.Init();
        BankCodes."Code" := '058';
        BankCodes."Name" := 'Guaranty Trust Bank';
        if not BankCodes.Insert() then BankCodes.Modify();

        BankCodes.Init();
        BankCodes."Code" := '069';
        BankCodes."Name" := 'Intercontinental Bank';
        if not BankCodes.Insert() then BankCodes.Modify();

        BankCodes.Init();
        BankCodes."Code" := '056';
        BankCodes."Name" := 'Oceanic Bank';
        if not BankCodes.Insert() then BankCodes.Modify();

        BankCodes.Init();
        BankCodes."Code" := '082';
        BankCodes."Name" := 'Platinum Habib Bank';
        if not BankCodes.Insert() then BankCodes.Modify();

        BankCodes.Init();
        BankCodes."Code" := '076';
        BankCodes."Name" := 'Skye Bank( Old Prudent Bank)';
        if not BankCodes.Insert() then BankCodes.Modify();

        BankCodes.Init();
        BankCodes."Code" := '084';
        BankCodes."Name" := 'Spring Bank';
        if not BankCodes.Insert() then BankCodes.Modify();

        BankCodes.Init();
        BankCodes."Code" := '039';
        BankCodes."Name" := 'Stanbic IBTC Bank';
        if not BankCodes.Insert() then BankCodes.Modify();

        BankCodes.Init();
        BankCodes."Code" := '068';
        BankCodes."Name" := 'Standard chartered';
        if not BankCodes.Insert() then BankCodes.Modify();

        BankCodes.Init();
        BankCodes."Code" := '232';
        BankCodes."Name" := 'Sterling Bank';
        if not BankCodes.Insert() then BankCodes.Modify();

        BankCodes.Init();
        BankCodes."Code" := '032';
        BankCodes."Name" := 'Union Bank';
        if not BankCodes.Insert() then BankCodes.Modify();

        BankCodes.Init();
        BankCodes."Code" := '033';
        BankCodes."Name" := 'United Bank for Africa';
        if not BankCodes.Insert() then BankCodes.Modify();

        BankCodes.Init();
        BankCodes."Code" := '215';
        BankCodes."Name" := 'Unity Bank';
        if not BankCodes.Insert() then BankCodes.Modify();

        BankCodes.Init();
        BankCodes."Code" := '035';
        BankCodes."Name" := 'Wema Bank';
        if not BankCodes.Insert() then BankCodes.Modify();

        BankCodes.Init();
        BankCodes."Code" := '057';
        BankCodes."Name" := 'Zenith International Bank';
        if not BankCodes.Insert() then BankCodes.Modify();
    end;
}

