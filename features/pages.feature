Feature: Dynamic Content on Schedule
  As an admin
  I want to embed dynamic wiki content on the schedule page
  So that I can update it easily


  Scenario: See the list of schedules
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

  Scenario: Dynamic Page content not required with schedule
    Given The existing schedules are:
      | slug        | name          |
      | san_antonio | San Antonio   |
      And schedule san_antonio has no associated page
     When I navigate to the schedule page for san_antonio
     Then I should see content matching
      | Chess Schedule: San Antonio |

    @needs_internet
  Scenario: Schedule Dynamic Page Can reload and renders
    Given The existing schedules are:
      | slug        | name          |
      | san_antonio | San Antonio   |
      And schedule san_antonio has the associated page:
      | syntax   | source |
      | asciidoc | https://raw.githubusercontent.com/wiki/bwtaylor/chessflyers/Test.asciidoc |
     When I reload the page for schedule san_antonio
      And I navigate to the schedule page for san_antonio
     Then I should see content matching
      | happy12345happy67890 |