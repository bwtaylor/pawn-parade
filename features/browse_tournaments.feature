
Feature: Browse Tournaments
  As a web user
  I want to browse a chess tournament schedule
  So that I can discover tournaments I may be interested in

Scenario: See upcoming tournaments on a schedule
  Given a schedule named "testschedule" exists with tournaments:
        | slug            | location                 | event_date |
        | JayHS-Fall-2013 | John Jay High School     | 2013-9-28  |
        | harmony_hills   | Harmony Hills Elementary | 2013-10-19 |
        | briscoe_ms      | Briscoe Middle School    | 2013-9-14  |
   When the date is "2013-7-7"
    And I navigate to "/schedules/testschedule"
   Then I should see the tournament-schedule table matching
        | Briscoe Middle School    | 2013-09-14 |
        | John Jay High School     | 2013-09-28 |
        | Harmony Hills Elementary | 2013-10-19 |
                    
                                                                    
