
Feature: Authentication works
  As the application administrator
  I want Users to login and logout
  So that the app can assure privacy and security

  Scenario: Public Can't View Team List
    Given I have no authenticated session
     When I navigate to "/teams"
     Then I should see the sign in page

  Scenario: Can Sign in
    Given user bob@sacastle.org exists with password "password1"
     When I navigate to the home page
      And I click the "Sign In" link
      And I enter the following:
        | Email | bob@sacastle.org |
        | Password | password1     |
      And I click the "Sign in" button
     Then I should see my personal home page
      And there is a "Sign Out" link or button

  Scenario: Can Sign Out
    Given I have an authenticated session
     When I navigate to the team page
      And I click the "Sign Out" button
     Then I should see the home page
      And I navigate to "/teams"
     Then I should see the sign in page



