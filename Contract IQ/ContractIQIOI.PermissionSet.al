namespace IOI.ContractIQ;

using IOI.ContractIQ;

permissionset 70000 "Contract IQ IOI"
{
    Assignable = true;
    Permissions = tabledata "Fields IOI" = RIMD,
        tabledata "App Meta Files IOI" = RIMD,
        tabledata "App Meta IOI" = RIMD,
        tabledata "Tables IOI" = RIMD,
        table "Fields IOI" = X,
        table "App Meta Files IOI" = X,
        table "App Meta IOI" = X,
        table "Tables IOI" = X,
        codeunit "App Files Mgt. IOI" = X,
        codeunit "App Meta Mgt. IOI" = X,
        codeunit "Events IOI" = X,
        codeunit "GetFile IOI" = X,
        codeunit "JSON Mgt. IOI" = X,
        codeunit "WriteTableCode IOI" = X,
        codeunit "XML Mgt. IOI" = X,
        page "Contract IQ IOI" = X;
}