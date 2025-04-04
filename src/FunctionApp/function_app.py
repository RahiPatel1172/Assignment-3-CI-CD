import azure.functions as func
import datetime
import json

def main(req: func.HttpRequest) -> func.HttpResponse:
    current_time = datetime.datetime.utcnow().isoformat()
    
    response_data = {
        "message": "Hello, World!",
        "timestamp": current_time
    }
    
    return func.HttpResponse(
        json.dumps(response_data),
        mimetype="application/json",
        status_code=200
    ) 