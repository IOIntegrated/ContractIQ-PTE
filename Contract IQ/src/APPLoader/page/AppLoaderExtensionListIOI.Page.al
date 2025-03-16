page 70011 "App Loader Extension List IOI"
{
    ApplicationArea = All;
    Caption = 'Extension List';
    PageType = List;
    SourceTable = "App Loader Extension IOI";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(packageId; Rec.packageId)
                {
                    ToolTip = 'Specifies the value of the packageId field.';
                }
                field(id; Rec.id)
                {
                    ToolTip = 'Specifies the value of the id field.';
                    trigger OnDrillDown()
                    var
                        SRObjectRec: record "SR Object IOI";
                        SRObject: page "SR Object List IOI";
                    begin
                        SRObjectRec.SetRange("App Package ID", Rec.id);
                        SRObject.SetTableView(SRObjectRec);
                        SRObject.Run();
                    end;
                }
                field(publisher; Rec.publisher)
                {
                    ToolTip = 'Specifies the value of the publisher field.';
                }
                field(displayName; Rec.displayName)
                {
                    ToolTip = 'Specifies the value of the displayName field.';
                }
                field(versionMajor; Rec.versionMajor)
                {
                    ToolTip = 'Specifies the value of the versionMajor field.';
                }
                field(versionMinor; Rec.versionMinor)
                {
                    ToolTip = 'Specifies the value of the versionMinor field.';
                }
                field(versionBuild; Rec.versionBuild)
                {
                    ToolTip = 'Specifies the value of the versionBuild field.';
                }
                field(versionRevision; Rec.versionRevision)
                {
                    ToolTip = 'Specifies the value of the versionRevision field.';
                }
                field(publishedAs; Rec.publishedAs)
                {
                    ToolTip = 'Specifies the value of the publishedAs field.';
                }
                field(isInstalled; Rec.isInstalled)
                {
                    ToolTip = 'Specifies the value of the isInstalled field.';
                }
                field(AppSourceDownloaded; this.AppSourceDownloaded)
                {
                    Caption = 'App Source Downloaded';
                    ToolTip = 'AppSourceDownloaded';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(UnZip)
            {
                Caption = 'UnZip AppSource';
                ToolTip = 'UnZip AppSource';
                ApplicationArea = All;
                trigger OnAction()
                var
                    TempBlob: Codeunit "Temp Blob";
                    DecodedBlob: Codeunit "Temp Blob";
                    CompilerService: Codeunit "Compiler Service IOI";
                    Base64Decoder: Codeunit "Base64 Convert";
                    SQImport: Codeunit "SR Import IOI";
                    Progressbar: Codeunit "Progressbar IOI";
                    InStr: InStream;
                    OutStr: OutStream;
                    JsonResponse: Text;
                    JsonToken: JsonToken;
                    JsonObj: JsonObject;
                    JsonArray: JsonArray;
                    FileContent: Text;
                    FileName: Text;
                begin
                    // 1. Hole den Blob-Wert aus Feld 11
                    Rec.CalcFields("AppSource");
                    if not Rec."AppSource".HasValue then
                        Error('Kein AppSource-Inhalt vorhanden');

                    // 2. Erstelle einen InStream aus dem Blob
                    Rec."AppSource".CreateInStream(InStr);
                    TempBlob.CreateOutStream(OutStr);
                    CopyStream(OutStr, InStr);

                    // 3. Rufe die Azure-Dekomprimierungsfunktion auf
                    if CompilerService.Decompress7zFile(TempBlob, Rec.id) then begin

                        // 4. Überprüfe, ob die Datei extrahiert wurde
                        TempBlob.CreateInStream(InStr);
                        InStr.Read(JsonResponse);
                        JsonObj.ReadFrom(JsonResponse);

                        Progressbar.ProgressbarInit();
                        Progressbar.ProgressbarUpdate(3, Rec.displayName);

                        if this.GetJsonArray(JsonObj, 'files', JsonArray) then
                            foreach JsonToken in JsonArray do
                                if this.GetTextFromJson(JsonToken.AsObject(), 'filename', FileName) = 'SymbolReference.json' then begin
                                    this.GetTextFromJson(JsonToken.AsObject(), 'filecontent', FileContent);
                                    DecodedBlob.CreateOutStream(OutStr);
                                    Base64Decoder.FromBase64(FileContent, OutStr);
                                    DecodedBlob.CreateInStream(InStr);
                                    SQImport.ProcessJson(DecodedBlob, Progressbar);
                                end;
                        Progressbar.ProgressbarClose();
                    end;
                end;
            }
        }
    }
    var
        AppSourceDownloaded: Boolean;

    trigger OnAfterGetRecord()
    begin
        this.AppSourceDownloaded := Rec.AppSource.HasValue;
    end;

    local procedure GetJsonArray(JsonObject: JsonObject; JsonKey: Text; var JsonArray: JsonArray): boolean
    var
        JsonToken: JsonToken;
    begin
        if JsonObject.Get(JsonKey, JsonToken) then
            if JsonToken.IsArray then begin
                JsonArray := JsonToken.AsArray();
                exit(true);
            end;
        exit(false);
    end;

    local procedure GetJsonObject(ParentJsonObject: JsonObject; JsonKey: Text; var JsonObject: JsonObject): boolean
    var
        JsonToken: JsonToken;
    begin
        if ParentJsonObject.Get(JsonKey, JsonToken) then
            if JsonToken.IsObject then begin
                JsonObject := JsonToken.AsObject();
                exit(true);
            end;
        exit(false);
    end;

    local procedure GetTextFromJson(JsonObject: JsonObject; JsonKey: Text; var JsonText: Text): Text
    var
        JsonToken: JsonToken;
    begin
        if JsonObject.Get(JsonKey, JsonToken) then
            if JsonToken.IsValue() then begin
                JsonText := JsonToken.AsValue().AsText();
                exit(JsonText);
            end;
        exit(JsonText);
    end;

}
