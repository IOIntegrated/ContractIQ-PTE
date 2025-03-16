namespace IOI.ContractIQ;

using System.Utilities;
codeunit 70004 "App Files Mgt. IOI"
{
    procedure GetSingleFile(AppMetaFiles: Record "App Meta Files IOI"): BigInteger
    var
        AppMeta: Record "App Meta IOI";
        Tables: Record "Tables IOI";
        XMLMgt: Codeunit "XML Mgt. IOI";
        JSONMgt: Codeunit "JSON Mgt. IOI";
        PersistentBlob: Codeunit "Persistent Blob";
        WriteTableCode: Codeunit "WriteTableCode IOI";
        TempBlob: Codeunit "Temp Blob";
        OutStream: OutStream;
        InStream: InStream;
        Response: Text;
        PersistentBlobId: BigInteger;

    begin
        AppMeta.Reset();
        AppMeta.SetRange(id, AppMetaFiles.id);
        AppMeta.SetRange(version, AppMetaFiles.version);
        AppMeta.FindFirst();

        CASE AppMetaFiles.type of
            AppMetaFiles.type::Structure:
                CASE AppMetaFiles.name of
                    '[Content_Types]':
                        Response := XMLMgt.ContentTypes();
                    'DocComments':
                        Response := XMLMgt.DocComments(AppMeta);
                    'MediaIdListing':
                        Response := XMLMgt.MediaIdListing(AppMeta);
                    'navigation':
                        Response := XMLMgt.navigation(AppMeta);
                    'NavxManifest':
                        Response := XMLMgt.NavxManifest(AppMeta);
                    'SymbolReference':
                        Response := JSONMgt.GenerateSymbolref(AppMeta);
                END;
            AppMetaFiles.type::Table:
                begin
                    Tables.Reset();
                    Tables.SetRange(id, AppMetaFiles.id);
                    Tables.SetRange(name, AppMetaFiles.name);
                    if Tables.FindFirst() then
                        Response := WriteTableCode.WriteCode(Tables)
                end;
        END;

        PersistentBlobId := PersistentBlob.Create();
        TempBlob.CreateOutStream(OutStream);
        OutStream.Write(Response);
        TempBlob.CreateInStream(InStream);
        IF PersistentBlob.CopyFromInStream(PersistentBlobId, InStream) then
            exit(PersistentBlobId);

    end;

}
