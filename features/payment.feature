Feature: Dynamic Content on Schedule
  As an tournament or event organizer
  I want to manage registration cost and amount due
  So that I can determine which registrations are paid and which are not

  Scenario: Registration for Free Tournaments/Events doesn't show payment information
    Given a tournament exists:
      | slug | name                       | location  | event_date | short_description                                              |
      | rax  | Rackspace Chess Tournament | Rackspace | 2016-10-26 | One-day scholastic tournament with rated and unrated sections. |
    And registration for the tournament is on
    And user dad@example.com exists with password "password"
    And I authenticate as dad@example.com

  Scenario: Registration for Free Tournaments/Events doesn't show payment information
    Given I have an authenticated session as "dad@example.com"
    And these players exist:
      | first_name | last_name | school | uscf_id   | grade | gender | guardians |
      | Adam       | Ant       | West   | 00005678  | 1     | M      | mom@example.com dad@example.com |
      | Art        | Ant       | West   |           | 2     | M      | dad@example.com                 |
      | Alice      | Ant       | West   |           | 2     | M      | mom@example.com                 |
    And a tournament exists:
      | slug | name                       | location     | event_date | fee | short_description                                              |
      | rax  | Rackspace Chess Tournament | Rackspace    | 2015-10-26 |  0  | One-day scholastic tournament with rated and unrated sections. |
    And the date is "2013-7-7"
    And registration for the tournament is on
    When I navigate to the dashboard page
    And I click on the "Register Players" link
    Then I should see content matching
      | Register for Rackspace Chess Tournament |
      | ANT, ADAM                               |
      | ANT, ART                                |
    And I should not see content "ANT, ALICE"
    And I should not see content "Fee"
    And I should not see content "Paid"

  Scenario: Registration for Tournaments with Fee Displays payment information
    Given I have an authenticated session as "dad@example.com"
    And these players exist:
      | first_name | last_name | school | uscf_id   | grade | gender | guardians |
      | Adam       | Ant       | West   | 00005678  | 1     | M      | mom@example.com dad@example.com |
      | Art        | Ant       | West   |           | 2     | M      | dad@example.com                 |
      | Alice      | Ant       | West   |           | 2     | M      | mom@example.com                 |
    And a tournament exists:
      | slug | name                       | location     | event_date | fee  | short_description                                              |
      | rax  | Rackspace Chess Tournament | Rackspace    | 2013-10-26 | 8.00 | One-day scholastic tournament with rated and unrated sections. |
    And the date is "2013-7-7"
    And registration for the tournament is on
    When I navigate to the dashboard page
    And I click on the "Register Players" link
    Then I should see content matching
      | Register for Rackspace Chess Tournament |
      | Fee                                     |
      | Paid                                    |
      | ANT, ADAM                               |
      | ANT, ART                                |
    And I should not see content "ANT, ALICE"

  Scenario: Registration shows amount due, amount paid, and payment method
    Given The existing schedules are:
      | slug        | name          |
      | san_antonio | San Antonio   |
      | austin      | Austin        |
      | nisd_tx     | Northside ISD |
    When I navigate to "/schedules"
    Then I should see the schedules table matching
      | Schedule      |
      | Austin        |
      | Northside ISD |
      | San Antonio   |
