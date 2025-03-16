namespace IOI.ContractIQ;

permissionset 70001 "APPLoader IOI"
{
    Assignable = true;
    Permissions = tabledata "App Loader Company IOI" = RIMD,
        tabledata "App Loader Environment IOI" = RIMD,
        table "App Loader Company IOI" = X,
        table "App Loader Environment IOI" = X,
        codeunit "Device Code Flow IOI" = X,
        codeunit "Download Symbols IOI" = X,
        page "Device Code Flow Page IOI" = X,
        tabledata "App Loader Extension IOI" = RIMD,
        table "App Loader Extension IOI" = X,
        page "App Loader Extension List IOI" = X;
}