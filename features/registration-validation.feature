
Feature: Registration Validation
  As the application administrator
  I want to validate input from the registration form
  So that data quality and security is maximized and users get good feedback about errors

  Background:
    Given a tournament exists:
      | slug | name                       | location  | event_date | rating_type  | short_description                                              |
      | rax  | Rackspace Chess Tournament | Rackspace | 2013-10-26 | regular-live | One-day scholastic tournament with rated and unrated sections. |
    And the tournament has sections:
      | Primary (K-3) Rated Open         |
      | Elementary (K-5) Rated Open      |
      | Elementary (K-5) Rated U400      |
      | Middle School (K-8) Rated Open   |
      | High School (K-12) Rated Open    |
      | Primary (K-3) Unrated Open       |
      | Elementary (K-5) Unrated Open    |
      | Elementary (K-5) Unrated JV      |
      | Middle School (K-8) Unrated Open |
      | Middle School (K-8) Unrated JV   |
      | High School (K-12) Unrated Open  |
      | Novice (K-12) Unrated            |
    And registration for the tournament is on
    When I navigate to "/tournaments/rax/registrations/new"

  Scenario: Missing Registration Fields
    Then Submitting registration form data as follows should give the expected message:
      | select: section        | first_name | last_name | school | select: grade | select: gender | expected_message                  |
      |                        | Magnus     | Carlson   | PS71   | 10            | M              | Section can't be blank            |
      | Novice (K-12) Unrated  |            | Carlson   | PS71   | 10            | F              | First name can't be blank         |
      | Novice (K-12) Unrated  | Magnus     |           | PS71   | 10            | M              | Last name can't be blank          |
      | Novice (K-12) Unrated  | Magnus     | Carlson   |        | 10            | M              | School can't be blank             |
      | Novice (K-12) Unrated  | Magnus     | Carlson   | PS71   |               | M              | Grade is not included in the list |
      | Novice (K-12) Unrated  | Magnus     | Carlson   | PS71   | 10            |                | Gender is not included in the list |

  Scenario: Registration Fields Too Long: first name
    When I select "Primary (K-3) Rated Open" for registration_section
    And I enter the following:
      | registration first name      | 12345678901234567890123456789012345678901 |
      | registration last name       | Carlsen                                   |
      | registration school          | Hard Knocks Elementary                    |
    And I select "2" for registration grade
    And I click the "Submit" button
    Then I should see content "First name is too long (maximum is 40 characters)"

  Scenario: Registration Fields Too Long: last name
    When I select "Primary (K-3) Rated Open" for registration_section
    And I enter the following:
      | registration first name      | Magnus                                    |
      | registration last name       | 12345678901234567890123456789012345678901 |
      | registration school          | Hard Knocks Elementary                    |
    And I select "2" for registration grade
    And I click the "Submit" button
    Then I should see content "Last name is too long (maximum is 40 characters)"

  Scenario: Registration Fields Too Long: school
    When I select "Primary (K-3) Rated Open" for registration_section
    And I enter the following:
      | registration first name      | Magnus                                    |
      | registration last name       | Carlsen                                   |
      | registration school          | 123456789012345678901234567890123456789012345678901234567890123456789012345678901 |
    And I select "2" for registration grade
    And I click the "Submit" button
    Then I should see content "School is too long (maximum is 80 characters)"

  Scenario: Registration Fields Misformatted: uscf member id
    When I select "Primary (K-3) Rated Open" for registration_section
    And I enter the following:
      | registration first name      | Magnus             |
      | registration last name       | Carlsen            |
      | registration school          | Langley Elementary |
      | registration uscf member id  | 123456789          |
    And I select "2" for registration grade
    And I click the "Submit" button
    Then I should see content "Uscf member id must be 8 digits"

  Scenario: Grade Ineligible for Section
    Then Submitting registration form data as follows should give the expected message:
      | select: section                | first_name | last_name | school | select: grade | expected_message           |
      | Primary (K-3) Rated Open       | Magnus     | Carlson   | PS71   | 4             | Grade Too High for Section |
      | Elementary (K-5) Rated U400    | Magnus     | Carlson   | PS71   | 10            | Grade Too High for Section |
      | Middle School (K-8) Unrated JV | Magnus     | Carlson   | PS71   | 9             | Grade Too High for Section |

  Scenario: Rating Ineligible for Section
    When I select "Elementary (K-5) Rated U400" for registration_section
     And I enter the following:
       | registration first name      | Jackson   |
       | registration last name       | Taylor    |
       | registration school          | Blattman  |
       | registration uscf member id  | 15127606  |
     And I select "2" for registration grade
     And I select "M" for registration gender
     And I click the "Submit" button
    Then I should see content "Rating Too High for Section"

  Scenario: Allow Live Rating for Section
    And these players exist:
      | first_name | last_name | school   | uscf_id   | grade | gender | rating | live_rating |
      | Adam       | Ant       | Blattman | 87654321  | 1     | M      | 390    | 410         |
    When I select "Elementary (K-5) Rated U400" for registration_section
    And I enter the following:
      | registration first name      | Adam      |
      | registration last name       | Ant       |
      | registration school          | Blattman  |
      | registration uscf member id  | 87654321  |
    And I select "2" for Grade
    And I select "M" for Gender
    And I click the "Submit" button
    Then I should see content "Rating Too High for Section"

  Scenario: Rated Section Requires USCF ID or Address
    When I select "Elementary (K-5) Rated U400" for registration_section
    And I enter the following:
      | registration first name      | Adam      |
      | registration last name       | Ant       |
      | registration school          | Blattman  |
    And I select "2" for Grade
    And I select "M" for Gender
    And I click the "Submit" button
   And I should not see content "preregistered in the "Elementary (K-5) Rated U400" section of Rackspace Chess Tournament"

  Scenario: Rated Section Requires USCF ID or DOB+Address
    When I select "Elementary (K-5) Rated U400" for registration_section
    And I enter the following:
      | registration first name      | Adam      |
      | registration last name       | Ant       |
      | registration school          | Blattman  |
      | select: registration date of birth 1i  | 2006         |
      | select: registration date of birth 2i  | March        |
      | select: registration date of birth 3i  | 28           |
    And I select "2" for Grade
    And I select "M" for Gender
    And I click the "Submit" button
    And I should see content "both date of birth and address"
    And I should not see content "preregistered in the "Elementary (K-5) Rated U400" section of Rackspace Chess Tournament"

  Scenario: Rated Section Requires USCF ID or Address
    When I select "Elementary (K-5) Rated U400" for registration_section
    And I enter the following:
      | registration first name      | Adam      |
      | registration last name       | Ant       |
      | registration school          | Blattman  |
      | select: registration date of birth 1i  | 2006         |
      | select: registration date of birth 2i  | March        |
      | select: registration date of birth 3i  | 28           |
      | registration address         | 1 Meg Dr  |
      | registration city            | Lubbock   |
      | registration state           | TX        |
      | registration zip_code        | 98123     |
    And I select "2" for Grade
    And I select "M" for Gender
    And I click the "Submit" button
    And I should see content "preregistered in the "Elementary (K-5) Rated U400" section of Rackspace Chess Tournament"
