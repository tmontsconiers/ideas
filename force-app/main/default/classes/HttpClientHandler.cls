public class HttpClientHandler extends HttpMessageHandler {

    private Http http;

    public HttpClientHandler(){ this.http = new Http(); }

    public override HttpResponse send(HttpRequest request) {
        System.debug('HttpClientHandler - send');
        return http.send(request);
    }
}