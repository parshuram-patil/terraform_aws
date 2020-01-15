def hello(event, context):
    message = "Welcome to Python Function"
    print(message)

    return {
        'message' :  message
    }