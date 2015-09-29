
Feature: Manage Tournaments via CLI
  As the application administrator
  I want to manage tournaments
  So that the user community following a schedule can have new tournament information

  Scenario: See upcoming tournaments on a schedule
    Given a schedule named "testschedule" exists with tournaments:
      | slug            | name                                 | location                 | event_date | short_description |
      | JayHS-Fall-2013 | John Jay Scholastic Chess Tournament | John Jay High School     | 2013-9-28  | One day, 5SS, G/30 d5, in 4 sections |
      | harmony_hills   | Fall-2013 Harmony Hills Tournament   | Harmony Hills Elementary | 2013-10-19 | 5-SS, Rd. 1 and 2 G/90, Rds. 3-5 30/90 S/D1. |
      | briscoe_ms      | Bricscoe MS Scholastic Tournament    | Briscoe Middle School    | 2013-9-14  | One-day scholastic tournament with rated and unrated sections. |
    When the date is "2013-7-7"
    And I run `pawn schedule show testschedule`
    Then the output should contain:
    """
    Briscoe Middle School 2013-09-14
    John Jay High School 2013-09-28
    Harmony Hills Elementary 2013-10-19
    3 tournaments found
    """

  Scenario: Create new tournament listing via CLI
    Given the tournament with slug "briscoe-fall-2013" does not exist
    When I run `pawn tournament create Briscoe-fall-2013 "Bricscoe MS Scholastic Tournament" "Briscoe Middle School" 2013-9-14 "One-day scholastic tournament with rated and unrated sections."`
    Then the output should contain "tournament briscoe-fall-2013 created"
    And exactly one tournament with slug "briscoe-fall-2013" should exist

  Scenario: Can't create duplicate tournament slug
    Given a tournament exists:
      | slug            | name                                 | location                 | event_date | short_description |
      | jayhs-fall-2013 | John Jay Scholastic Chess Tournament | John Jay High School     | 2013-9-28  | One day, 5SS, G/30 d5, in 4 sections |
    When I run `pawn tournament create JayHS-Fall-2013 "Jay Chess Tny" "John Jay High School" 2013-9-14 "Play chess at Jay"`
    Then the output should contain "Tournament jayhs-fall-2013 already exists."
    And exactly one tournament with slug "jayhs-fall-2013" should exist

  Scenario: Can't create duplicate tournament location & event_date
    Given a tournament exists:
      | slug            | name                                 | location                 | event_date | short_description |
      | jayhs-fall-2013 | John Jay Scholastic Chess Tournament | John Jay High School     | 2013-9-28  | One day, 5SS, G/30 d5, in 4 sections |
    When I run `pawn tournament create JJHS-Fall-2013 "Jay Chess Tny" "John Jay High School" 2013-9-28 "Play chess at Jay"`
    Then the output should contain "Tournament duplicates location and event date of tournament jayhs-fall-2013."
    And exactly one tournament with slug "jayhs-fall-2013" should exist

  Scenario: Generate CLI command to recreate existing tournament
    Given a tournament exists:
        | slug            | name                                 | location                 | event_date | short_description |
        | jayhs-fall-2013 | John Jay Scholastic Chess Tournament | John Jay High School     | 2013-9-28  | One day, 5SS, G/30 d5, in 4 sections |
     When I run `pawn tournament export jayhs-fall-2013`
     Then the output should contain 'pawn tournament create jayhs-fall-2013 "John Jay Scholastic Chess Tournament" "John Jay High School" 2013-09-28 "One day, 5SS, G/30 d5, in 4 sections"'
