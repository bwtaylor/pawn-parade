Feature: Manage Sections
  As the application administrator
  I want to manage tournament sections
  So that users and I can leverage the registration functionality

  Scenario: Add Sections to an Existing Tournament via CLI
    Given a tournament exists:
        | slug            | name                                 | location                 | event_date | short_description |
        | jayhs-fall-2013 | John Jay Scholastic Chess Tournament | John Jay High School     | 2013-9-28  | One day, 5SS, G/30 d5, in 4 sections |
      And the tournament has no sections
      And I have local shell access to execute "bin/pawn" in the project directory
     When I run `pawn section import --to jayhs-fall-2013 "Primary Unrated" "Elementary Unrated" "U500" "Open Rated" "Middle School Unrated" "HS Unrated"`
     Then the output should contain "Tournament jayhs-fall-2013 has 6 sections, 2 rated, 4 unrated"
      And the tournament should have 6 sections
      And the tournament should have 2 rated sections
      And the tournament should have 4 unrated sections

  Scenario: Show Sections for an Existing Tournament via CLI
    Given a tournament exists:
        | slug            | name                                 | location                 | event_date | short_description |
        | jayhs-fall-2013 | John Jay Scholastic Chess Tournament | John Jay High School     | 2013-9-28  | One day, 5SS, G/30 d5, in 4 sections |
      And the tournament has sections:
        | Primary Rated         |
        | Elementary Rated      |
        | Elementary Unrated    |
     When I run `pawn section list --for jayhs-fall-2013`
     Then the output should contain "primary_rated [rated]"
      And the output should contain "elementary_rated [rated]"
      And the output should contain "elementary_unrated [unrated]"
      And the output should contain "Tournament jayhs-fall-2013 has 3 sections, 2 rated, 1 unrated"

