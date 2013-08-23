
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

