<%@Page ContentType="text/xml" debug="true" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Xml" %>
<%
/*
* Esse proxy
*   - recebe a URL externa via querystring (GET)
*   - recebe os parâmetros (Soap Envelope em XML) a serem enviados para a URL externa via (POST)
*   - escreve o resultado na tela
*   - retorna o resultado como XML
*
*   Mais informações:
*   http://msdn.microsoft.com/en-us/library/debx8sh9.aspx
*/

//Recebe o endereço URL final via querystring
string webserviceAddress = HttpUtility.UrlDecode(Request.QueryString.ToString());
string soapEnvelope = null;
string soapResult = null;

if (webserviceAddress != "")
{
    //recebe os parâmetros enviados via POST
    soapEnvelope = Request.Form.ToString();

    if (!string.IsNullOrEmpty(soapEnvelope)) {
        soapEnvelope = System.Web.HttpContext.Current.Server.UrlDecode(soapEnvelope);

        HttpWebRequest webRequest = (HttpWebRequest)WebRequest.Create(webserviceAddress);
        // pode ser necessario utilizar uma das linhas abaixo dependendo do Webservice
        //webRequest.Headers.Add(@"SOAP:Action");
        //webRequest.Headers.Add(@"SOAPAction:");
        webRequest.ContentType = "text/xml;charset=\"utf-8\"";
        webRequest.Accept = "text/xml";
        webRequest.Method = "POST";

        XmlDocument soapEnvelopeXml = new XmlDocument();
        soapEnvelopeXml.LoadXml(soapEnvelope);

        using (Stream stream = webRequest.GetRequestStream())
        {
            soapEnvelopeXml.Save(stream);
        }

        WebResponse response = null;

        try
        {
            response = webRequest.GetResponse();

            using (StreamReader rd = new StreamReader(response.GetResponseStream()))
            {
                soapResult = rd.ReadToEnd();
            }    
        }
        catch (WebException wex)
        {
            // Caso ocorra erro HTTP 500 entao deve obter resposta no objeto WebException
            response = wex.Response;

            using (StreamReader rd = new StreamReader(response.GetResponseStream()))
            {
                soapResult = rd.ReadToEnd();
            }

            Response.Write(soapResult);
            Response.End();
        }

        if (soapResult != null) {

            XmlDocument doc = new XmlDocument();

            doc.LoadXml(soapResult);

            System.Text.StringBuilder sb = new StringBuilder();

            XmlWriterSettings xwsSettings = new XmlWriterSettings();
            xwsSettings.Indent = false;
            xwsSettings.NewLineChars = String.Empty;

            XmlWriter xwWriter = XmlWriter.Create(sb, xwsSettings);

            doc.Save(xwWriter);

            xwWriter.Close();

            Response.Write(doc.InnerXml);
            Response.End();
        }

    }
}
%>
