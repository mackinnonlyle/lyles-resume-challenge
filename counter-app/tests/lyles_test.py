# Import the necessary libraries
import boto3
import app



import pytest
import lambda_handler

def test_parse_event():
    # Test with valid input
    valid_event = {
        "httpMethod": "GET",
        "headers": {
            "Accept": "application/json",
        },
        "queryStringParameters": {
            "param1": "value1",
            "param2": "value2"
        }
    }
    assert app.parse_event(valid_event) == ("GET", {"param1": "value1", "param2": "value2"})

    # Test with invalid input
    invalid_event = {
        "httpMethod": "POST",
        "headers": {
            "Accept": "application/xml",
        }
    }
    assert app.parse_event(invalid_event) == ("POST", None)
