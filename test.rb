require 'simple_spark'
require 'pry'
require 'json'
require "google_drive"

current_date = Time.now
past_date = current_date - (3600 * 168)

formatted_current_date = current_date.iso8601
formatted_past_date = past_date.iso8601

simple_spark = SimpleSpark::Client.new(api_key: '712f2abc9cf6e9160f0a5820b8b9630ad6040c95')
results = simple_spark.events.search(
  sending_domain: 'mail.allmedx.com',
  from: formatted_past_date,
  to: formatted_current_date,
  per_page: 10000,
  events: 'spam_complaint,list_unsubscribe,link_unsubscribe'
)
#
# template_version:integer friendly_from:string subject:string ip_pool:string sending_domain:string rcpt_tags:array type:string raw_rcpt_to:string msg_from:string rcpt_to:string report_to:string transmission_id:integer fbtype:string rcpt_meta:hstore message_id:string recipient_domain:string report_by:string:string event_id:integer routing_domain:string sending_ip:float template_id:string
# delv_method:string injection_time:timestamp msg_size:integer timestamp:timestamp formattedDate:datetime
#
# template_version
# friendly_from
# subject
# ip_pool
# sending_domain
# rcpt_tags
# type
# raw_rcpt_to
# msg_from
# rcpt_to
# report_to
# transmission_id
# fbtype
# rcpt_meta
# message_id
# recipient_domain
# report_by
# event_id
# routing_domain
# sending_ip
# template_id
# delv_method
# customer_id
# injection_time
# msg_size
# timestamp
# formattedDate

binding.pry

# # Creates a session. This will prompt the credential via command line for the
# # first time and save it to config.json file for later usages.
# # See this document to learn how to create config.json:
# # https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md
# session = GoogleDrive::Session.from_config("oath.json")
#
# # First worksheet of
# # https://docs.google.com/spreadsheet/ccc?key=pz7XtlQC-PYx-jrVMJErTcg
# # Or https://docs.google.com/a/someone.com/spreadsheets/d/pz7XtlQC-PYx-jrVMJErTcg/edit?usp=drive_web
# ws = session.spreadsheet_by_key("pz7XtlQC-PYx-jrVMJErTcg").worksheets[0]
#
# # Gets content of A2 cell.
# p ws[2, 1]  #==> "hoge"
#
# # Changes content of cells.
# # Changes are not sent to the server until you call ws.save().
# ws[2, 1] = "foo"
# ws[2, 2] = "bar"
# ws.save
#
# # Dumps all cells.
# (1..ws.num_rows).each do |row|
#   (1..ws.num_cols).each do |col|
#     p ws[row, col]
#   end
# end
#
# # Yet another way to do so.
# p ws.rows  #==> [["fuga", ""], ["foo", "bar]]
#
# # Reloads the worksheet to get changes by other clients.
# ws.reload
