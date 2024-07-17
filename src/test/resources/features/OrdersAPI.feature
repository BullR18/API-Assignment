Feature: API testing using Karate
  Background:
    Given url 'https://simple-books-api.glitch.me'
    #    Given path '/api-clients/'
    #    And request {"clientName": "Postman11", "clientEmail": "valentin11@example.com"}
    #    And header Content-Type = 'application/json'
    #    When method POST
    #    Then status 201
    #* def token = response.token
    * def token = 'd3ae0a0ac95f2a4414e3b889275546a93227f3ba4e0263a5b5bfaf4200da89af'
    * print 'Value of the token ' + token

    # Verify whether data being created in server using POST method
    Given path '/orders'
    And header Authorization = 'Bearer ' + token
    And header Content-Type = 'application/json'
    And header accept = 'application/json'
    And request
    """
    {
    "bookId": 1,
    "customerName": "John"
    }
    """
    When method POST
    Then status 201
    And match response.created == true
    Then match response ==
    """
    {
    created: '#boolean',
    orderId: '#string',
    }
    """
    * def orderId = response.orderId
    * print orderId
    * print response

  @GET_ORDER_BY_ID
  Scenario: Verify whether data being retried from server using GET method
    Given path '/orders/'+orderId
    And header Authorization = 'Bearer ' + token
    When method GET
    Then status 200
    * print response
    And match response.customerName == 'John'
    Then match response ==
    """
    {
    id: '#string',
    bookId: '#number',
    customerName: '#string',
    createdBy: '#string',
    quantity: '#number',
    timestamp: '#number'
    }
    """

  @PATCH_ORDER_BY_ID
  Scenario: Verify whether data being updated to server using PATCH method
    Given path '/orders/'+orderId
    And header Authorization = 'Bearer ' + token
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    And request  {"customerName": "John2"}
    When method PATCH
    Then status 204
    * print response

    Given  url 'https://simple-books-api.glitch.me'
    Given path '/orders/'+orderId
    And header Authorization = 'Bearer ' + token
    When method GET
    Then status 200
    * print response
    And match response.customerName == 'John2'

  @DELETE_ORDER_BY_ID
  Scenario: Verify whether data being deleted from server using DELETE method
    Given path '/orders/'+orderId
    And header Authorization = 'Bearer ' + token
    And header Content-Type = 'application/json'
    And header Accept = 'application/json'
    When method DELETE
    Then status 204
    * print response

    Given  url 'https://simple-books-api.glitch.me'
    Given path '/orders/'+orderId
    And header Authorization = 'Bearer ' + token
    When method GET
    Then status 404
    * print response
    And match response == { error: '#string' }
    And match response.error contains 'No order with id'
    And match response.error contains orderId

