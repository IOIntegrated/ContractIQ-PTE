namespace IOI.ContractIQ;

using System.Utilities;

codeunit 70011 "Compiler Service IOI"
{
    procedure Decompress7zFile(var TempBlob: Codeunit "Temp Blob"; FileName: text[100]): boolean;
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        Headers: HttpHeaders;
        ResponseStream: InStream;
        Content: HttpContent;
        TempInStream: InStream;
        TempOutStream: OutStream;
        Uri: Text;
        FileContent: Text;
        BodyJson: Text;
    begin
        // URL der Azure-Funktion
        Uri := 'https://copy-of-al-compiler-service.azurewebsites.net/api/decompress-app?';

        // Sicherstellen, dass der TempBlob einen Inhalt hat
        if not TempBlob.HasValue() then
            Error('Die Temp Blob Codeunit enthält keine Daten.');

        // InStream aus TempBlob holen
        TempBlob.CreateInStream(TempInStream);

        // HTTP-Request vorbereiten
        Request.Method := 'POST';
        Request.SetRequestUri(Uri);

        // Datei-Inhalt in eine Textvariable schreiben
        TempInStream.ReadText(FileContent);

        // JSON-Body erstellen
        BodyJson := '{"filename": "' + FileName + '.app", "filecontent": "' + FileContent + '"}';

        // JSON-Payload setzen
        Content.WriteFrom(BodyJson);
        Content.GetHeaders(Headers);
        if not Headers.Contains('Content-Type') then
            Headers.Add('Content-Type', 'application/json');
        Request.Content := Content;

        // Request senden
        if Client.Send(Request, Response) then begin

            // Antwort prüfen
            if Response.IsSuccessStatusCode then begin
                Response.Content.ReadAs(ResponseStream);

                // Antwort direkt in TempBlob speichern
                TempBlob.CreateOutStream(TempOutStream);
                CopyStream(TempOutStream, ResponseStream);
                exit(true);
            end else
                exit(false);
        end else
            exit(false);
    end;

}
