from decouple import config

APP_ID = config("FORWARDER_APP_ID", default=None, cast=int)
API_HASH = config("FORWARDER_API_HASH", default=None)
SESSION = config("FORWARDER_SESSION")
FORWARDER_FROM_CHANNEL = config("FORWARDER_FROM_CHANNEL") # multiple inputs separated by commas, ID's or username without '@'
FORWARDER_TO_CHANNEL = config("FORWARDER_TO_CHANNEL") # multiple inputs separated by commas, ID's or username without '@'
