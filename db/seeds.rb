# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
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
