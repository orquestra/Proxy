<%@Page ContentType="text/html"%>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.IO" %>
<%
/*
* Esse proxy
*   - recebe a URL externa via querystring (GET)
*   - recebe os parâmetros a serem enviados para a URL externa via form (POST)
*   - escreve o resultado na tela
*   - retorna o resultado como HTML
*
*   - Atenção! Caso NECESSITE, você pode configurar o retorna desse proxy como XML modificando o "ContentType" acima para "text/xml"
*
*   Mais informações:
*   http://msdn.microsoft.com/en-us/library/debx8sh9.aspx
*/

//Recebe o endereço URL final via querystring
string proxyURL = HttpUtility.UrlDecode(Request.QueryString.ToString());

if (proxyURL != "")
{
    //abre uma requisição web
    HttpWebRequest request = (HttpWebRequest)WebRequest.Create(proxyURL);
    
    //os parâmetros são enviados via POST para a URL final. Certifique-se de que sua URL externa recebe parâmetros via POST
    request.Method = "POST";

    //recebe os parâmetros enviados via POST
    string postData = Request.Form.ToString();
    
    //converte os parâmetros para um array de bytes
    byte[] byteArray = Encoding.UTF8.GetBytes (postData);
    
    //configura o contenttype da requisição
    request.ContentType = "application/x-www-form-urlencoded";
    
    //configura o tamanho da requisição
    request.ContentLength = byteArray.Length;
    
    //obtem o stream
    Stream dataStream = request.GetRequestStream ();
    
    //escreve os parâmetros para o stream
    dataStream.Write (byteArray, 0, byteArray.Length);
    
    //fecha o stream
    dataStream.Close ();
    
    //obtem a resposta
    WebResponse response = request.GetResponse();
    
    //obtem o texto da resposta
    dataStream = response.GetResponseStream();
    
    //abre o stream recebido 
    StreamReader reader = new StreamReader(dataStream);
    
    //le o stream
    string responseFromServer = reader.ReadToEnd();
    
    //escreve a resposta na tela
    Response.Write(responseFromServer);
    
    //fecha os objetos
    reader.Close();
    dataStream.Close();
    response.Close();
}
 %>
