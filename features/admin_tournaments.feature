Feature: Browse Tournament
  As an admin
  I want to browse the list of tournaments
  So that I can navigate quickly to the various pages related to them

  Scenario: Admin can view the administrate tournaments page
      Given I have an authenticated admin session
       When I navigate to the dashboard page
        And I click the "View Tournaments" link
       Then I should see content "Administrate Tournaments"

  Scenario: Non-Admin cannot view the adminstrate tournaments page
      Given I have an authenticated session
       When I navigate to the dashboard page
       Then I should not see content "View Tournaments"
       When I navigate to the tournaments page
       Then I should not see content "Administrate Tournaments"
  @wip
  Scenario: Admin can view section email list
      Given I have an authenticated admin session
        And a tournament exists:
            | slug | name                       | location  | event_date | rating_type | short_description             |
            | rax  | Rackspace Chess Tournament | Rackspace | 2013-10-26 | regular     | One-day scholastic tournament |
        And team North exists with slug north
        And bob@sacastle.org manages North
        And the north team has players:
            | first_name | last_name | uscf_id   | grade | gender |
            | Adam       | Ant       | 00003033  | 1     | M      |
        And the tournament has sections:
            | section1 |
            | section2 |
        And registration for the tournament is on
        And the following players have registered for the tournament:
            | first_name | last_name | uscf_id  | grade | gender | school | section  | guardian_emails |
            | Adam       | Ant       | 00003033 | 1     | M      | North  | section1 | dad@ant.com     |
            | Betty      | Boop      | 00003044 | 2     | F      | South  | section1 | joe@boop.com    |
            | Charlie    | Chan      | 00003055 | 4     | M      | South  | section2 | mom@chan.com    |
       When I navigate to the email page for section1
       Then I should see content matching
            | dad@ant.com      |
            | joe@boop.com     |
            | bob@sacastle.org |
        And I should not see content "mom@chan.com"


