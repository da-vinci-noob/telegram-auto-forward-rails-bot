from telethon import TelegramClient, events
import logging
from telethon.sessions import StringSession
from variables import *

def check_user_input(val):
  try:
    return int(val)
  except Exception as e:
    print(e)
    logging.error(e)
    return val

logging.basicConfig(format='[%(levelname) 5s/%(asctime)s] %(name)s: %(message)s', filename='errors.log', encoding='utf-8', level=logging.WARNING)

print("Starting...")

SOURCE = [check_user_input(i) for i in FORWARDER_FROM_CHANNEL.split(',')]
DESTINATION = [check_user_input(i) for i in FORWARDER_TO_CHANNEL.split(',')]

try:
  client = TelegramClient(StringSession(SESSION), APP_ID, API_HASH)
  client.start()
except Exception as e:
  print(f"Error Telegram Client ----------> - {e}")
  exit(1)

@client.on(events.NewMessage(incoming=True, chats=SOURCE))
async def forward_messages(event):
  for i in DESTINATION:
    try:
      await client.send_message(i,event.message)
      sender = await event.get_sender()
      sender_id = event.sender_id
      sender_full_name = sender.title if hasattr(sender, 'title') else ''
      sender_username = sender.username if hasattr(sender, 'username') else ''
      receiver = await client.get_entity(i)
      receiver_full_name = receiver.title if hasattr(receiver, 'title') else ''
      if hasattr(receiver, 'first_name'): receiver_full_name = f'{receiver_full_name} {receiver.first_name}'
      receiver_username = receiver.username if hasattr(receiver, 'username') else ''
      print(f"Message '{event.text}' sent from {sender_full_name} ({sender_username}) to {receiver_full_name} ({receiver_username})")
    except Exception as e:
      print(f"Error SEND Message {event.text} ----------> {e}")
      logging.error(f"Error SEND Message {event.text} ----------> {e}")

print("Bot has started.")
client.run_until_disconnected()
