import azure.functions as func
import json
from function_app import main

def test_function_returns_hello_world():
    # Arrange
    request = func.HttpRequest(
        method='GET',
        body=None,
        url='/api/hello',
        params={}
    )

    # Act
    response = main(request)
    response_body = json.loads(response.get_body())

    # Assert
    assert "Hello, World!" in response_body["message"]

def test_function_returns_200():
    # Arrange
    request = func.HttpRequest(
        method='GET',
        body=None,
        url='/api/hello',
        params={}
    )

    # Act
    response = main(request)

    # Assert
    assert response.status_code == 200

def test_function_returns_json():
    # Arrange
    request = func.HttpRequest(
        method='GET',
        body=None,
        url='/api/hello',
        params={}
    )

    # Act
    response = main(request)

    # Assert
    assert response.mimetype == "application/json"
    assert "timestamp" in json.loads(response.get_body()) 