Edflix README

Introduction
    Welcome to our website! This platform is designed to provide users with a wide range of courses and a seamless learning experience. Users can explore courses, enroll in them, and interact with other learners. The website includes features such as user registration, course management, and administrative functionalities for admins, moderators, and managers.

Features
    Homepage: Provides basic information about the website and showcases courses listed from most upvotes to least upvotes.
    User Registration: Users can sign up by providing their username, email, password, and indicating whether they are a trusted course provider.
    Login: Registered users can log in with their credentials.
    Password Recovery: If a user forgets their password, they can request a one-time-use password "via email"* to change their password.
    User Dashboard: Upon logging in, users are directed to their personal dashboard, where they can view and update their details and track their course progress.
    Courses Page: Users can explore courses, enroll in them, and upvote or downvote courses they find helpful or relevant.
    Admin, Moderator, and Manager Dashboards: Users with admin, moderator, or manager roles have access to unique dashboards with additional functionalities based on their roles.
        Admins: Can edit user details, including the ability to suspend user accounts.
        Moderators: Can review and manage suggested courses from the Contact Us page.
        Managers: Have access to filtered reports on user activities and courses.

Technologies Used
    HTML5 and CSS3: Front-end development.
    Ruby and Sinatra: Back-end development and routing.
    SQLite3: Database for storing user and course information.
    RSpec: Testing tool for automated testing of the application.


File Structure
    app.rb: Ruby file containing the server-side code and route handling.
    controllers/: Directory containing .rb files that handle interactions between models and view.
    models/: Directory containing classes that interact with the database.
    spec/: Directory containing testing files (RSpec and end to end).
    views/: Directory containing HTML templates for different pages.
    public/: Directory for static files such as CSS stylesheets and JavaScript files.
    db/: Directory containing the SQLite3 database files and migration scripts.

License
    This project is licensed under the MIT License.

Contact
    If you have any questions, suggestions, or concerns regarding the website, please contact us via the contact us form on the website.

How to run Program
    Step 1: Clone the git repository into Codio
    Step 2: Enter the “project” directory
    Step 3: Type “bundle install” into the terminal to install the gems
    Step 4: In the terminal type “sinatra” to run the program.



* As codio email sending is buggy, users will instead be shown an example email containing their one time password.