namespace IOI.ContractIQ;

enum 70004 "App Data Classification IOI"
{
    Extensible = true;

    value(1; CustomerContent)
    {
        Caption = 'CustomerContent';
    }
    value(2; EndUserIdentifiableInformation)
    {
        Caption = 'EndUserIdentifiableInformation';
    }
    value(3; AccountData)
    {
        Caption = 'AccountData';
    }
    value(4; EndUserPseudonymousIdentifiers)
    {
        Caption = 'EndUserPseudonymousIdentifiers';
    }
    value(5; OrganizationIdentifiableInformation)
    {
        Caption = 'OrganizationIdentifiableInformation';
    }
    value(6; SystemMetadata)
    {
        Caption = 'SystemMetadata';
    }
    value(7; ToBeClassified)
    {
        Caption = 'ToBeClassified';
    }

}
