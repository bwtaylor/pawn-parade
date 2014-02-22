Feature: Manage Team List
  As an authenticated user who manages a team
  I want to see and edit the list of players associated with that team
  So that I can prepare a roster for easy tournament registration

  Scenario: See players on Team
    Given team Blattman exists with slug blattm
      And I have an authenticated session as bob@sacastle.org with password "password1"
      And bob@sacastle.org manages blattm
      And the blattm team has players:
        | first_name | last_name | uscf_id   | grade |
        | Adam       | Ant       | 12345678  | 1     |
        | Betty      | Boop      |           | 2     |
     When I navigate to the team page for blattm
     Then I should see content matching
       | Adam Ant |
       | Betty Boop |

  Scenario: Create new player on Team
    Given team Blattman exists with slug blattm
      And I have an authenticated session as bob@sacastle.org with password "password1"
      And bob@sacastle.org manages blattm
      And the blattm team has no players
     When I navigate to the team page for blattm
     Then I should see content matching
      | There are 0 players on this team. |
      | Player Information: Add a Player to Blattman Team |
      | First name |
      | Grade |
      | USCF Id |
