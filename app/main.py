import sys


def app(env, start_response):
    version = f"{sys.version_info.major}.{sys.version_info.minor}"
    start_response("200 OK", [("Content-Type", "text/plain")])
    message = f"Waitress serving up Python {version} in a Docker container"
    return [message.encode("utf-8")]
