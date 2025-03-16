namespace IOI.ContractIQ;

codeunit 70002 "App Meta Mgt. IOI"
{
    procedure GetAppMetaNameFromPK(id: Guid; version: Text[50]; var appname: Text)
    var
        AppMeta: Record "App Meta IOI";
    begin
        if not ((IsNullGuid(id)) AND (version <> '')) then begin
            AppMeta.SetRange(id, id);
            AppMeta.SetRange(version, version);
            AppMeta.FindFirst();
            appname := AppMeta.name
        end;
    end;


    procedure CreateTableFromAppMeta(AppMeta: Record "App Meta IOI"; var AppTables: Record "Tables IOI")


    begin

        if not AppMeta.IsEmpty then begin
            AppTables.Init();
            AppTables.id := AppMeta.id;
            AppTables.name := 'Table Name ' + format(Random(99999));
            AppTables.Insert();
        end;

    end;

    procedure CreateNewVersionFromAppMeta(AppMeta: Record "App Meta IOI"; var NewAppMeta: Record "App Meta IOI")

    var
        AppFields: Record "Fields IOI";
        AppMetaFiles: Record "App Meta Files IOI";
        AppTables: Record "Tables IOI";
        NewAppFields: Record "Fields IOI";
        NewAppMetaFiles: Record "App Meta Files IOI";
        NewAppTables: Record "Tables IOI";

    begin
        NewAppMeta.Init();
        NewAppMeta.TransferFields(AppMeta);
        NewAppMeta.version := IncStr(AppMeta.version);
        NewAppMeta.Insert();

        AppFields.Reset();
        AppFields.SetRange(id, AppMeta.id);
        if AppFields.FindSet() then
            repeat
                NewAppFields.Init();
                NewAppFields.TransferFields(AppFields);
                NewAppFields.Insert();
            UNTIL AppFields.NEXT() = 0;

        AppMetaFiles.Reset();
        AppMetaFiles.SetRange(id, AppMeta.id);
        AppMetaFiles.SetRange(version, AppMeta.version);
        if AppMetaFiles.FindSet() then
            repeat
                NewAppMetaFiles.Init();
                NewAppMetaFiles.TransferFields(AppMetaFiles);
                NewAppMetaFiles.version := NewAppMeta.version;
                NewAppMetaFiles.Insert();
            UNTIL AppMetaFiles.NEXT() = 0;

        AppTables.Reset();
        AppTables.SetRange(id, AppMeta.id);
        if AppTables.FindSet() then
            repeat
                NewAppTables.Init();
                NewAppTables.TransferFields(AppTables);
                NewAppTables.Insert();
            UNTIL AppTables.NEXT() = 0;


    end;

}
