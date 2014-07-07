
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

  Scenario: Adult Can Register for Sections that Admit Adults
    Given a tournament exists:
          | slug | name                 | location    | event_date | short_description |
          | igo  | Igo Chess Tournament | Igo Library | 2014-7-12  | One day, 5SS, G/30 d5, in 2 sections |
      And the tournament has sections:
          | Open Rated               |
          | Scholastic (K-12) Rated  |
      And registration for the tournament is on
     When I navigate to "/tournaments/igo/registrations/new"
      And I select "Open Rated" for registration section
      And I select "Adult" for registration grade
      And I enter the following:
          | registration first name      | Bryan          |
          | registration last name       | Taylor         |
          | registration uscf member id  | 12430764       |
          | select: registration gender  | M              |
          | registration guardian emails | me@example.com |
      And I click the "Submit" button
     Then I should see content "preregistered in the "Open Rated" section"
      And a registration should exist for Bryan Taylor in the "Open Rated" section for tournament igo
      And exactly one player with USCF Id 12430764 should exist
      And player Bryan Taylor should have 1 guardians
      And player Bryan Taylor should have school "N/A - Adult"



