Feature: Browse Tournament
  As an admin
  I want to browse the list of tournaments
  So that I can navigate quickly to the various pages related to them

  Scenario: Admin can
      Given I have an authenticated admin session
       When I navigate to the dashboard page
        And I click the "View Tournaments" link
       Then I should see content "Administrate Tournaments"

  Scenario: Admin can
      Given I have an authenticated session
       When I navigate to the dashboard page
       Then I should not see content "View Tournaments"
       When I navigate to the tournaments page
       Then I should not see content "Administrate Tournaments"



