Feature: Admins
  As the application deployer
  I want to grant certain users admin rights
  So that they can do certain actions that require authorization

  Scenario: Grant admin via CLI to existing user
    Given I have local shell access to execute "bin/pawn" in the project directory
      And user dude@example.com exists with password "password1"
      And user dude@example.com is not an admin
     When I run `pawn user create --admin dude@example.com`
     Then the output should contain "User dude@example.com is now an admin"
      And the user dude@example.com should exist exactly once
      And dude@example.com can authenticate with password "password1"
      And user dude@example.com should be an admin

  Scenario: Teams are isolated sans admin role
     Given team Blattman exists with slug blattm
       And team Langley exists with slug langl
       And user green@example.com exists with password "password1"
       And I have an authenticated session as me@sacastle.org with password "password2"
       And user me@sacastle.org is not an admin
       And me@sacastle.org manages blattm
       And green@example.com manages langl
      When I navigate to the team page
      Then I should see content "Blattman"
       And I should not see content "Langley"
