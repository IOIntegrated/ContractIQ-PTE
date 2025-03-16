namespace IOI.ContractIQ;

using System.Utilities;
codeunit 70000 "XML Mgt. IOI"
{

    procedure MediaIdListing(AppMeta: Record "App Meta IOI"): Text
    var
        TempBlob: Codeunit "Temp Blob";
        BigString: BigText;
        main: XmlElement;
        xmlElem2: XmlElement;
        xmlElem3: XmlElement;
        xmlDoc: XmlDocument;
        OutStream: OutStream;
        InStream: InStream;
        Textv: Text;

    begin

        xmlDoc := xmlDocument.Create();
        main := xmlElement.Create('doc');

        xmlElem2 := XmlElement.Create('MediaIdListing');
        xmlElem2.SetAttribute('LogoFileName', 'tempo.png');
        xmlElem2.SetAttribute('LogoId', '4c8f637a-6bc3-4ef3-a3aa-fe085973e140');
        xmlElem3 := xmlElement.Create('MediaSetIds');
        xmlElem2.Add(xmlElem3);

        main.Add(xmlElem2);

        xmlDoc.Add(main);

        TempBlob.CreateOutStream(OutStream, TextEncoding::UTF8);
        xmlDoc.WriteTo(OutStream);
        TempBlob.CreateInStream(InStream, TextEncoding::UTF8);
        BigString.Read(InStream);
        BigString.GetSubText(Textv, 1);

        Textv := Textv.Replace('<MediaIdListing ', '<MediaIdListing xmlns="http://schemas.microsoft.com/navx/2016/mediaidlisting" ');
        Textv := DELSTR(Textv, StrPos(Textv, ' encoding="utf-8"'), StrLen(' encoding="utf-8"')); //encoding löschen
        Textv += NewLine();

        Exit(Textv);

    end;

    procedure DocComments(AppMeta: Record "App Meta IOI"): Text
    var
        TempBlob: Codeunit "Temp Blob";
        BigString: BigText;
        main: XmlElement;
        xmlElem2: XmlElement;
        xmlElem3: XmlElement;
        xmlElem4: XmlElement;
        xmlDoc: XmlDocument;
        OutStream: OutStream;
        InStream: InStream;
        Textv: Text;
    begin

        xmlDoc := xmlDocument.Create();
        //xmlDec := xmlDeclaration.Create('1.0', 'UTF-8', '');
        //xmlDoc.SetDeclaration(xmlDec);
        main := xmlElement.Create('doc');

        xmlElem2 := XmlElement.Create('application');
        xmlElem3 := XmlElement.Create('id');
        xmlElem3.Add(xmlText.Create(AppMeta.id));
        xmlElem2.Add(xmlElem3);
        Clear(xmlElem3);
        xmlElem3 := XmlElement.Create('name');
        xmlElem3.Add(xmlText.Create(AppMeta.name));
        xmlElem2.Add(xmlElem3);
        Clear(xmlElem3);
        xmlElem3 := XmlElement.Create('publisher');
        xmlElem3.Add(xmlText.Create(AppMeta.publisher));
        xmlElem2.Add(xmlElem3);
        Clear(xmlElem3);
        xmlElem3 := XmlElement.Create('version');
        xmlElem3.Add(xmlText.Create(AppMeta.version));
        xmlElem2.Add(xmlElem3);
        xmlElem4 := XmlElement.Create('members');
        xmlElem4.Add(xmlText.Create(''));

        main.Add(xmlElem2);
        main.Add(xmlElem4);

        xmlDoc.Add(main);

        TempBlob.CreateOutStream(OutStream, TextEncoding::UTF8);
        xmlDoc.WriteTo(OutStream);
        TempBlob.CreateInStream(InStream, TextEncoding::UTF8);
        BigString.Read(InStream);
        BigString.GetSubText(Textv, 1);


        Textv := DELSTR(Textv, StrPos(Textv, ' encoding="utf-8"'), StrLen(' encoding="utf-8"')); //encoding löschen
        Textv += NewLine();

        Exit(Textv);


    end;

    procedure ContentTypes(): Text
    var
        TempBlob: Codeunit "Temp Blob";
        BigString: BigText;
        main: XmlElement;
        xmlElem8: XmlElement;
        xmlDoc: XmlDocument;
        OutStream: OutStream;
        InStream: InStream;
        Textv: Text;
    begin

        xmlDoc := xmlDocument.Create();
        main := xmlElement.Create('Types');

        xmlElem8 := XmlElement.Create('Default');
        xmlElem8.SetAttribute('Extension', 'xml');
        xmlElem8.SetAttribute('ContentType', '');
        main.Add(xmlElem8);
        Clear(xmlElem8);
        xmlElem8 := XmlElement.Create('Default');
        xmlElem8.SetAttribute('Extension', 'al');
        xmlElem8.SetAttribute('ContentType', '');
        main.Add(xmlElem8);
        Clear(xmlElem8);
        xmlElem8 := XmlElement.Create('Default');
        xmlElem8.SetAttribute('Extension', 'json');
        xmlElem8.SetAttribute('ContentType', '');
        main.Add(xmlElem8);

        xmlDoc.Add(main);

        TempBlob.CreateOutStream(OutStream, TextEncoding::UTF8);
        xmlDoc.WriteTo(OutStream);
        TempBlob.CreateInStream(InStream, TextEncoding::UTF8);
        BigString.Read(InStream);
        BigString.GetSubText(Textv, 1);


        Textv := Textv.Replace('<Types>', '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">');
        Textv += NewLine();

        Exit(Textv);
    end;

    procedure NavxManifest(AppMeta: Record "App Meta IOI"): Text
    var
        TempBlob: Codeunit "Temp Blob";
        BigString: BigText;
        main: XmlElement;
        xmlel: XmlElement;
        xmlElem: XmlElement;
        xmlElem2: XmlElement;
        xmlElem3: XmlElement;
        xmlElem7: XmlElement;
        xmlElem8: XmlElement;
        xmlElem9: XmlElement;
        xmlElem10: XmlElement;
        xmlElem11: XmlElement;
        xmlElem12: XmlElement;
        xmlDoc: XmlDocument;
        OutStream: OutStream;
        InStream: InStream;
        Textv: Text;

    begin

        xmlDoc := xmlDocument.Create();
        main := xmlElement.Create('Package');
        xmlElem := xmlElement.Create('App');
        xmlElem.SetAttribute('Id', AppMeta.id);
        xmlElem.SetAttribute('Name', AppMeta.name);
        xmlElem.SetAttribute('Publisher', AppMeta.publisher);
        xmlElem.SetAttribute('Brief', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ');
        xmlElem.SetAttribute('Description', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ');
        xmlElem.SetAttribute('Version', AppMeta.version);
        xmlElem.SetAttribute('CompatibilityId', '0.0.0.0');
        xmlElem.SetAttribute('PrivacyStatement', 'https://www.tempo.io/privacy-policy');
        xmlElem.SetAttribute('ApplicationInsightsKey', '00000000-0000-0000-0000-000000000000');
        xmlElem.SetAttribute('EULA', 'https://www.tempo.io/eula');
        xmlElem.SetAttribute('Help', 'https://www.tempo.io/documentation');
        xmlElem.SetAttribute('HelpBaseUrl', '');
        xmlElem.SetAttribute('ContextSensitiveHelpUrl', 'https://www.tempo.io/documentation');
        xmlElem.SetAttribute('Url', 'https://www.tempo.io/');
        xmlElem.SetAttribute('Logo', '/logo/tempo.png');
        xmlElem.SetAttribute('Platform', AppMeta.sys_version.Names.Get(AppMeta.sys_version.Ordinals.IndexOf(AppMeta.sys_version.AsInteger())));
        xmlElem.SetAttribute('Application', AppMeta.sys_version.Names.Get(AppMeta.sys_version.Ordinals.IndexOf(AppMeta.sys_version.AsInteger())));
        xmlElem.SetAttribute('Runtime', '6.0');
        xmlElem.SetAttribute('Target', 'Extension');
        xmlElem.SetAttribute('ShowMyCode', 'True');
        main.Add(xmlElem);

        xmlElem2 := XmlElement.Create('IdRanges');
        xmlElem3 := XmlElement.Create('IdRange');
        xmlElem3.SetAttribute('MinObjectId', FORMAT(AppMeta.ObjectRangeFrom));
        xmlElem3.SetAttribute('MaxObjectId', FORMAT(AppMeta.ObjectRangeTo));
        xmlElem2.Add(xmlElem3);
        main.Add(xmlElem2);

        xmlel := XmlElement.Create('Dependencies');
        main.Add(xmlel);
        xmlel := XmlElement.Create('InternalsVisibleTo');
        main.Add(xmlel);
        xmlel := XmlElement.Create('ScreenShots');
        main.Add(xmlel);

        xmlElem7 := XmlElement.Create('SupportedLocales');
        xmlElem8 := XmlElement.Create('SupportedLocale');
        xmlElem8.SetAttribute('Local', 'de-DE');
        xmlElem9 := XmlElement.Create('SupportedLocale');
        xmlElem9.SetAttribute('Local', 'en-US');

        xmlElem7.Add(xmlElem9);
        xmlElem7.Add(xmlElem8);
        main.Add(xmlElem7);

        xmlElem10 := XmlElement.Create('Features');
        xmlElem11 := XmlElement.Create('Feature');
        xmlElem11.Add(xmlText.Create('TRANSLATIONFILE'));
        xmlElem10.Add(xmlElem11);
        xmlElem12 := XmlElement.Create('Feature');
        xmlElem12.Add(xmlText.Create('GENERATECAPTIONS'));
        xmlElem10.Add(xmlElem12);
        main.Add(xmlElem10);

        xmlel := XmlElement.Create('PreprocessorSymbols');
        main.Add(xmlel);

        xmlel := XmlElement.Create('SuppressWarnings');
        main.Add(xmlel);

        xmlel := XmlElement.Create('KeyVaultUrls');
        main.Add(xmlel);

        xmlDoc.Add(main);

        TempBlob.CreateOutStream(OutStream, TextEncoding::UTF8);
        xmlDoc.WriteTo(OutStream);
        TempBlob.CreateInStream(InStream, TextEncoding::UTF8);
        //CopyStream(OutStream, InStream);
        BigString.Read(InStream);
        BigString.GetSubText(Textv, 1);


        Textv := Textv.Replace('<Package>', '<Package xmlns="http://schemas.microsoft.com/navx/2015/manifest">');
        Textv += NewLine();

        Exit(Textv);
    end;


    procedure navigation(AppMeta: Record "App Meta IOI"): Text
    var
        TempBlob: Codeunit "Temp Blob";
        BigString: BigText;
        main: XmlElement;
        xmlElem7: XmlElement;
        xmlElem8: XmlElement;
        xmlElem9: XmlElement;
        xmlDoc: XmlDocument;
        OutStream: OutStream;
        InStream: InStream;
        Textv: Text;
    begin

        xmlDoc := xmlDocument.Create();
        main := xmlElement.Create('NavigationDefinition');

        xmlElem7 := XmlElement.Create('NavigationChanges');
        xmlElem8 := XmlElement.Create('ActionChange');
        xmlElem8.SetAttribute('TargetID', '143');
        xmlElem8.SetAttribute('TargetType', 'Page');
        xmlElem9 := XmlElement.Create('ActionChange');
        xmlElem9.SetAttribute('TargetID', '143');
        xmlElem9.SetAttribute('TargetType', 'Page');

        xmlElem7.Add(xmlElem9);
        xmlElem7.Add(xmlElem8);
        main.Add(xmlElem7);

        xmlDoc.Add(main);

        TempBlob.CreateOutStream(OutStream, TextEncoding::UTF8);
        xmlDoc.WriteTo(OutStream);
        TempBlob.CreateInStream(InStream, TextEncoding::UTF8);
        BigString.Read(InStream);
        BigString.GetSubText(Textv, 1);


        Textv := Textv.Replace('<NavigationDefinition>', '<NavigationDefinition xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns="urn:schemas-microsoft-com:dynamics:NAV:MetaObjects">');
        Textv += NewLine();
        Exit(Textv);
    end;

    local procedure NewLine(): Text
    var
        Char10: Char;
    begin
        Char10 := 10;
        exit(Format(Char10));
    end;



}