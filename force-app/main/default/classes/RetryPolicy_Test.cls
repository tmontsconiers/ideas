@IsTest
private class RetryPolicy_Test {

    @IsTest
    static void throwExceptionOnPolicyFailure() {
        // Arrange
        Integer permittedNumberOfTries = 5;

        RetryPolicy policy = new RetryPolicy(
            HttpErrorCodes.TransientErrors,
            permittedNumberOfTries);

        // Act & Assert
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new Request408TimeoutResponse());
            try {
                HttpRequest request = new HttpRequest();
                policy.execute(request);
                Assert.fail('RetryPolicy.RetryPolicyException should have been thrown.');
            }
            catch (Exception e) {
                Assert.areEqual(permittedNumberOfTries,policy.numberOfAttemptedCallouts);
                Assert.areEqual(e.getTypeName(),'RetryPolicy.RetryPolicyException');
                Assert.areEqual(e.getMessage(),'Max number of retries reached');
            }
        Test.stopTest();
    }

    private class Request408TimeoutResponse implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(408);
            return res;
        }
    }
}