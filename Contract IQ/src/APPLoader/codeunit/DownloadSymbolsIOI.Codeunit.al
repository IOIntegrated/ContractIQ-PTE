namespace IOI.ContractIQ;

using System.Environment;
using System.Utilities;
using System.Text;

codeunit 70010 "Download Symbols IOI"
{
    internal procedure DownloadExtension(BearerToken: Text; Extension: record "App Loader Extension IOI"; Progressbar: codeunit "Progressbar IOI"): Boolean
    var
        IStr: InStream;
    begin
        if not Extension.AppSource.HasValue() then begin
            CallWebservice(Extension.DownloadUri(), BearerToken, IStr);
            Extension.SetAppFile(IStr);
            ExtractSymbols(Extension, Progressbar);
        end;
        exit(true);
    end;

    internal procedure ExtractSymbols(Extension: record "App Loader Extension IOI"; Progressbar: codeunit "Progressbar IOI")
    var
        TempBlob: Codeunit "Temp Blob";
        DecodedBlob: Codeunit "Temp Blob";
        CompilerService: Codeunit "Compiler Service IOI";
        Base64Decoder: Codeunit "Base64 Convert";
        SRImport: Codeunit "SR Import IOI";
        InStr: InStream;
        OutStr: OutStream;
        JsonResponse: Text;
        JsonToken: JsonToken;
        JsonObj: JsonObject;
        JsonArray: JsonArray;
        FileContent: Text;
        FileName: Text;
    begin
        Extension.CalcFields("AppSource");
        if not Extension."AppSource".HasValue then
            exit;

        Extension."AppSource".CreateInStream(InStr);
        TempBlob.CreateOutStream(OutStr);
        CopyStream(OutStr, InStr);

        if CompilerService.Decompress7zFile(TempBlob, Extension.id) then begin

            TempBlob.CreateInStream(InStr);
            InStr.Read(JsonResponse);
            JsonObj.ReadFrom(JsonResponse);

            if this.GetJsonArray(JsonObj, 'files', JsonArray) then
                foreach JsonToken in JsonArray do
                    if this.GetTextFromJson(JsonToken.AsObject(), 'filename', FileName) = 'SymbolReference.json' then begin
                        this.GetTextFromJson(JsonToken.AsObject(), 'filecontent', FileContent);
                        DecodedBlob.CreateOutStream(OutStr);
                        Base64Decoder.FromBase64(FileContent, OutStr);
                        DecodedBlob.CreateInStream(InStr);
                        SRImport.ProcessJson(DecodedBlob, Progressbar);
                        exit;
                    end;
        end;
    end;

    internal procedure GetExtensionList(BearerToken: text): Boolean
    var
        ExtensionRec: Record "App Loader Extension IOI";
        EnvironmentInformation: Codeunit "Environment Information";
        // ExtensionListAPIMsg: A label containing the URL template for accessing the list of extensions
        // via the Business Central API. The placeholders in the URL are as follows:
        // %1 - The environment name (e.g., 'sandbox', 'production')
        // %2 - The tenant ID
        // %3 - The company ID
        ExtensionListAPIMsg: label 'https://api.businesscentral.dynamics.com/v2.0/%1/%2/api/microsoft/automation/v2.0/companies(%3)/extensions';
        Result, CompanyId, CurrentEnvironment, TenantId : Text;
        //Json handling
        JO, O : JsonObject;
        T, T2 : JsonToken;
        packageId, id, displayName, publisher : Text;
        versionMajor, versionMinor, versionBuild, versionRevision : Integer;
    begin
        CurrentEnvironment := EnvironmentInformation.GetEnvironmentName();
        if this.GetEnvironmentList(BearerToken, TenantId) then
            if this.GetCompanyList(BearerToken, TenantId, CurrentEnvironment, CompanyId) then begin
                Result := this.CallWebservice(StrSubstNo(ExtensionListAPIMsg, TenantId, CurrentEnvironment, CompanyId), BearerToken);
                if JO.ReadFrom(Result) then
                    if JO.SelectToken('value', T) then
                        if T.IsArray() then
                            foreach T2 in T.AsArray() do begin
                                O := T2.AsObject();
                                packageId := this.GetJsonToken(O, 'packageId').AsValue().AsText();
                                id := this.GetJsonToken(O, 'id').AsValue().AsText();
                                displayName := this.GetJsonToken(O, 'displayName').AsValue().AsText();
                                publisher := this.GetJsonToken(O, 'publisher').AsValue().AsText();
                                versionMajor := this.GetJsonToken(O, 'versionMajor').AsValue().AsInteger();
                                versionMinor := this.GetJsonToken(O, 'versionMinor').AsValue().AsInteger();
                                versionBuild := this.GetJsonToken(O, 'versionBuild').AsValue().AsInteger();
                                versionRevision := this.GetJsonToken(O, 'versionRevision').AsValue().AsInteger();
                                if not ExtensionRec.Get(id, versionMajor, versionMinor, versionBuild, versionRevision) then begin
                                    ExtensionRec.Init();
                                    ExtensionRec.Id := CopyStr(id, 1, MaxStrLen(ExtensionRec.Id));
                                    ExtensionRec.versionMajor := versionMajor;
                                    ExtensionRec.versionMinor := versionMinor;
                                    ExtensionRec.versionBuild := versionBuild;
                                    ExtensionRec.versionRevision := versionRevision;
                                    ExtensionRec.Insert();
                                end;
                                ExtensionRec.packageId := CopyStr(packageId, 1, MaxStrLen(ExtensionRec.packageId));
                                ExtensionRec.displayName := CopyStr(displayName, 1, MaxStrLen(ExtensionRec.displayName));
                                ExtensionRec.Publisher := CopyStr(publisher, 1, MaxStrLen(ExtensionRec.Publisher));
                                ExtensionRec.isInstalled := this.GetJsonToken(O, 'isInstalled').AsValue().AsBoolean();
                                Evaluate(ExtensionRec.publishedAs, this.GetJsonToken(O, 'publishedAs').AsValue().AsText());
                                ExtensionRec.Modify();
                            end;


            end;
        exit(ExtensionRec.Count() > 0);
    end;

    internal procedure GetEnvironmentList(BearerToken: text; var TenantId: text): Boolean
    var
        EnvionmentRec: Record "App Loader Environment IOI";
        Result: Text;
        EnvironmentListAPIMsg: label 'https://api.businesscentral.dynamics.com/environments/v1.1';
        JO, O : JsonObject;
        T, T2 : JsonToken;
        aadTenantId, name : Text;
    begin
        Result := this.CallWebservice(EnvironmentListAPIMsg, BearerToken);
        if Result = '' then
            exit(false);
        if JO.ReadFrom(Result) then
            if JO.SelectToken('value', T) then
                if T.IsArray() then begin
                    foreach T2 in T.AsArray() do begin
                        O := T2.AsObject();
                        aadTenantId := this.GetJsonToken(O, 'aadTenantId').AsValue().AsText();
                        name := this.GetJsonToken(O, 'name').AsValue().AsText();
                        if not EnvionmentRec.Get(aadTenantId, name) then begin
                            EnvionmentRec.Init();
                            EnvionmentRec.aadTenantId := CopyStr(aadTenantId, 1, MaxStrLen(EnvionmentRec.aadTenantId));
                            EnvionmentRec.name := CopyStr(name, 1, MaxStrLen(EnvionmentRec.name));
                            EnvionmentRec.Insert();
                        end;
                        EnvionmentRec.applicationFamily := CopyStr(this.GetJsonToken(O, 'applicationFamily').AsValue().AsText(), 1, MaxStrLen(EnvionmentRec.applicationFamily));
                        Evaluate(EnvionmentRec.type, this.GetJsonToken(O, 'type').AsValue().AsText());
                        EnvionmentRec.countryCode := CopyStr(this.GetJsonToken(O, 'countryCode').AsValue().AsText(), 1, MaxStrLen(EnvionmentRec.countryCode));
                        EnvionmentRec.webServiceUrl := CopyStr(this.GetJsonToken(O, 'webServiceUrl').AsValue().AsText(), 1, MaxStrLen(EnvionmentRec.webServiceUrl));
                        EnvionmentRec.webClientLoginUrl := CopyStr(this.GetJsonToken(O, 'webClientLoginUrl').AsValue().AsText(), 1, MaxStrLen(EnvionmentRec.webClientLoginUrl));
                        EnvionmentRec.Modify();
                        TenantId := this.GetJsonToken(O, 'aadTenantId').AsValue().AsText();
                        IsolatedStorage.Set('TenantId', TenantId);
                    end;
                    exit(TenantId <> '');
                end;
    end;

    internal procedure GetCompanyList(BearerToken: text; TenantId: text; Environment: Text; var CompanyId: text): Boolean
    var
        CompanyRec: Record "App Loader Company IOI";
        Result: Text;
        // URL template for retrieving the list of companies from Business Central API.
        // %1 - Represents the tenant ID.
        // %2 - Represents the environment name.
        CompanyListAPIMsg: label 'https://api.businesscentral.dynamics.com/v2.0/%1/%2/api/microsoft/automation/v2.0/companies';
        JO, O : JsonObject;
        T, T2 : JsonToken;
    begin
        Result := CallWebservice(StrSubstNo(CompanyListAPIMsg, TenantId, Environment), BearerToken);
        if Result = '' then
            exit(false);
        CompanyRec.DeleteAll();
        if JO.ReadFrom(Result) then
            if JO.SelectToken('value', T) then
                if T.IsArray() then begin
                    foreach T2 in T.AsArray() do begin
                        O := T2.AsObject();
                        CompanyRec.Init();
                        CompanyRec.id := CopyStr(this.GetJsonToken(O, 'id').AsValue().AsText(), 1, MaxStrLen(CompanyRec.id));
                        CompanyRec.name := CopyStr(this.GetJsonToken(O, 'name').AsValue().AsText(), 1, MaxStrLen(CompanyRec.name));
                        CompanyRec.systemVersion := CopyStr(this.GetJsonToken(O, 'systemVersion').AsValue().AsText(), 1, MaxStrLen(CompanyRec.systemVersion));
                        CompanyRec.displayName := CopyStr(this.GetJsonToken(O, 'displayName').AsValue().AsText(), 1, MaxStrLen(CompanyRec.displayName));
                        CompanyRec.businessProfileId := CopyStr(this.GetJsonToken(O, 'businessProfileId').AsValue().AsText(), 1, MaxStrLen(CompanyRec.businessProfileId));
                        CompanyRec.timestampInt := this.GetJsonToken(O, 'timestamp').AsValue().AsInteger();
                        CompanyRec.Insert();
                        CompanyId := this.GetJsonToken(O, 'id').AsValue().AsText()
                    end;
                    exit(CompanyId <> '');
                end;
    end;

    internal procedure GetJsonToken(JsonObject: JsonObject; TokenKey: Text) JsonToken: JsonToken;
    var
        MessageText: Text;
        // This label is used to display a message when a specific token is not found.
        // %1 - The token that was not found.
        MessageMsg: Label 'Token %1 not found';
    begin
        MessageText := StrSubstNo(MessageMsg, TokenKey);
        if not JsonObject.Get(TokenKey, JsonToken) then
            Error(MessageText);
    end;

    internal procedure GetJsonArray(JsonObject: JsonObject; JsonKey: Text; var JsonArray: JsonArray): boolean
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

    internal procedure GetTextFromJson(JsonObject: JsonObject; JsonKey: Text; var JsonText: Text): Text
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

    internal procedure CallWebservice(APIUrl: text; BearerToken: text): Text
    var
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        RequestHeader: HttpHeaders;
        WebClient: HttpClient;
        ResponseText: Text;
    begin
        RequestMessage.Method := 'GET';
        RequestMessage.SetRequestUri := APIUrl;
        RequestMessage.GetHeaders(RequestHeader);
        RequestHeader.Add('Authorization', 'Bearer ' + BearerToken);
        WebClient.Send(RequestMessage, ResponseMessage);

        if ResponseMessage.IsSuccessStatusCode() then begin
            ResponseMessage.Content().ReadAs(ResponseText);
            exit(ResponseText);
        end;
    end;

    internal procedure CallWebservice(APIUrl: text; BearerToken: text; var InStr: InStream)
    var
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        RequestHeader: HttpHeaders;
        WebClient: HttpClient;
    begin
        RequestMessage.Method := 'GET';
        RequestMessage.SetRequestUri := APIUrl;
        RequestMessage.GetHeaders(RequestHeader);
        RequestHeader.Add('Authorization', 'Bearer ' + BearerToken);
        WebClient.Send(RequestMessage, ResponseMessage);

        if ResponseMessage.IsSuccessStatusCode() then
            ResponseMessage.Content().ReadAs(InStr);
    end;
}
