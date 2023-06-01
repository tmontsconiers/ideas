public class Http2 {
    public class Http2Exception extends Exception { }

    @TestVisible private RetryPolicy policy;

    public Http2 setRetryPolicy(RetryPolicy policy){
        this.policy = policy;
        return this;
    }

    public HttpResponse send(HttpRequest request){
        return (policy!=null) ?
                policy.execute(request) :
                new Http().send(request);
    }
}