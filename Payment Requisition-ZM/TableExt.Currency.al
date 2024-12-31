TableExtension 50100 CurrencyExt extends Currency
{
    fields
    {
        field(60000; "Lower Unit Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Description = 'To give the info such as Cent, Kobo etc';
        }
    }
}

