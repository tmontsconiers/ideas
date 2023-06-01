public class RetryPolicy extends HttpResponsePolicy {
    public class RetryPolicyException extends Exception { }

    private final Integer permittedRetryCount;
    private final Set<Integer> httpErrorCodes;
    private final HttpMessageHandler handler;
    @TestVisible private Integer numberOfAttemptedCallouts;

    public RetryPolicy(Set<Integer> httpResponseCodes,
                       Integer permittedNumberOfRetries)
    {
        this.httpErrorCodes = httpResponseCodes;
        this.permittedRetryCount = permittedNumberOfRetries;
        this.handler = new HttpClientHandler();
        this.numberOfAttemptedCallouts = 0;
    }

    public override HttpResponse execute(HttpRequest request) {
        HttpResponse response;
        do {
            numberOfAttemptedCallouts++;
            System.debug('Attempt ' + numberOfAttemptedCallouts + ' of ' + permittedRetryCount);
            response = handler.send(request);
        }
        while(numberOfAttemptedCallouts <permittedRetryCount && httpErrorCodes.contains(response.getStatusCode()));
        if(httpErrorCodes.contains(response?.getStatusCode())) {
            throw new RetryPolicyException('Max number of retries reached');
        }
        return response;
    }
}