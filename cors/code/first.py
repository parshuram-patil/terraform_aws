import time

def hello(event, context):
    print('Execution Started')
    # raise Exception('My Exception!')
    time.sleep(5000)
    message = ["Welcome", "To", "Python", "Lambda", "Function"]
    print(message)
    print('Execution Ended')
    # Body and Status Code is mandatory if you are using lambda with API gateway
    return {
        "body": message,
        "statusCode": 200
    }