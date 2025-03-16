namespace IOI.ContractIQ;

table 70009 "App Loader Company IOI"
{
    Caption = 'App Loader Company';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; id; Text[100])
        {
            Caption = 'id';
            DataClassification = ToBeClassified;
        }
        field(2; systemVersion; Text[100])
        {
            Caption = 'systemVersion';
            DataClassification = ToBeClassified;
        }
        field(3; timestampInt; Integer)
        {
            Caption = 'timestamp';
            DataClassification = ToBeClassified;
        }
        field(4; name; Text[100])
        {
            Caption = 'name';
            DataClassification = ToBeClassified;
        }
        field(5; displayName; Text[100])
        {
            Caption = 'displayName';
            DataClassification = ToBeClassified;
        }
        field(6; businessProfileId; Text[100])
        {
            Caption = 'businessProfileId';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; id)
        {
            Clustered = true;
        }
    }
}
