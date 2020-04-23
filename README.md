## SparkPost Metrics
Created by Joseph Harwood

## Description:

This application pulls Events metrics from the SparkPost API.

## Instructions
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
