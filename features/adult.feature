
Feature: Adult Sections
  As the application administrator
  I want to create a section that accepts adults
  So that adults can register to play

  Scenario: Add Open Section that takes Adults
  Given a tournament exists:
        | slug | name                 | location    | event_date | short_description |
        | igo  | Igo Chess Tournament | Igo Library | 2014-7-12  | One day, 5SS, G/30 d5, in 2 sections |
    And the tournament has no sections
    And I have local shell access to execute "bin/pawn" in the project directory
   When I run `pawn section import --to igo "Open Rated" "Scholastic Rated"`
   Then the output should contain "Tournament igo has 2 sections, 2 rated, 0 unrated"
    And the tournament should have 2 sections
    And the tournament should have 2 rated sections
    And section open_rated should accept adults
    And the tournament is open for adults
