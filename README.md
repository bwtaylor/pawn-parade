# Pawn Parade

This is an application to manage chess leagues and tournaments.

## Vision

This app exists to help anyone organize a chess league. This especially includes scholastic chess leagues, where a league might be formed within one or more school districts. League administrators can keep league play rules and a tournament schedule. Coaches can manage their team rosters. Tournament directors within the league can publish tournament announcements onto a schedule. Coaches can coordinate with players or their parent/guardian and manage tournament preregistration, eliminating a barage of paper flyers and emails. 

Tournament directors will have an easier time getting the roster of people together to enter into the chess pairings. They can also publish the official results. League administrators can run a "grand prix" where awards are given for results across a season.

## Status

Basically vaporware. The first feature, browsing a schedule of tournaments exists, but there's no way to create a tournament yet through the app, and no real work has been done on the layout and style.

We just got started. The good news is that this project was born free under a GPL'd open source license. The bad news is that it's still a newborn. We'll be adding features as we go, and intend have a very tight release cycle. 

## Development Methodology

We intend this project to be run using the best practices of software development. In summer of 2013, this means open source, holistic devops, continuous integration / continuous delivery, 100% test driven development using a behavior driven development approach.

## How to Contribute

Fork. Code. Pull Request.

Pull requests that don't respect the rigorous test and behavior driven development paradigm will be be rejected. This means: write the feature file first, then steps, then iterate through each failing step implementing only the absolute minimum functionality to meet the step, with rspec tests as appropriate.

Features files should be socialized before writing code to make them pass. Recommended practice is to mark them with the @wip tag and work in a feature branch in your local repository. When they pass, rebase and squash them against master and merge them into master, so that the feature appears as a single commit when pulled. 

All code is GPL version 2. See the LICENSE file in the root of the source directory. We do NOT expect you to assign your copyright to us for your contributions. If you send us pull requests, then you have modified our copyrighted work and  have distributed a derivitive of our work to Github. That is copyright infringement unless you have a license, and the GPL is the only option. Therefore, a pull request indicates  to us that you abide by the GPL. If you work for an organization with an ownership claim to code you write, you must follow their procedures for contributing under the GPL. 
