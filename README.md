## SparkPost Metrics
Created by Joseph Harwood

## Description:

This application pulls Events metrics from the SparkPost API.

## Instructions to store the 7 day SparkPost Events metrics in a PostgreSQL database
1) In order to run this, within the root directory make sure to install
dependencies by opening the terminal and typing the following:

  `bundle install`

2) Create the database:

  `rails db:create`

3) Run the migration:

  `rails db:migrate`

4) Seed the table:

  `rails db:seed`

5) Start the application:

  `rails s`

6) View the events at:

  `http://localhost:3000/events`

## Instructions to generate an Excel Spreadsheet for the 7 day SparkPost Events email
1) In order to run this, within the root directory make sure to install
dependencies by opening the terminal and typing the following:

  `bundle install`

2) Run this in the terminal from the root directory

  `ruby generate_spreadsheet.rb`

3) Import the CSV from the Spreadsheets folder into Google Sheets

4) Modify the Google Sheet to look like this: https://docs.google.com/spreadsheets/d/1oYrHrB951nj-CyTaRbN3AdgQ0MvHLcN0vNVyD0qv20o/edit?usp=sharing

5) Things to change in Google Sheets:

  Every pivot table needs the Values event type column to be changed to Summarize By changed from SUM to COUNTA.
  Every date sheet has 2 pivot tables that needs to be filtered by MM/DD for the timestamp. Duplicate the sheets and change the filter to a different day.
  Update the Summary sheet with high numbers from the pivot tables.


6) View the events at:

  `http://localhost:3000/events`
