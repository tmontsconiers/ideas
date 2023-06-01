@IsTest
private class Http2_Test {

    @IsTest
    static void okTest() {
        // Arrange
        RetryPolicy transientErrorRetryPolicy
                = new RetryPolicy(HttpErrorCodes.TransientErrors,3);

        Http2 client
                = new Http2().setRetryPolicy(transientErrorRetryPolicy);

        // Act
        Test.setMock(HttpCalloutMock.class, new OkResponse());
        Test.startTest();
            HttpResponse response = client.send(new HttpRequest());
        Test.stopTest();

        // Assert
        Assert.areEqual(200,response.getStatusCode(),'Response should be OK');
        Assert.areEqual(1,client.policy.numberOfAttemptedCallouts,'This should have made 1 call out');
    }

    @IsTest
    static void okTestNoRetryPolicySet() {
        // Arrange
        Http2 client = new Http2();

        // Act
        Test.setMock(HttpCalloutMock.class, new OkResponse());
        Test.startTest();
            HttpResponse response = client.send(new HttpRequest());
        Test.stopTest();

        // Assert
        Assert.areEqual(200,response.getStatusCode(),'Response should be OK');
        Assert.areEqual(null,client.policy,'Policy should not be set');
    }

    @IsTest
    static void timeoutTest() {
        // Arrange
        RetryPolicy transientErrorRetryPolicy
                = new RetryPolicy(HttpErrorCodes.TransientErrors,3);

        Http2 client
                = new Http2().setRetryPolicy(transientErrorRetryPolicy);

        // Act
        Test.setMock(HttpCalloutMock.class, new TimeoutResponse());
        Test.startTest();
            try {
                client.send(new HttpRequest());
                Assert.fail('RetryPolicy.RetryPolicyException should have been thrown.');
            }
            catch (Exception e){
                Assert.areEqual(e.getTypeName(),'RetryPolicy.RetryPolicyException');
                Assert.areEqual(e.getMessage(),'Max number of retries reached');
                Assert.areEqual(3,client.policy.numberOfAttemptedCallouts,'This should have made 3 call outs');
            }
        Test.stopTest();
    }

    private class OkResponse implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            return res;
        }
    }

    private class TimeoutResponse implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(408);
            return res;
        }
    }
}