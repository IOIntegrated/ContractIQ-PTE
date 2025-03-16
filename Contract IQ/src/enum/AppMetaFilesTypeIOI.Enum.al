namespace IOI.ContractIQ;

enum 70001 "App Meta Files Type IOI"
{
    Extensible = true;

    value(1; Structure)
    {
        Caption = 'Structure';
    }
    value(2; Codeunit)
    {
        Caption = 'Codeunit';
    }
    value(3; Table)
    {
        Caption = 'Table';
    }
    value(4; Page)
    {
        Caption = 'Page';
    }
    value(5; Enum)
    {
        Caption = 'Enum';
    }

}
