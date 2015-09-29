Feature: Create Tournament
  As the application administrator
  I want to create a tournament via the UI
  So that the scholastic chess community can see tournament details

  Scenario: Create new tournament listing via UI
      Given I have an authenticated admin session
        And the tournament with slug "briscoe-fall-2013" does not exist
       When I navigate to the create tournament page
       Then I should see content "Create Tournament"
       When I enter the following:
            | tournament slug                  | briscoe-fall-2013           |
            | tournament name                  | Briscoe Fall 2014           |
            | tournament location              | Briscoe MS                  |
            | date: tournament event date      | 2013-September-28           |
            | tournament short_description     | A nice friendly tournament  |
        And I click the "Create Tournament" button
       Then exactly one tournament with slug "briscoe-fall-2013" should exist

  Scenario: Must be admin to navigate to create tournament page
      Given I have an authenticated session
       When I navigate to the create tournament page
       Then I should not see content "Create Tournament"

  Scenario: Modify existing tournament listing via UI
      Given I have an authenticated admin session
        And a tournament exists:
            | slug | name                       | location     | event_date | short_description                                              |
            | rax  | Rackspace Chess Tournament | Rackspace    | 2013-10-26 | One-day scholastic tournament with rated and unrated sections. |
        And registration for the tournament is off
       When I navigate to the edit tournament page for rax
       Then I should see content "Edit Tournament"

  Scenario: Must be admin to navigate to edit tournament page
      Given I have an authenticated session
        And a tournament exists:
            | slug | name                       | location     | event_date | short_description                                              |
            | rax  | Rackspace Chess Tournament | Rackspace    | 2013-10-26 | One-day scholastic tournament with rated and unrated sections. |
        And registration for the tournament is off
       When I navigate to the edit tournament page for rax
       Then I should not see content "Edit Tournament"
