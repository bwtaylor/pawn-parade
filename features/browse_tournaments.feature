
Feature: Browse Tournaments
  As a web user
  I want to browse a chess tournament schedule
  So that I can discover tournaments I may be interested in

Scenario: See upcoming tournaments on a schedule
  Given a schedule named "testschedule" exists with tournaments:
        | slug            | name                                 | location                 | event_date | short_description |
        | JayHS-Fall-2013 | John Jay Scholastic Chess Tournament | John Jay High School     | 2013-9-28  | One day, 5SS, G/30 d5, in 4 sections |
        | harmony_hills   | Fall-2013 Harmony Hills Tournament   | Harmony Hills Elementary | 2013-10-19 | 5-SS, Rd. 1 and 2 G/90, Rds. 3-5 30/90 S/D1. |
        | briscoe_ms      | Bricscoe MS Scholastic Tournament    | Briscoe Middle School    | 2013-9-14  | One-day scholastic tournament with rated and unrated sections. |
   When the date is "2013-7-7"
    And I navigate to "/schedules/testschedule"
   Then I should see the tournament-schedule table matching
     | Date       | Event                           | Location                 | Description                                                    |
     | 2013-09-14 | Bricscoe MS Scholastic Tournament    | Briscoe Middle School    | One-day scholastic tournament with rated and unrated sections. |
     | 2013-09-28 | John Jay Scholastic Chess Tournament | John Jay High School     | One day, 5SS, G/30 d5, in 4 sections                           |
     | 2013-10-19 | Fall-2013 Harmony Hills Tournament   | Harmony Hills Elementary | 5-SS, Rd. 1 and 2 G/90, Rds. 3-5 30/90 S/D1.                   |

  Scenario: See the page for a specific tournament
  Given a tournament exists:
    | slug            | name                                 | location                 | event_date | short_description |
    | JayHS-Fall-2013 | John Jay Scholastic Chess Tournament | John Jay High School     | 2013-9-28  | One day, 5SS, G/30 d5, in 4 sections |
   When I navigate to "/tournaments/jayhs-fall-2013"
   Then I should see content matching
    | John Jay Scholastic Chess Tournament |
    | John Jay High School |
    | One day, 5SS, G/30 d5, in 4 sections |