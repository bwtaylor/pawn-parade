Feature: Manage Teams
  As an authenticated user
  I want to see the list of teams
  So that I can see who competes in chess

  Scenario: View Team List
    Given I have an authentication session
    When I navigate to "/teams"
    Then I should see the teams page

  Scenario: Public Can't View Team List
    Given I have no authentication session
    When I navigate to "/teams"
    Then I should see the login page




