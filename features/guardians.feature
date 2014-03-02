Feature: Player's Guardians
  As a player
  I want to specify my guardians via email address
  So that they can edit my record as users

  Scenario: Guardians see their Player on their dashboard
    Given user dad@example.com exists with password "password"
      And no user mom@example.com exists
      And these players exist:
        | first_name | last_name | uscf_id   | grade | guardians |
        | Adam       | Ant       | 12345678  | 1     | mom@example.com dad@example.com |
        | Art        | Ant       |           | 2     | mom@example.com                 |
     When I authenticate as dad@example.com
      And I navigate to the dashboard page
     Then I should not see text "ANT, ART"
      And I should see text "ANT, ADAM"
     When I logout as dad@example.com
      And I sign up and login as mom@example.com
      And I navigate to the dashboard page
     Then I should see text "ANT, ART"
      And I should see text "ANT, ADAM"
