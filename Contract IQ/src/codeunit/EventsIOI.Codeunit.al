namespace IOI.ContractIQ;

codeunit 70003 "Events IOI"
{

    [EventSubscriber(ObjectType::Table, Database::"App Meta IOI", 'OnAfterDeleteEvent', '', false, false)]
    local PROCEDURE OnAfterDeleteEventAppMeta(VAR Rec: Record "App Meta IOI"; RunTrigger: Boolean);
    begin
        if RunTrigger then
            DeleteRelatedTables(Rec);
    end;


    local procedure DeleteRelatedTables(AppMeta: Record "App Meta IOI")
    var
        AppFields: Record "Fields IOI";
        AppTables: Record "Tables IOI";
        AppMetaFiles: Record "App Meta Files IOI";
    begin

        AppFields.Reset();
        AppFields.SetRange(id, AppMeta.id);
        if AppFields.FindSet() then
            AppFields.DeleteAll();

        AppTables.Reset();
        AppTables.SetRange(id, AppMeta.id);
        if AppTables.FindSet() then
            AppTables.DeleteAll();

        AppMetaFiles.Reset();
        AppMetaFiles.SetRange(id, AppMeta.id);
        if AppMetaFiles.FindSet() then
            AppMetaFiles.DeleteAll();

    end;


}
