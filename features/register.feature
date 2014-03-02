
Feature: Preregister for Tournament
  As a web user
  I want to pre-register someone for a tournament
  So that they can play in it

  Scenario: Navigate to Tournament Registration Page
    Given a tournament exists:
        | slug | name                       | location     | event_date | short_description                                              |
        | rax  | Rackspace Chess Tournament | Rackspace    | 2013-10-26 | One-day scholastic tournament with rated and unrated sections. |
      And registration for the tournament is on
     When I navigate to "/tournaments/rax"
      And I click the "Register" link
     Then I should see content matching
        | Register to Play |
        | Rackspace Chess Tournament |
        | 2013-10-26 |
        | Desired Section |

  Scenario: Can't Navigate to Tournament Registration Page if Registrations are Off
    Given a tournament exists:
        | slug | name                       | location     | event_date | short_description                                              |
        | rax  | Rackspace Chess Tournament | Rackspace    | 2013-10-26 | One-day scholastic tournament with rated and unrated sections. |
      And registration for the tournament is off
     When I navigate to "/tournaments/rax"
     Then there is no "Register" link or button

  Scenario:  Register for a Rated Section with USCF ID
  Given a tournament exists:
      | slug | name                       | location     | event_date | short_description                                              |
      | rax  | Rackspace Chess Tournament | Rackspace    | 2013-10-26 | One-day scholastic tournament with rated and unrated sections. |
    And the tournament has sections:
      | Primary Rated Open         |
      | Elementary Rated Open      |
      | Elementary Rated JV        |
    And registration for the tournament is on
    And player Gata Kamsky does not exist
   When I navigate to "/tournaments/rax/registrations/new"
    And I select "Primary Rated Open" for registration section
    And I enter the following:
      | registration first name      | Gata                   |
      | registration last name       | Kamsky                 |
      | registration school          | Hard Knocks Elementary |
      | registration uscf member id  | 12528459               |
      | select: registration grade   | 2                      |
      | select: registration gender  | M                      |
    And I click the "Submit" button
   Then a registration should exist for Gata Kamsky in the "Primary Rated Open" section for tournament rax
    And player Gata Kamsky should exist
    And I should see content "preregistered in the "Primary Rated Open" section of Rackspace Chess Tournament"

  Scenario:  Register for a Rated Section without USCF ID
  Given a tournament exists:
      | slug | name                       | location     | event_date | short_description                                              |
      | rax  | Rackspace Chess Tournament | Rackspace    | 2013-10-26 | One-day scholastic tournament with rated and unrated sections. |
    And the tournament has sections:
      | Primary Rated Open         |
      | Elementary Rated Open      |
      | Elementary Rated JV        |
    And registration for the tournament is on
    And player Gata Kamsky does not exist
   When I navigate to "/tournaments/rax/registrations/new"
    And I select "Primary Rated Open" for registration section
    And I enter the following:
      | registration first name      | Gata                   |
      | registration last name       | Kamsky                 |
      | registration school          | Hard Knocks Elementary |
      | select: registration grade   | 2                      |
      | select: registration gender  | M                      |
      | select: registration date of birth 1i  | 2006         |
      | select: registration date of birth 2i  | March        |
      | select: registration date of birth 3i  | 28           |
      | registration address         | 101 Checkmate Ln       |
      | registration city            | New York               |
      | registration state           | NY                     |
      | registration zip code        | 12345                  |
    And I click the "Submit" button
   Then a registration should exist for Gata Kamsky in the "Primary Rated Open" section for tournament rax
    And player Gata Kamsky should exist
    And I should see content "preregistered in the "Primary Rated Open" section of Rackspace Chess Tournament"

  Scenario: Register for an Unrated Section
    Given a tournament exists:
      | slug | name                       | location     | event_date | short_description                                              |
      | rax  | Rackspace Chess Tournament | Rackspace    | 2013-10-26 | One-day scholastic tournament with rated and unrated sections. |
    And the tournament has sections:
      | Primary (K-2) Rated Open         |
      | Elementary (K-5) Rated Open      |
      | Primary (K-2) Unrated Open       |
    And registration for the tournament is on
    When I navigate to "/tournaments/rax/registrations/new"
    And I enter the following:
      | select: registration section     | Primary (K-2) Unrated Open |
      | registration first name          | Johny                |
      | registration last name           | Chester              |
      | registration school              | Bishop Elementary    |
      | registration uscf member id      |                      |
      | select: registration grade       | K                    |
      | select: registration gender      | M                    |
    And I click the "Submit" button
    Then a registration should exist for Johny Chester in the "Primary (K-2) Unrated Open" section for tournament rax
    And I should see content "preregistered in the "Primary (K-2) Unrated Open" section of Rackspace Chess Tournament"

  Scenario: Register with Guardian, then Sign Up as Guardian and see player
    Given a tournament exists:
      | slug | name                       | location     | event_date | short_description                                              |
      | rax  | Rackspace Chess Tournament | Rackspace    | 2013-10-26 | One-day scholastic tournament with rated and unrated sections. |
    And the tournament has sections:
      | Primary (K-2) Rated Open         |
      | Elementary (K-5) Rated Open      |
      | Primary (K-2) Unrated Open       |
    And registration for the tournament is on
    When I navigate to "/tournaments/rax/registrations/new"
    And I enter the following:
      | select: registration section       | Primary (K-2) Unrated Open |
      | registration first name            | Johny                |
      | registration last name             | Chester              |
      | registration school                | Bishop Elementary    |
      | select: registration grade         | 2                    |
      | select: registration gender        | M                    |
      | registration guardian emails | mom@example.com, dad@example.com |
    And I click the "Submit" button
   Then I should see content "preregistered"
    And a registration should exist for Johny Chester in the "Primary (K-2) Unrated Open" section for tournament rax
    And player Johny Chester should exist
    And player Johny Chester should have 2 guardians
   When I sign up and login as mom@example.com
    And I navigate to the dashboard page
   Then I should see text "CHESTER, JOHNY"

  Scenario: Select Sections on Registration Form
    Given a tournament exists:
        | slug | name                       | location     | event_date | short_description                                              |
        | rax  | Rackspace Chess Tournament | Rackspace    | 2013-10-26 | One-day scholastic tournament with rated and unrated sections. |
      And the tournament has sections:
        | Primary Rated Open         |
        | Elementary Rated Open      |
        | Elementary Rated JV        |
        | Middle School Rated Open   |
        | High School Rated Open     |
        | Primary Unrated Open       |
        | Elementary Unrated Open    |
        | Elementary Unrated JV      |
        | Middle School Unrated Open |
        | Middle School Unrated JV   |
        | High School Unrated Open   |
        | Novice Unrated             |
      And registration for the tournament is on
     When I navigate to "/tournaments/rax/registrations/new"
      And I select "Elementary Rated Open" for registration section
      And I select "Primary Rated Open" for registration section
      And I select "Elementary Rated JV" for registration section
      And I select "Middle School Rated Open" for registration section
      And I select "High School Rated Open" for registration section
      And I select "Primary Unrated Open" for registration section
      And I select "Elementary Unrated Open" for registration section
      And I select "Elementary Unrated JV" for registration section
      And I select "Middle School Unrated Open" for registration section
      And I select "Middle School Unrated JV" for registration section
      And I select "High School Unrated Open" for registration section
      And I select "Novice Unrated" for registration section
     Then I should see "Novice Unrated" selected for registration section
      And I should not see "High School Unrated Open" selected for registration section

   Scenario: Register for a Section with a Quota that is not Full
    Given a tournament exists:
        | slug | name                       | location     | event_date | short_description                                              |
        | rax  | Rackspace Chess Tournament | Rackspace    | 2013-10-26 | One-day scholastic tournament with rated and unrated sections. |
      And the tournament has sections:
        | Primary Rated Open         |
      And registration for the tournament is on
      And the quota for section "Primary Rated Open" is 30
      And no registrations exist for the tournament
     When I navigate to "/tournaments/rax/registrations/new"
      And I select "Primary Rated Open" for registration_section
      And I enter the following:
        | registration first name      | Gata                   |
        | registration last name       | Kamsky                 |
        | registration school          | Hard Knocks Elementary |
        | registration uscf member id  | 12528459               |
        | select: registration grade   | 2                      |
        | select: registration gender  | M                    |
      And I click the "Submit" button
     Then a registration should exist for Gata Kamsky in the "Primary Rated Open" section for tournament rax
      And I should see content "preregistered in the "Primary Rated Open" section of Rackspace Chess Tournament"

  Scenario: Register for a Section with a Quota that is Full
    Given a tournament exists:
      | slug | name                       | location     | event_date | short_description                                              |
      | rax  | Rackspace Chess Tournament | Rackspace    | 2013-10-26 | One-day scholastic tournament with rated and unrated sections. |
    And the tournament has sections:
      | Primary Rated Open         |
    And registration for the tournament is on
    And the quota for section "Primary Rated Open" is 0
    And no registrations exist for the tournament
    When I navigate to "/tournaments/rax/registrations/new"
    And I select "Primary Rated Open" for registration_section
    And I enter the following:
      | registration first name      | Gata                   |
      | registration last name       | Kamsky                 |
      | registration school          | Hard Knocks Elementary |
      | registration uscf member id  | 12528459               |
      | select: registration grade   | 2                      |
      | select: registration gender  | M                      |
    And I click the "Submit" button
    Then a registration should exist for Gata Kamsky in the "Primary Rated Open" section for tournament rax
    And I should see content "SECTION FULL!! GATA KAMSKY is on the waiting list in the "Primary Rated Open" section of Rackspace Chess Tournament"
