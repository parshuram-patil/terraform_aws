def hello(event, context):
    message = "Welcome to First Nested Python Function"
    print(message)

    # Body and Status Code is mandatory if you are using lambda with API gateway
    return {
        "body": message,
        "statusCode": 200
    }