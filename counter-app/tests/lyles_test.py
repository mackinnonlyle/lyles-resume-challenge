# Import the necessary libraries
import boto3
import pytest
import lambda_handler


def test_lambda_handler():
    # Create a mock event to test the function with
    event = {}

    # Create a mock context object to test the function with
    context = {}

    # Call the lambda_handler function with the mock event and context objects
    lambda_handler(event, context)

    # Connect to the DynamoDB table
    dynamodb = boto3.resource('dynamodb', region_name='us-east-1')
    table = dynamodb.Table('lyles-resume-challenge')

    # Retrieve the item from the table
    response = table.get_item(
        Key = {
            'ID':'visits'
        }
    )
    
    # Get the visit count from the item
    visit_count = response['Item']['counter'] 

    # Check if the visit count has been incremented by 1
    assert int(visit_count) == 1

    # Print a success message
    print("Testing has been successful!")