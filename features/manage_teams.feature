Feature: Manage Teams
  As an authenticated user
  I want to see the list of teams
  So that I can see who competes in chess

  Scenario: View Team List
    Given I have an authenticated session
    When  I navigate to the team page
    Then I should see the team page





