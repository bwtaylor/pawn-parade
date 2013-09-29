
Feature: Manage Registration via CLI
  As the application or league administrator
  I want to control tournament registration
  So that competitors can only sign up if I allow it

  Scenario: Enable Registration via CLI
    Given a tournament exists:
      | slug | name                       | location     | event_date | short_description                                              |
      | rax  | Rackspace Chess Tournament | Rackspace    | 2013-10-26 | One-day scholastic tournament with rated and unrated sections. |
    And the tournament has sections:
      | Primary Rated Open         |
      | Elementary Rated Open      |
      | Elementary Rated JV        |
    And I have local shell access to execute "bin/pawn" in the project directory
    And registration for the tournament is off
    And no registrations exist for the tournament
    When I run `pawn registration --on rax`
    Then registration for tournament rax should be on
    And the output should contain "registration on for tournament rax"

  Scenario: Disable Registration via CLI
    Given a tournament exists:
      | slug | name                       | location     | event_date | short_description                                              |
      | rax  | Rackspace Chess Tournament | Rackspace    | 2013-10-26 | One-day scholastic tournament with rated and unrated sections. |
    And I have local shell access to execute "bin/pawn" in the project directory
    And registration for the tournament is on
    When I run `pawn registration rax --off`
    Then registration for tournament rax should be off
    And the output should contain "registration off for tournament rax"

  Scenario: Enable Registration via CLI
    Given a tournament exists:
      | slug | name                       | location     | event_date | short_description                                              |
      | rax  | Rackspace Chess Tournament | Rackspace    | 2013-10-26 | One-day scholastic tournament with rated and unrated sections. |
    And the tournament has no sections
    And I have local shell access to execute "bin/pawn" in the project directory
    And registration for the tournament is off
    When I run `pawn registration --on rax`
    Then registration for tournament rax should be off
    And the output should contain "tournament rax has no sections, can't enable registration"


#  Scenario: Reenable Registration via CLI

#  Scenario: List Registrations for Tournament via CLI

