Jar files in /code/ are dependencies. They are pushed to the git repo for sake of convencience.

When you are pushing to this repo, the order of operations should be: Create a branch -> Commit and develop feature -> create PR -> make changes based on other members comments -> merge branch with main.

See: https://www.freecodecamp.org/news/guide-to-git-github-for-beginners-and-experienced-devs/

# Setup Guide
After cloning the repo, some of the CSV files needed to make this program work may be missing, in particular those in airport_tables.

If this is the case:
1. Ensure Processing is closed as sometimes it will undo changes people make in the file system
2. Download the CSV files off of blackboard
3. Add them to `/data/`, ensuring they are named in the form `flights_full.csv` or `flights2k.csv`
4. Try and run it again, it should now work.
