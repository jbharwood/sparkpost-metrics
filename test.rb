require 'simple_spark'
require 'pry'
require 'json'
require "google_drive"
# require 'axlsx_rails'
require 'axlsx'
require_relative './lib/nppes_api.rb'

# banks1 = NPPESApi.search(country_code: 'US', taxonomy_description: 'Hematology & Oncology', limit: 200)
# banks2 = NPPESApi.search(country_code: 'US', taxonomy_description: 'Hematology & Oncology', limit: 200, skip: 200)
# banks3 = NPPESApi.search(country_code: 'US', taxonomy_description: 'Hematology & Oncology', limit: 200, skip: 400)
banks4 = NPPESApi.search(country_code: 'US', taxonomy_description: 'Hematology & Oncology', limit: 200, skip: 500)
# banks = NPPESApi.search(number: 1932494937)
# NPPESApi.search(number: 1932494937).results.first.taxonomies.first.state
binding.pry

# p = Axlsx::Package.new
# wb = p.workbook
# # wb = xlsx_package.workbook
# wb.add_worksheet(name: "Events") do |sheet|
#   # this is the head row of your spreadsheet
#   sheet.add_row %w(id name email)
#
#   # each user is a row on your spreadsheet
#   results.each do |result|
#     sheet.add_row [result]
#     # sheet.add_row [user.id, user.name, user.email]
#   end
# end
#
# wb.serialize('./Spreadsheets')


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
