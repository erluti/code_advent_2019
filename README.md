My work for [Advent of Code 2019](https://adventofcode.com/2019)

This is the first time I've ever done Advent of Code.  My strategy is to get to a solution quickly.  So I'm trying to keep the code contained in one file.  Normally I would make a pass at the code to make it much cleaner before "going to production", but once a solution is found there's not much need to go back.  My tests are taken from the examples in the prompts, so shoring up those tests would be one of the main things I did before being content with the code.

Day2 mentioned reusing the work there, so when that happens, I'll probably do some refactoring and possibly restructuring of this repo.

----

Day9: After all the work I put into refactoring day7 to support threading IntcodePrograms for ProgramSeries, I decided I would restructure the repo a little.  Still doing a `dayX.rb` for each day to solve the problem.  But I've created the directory `intcode` to iterate on the IntcodeProgram.  The specs for each component are a lot messier than I would typically design, but they are mostly based on the example provided.

----

Day14: My solution didn't work and the busyness of the holidays overtook me.  I'm still going to try to finish, but at this point I'm content with just the first star for part 1.  I'm still glad to have worked on these, but getting behind makes it less fun and more of a chore. ¯\_(ツ)_/¯
