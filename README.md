My work for [Advent of Code 2019](https://adventofcode.com/2019)

This is the first time I've ever done Advent of Code.  My strategy is to get to a solution quickly.  So I'm trying to keep the code contained in one file.  Normally I would make a pass at the code to make it much cleaner before "going to production", but once a solution is found there's not much need to go back.  My tests are taken from the examples in the prompts, so shoring up those tests would be one of the main things I did before being content with the code.

Day2 mentioned reusing the work there, so when that happens, I'll probably do some refactoring and possibly restructuring of this repo.

----

Day9: After all the work I put into refactoring day7 to support threading IntcodePrograms for ProgramSeries, I decided I would restructure the repo a little.  Still doing a `dayX.rb` for each day to solve the problem.  But I've created the directory `intcode` to iterate on the IntcodeProgram.  The specs for each component are a lot messier than I would typically design, but they are mostly based on the example provided.

----

Day14: My solution didn't work and the busyness of the holidays overtook me.  I'm still going to try to finish, but at this point I'm content with just the first star for part 1.  I'm still glad to have worked on these, but getting behind makes it less fun and more of a chore. ¯\\\_(ツ)\_/¯

Figured I'd try Part 2 of this one, and it looks like it's taking about 1 second to get 100 FUEL, and dividing a trillion by the required fuel, I'm guess the result is around 1.7 million, which makes my algorithm take over 4.5 hours.  So  this is what I'm checking in, and we'll see if this doesn't interfere with my life so I can let it produce an answer. (I'm actually letting it run in two separate console tabs, one is running where it prints a `.` every 1000 fuel, and the other is running what's here.  I figured getting larger amounts of fuel at a time will reduce the amount of going up and down the call stack and be a little quicker, but going one at a time I'm more confident won't fail as it approaches the answer.  The chunked version is being checked in.)

----

Day15: After trying to be clever, I decided I'd create a bunch of random inputs until I got one that lead me to the oxygen, then I'd have a map to work from.  It was a good maze and the solution wasn't easily written by hand, so I figured I'd stick to programming and optimize my random results.  So I output my random results to use a source that I can test and then optimize.  After thinking through a bunch of possible optimizations, I realized the best (and ultimately only-needed) one was to find where my inputs returned to the same position, and delete those intervening instructions since those were unnecessary moves.  Once I got it debugged, it worked like a charm!

Looking at Part 2 I realized that I would need a better mapping algorithm than random input to find the entire map.  So I think I'll punt on Part 2.

The biggest challenge was I didn't use any of my expertise as a Software Engineer, instead thinking I could quickly solve it without making smart classes and tests.  Everytime I thought "I should make this an object" and I decided I was too cool and said "Well, this one tweak will make it work."  But then I ended up spending way longer on this than I wanted when I could have quickly solved this by tweaking well-tested methods.  So I'm going to not try to be too clever when I do Day 16, and be better with my best practices.