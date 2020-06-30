# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'simple_spark'

Event.delete_all

current_date = Time.now
past_date = current_date - (3600 * 168)

formatted_current_date = current_date.iso8601
formatted_past_date = past_date.iso8601

# gets the SparkPost events for a week
simple_spark = SimpleSpark::Client.new(api_key: '712f2abc9cf6e9160f0a5820b8b9630ad6040c95')
results = simple_spark.events.search(
  sending_domain: 'mail.allmedx.com',
  from: formatted_past_date,
  to: formatted_current_date,
  per_page: 10000,
  events: 'spam_complaint,list_unsubscribe,link_unsubscribe'
)

event = {}

# stores each event into the PostgreSQL table. some of the column names had to be
# changed due to being keywords in Ruby
results.each do |result|
  event["template_version"] = result["template_version"]
  event["friendly_from"] = result["friendly_from"]
  event["subject"] = result["subject"]
  event["ip_pool"] = result["ip_pool"]
  event["sending_domain"] = result["sending_domain"]
  event["rcpt_tags"]= result["rcpt_tags"]
  event["event_type"] = result["type"]
  event["raw_rcpt_to"] = result["raw_rcpt_to"]
  event["msg_from"] = result["msg_from"]
  event["rcpt_to"] = result["rcpt_to"]
  event["transmission_id"] = result["transmission_id"]
  event["rcpt_meta"] = result["rcpt_meta"]
  event["message_id"] = result["message_id"]
  event["recipient_domain"] = result["recipient_domain"]
  event["event_id"] = result["event_id"]
  event["routing_domain"] = result["routing_domain"]
  event["sending_ip"] = result["sending_ip"]
  event["template_id"] = result["template_id"]
  event["injection_time"] = result["injection_time"]
  event["msg_size"] = result["msg_size"]
  event["timestamp"] = result["timestamp"]
  Event.create(event)
end
