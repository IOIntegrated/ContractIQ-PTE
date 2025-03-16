namespace IOI.ContractIQ;

using System.Text;
using System.Environment;

table 70011 "App Loader Extension IOI"
{
    Caption = 'App Loader Extension';
    DataClassification = ToBeClassified;
    DataPerCompany = false;

    fields
    {
        field(1; packageId; Text[100])
        {
            Caption = 'packageId';
            DataClassification = ToBeClassified;
        }
        field(2; id; Text[100])
        {
            Caption = 'id';
            DataClassification = ToBeClassified;
        }
        field(3; displayName; Text[100])
        {
            Caption = 'displayName';
            DataClassification = ToBeClassified;
        }
        field(4; publisher; Text[100])
        {
            Caption = 'publisher';
            DataClassification = ToBeClassified;
        }
        field(5; versionMajor; Integer)
        {
            Caption = 'versionMajor';
            DataClassification = ToBeClassified;
        }
        field(6; versionMinor; Integer)
        {
            Caption = 'versionMinor';
            DataClassification = ToBeClassified;
        }
        field(7; versionBuild; Integer)
        {
            Caption = 'versionBuild';
            DataClassification = ToBeClassified;
        }
        field(8; versionRevision; Integer)
        {
            Caption = 'versionRevision';
            DataClassification = ToBeClassified;
        }
        field(9; isInstalled; Boolean)
        {
            Caption = 'isInstalled';
            DataClassification = ToBeClassified;
        }
        field(10; publishedAs; Enum "App Loader Ext. Pub. As IOI")
        {
            Caption = 'publishedAs';
            DataClassification = ToBeClassified;
        }
        field(11; AppSource; Blob)
        {
            Caption = 'AppSource';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; id, versionMajor, versionMinor, versionBuild, versionRevision)
        {
            Clustered = true;
        }
    }

    internal procedure GetAppFileName(): Text;
    var
        AppFileName: Text;
    begin
        AppFileName := StrSubstNo('%1_%2_', publisher, displayName);
        AppFileName += StrSubstNo('%1.%2.%3.%4', VersionMajor, VersionMinor, VersionBuild, VersionRevision);
        exit(AppFileName);
    end;

    internal procedure DownloadUri(): Text;
    var
        EnvironmentInformation: Codeunit "Environment Information";
        DownloadUriText: Text;
        VersionText: Text;
        // UrlTemplateLbl: Template URL for accessing Business Central API.
        // %1 - Environment ID
        // %2 - Publisher name
        // %3 - Application name
        // %4 - Version text
        // %5 - Application ID
        UrlTemplateLbl: Label 'https://api.businesscentral.dynamics.com/v2.0/%1/dev/packages?publisher=%2&appName=%3&versionText=%4&appId=%5';
    begin
        VersionText := StrSubstNo('%1.%2.%3.%4', VersionMajor, VersionMinor, VersionBuild, VersionRevision);
        DownloadUriText := StrSubstNo(UrlTemplateLbl, EnvironmentInformation.GetEnvironmentName(), publisher, displayName, VersionText, id);
        exit(DownloadUriText);
    end;

    internal procedure SetAppFile(AppContent: Text);
    var
        Convert: Codeunit "Base64 Convert";
        OutS: OutStream;
    begin
        Rec.CalcFields(AppSource);
        Rec.AppSource.CreateOutStream(OutS);
        OutS.Write(Convert.ToBase64(AppContent));
        Rec.Modify();
    end;

    internal procedure SetAppFile(InS: InStream);
    var
        Convert: Codeunit "Base64 Convert";
        OutS: OutStream;
        Result: text;
    begin
        Rec.CalcFields(AppSource);
        Rec.AppSource.CreateOutStream(OutS);
        Result := Convert.ToBase64(InS);
        OutS.Write(Result);
        Rec.Modify();
    end;

    internal procedure GetAppFile(var AppContent: Text): Text;
    var
        Convert: Codeunit "Base64 Convert";
        InS: InStream;
    begin
        Rec.CalcFields(AppSource);
        Rec.AppSource.CreateInStream(InS);
        InS.Read(AppContent);
        AppContent := Convert.FromBase64(AppContent);
        Exit(AppContent);
    end;

    internal procedure GetBase64AppFile(var AppContent: Text): Text;
    var
        InS: InStream;
    begin
        Rec.CalcFields(AppSource);
        Rec.AppSource.CreateInStream(InS);
        InS.Read(AppContent);
        Exit(AppContent);
    end;

    internal procedure GetAppFile(var InS: InStream): InStream;
    var
        OutS: OutStream;
        Result: Text;
    begin
        Rec.GetAppFile(Result);
        Rec.AppSource.CreateOutStream(OutS);
        CopyStream(OutS, InS);
        Exit(InS);
    end;
}
