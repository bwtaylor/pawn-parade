
Feature: Add a Schedule
  As the application or league administrator
  I want to manage schedules
  So that a user community and league can form around them

Scenario: Application admin creates schedule via CLI
  Given the schedule named "test1" does not exist
    And I have local shell access to execute "bin/pawn" in the project directory
   When I run `pawn schedule create test1`
   Then the schedule named "test1" should exist
    And the output should contain "schedule test1 created"

Scenario: Application admin lists schedules via CLI
  Given The existing schedules are:
        | test3 |
        | test2 |
   When I run `pawn schedule list`
   Then the output should contain:
        """
        test2
        test3
        2 schedules found
        """

  Scenario: Add tournament to schedule
    Given a schedule named "testschedule" exists with tournaments:
      | slug            | name                                 | location                 | event_date | short_description |
      | briscoe_ms      | Bricscoe MS Scholastic Tournament    | Briscoe Middle School    | 2013-9-14  | One-day scholastic tournament with rated and unrated sections. |
      | harmony_hills   | Fall-2013 Harmony Hills Tournament   | Harmony Hills Elementary | 2013-10-19 | 5-SS, Rd. 1 and 2 G/90, Rds. 3-5 30/90 S/D1. |
    And a tournament exists:
      | slug            | name                                 | location                 | event_date | short_description |
      | JayHS-Fall-2013 | John Jay Scholastic Chess Tournament | John Jay High School     | 2013-9-28  | One day, 5SS, G/30 d5, in 4 sections |
    When I run `pawn schedule add --to testschedule jayhs-fall-2013 `
    And I run `pawn schedule show testschedule`
    And the date is "2013-7-7"
    Then the output should contain:
    """
    Briscoe Middle School 2013-09-14
    John Jay High School 2013-09-28
    Harmony Hills Elementary 2013-10-19
    3 tournaments found
    """
