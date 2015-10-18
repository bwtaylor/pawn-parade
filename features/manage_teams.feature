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
      And bob@sacastle.org does not manage a team
      And I have local shell access to execute "bin/pawn" in the project directory
     When I run `pawn manager --for blattm bob@sacastle.org`
     Then the output should contain "made bob@sacastle.org team manager for Blattman"
      And bob@sacastle.org should manage blattm

  Scenario: Admin makes User a Team Manager via UI
    Given team Blattman exists with slug blattm
      And user bob@sacastle.org exists with password "password1"
      And bob@sacastle.org does not manage a team
      And I have an authenticated admin session
     When I navigate to the team page for Blattman
      And I enter the following:
          | manager email | bob@sacastle.org |
      And I click the "Add" button
     Then bob@sacastle.org should manage blattm
      And I should see content "bob@sacastle.org"

  Scenario: Dashboard lists teams I manages
    Given team Blattman exists with slug blattm
      And I have an authenticated session as bob@sacastle.org with password "password1"
      And bob@sacastle.org manages blattm
     When I navigate to the dashboard page
     Then the dashboard team list includes blattm

  Scenario: Team manager adds team details
    Given team Blattman exists with slug blattm
      And I have an authenticated session as bob@sacastle.org with password "password1"
      And bob@sacastle.org manages blattm
      And I navigate to the dashboard page
      And I navigate to the edit team page for Blattman
     When I enter the following:
          | team city    | San Antonio |
          | team county  | Bexar       |
          | team state   | TX          |
          | team school_district | NISD |
      And I click the "Update Team" button
     Then I should see content "San Antonio, TX - Bexar County (NISD)"

  Scenario: Batch Register team members for Tournament
    Given team Blattman exists with slug blattm
      And the blattm team has players:
        | first_name | last_name | uscf_id   | grade | gender |
        | Hari       | Tunga     | 15157042  | 4     | M      |
        | Jackson    | Taylor    | 15127606  | 2     | M      |
      And I have an authenticated session as "bob@sacastle.org"
      And bob@sacastle.org manages blattm
      And a schedule named "testschedule" exists with tournaments:
          | slug            | name                                 | location                 | event_date | registration | short_description |
          | JayHS-Fall-2013 | John Jay Scholastic Chess Tournament | John Jay High School     | 2013-9-28  | off           | One day, 5SS, G/30 d5, in 4 sections |
          | harmony_hills   | Fall-2013 Harmony Hills Tournament   | Harmony Hills Elementary | 2013-10-19 | on          | 5-SS, Rd. 1 and 2 G/90, Rds. 3-5 30/90 S/D1. |
          | briscoe_ms      | Bricscoe MS Scholastic Tournament    | Briscoe Middle School    | 2013-9-14  | on           | One-day scholastic tournament with rated and unrated sections. |
      And the date is "2013-7-7"
      And the tournament of interest has slug briscoe_ms
      And the tournament has sections:
        | Primary Rated Open         |
        | Elementary Rated Open      |
        | Elementary Rated JV        |
    When I navigate to the team page for Blattman
     Then I should see content "Bricscoe MS Scholastic Tournament"
      And I should see content "Fall-2013 Harmony Hills Tournament"
      And I should not see content "John Jay Scholastic Chess Tournament"
     When I navigate to the team registration page for Blattman and briscoe_ms

  Scenario: Add USCF ID to Team Member
    Given team Blattman exists with slug blattm
      And the blattm team has players:
        | first_name | last_name | uscf_id   | grade | gender |
        | JACKSON    | TAYLOR    |           | 2     | M      |
      And I have an authenticated session as bob@sacastle.org with password "testpassword"
      And bob@sacastle.org manages blattm
     When I navigate to the team page for Blattman
     Then I should see content "TAYLOR, JACKSON"
      And I click the "Edit" link
      And I enter "15127606" into the player uscf id field
      And I click the "Update" button
      And I navigate to the team page for Blattman
     Then I should see content "TAYLOR, JACKSON"
      And I should see content "15127606"


