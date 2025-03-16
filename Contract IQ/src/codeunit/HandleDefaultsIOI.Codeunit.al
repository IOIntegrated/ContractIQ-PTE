namespace IOI.ContractIQ;

codeunit 70007 "Handle Defaults IOI"
{
    procedure CheckInputStructure(ID: Guid)
    var
        AppTables: Record "Tables IOI";
    begin
        AppTables.SetRange(ID, ID);
        AppTables.SetRange("No.", 99999);
        if AppTables.IsEmpty() then begin
            AppTables."No." := 99999;
            AppTables.Name := 'Input Structure';
            AppTables.Caption := 'Input Structure';
            AppTables.DataClassification := AppTables.DataClassification::CustomerContent;
            AppTables.Insert();
        end;
    end;
}
