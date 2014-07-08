Feature: Player's Guardians
  As a player
  I want to specify my guardians via email address
  So that they can edit my record as users

  Scenario: Guardians see their Player on their dashboard
    Given user dad@example.com exists with password "password"
      And no user mom@example.com exists
      And these players exist:
        | first_name | last_name | school | uscf_id   | grade | gender | guardians |
        | Adam       | Ant       | West   | 00005678  | 1     | M      | mom@example.com dad@example.com |
        | Art        | Ant       | West   |           | 2     | M      | mom@example.com                 |
     When I authenticate as dad@example.com
      And I navigate to the dashboard page
     Then I should not see text "ANT, ART"
      And I should see text "ANT, ADAM"
     When I logout as dad@example.com
      And I sign up and login as mom@example.com
      And I navigate to the dashboard page
     Then I should see text "ANT, ART"
      And I should see text "ANT, ADAM"

# This is failing b/c there is js to submit the form after the Tournament is selected
@broken
Scenario: Guardians Player pages show Tournaments
    Given user dad@example.com exists with password "password"
      And I authenticate as dad@example.com
      And the date is "2013-7-7"
      And these players exist:
        | first_name | last_name | school   | uscf_id   | grade | gender | guardians       |
        | Adam       | Ant       | Westlake | 12345678  | 1     | M      | dad@example.com |
      And a tournament exists:
        | slug | name                       | location     | event_date | short_description                                              |
        | rax  | Rackspace Chess Tournament | Rackspace    | 2013-10-26 | One-day scholastic tournament with rated and unrated sections. |
      And the tournament has sections:
        | Primary Rated Open |
      And registration for the tournament is on
     When I navigate to the player page for Adam Ant
     Then I should see content "Player Page for ADAM ANT"
      And I select "Rackspace Chess Tournament" for Tournament
      And I click the "Register" button
      And I select "Primary Rated Open" for Section
      And I click the "Register" button
     Then I should see the new registration page for rax
      And I should see content "Gender is not included in the list"
     When I select "M" for registration gender
      And I click the "Submit" button
     Then I should see the player page for Adam Ant
      And I should see a tournament registration for rax

