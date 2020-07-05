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

# stores the dates for a week
current_date = Date.today
dates = []
day_before = (current_date - 1)
day_counter = 7
while day_counter >= 0
  prior_day = current_date - day_counter
  dates.push(prior_day.strftime("%m-%d"))
  day_counter -= 1
end

# SparkPost API call
simple_spark = SimpleSpark::Client.new(api_key: 'key')
results = simple_spark.events.search(
  sending_domain: 'mail.allmedx.com',
  from: formatted_past_time,
  to: formatted_current_time,
  per_page: 10000,
  events: 'spam_complaint,list_unsubscribe,link_unsubscribe'
)

event_keys = {}
new_results =[]

# stores each event into the new_results. some of the column names had to be
# changed due to being keywords in Ruby. Also stores event keys in event_keys
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

# first_row is used for header columns in the spreadsheet
first_row = true

p = Axlsx::Package.new
wb = p.workbook

p.workbook do |wb|
  styles = wb.styles
  title = styles.add_style(:sz => 15, :b => true, :u => true)
  default = styles.add_style(:border => Axlsx::STYLE_THIN_BORDER)
  header = styles.add_style(:bg_color => '66', :fg_color => 'FF', :b => true)

# Data sheet with unqiue email recipients query in it
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

# empty Summary sheet is created
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

# Subject Count sheet is created with a pivot table
  wb.add_worksheet(:name => 'Subject Count') do |sheet|
    table_range = 'A1:U1000'
    data_range = "A1:U9999"
    sheet.add_pivot_table(table_range, data_range) do |pivot_table|
       pivot_table.data_sheet = wb.worksheets[0]
       pivot_table.rows = ['subject']
       pivot_table.columns = ['event_type']
       pivot_table.data = ['event_type']
    end
  end

# Sheets for each day are created with 2 pivot tables
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

# creates Excel spreadsheet in Spreadsheets folder
p.serialize("./Spreadsheets/Unsubscribes and Complaints Events #{dates.first}-20 - #{dates.last}-20.xlsx")
