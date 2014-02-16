
Feature: Manage Users via CLI
  As the application administrator
  I want to create Users via the CLI
  So that those users can authenticate

  Scenario: Add User via CLI
    Given no user bob@sacastle.org exists
      And I have local shell access to execute "bin/pawn" in the project directory
      And The default aruba timeout is 3 seconds
     When I run `pawn user create bob@sacastle.org` interactively
      And I wait for stdout to contain "Password:"
      And I type "mysecret"
     Then the output should contain "User bob@sacastle.org created"
      And the user bob@sacastle.org should exist exactly once
      And bob@sacastle.org can authenticate with password "mysecret"

  Scenario: Reset password via CLI
    Given user bob@sacastle.org exists with password "password1"
      And I have local shell access to execute "bin/pawn" in the project directory
      And The default aruba timeout is 3 seconds
     When I run `pawn user password bob@sacastle.org` interactively
      And I wait for stdout to contain "Password:"
      And I type "password2"
     Then the output should contain "Password updated for bob@sacastle.org"
      And bob@sacastle.org can authenticate with password "password2"