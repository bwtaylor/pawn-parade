
Feature: Browse Schedules
  As a web user
  I want to browse the list of schedules
  So that I can discover a schedule I may be interested in

Scenario: See the list of schedules
  Given The existing schedules are:
    | slug        | name          |
    | san_antonio | San Antonio   |
    | austin      | Austin        |
    | nisd_tx     | Northside ISD |
   When I navigate to "/schedules"
   Then I should see the schedules table matching
        | Schedule      |
        | Austin        |
        | Northside ISD |
        | San Antonio   |


