
Feature: Manage Tournament Fliers
  As the application administrator
  I want to manage tournament flier documents
  So that the scholastic chess community can see web and printable views of tournament details


  Scenario: Upload flier from local asciidoc file
  Given a tournament exists:
      | slug | name                       | location     | event_date | short_description                                              |
      | rax  | Rackspace Chess Tournament | Rackspace    | 2013-10-26 | One-day scholastic tournament with rated and unrated sections. |
    And a file rax_flier exists relative to the current working directory with content matching file test/content/rax_flier.asciidoc
   When I run `pawn tournament flier --file rax_flier rax`
   Then the output should contain "uploaded description for tournament rax from rax_flier"

  Scenario: Upload flier from asciidoc file via URI
  Given a tournament exists:
      | slug | name                       | location     | event_date | short_description                                              |
      | rax  | Rackspace Chess Tournament | Rackspace    | 2013-10-26 | One-day scholastic tournament with rated and unrated sections. |
    And a file rax_flier exists relative to the current working directory with content matching file test/content/rax_flier.asciidoc
   When I run `pawn tournament flier rax --uri https://raw.github.com/wiki/bwtaylor/pawn-parade/Sample-Flier-AsciiDoc.asciidoc`
    And I navigate to "/tournaments/rax"
   Then I should see content matching
      | Rackspace Fall 2013 Scholastic Chess Tournament |
      | Free Entry!!! Free Food!!! |
      | Elementary (K-5) Rated JV |
      | All games are G/25, d5. |