namespace IOI.ContractIQ;

using System.Environment;

codeunit 70009 "Device Code Flow IOI"
{
    internal procedure StartAuthorizationProcess(ClientID: Text; var UserCode: Text; var VerificationURI: Text; var DeviceCode: Text; var ExpiresIn: Integer): Boolean
    var
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        RequestHeader: HttpHeaders;
        RequestContent: HttpContent;
        RequestUri: Text;
        WebClient: HttpClient;
        JObjectResult: JsonObject;
        AuthPayload: Text;
        ResponseText: Text;
        ExpiresOn: DateTime;
        WebserviceErrorLbl: Label 'Webservice Error :/';
    begin
        RequestMessage.Method := 'POST';
        RequestUri := 'https://login.microsoftonline.com/' + this.GetCurrentTenant() + '/oauth2/v2.0/devicecode';
        RequestMessage.SetRequestUri(RequestUri);
        RequestMessage.GetHeaders(RequestHeader);

        AuthPayload := 'client_id=' + ClientID + '&scope=https://api.businesscentral.dynamics.com/user_impersonation';

        // Get Request Content
        RequestContent.WriteFrom(AuthPayload);
        RequestContent.GetHeaders(RequestHeader);
        RequestHeader.Remove('Content-Type');
        RequestHeader.Add('Content-Type', 'application/x-www-form-urlencoded');

        RequestMessage.Content := RequestContent;
        WebClient.Send(RequestMessage, ResponseMessage);

        if ResponseMessage.IsSuccessStatusCode() then begin
            ResponseMessage.Content().ReadAs(ResponseText);

            if JObjectResult.ReadFrom(ResponseText) then begin
                DeviceCode := this.GetJsonToken(JObjectResult, 'device_code').AsValue().AsText();
                IsolatedStorage.Set('DeviceCode', DeviceCode);
                UserCode := this.GetJsonToken(JObjectResult, 'user_code').AsValue().AsText();
                VerificationURI := this.GetJsonToken(JObjectResult, 'verification_uri').AsValue().AsText();
                ExpiresIn := this.GetJsonToken(JObjectResult, 'expires_in').AsValue().AsInteger();
                ExpiresOn := CurrentDateTime + ExpiresIn * 1000;
                IsolatedStorage.Set('DeviceCode_ExpiresOn', Format(ExpiresOn, 0, '<Year4>-<Month,2>-<Day,2>T<Hour,2>:<Minute,2>:<Second,2>'));
            end else
                exit(false);
        end else begin
            ResponseMessage.Content().ReadAs(ResponseText);
            ResponseText := WebserviceErrorLbl + ResponseText;
            Error(ResponseText);
        end;
        exit(true);
    end;

    internal procedure GetCurrentTenant(): Text
    var
        BCURLList: List of [Text];
    begin
        BCURLList := GetUrl(ClientType::Web).Split('/');
        exit(BCURLList.Get(4));
    end;

    internal procedure WaitForDeviceCode(ClientID: Text; DeviceCode: Text; var TokenType: Text; var BearerToken: Text; var ExpiresIn: Integer; var ExtExpiresIn: Integer): Boolean
    var
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        RequestHeader: HttpHeaders;
        RequestContent: HttpContent;
        WebClient: HttpClient;
        JObjectResult: JsonObject;
        JsonToken: JsonToken;
        AuthPayload: Text;
        ResponseText: Text;
        ExpiresOn: DateTime;
        DeviceCodeExpiresOn: Text;

    begin
        if IsolatedStorage.Get('DeviceCode_ExpiresOn', DeviceCodeExpiresOn) then
            if DeviceCodeExpiresOn < Format(CurrentDateTime, 0, '<Year4>-<Month,2>-<Day,2>T<Hour,2>:<Minute,2>:<Second,2>') then
                exit(false); //Device Code expired -> return false to stop polling

        RequestMessage.Method := 'POST';
        RequestMessage.SetRequestUri('https://login.microsoftonline.com/Common//oauth2/v2.0/token');
        RequestMessage.GetHeaders(RequestHeader);

        AuthPayload := 'tenant=Common&grant_type=urn:ietf:params:oauth:grant-type:device_code&client_id=' + ClientId + '&scope=https://api.businesscentral.dynamics.com/user_impersonation&device_code=' + DeviceCode;

        //Get Request Content
        RequestContent.WriteFrom(AuthPayload);

        RequestContent.GetHeaders(RequestHeader);
        RequestHeader.Remove('Content-Type');
        RequestHeader.Add('Content-Type', 'application/x-www-form-urlencoded');

        RequestMessage.Content := RequestContent;
        WebClient.Send(RequestMessage, ResponseMessage);

        if ResponseMessage.IsSuccessStatusCode() then begin
            ResponseMessage.Content().ReadAs(ResponseText);

            if JObjectResult.ReadFrom(ResponseText) then
                if JObjectResult.Get('access_token', JsonToken) then begin
                    TokenType := GetJsonToken(JObjectResult, 'token_type').AsValue().AsText();
                    BearerToken := GetJsonToken(JObjectResult, 'access_token').AsValue().AsText();
                    ExpiresIn := GetJsonToken(JObjectResult, 'expires_in').AsValue().AsInteger();
                    ExtExpiresIn := GetJsonToken(JObjectResult, 'ext_expires_in').AsValue().AsInteger();
                    IsolatedStorage.Set('BearerToken', BearerToken);
                    ExpiresOn := CurrentDateTime + ExpiresIn * 1000;
                    IsolatedStorage.Set('BearerToken_ExpiresOn', Format(ExpiresOn, 0, '<Year4>-<Month,2>-<Day,2>T<Hour,2>:<Minute,2>:<Second,2>'));
                    exit(false);
                end;
        end;
        exit(true);
    end;

    internal procedure GetAccessToken(var BearerToken: Text): Boolean;
    var
        ExpiresOn: Text;
    begin
        if IsolatedStorage.Get('BearerToken_ExpiresOn', ExpiresOn) then
            if ExpiresOn > Format(CurrentDateTime, 0, '<Year4>-<Month,2>-<Day,2>T<Hour,2>:<Minute,2>:<Second,2>') then
                if IsolatedStorage.Get('BearerToken', BearerToken) then
                    exit(true);
        exit(false);
    end;

    local procedure GetJsonToken(JsonObject: JsonObject; TokenKey: Text) JsonToken: JsonToken;
    var
        MessageTxt: Text;
        // MessageLbl: Label that displays a message when a token is not found.
        // The placeholder %1 is used to insert the specific token that was not found.
        MessageLbl: Label 'Token not found: %1';
    begin
        MessageTxt := StrSubstNo(MessageLbl, TokenKey);
        if not JsonObject.Get(TokenKey, JsonToken) then
            Error(MessageTxt);
    end;
}
