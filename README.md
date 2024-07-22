#### Project Introduction
This app was created with restaurant workers in mind, but applies to any tip-based job. One thing I always struggled with as a waitress & bartender was keeping track of my tips for each job I had. I sometimes had 2 or 3 tip-based jobs at a time, and it would have been helpful to have a digital way to track my tips so that I could see which restaurants and which shifts were most profitable.

For the naming, I opted to use workplace instead of restaurant. I felt that the former was more of an umbrella term, and I wanted the program to be applicable for any tip-based job or “side-hustle”.

To keep the shifts consistent, I decided to limit it to Morning, Afternoon, and Night. This structure aligns with jobs of all kinds, and the separation makes it possible to keep track of which types of shifts make the most money.



#### Future Features
1. Add a dashboard of sorts that displays a "Shift Summary" with the most profitable day of the week and shift type
2. Incorporate a `users` table with `user_id` to allow only user-specific data to be displayed when logged in; also allow users to create a unique username and password which will be added to `users.yml`
3. Display a Monthly, Yearly, and Estimated Tax total along with the Total Tips
4. Allow the user to set a savings goal
5. Allow the user to toggle the the list of workplaces and shifts by the tip amount, allowing them to see the highest or lowest earning at the top



#### Instructions
1. Download and extract `tip_income_project`
2. `cd` into `tip_income_project`
3. Run `bundle install` to install necessary gems and dependencies
4. Run `createdb tips` to create the database needed by the application
5. Run `psql -d tips < schema.sql` to create the schema and import the seed data
6. Run `bundle exec ruby tip_tracker.rb`
7. Open a browser window and visit `localhost:4567`
8. Login to the app using the username `admin` and the password `password`.
