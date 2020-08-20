import sys


def application(env, start_response):
    version = f"{sys.version_info.major}.{sys.version_info.minor}"
    start_response("200 OK", [("Content-Type", "text/plain")])
    message = f"Waitress serving up WSGI Python {version} in a Docker container"
    return [message.encode("utf-8")]
