namespace IOI.ContractIQ;

using System.DataAdministration;

table 70010 "App Loader Environment IOI"
{
    Caption = 'App Loader Environment';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; aadTenantId; Text[100])
        {
            Caption = 'aadTenantId';
            DataClassification = ToBeClassified;
        }
        field(2; applicationFamily; Text[100])
        {
            Caption = 'applicationFamily';
            DataClassification = ToBeClassified;
        }
        field(3; type; Enum "Environment Type")
        {
            Caption = 'type';
            DataClassification = ToBeClassified;
        }
        field(4; name; Text[100])
        {
            Caption = 'name';
            DataClassification = ToBeClassified;
        }
        field(5; countryCode; Code[10])
        {
            Caption = 'countryCode';
            DataClassification = ToBeClassified;
        }
        field(6; webServiceUrl; Text[250])
        {
            Caption = 'webServiceUrl';
            DataClassification = ToBeClassified;
        }
        field(7; webClientLoginUrl; Text[250])
        {
            Caption = 'webClientLoginUrl';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; aadTenantId, name)
        {
            Clustered = true;
        }
    }
}

