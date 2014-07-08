Feature: Manage Team List
  As an authenticated user who manages a team
  I want to see and edit the list of players associated with that team
  So that I can prepare a roster for easy tournament registration

  Scenario: See players on Team
    Given team Blattman exists with slug blattm
      And I have an authenticated session as bob@sacastle.org with password "password1"
      And bob@sacastle.org manages blattm
      And the blattm team has players:
        | first_name | last_name | uscf_id   | grade | gender |
        | Adam       | Ant       | 00005678  | 1     | M      |
        | Betty      | Boop      |           | 2     | F      |
     When I navigate to the team page for Blattman
     Then I should see content matching
       | ANT, ADAM |
       | BOOP, BETTY |

  Scenario: Create new player on Team
    Given team Blattman exists with slug blattm
      And I have an authenticated session as bob@sacastle.org with password "password1"
      And bob@sacastle.org manages blattm
      And the blattm team has no players
     When I navigate to the team page for Blattman
     Then I should see content matching
      | There are 0 players on this team. |
     When I click the "Add New Player to Team" link
    Then I should see content matching
      | Player Information: Add a Player to Blattman |
      | First name |
      | Grade |
      | USCF Id |

  Scenario: Populate New JTP Player Form using USCF ID
    Given team Blattman exists with slug blattm
    And I have an authenticated session as bob@sacastle.org with password "password1"
    And bob@sacastle.org manages blattm
    And the blattm team has no players
    When I navigate to the team page for Blattman
    And I enter "12541975" into the uscf search field
    And I click the "Search" button
    Then I should see text matching
      | USCF Searches are better for teams with a value for State |
     And I should see a list entry with text containing
      | RODRIGUEZ, JUAN J (UNR) - 12541975 JTP |

  Scenario: Populate Player Form using USCF ID
    Given team Blattman exists with slug blattm
    And team blattm has state TX
    And I have an authenticated session as bob@sacastle.org with password "password1"
    And bob@sacastle.org manages blattm
    And the blattm team has no players
    When I navigate to the team page for Blattman
    And I enter "15127606" into the uscf search field
    And I click the "Search" button
    Then I should see text matching
      | TAYLOR, JACKSON |
      | 15127606 |
      | MEMBER |
    And I should not see content "USCF Searches are better for teams with a value for State"

  Scenario: Search for Player by name
    Given team Blattman exists with slug blattm
    And I have an authenticated session as bob@sacastle.org with password "password1"
    And bob@sacastle.org manages blattm
    And the blattm team has no players
    When I navigate to the team page for Blattman
    And I enter "Taylor, Jackson" into the uscf search field
    And I click the "Search" button
    Then I should see text matching
      | 15127606 |
      | 14076916 |
      | 13249356 |
      | USCF Searches are better for teams with a value for State |

  Scenario: Add Search Hit to Team
    Given team Blattman exists with slug blattm
    And team blattm has state TX
    And I have an authenticated session as bob@sacastle.org with password "password1"
    And bob@sacastle.org manages blattm
    And the blattm team has no players
    When I navigate to the team page for Blattman
    And I enter "15157042" into the uscf search field
    And I click the "Search" button
    When I click the "Add to Team" button
    Then I should see the new player page for Blattman
    When I select "4" for Grade
     And I select "M" for Gender
     And I click the "Create Player" button
    Then I should see the team page for Blattman
     And I should see text matching
         | There are 1 players on this team. |
