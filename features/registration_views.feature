Feature: Registration Summary
  As a tournament organizer
  I want to see sections, players, and counts for a tournament
  So that I can manage the event
  

Background:
  Given a tournament exists:
      | slug | name                       | location  | event_date | rating_type  | short_description                                              |
      | rax  | Rackspace Chess Tournament | Rackspace | 2013-10-26 | regular-live | One-day scholastic tournament with rated and unrated sections. |
    And the tournament has sections:
      | Primary (K-3) Rated Open    |
      | Elementary (K-5) Rated Open |
    And registration for the tournament is on
    And the following players have registered for the tournament:
      | first_name | last_name | uscf_id  | grade | gender | school | section                  |
      | Adam       | Ant       | 00003033 | 1     | M      | North  | Primary (K-3) Rated Open |
      | Betty      | Boop      | 00003044 | 2     | F      | South  | Primary (K-3) Rated Open |
      | Charlie    | Chan      | 00003055 | 4     | M      | South  | Elementary (K-5) Rated Open |

Scenario: Tournament & Section Counts
  When I navigate to the registration status page for the tournament
  Then I should see content "Registrations for Rackspace Chess Tournament [3 players]"
   And I should see content "Section: Primary (K-3) Rated Open [2 players]"
   And I should see content "Section: Elementary (K-5) Rated Open [1 players]"

  Scenario: Withdraws Not Counted
  When Betty Boop withdraws from the tournament
   And I navigate to the registration status page for the tournament
  Then I should see content "Registrations for Rackspace Chess Tournament [2 players]"
    And I should see content "Section: Primary (K-3) Rated Open [1 players]"
    And I should see content "Section: Elementary (K-5) Rated Open [1 players]"

  Scenario: Withdraws, Duplicates, and Spam Not Show
    And the following players have registered for the tournament:
      | first_name | last_name | uscf_id  | grade | gender | school | section                  | status    |
      | Adam       | Ant       | 00003304 | 1     | M      | North  | Primary (K-3) Rated Open | duplicate |
      | Spamo      | Spammer   | 00003305 | 2     | F      | South  | Primary (K-3) Rated Open | spam      |
    And Betty Boop withdraws from the tournament
    And I navigate to the registration status page for the tournament
   Then I should see content "Registrations for Rackspace Chess Tournament [2 players]"
    And I should not see content "duplicate"
    And I should not see content "spam"
    And I should not see content "withdraw"