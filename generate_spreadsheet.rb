require 'simple_spark'
require 'pry'
require 'json'
require "google_drive"
require 'axlsx'
require_relative './lib/nppes_api.rb'
require 'time'
require 'date'

current_time = Time.now
past_time = current_time - (3600 * 168)

formatted_current_time = current_time.iso8601
formatted_past_time = past_time.iso8601

current_date = Date.today
dates = []
day_before = (current_date - 1)
day_counter = 7
while day_counter >= 0
  prior_day = current_date - day_counter
  dates.push(prior_day.strftime("%m-%d"))
  day_counter -= 1
end

simple_spark = SimpleSpark::Client.new(api_key: '712f2abc9cf6e9160f0a5820b8b9630ad6040c95')
results = simple_spark.events.search(
  sending_domain: 'mail.allmedx.com',
  from: formatted_past_time,
  to: formatted_current_time,
  per_page: 10000,
  events: 'spam_complaint,list_unsubscribe,link_unsubscribe'
)

event_keys = {}
new_results =[]

results.each do |result|
  event = {}
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
  dates.each do |date|
    event["unique_email_recipients_#{date}"] = nil
  end
  event_keys = event
  new_results << event
end

first_row = true

p = Axlsx::Package.new
wb = p.workbook

p.workbook do |wb|
  # define your regular styles
  styles = wb.styles
  title = styles.add_style(:sz => 15, :b => true, :u => true)
  default = styles.add_style(:border => Axlsx::STYLE_THIN_BORDER)
  header = styles.add_style(:bg_color => '66', :fg_color => 'FF', :b => true)

  wb.add_worksheet(:name => "Data") do |sheet|
    sheet.add_row event_keys.keys, :style => header
    new_results.each do |e|
      row = []
      if first_row == true
        dates.each do |date|
          formatted_date = date.sub("-", "/")
          e["unique_email_recipients_#{date}"] = "=unique(query(A:U, \"Select H where U like \'#{formatted_date}%\'\"))"
          first_row = false
        end
      end
      event_keys.keys.each do |key|
        final_key = e[key]
        if key == "timestamp" || key == 'injection_time'
          final_key = Time.parse(e[key]).strftime("%m/%d/%Y %I:%M:%S")
        end
        row << final_key
      end
      sheet.add_row row
    end
  end

  wb.add_worksheet(:name => 'Summary') do |sheet|
    sheet.add_row ['Subject', 'list_unsubscribe',	'spam_complaint',	'Grand Total'], :style => header
    8.times do |n|
      sheet.add_row [nil]
    end
    sheet.add_row ['subject',	'date',	'complaints/unsubscribes'], :style => header
    9.times do |n|
      sheet.add_row [nil]
    end
    sheet.add_row ['email',	'date',	'complaints/unsubscribes'], :style => header
  end

  wb.add_worksheet(:name => 'Subject Count') do |sheet|
    # pivot_table = Axlsx::PivotTable.new 'A1:U9999', "A1:U9999", wb.worksheets[0]
    # pivot_table.rows = ['subject']
    # pivot_table.columns = ['event_type']
    # pivot_table.data = ['event_type']
    # sheet.pivot_tables << pivot_table

    table_range = 'A1:U1000'
    data_range = "A1:U9999"
    sheet.add_pivot_table(table_range, data_range) do |pivot_table|
       pivot_table.data_sheet = wb.worksheets[0]
       pivot_table.rows = ['subject']
       pivot_table.columns = ['event_type']
       pivot_table.data = ['event_type']
    end
  end

  wb.add_worksheet(:name => dates[0]) do |sheet|
    table_range = 'A1:U24'
    data_range = "A1:U9999"
    sheet.add_pivot_table(table_range, data_range) do |pivot_table|
       pivot_table.data_sheet = wb.worksheets[0]
       pivot_table.rows = ['raw_rcpt_to']
       pivot_table.columns = ['timestamp']
       pivot_table.data = ['timestamp']
    end
    sheet.add_pivot_table('A25:U1000', data_range) do |pivot_table|
       pivot_table.data_sheet = wb.worksheets[0]
       pivot_table.rows = ['raw_rcpt_to']
       pivot_table.columns = ['subject']
       pivot_table.data = ['subject']
    end
  end

end

# dates.each do |date|
#   wb.add_worksheet(:name => date) do |sheet|
#     table_range = 'A1:U4'
#     data_range = "A1:U9999"
#     sheet.add_pivot_table(table_range, data_range) do |pivot_table|
#        pivot_table.data_sheet = wb.worksheets[0]
#        pivot_table.rows = ['raw_rcpt_to']
#        pivot_table.columns = ['timestamp']
#        pivot_table.data = ['timestamp']
#     end
#     sheet.add_pivot_table('A5:U1000', data_range) do |pivot_table|
#        pivot_table.data_sheet = wb.worksheets[0]
#        pivot_table.rows = ['raw_rcpt_to']
#        pivot_table.columns = ['subject']
#        pivot_table.data = ['subject']
#     end
#   end
# end

p.serialize("./Spreadsheets/Unsubscribes and Complaints Events #{dates.first}-20 - #{dates.last}-20.xlsx")
# p.serialize("./Spreadsheets/railstest.xlsx")

# sheet.add_row(event["template_version"], event["friendly_from"], event["subject"], event["ip_pool"], event["sending_domain"], event["rcpt_tags", event["event_type"], event["raw_rcpt_to"], event["msg_from"], event["rcpt_to"], event["transmission_id"], event["rcpt_meta"] event["message_id"], event["recipient_domain"], event["event_id"], event["routing_domain"], event["sending_ip"], event["template_id"], event["injection_time"], event["msg_size"], event["timestamp"])

# event["template_version"],
# event["friendly_from"],
# event["subject"],
# event["ip_pool"],
# event["sending_domain"],
# event["rcpt_tags",
# event["event_type"],
# event["raw_rcpt_to"],
# event["msg_from"],
# event["rcpt_to"],
# event["transmission_id"],
# event["rcpt_meta"],
# event["message_id"],
# event["recipient_domain"],
# event["event_id"],
# event["routing_domain"],
# event["sending_ip"],
# event["template_id"],
# event["injection_time"],
# event["msg_size"],
# event["timestamp"]


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
