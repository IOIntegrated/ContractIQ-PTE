namespace IOI.ContractIQ;
page 70010 "Device Code Flow Page IOI"
{
    Caption = 'OAuth Connection Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = ConfirmationDialog;
    ShowFilter = false;
    layout
    {
        area(Content)
        {
            group(General)
            {
                InstructionalText = 'To sign in, use a web browser to open the page <VerificationURI> and enter the code <UserCode> to authenticate.';
                field(UserCode; UserCode)
                {
                    Caption = 'User Code';
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'User code to authenticate';
                }
                field(VerificationURI; VerificationURI)
                {
                    Caption = 'Verification URI';
                    ToolTip = 'URI to open in browser';
                    ApplicationArea = all;
                    Editable = false;
                    ExtendedDatatype = URL;
                }
            }
        }
    }

    var
        DeviceCodeFlow: Codeunit "Device Code Flow IOI";
        Instruction, ClientId, UserCode, VerificationURI, DeviceCode, TokenType, AccessToken : Text;
        ExpiresIn, ExtExpiresIn : Integer;

    trigger OnAfterGetCurrRecord()
    begin
        this.ClientId := '61dbdfff-cf01-4716-9394-b011e82ba2de';
        this.ClientId := '04b07795-8ddb-461a-bbee-02f9e1bf7b46'; //# Common Client ID for Microsoft First-Party App
        this.DeviceCodeFlow.StartAuthorizationProcess(this.ClientId, this.UserCode, this.VerificationURI, this.DeviceCode, this.ExpiresIn);
    end;

    internal procedure GetAccessToken(var AccessTokenPar: Text): Boolean;
    begin
        // look for allready existing access token
        if this.DeviceCodeFlow.GetAccessToken(AccessTokenPar) then
            exit(true);
        // otherwise wait for Device Code Flow to complete
        while this.WaitForDeviceCode() do;
        if this.TokenType = 'Bearer' then begin
            IsolatedStorage.Set('access_token', this.AccessToken);
            IsolatedStorage.Set('client_id', this.ClientId);
            AccessTokenPar := this.AccessToken;
            exit(true);
        end;
        exit(false);
    end;

    local procedure WaitForDeviceCode(): Boolean;
    begin
        ExpiresIn -= 1;
        Sleep(1000);
        exit(this.DeviceCodeFlow.WaitForDeviceCode(this.ClientId, this.DeviceCode, this.TokenType, AccessToken, ExpiresIn, ExtExpiresIn) and (ExpiresIn > 0));
    end;
}