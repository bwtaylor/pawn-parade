Feature: Manage Team List
  As an authenticated user
  I want to see the list of teams
  So that I can see who competes in chess

  Scenario: View Team List
    Given I have an authenticated session
    When  I navigate to the team page
    Then I should see the team page

  Scenario: Admin makes User a Team Manager via CLI
    Given team Blattman exists with slug blattm
      And user bob@sacastle.org exists with password "password1"
      And bob@sacastle.org manages no teams
      And I have local shell access to execute "bin/pawn" in the project directory
     When I run `pawn manager --for blattm bob@sacastle.org`
     Then the output should contain "made bob@sacastle.org team manager for Blattman"
      And bob@sacastle.org should manage blattm

  Scenario: Dashboard lists teams I manages
    Given team Blattman exists with slug blattm
      And I have an authenticated session as bob@sacastle.org with password "password1"
      And bob@sacastle.org manages blattm
     When I navigate to the dashboard page
     Then the dashboard team list includes blattm
