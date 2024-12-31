Codeunit 50017 Library
{

    trigger OnRun()
    begin
    end;

    var
        "------------------------------": Text[30];
        Words: Text[250];
        Ands: Text[10];
        ZvAL: Decimal;
        SVal: Text[30];


    procedure "A-A-A-----------------"()
    begin
    end;


    procedure C1000_Infinity(Value: Decimal) retvalue: Text[250]
    var
        t: Decimal;
        tmp: Text[250];
        t3: Integer;
    begin
        begin
            tmp := Format(ROUND(Value, 1, '<'));
            t := ROUND(StrLen(Format(ROUND(Value, 1, '<'), 0, 1)) / 3, 1, '>');
            retvalue := '';

            repeat
                if StrPos(tmp, ',') <> 0 then begin
                    Evaluate(t3, CopyStr(tmp, 1, StrPos(tmp, ',') - 1));
                    ZvAL := t3;
                    tmp := CopyStr(tmp, StrPos(tmp, ',') + 1)
                end
                else begin
                    Evaluate(t3, tmp);
                    //EVALUATE(ZvAL,COPYSTR(tmp,1,3));
                    tmp := '';
                end;
                t := t - 1;
                retvalue := retvalue + C0_999(t3);
                //AAA-Sta Feb 21 2002
                if (t = 1) and (ZvAL = 0)
                 then
                    SVal := ''
                else
                    SVal := SelectStr(28 + t, Words);
                if (t > 0) then retvalue := retvalue + ' ' + SVal + ' ';
            //AAA-Sto - Feb 21 2002
            //AAA IF(t>0)THEN retvalue := retvalue+' '+SELECTSTR(28+t,Words)+' ';
            until tmp = '';
            exit(retvalue);
        end;
    end;


    procedure C0_9(digit: Integer): Text[20]
    begin
        begin
            case digit of
                0:
                    exit('');
                1:
                    exit(SelectStr(1, Words));
                2:
                    exit(SelectStr(2, Words));
                3:
                    exit(SelectStr(3, Words));
                4:
                    exit(SelectStr(4, Words));
                5:
                    exit(SelectStr(5, Words));
                6:
                    exit(SelectStr(6, Words));
                7:
                    exit(SelectStr(7, Words));
                8:
                    exit(SelectStr(8, Words));
                9:
                    exit(SelectStr(9, Words));
            end;
        end;
    end;


    procedure C0_999(ThreeDigit: Integer): Text[100]
    var
        text1: Text[30];
        TwoDigit: Integer;
        Hundreds: Text[30];
    begin
        begin
            TwoDigit := ThreeDigit MOD 100;
            Hundreds := C0_9(ROUND(ThreeDigit / 100, 1, '<'));
            if (Hundreds <> '') then Hundreds := Hundreds + ' ' + SelectStr(28, Words);

            if (TwoDigit > 0) and (Hundreds <> '') then
                Hundreds := Hundreds + ' ' + Ands + ' ';

            if (TwoDigit > 19) then begin
                text1 := C0_9(TwoDigit MOD 10);
                if text1 <> '' then text1 := ' ' + text1;
            end;

            case ROUND(TwoDigit / 10, 1, '<') of
                0, 1:
                    begin
                        case TwoDigit of
                            0, 1, 2, 3, 4, 5, 6, 7, 8, 9:
                                exit(Hundreds + C0_9(TwoDigit));
                            10:
                                exit(Hundreds + SelectStr(10, Words));
                            11:
                                exit(Hundreds + SelectStr(11, Words));
                            12:
                                exit(Hundreds + SelectStr(12, Words));
                            13:
                                exit(Hundreds + SelectStr(13, Words));
                            14:
                                exit(Hundreds + SelectStr(14, Words));
                            15:
                                exit(Hundreds + SelectStr(15, Words));
                            16:
                                exit(Hundreds + SelectStr(16, Words));
                            17:
                                exit(Hundreds + SelectStr(17, Words));
                            18:
                                exit(Hundreds + SelectStr(18, Words));
                            19:
                                exit(Hundreds + SelectStr(19, Words));
                        end;
                    end;
                2:
                    exit(Hundreds + SelectStr(20, Words) + text1);
                3:
                    exit(Hundreds + SelectStr(21, Words) + text1);
                4:
                    exit(Hundreds + SelectStr(22, Words) + text1);
                5:
                    exit(Hundreds + SelectStr(23, Words) + text1);
                6:
                    exit(Hundreds + SelectStr(24, Words) + text1);
                7:
                    exit(Hundreds + SelectStr(25, Words) + text1);
                8:
                    exit(Hundreds + SelectStr(26, Words) + text1);
                9:
                    exit(Hundreds + SelectStr(27, Words) + text1);
            end;
        end;
    end;


    procedure ToWords(Value: Decimal; Currency: Text[30]; CurrencyUnit: Text[30]; ConversionRate: Integer; LanguageCodes: Text[250]): Text[250]
    var
        WholeNumber: Decimal;
        DecimalPart: Decimal;
        l: Integer;
    begin
        begin
            Value := Abs(Value);
            if LanguageCodes = '' then begin
                LanguageCodes := 'One,Two,Three,Four,Five,Six,Seven,Eight,Nine,Ten,Eleven,Twelve,Thirtheen,Fourteen,Fifteen,Sixteen,Seventeen,'
             ;
                LanguageCodes := LanguageCodes + 'Eighteen,Nineteen,Twenty,Thirty,Fourty,Fifty,Sixty,Seventy,Eighty,Ninety,Hundred,Thousand,';
                LanguageCodes := LanguageCodes + 'Million,Billion,Trillion';
            end;
            Words := LanguageCodes;
            Ands := 'and';

            if ConversionRate = 0 then ConversionRate := 100;

            WholeNumber := ROUND(Value, 1, '<');
            if StrPos(Format(Value), '.') <> 0 then begin
                l := StrLen(Format(Value)) + 1;
                repeat
                    l := l - 1;
                until Evaluate(DecimalPart, '0' + CopyStr(CopyStr(Format(Value), 1, l), StrPos(Format(Value), '.')));
                DecimalPart := DecimalPart * ConversionRate;
                DecimalPart := ROUND(DecimalPart, 1, '=');
            end
            else
                DecimalPart := 0;
            if (WholeNumber > 0) and (DecimalPart > 0) then
                exit(C1000_Infinity(WholeNumber) + ' ' + Currency + ' ' + C1000_Infinity(DecimalPart) + ' ' + CurrencyUnit);

            if (WholeNumber > 0) and (DecimalPart = 0) then
                exit(C1000_Infinity(WholeNumber) + ' ' + Currency);

            if (WholeNumber = 0) and (DecimalPart > 0) then
                exit(C1000_Infinity(DecimalPart) + ' ' + CurrencyUnit);

            if (WholeNumber = 0) and (DecimalPart = 0) then
                exit('');
        end;
    end;
}

