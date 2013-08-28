
Feature: Manage Tournaments via CLI
  As the application administrator
  I want to manage tournaments
  So that the user community following a schedule can have new tournament information

  Scenario: See upcoming tournaments on a schedule
    Given a schedule named "testschedule" exists with tournaments:
      | slug            | location                 | event_date |
      | JayHS-Fall-2013 | John Jay High School     | 2013-9-28  |
      | harmony_hills   | Harmony Hills Elementary | 2013-10-19 |
      | briscoe_ms      | Briscoe Middle School    | 2013-9-14  |
    When the date is "2013-7-7"
    And I run `pawn schedule show testschedule`
    Then the output should contain:
    """
    Briscoe Middle School 2013-09-14
    John Jay High School 2013-09-28
    Harmony Hills Elementary 2013-10-19
    3 tournaments found
    """

  Scenario: Create new tournament listing
    Given the tournament with slug "briscoe-fall-2013" does not exist
    When I run `pawn tournament create Briscoe-fall-2013 "Briscoe Middle School" 2013-9-14`
    Then the output should contain "tournament briscoe-fall-2013 created"
    And exactly one tournament with slug "briscoe-fall-2013" should exist

  Scenario: Create duplicate tournament slug
    Given a tournament exists:
      | slug            | location                 | event_date |
      | jayhs-fall-2013 | John Jay High School     | 2013-9-28  |
    When I run `pawn tournament create JayHS-Fall-2013 "John Jay High School" 2013-9-14`
    Then the output should contain "Tournament jayhs-fall-2013 already exists."
    And exactly one tournament with slug "jayhs-fall-2013" should exist

  Scenario: Create duplicate tournament location & event_date
    Given a tournament exists:
      | slug            | location                 | event_date |
      | jayhs-fall-2013 | John Jay High School     | 2013-9-28  |
    When I run `pawn tournament create JJHS-Fall-2013 "John Jay High School" 2013-9-28`
    Then the output should contain "Tournament duplicates location and event date of tournament jayhs-fall-2013."
    And exactly one tournament with slug "jayhs-fall-2013" should exist

