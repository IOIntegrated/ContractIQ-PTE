namespace IOI.ContractIQ;

using IOI.ContractIQ;

permissionset 70000 "Contract IQ IOI"
{
    Assignable = true;
    Permissions =
        tabledata "ContractIQ Settings IOI" = RIMD,
        table "ContractIQ Settings IOI" = X,
        tabledata "Translation IOI" = RIMD,
        table "Translation IOI" = X,
        tabledata "SR Object IOI" = RIMD,
        table "SR Object IOI" = X,
        tabledata "SR Object Detail IOI" = RIMD,
        table "SR Object Detail IOI" = X,
        tabledata "SR Extension IOI" = RIMD,
        table "SR Extension IOI" = X,
        tabledata "Fields IOI" = RIMD,
        table "Fields IOI" = X,
        tabledata "App Meta Files IOI" = RIMD,
        table "App Meta Files IOI" = X,
        tabledata "App Meta IOI" = RIMD,
        table "App Meta IOI" = X,
        tabledata "Tables IOI" = RIMD,
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
