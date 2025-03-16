namespace IOI.ContractIQ;

table 70008 "SR Extension IOI"
{
    Caption = 'SR Extension';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "App Package ID"; Guid)
        {
            Caption = 'App Package ID';
        }
        field(2; Name; Text[250])
        {
            Caption = 'Name';
        }
        field(3; Publisher; Text[250])
        {
            Caption = 'Publisher';
        }
        field(4; Version; Text[50])
        {
            Caption = 'Version';
        }
    }
    keys
    {
        key(PK; "App Package ID")
        {
            Clustered = true;
        }
    }
}
