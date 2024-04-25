classdef Main_game_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                 matlab.ui.Figure
        CapitalsOfTheWorldLabel  matlab.ui.control.Label
        StartButton              matlab.ui.control.Button
        CloseButton              matlab.ui.control.Button
        MusicOnButton            matlab.ui.control.Button
        PauseButton              matlab.ui.control.Button
        ComputerLabel_2          matlab.ui.control.Label
        UserLabel_2              matlab.ui.control.Label
        UserLabel                matlab.ui.control.Label
        ComputerLabel            matlab.ui.control.Label
        MediumModeLabel          matlab.ui.control.Label
        HardButton               matlab.ui.control.Button
        MediumButton             matlab.ui.control.Button
        EasyButton               matlab.ui.control.Button
        TimeLabel                matlab.ui.control.Label
        Player2Gauge             matlab.ui.control.Gauge
        ResetButton              matlab.ui.control.Button
        Player2Lamp              matlab.ui.control.Lamp
        Player1Gauge             matlab.ui.control.Gauge
        Player1Lamp              matlab.ui.control.Lamp
        CountryLabel             matlab.ui.control.Label
        Instructions             matlab.ui.control.Label
        OceaniaButton            matlab.ui.control.Button
        AsiaButton               matlab.ui.control.Button
        EuropeButton             matlab.ui.control.Button
        NorthAmericaButton       matlab.ui.control.Button
        SouthAmericaButton       matlab.ui.control.Button
        AfricaButton             matlab.ui.control.Button
        Answer3Button            matlab.ui.control.Button
        Answer4Button            matlab.ui.control.Button
        Answer2Button            matlab.ui.control.Button
        Answer1Button            matlab.ui.control.Button
        Image                    matlab.ui.control.Image
    end

    
    properties (Access = private)
        answerLocation % Correct answer location 

        % Determining questions & answers 
        correctAnswer
        correctQuestion 
        incorrectAnswers
        numCountries % Number of countries

        % Countries/capitals arrays
        countriesAsia
        countriesOceania
        countriesEurope
        countriesAfrica
        countriesSAmerica
        countriesNAmerica
        capitalsAsia
        capitalsOceania
        capitalsEurope
        capitalsAfrica
        capitalsSAmerica
        capitalsNAmerica

        state = 0;% Button pushed -> continent
        stateComputer = 1; % State of the computer player
        scoreUser = 0; % Score of the user
        scoreComputer = 0; % Score of the computer player
        t % Timer
        time = 0; % Time variable
        tDifference=0; % Time difference
        tStamp=0; % Time stamp
        timeAnswer % Time to answer
        rNum % Random number to determine true/false of the computer player answer
        probability=0.4; % Computer player answer probability (1-probability)
        min=2; % Min time to answer
        max=4; % Max time to answer

        % Indexing into countries/capitals arrays
        correctIndex 
        correctOrder
        possibleIndices
        incorrectIndices

        answerButton % Clicked answer button
        countdown = [10 9 8 7 6 5 4 3 2 1 0]; % Countdown array
        timeLabel % Shown to the user
        counter = 1; % Indexing through countdown array
        modeState = 1; % Easy, Medium & Hard modes
        previousMode = 1; 
        transitionState = 0; % Changing/not chaning modes state
        pauseCounter = 0; % Counting pause/play button pushes
        musicCounter = 0; % Counting music button pushes

        % Audio/music files
        music
        file_path
        audio_data 
        sample_rate
        file_path2
        audio_data2
        sample_rate2
        file_path3
        audio_data3
        sample_rate3
        file_path4
        audio_data4
        sample_rate4
        file_path5
        audio_data5
        sample_rate5
        youwin
        youlose
        correct
        incorrect

    end
    
    methods (Access = private)
        
        function answer(app)

            % Location of the correct answer
            if app.answerLocation == 1
                app.Answer1Button.Text = app.correctAnswer;
                app.Answer2Button.Text = app.incorrectAnswers(1);
                app.Answer3Button.Text = app.incorrectAnswers(2);
                app.Answer4Button.Text = app.incorrectAnswers(3);
            elseif app.answerLocation == 2
                app.Answer1Button.Text = app.incorrectAnswers(1);
                app.Answer2Button.Text = app.correctAnswer;
                app.Answer3Button.Text = app.incorrectAnswers(2);
                app.Answer4Button.Text = app.incorrectAnswers(3);
            elseif app.answerLocation == 3
                app.Answer1Button.Text = app.incorrectAnswers(1);
                app.Answer2Button.Text = app.incorrectAnswers(2);
                app.Answer3Button.Text = app.correctAnswer;
                app.Answer4Button.Text = app.incorrectAnswers(3);
            else
                app.Answer1Button.Text = app.incorrectAnswers(1);
                app.Answer2Button.Text = app.incorrectAnswers(2);
                app.Answer3Button.Text = app.incorrectAnswers(3);
                app.Answer4Button.Text = app.correctAnswer;
            end
        end
        
        function loopcontinent(app) % Sets up the randomised correct & incorrect answers

            % Determine correct arrays based on the state (continent button pressed)
            if app.state == 1
                countries = app.countriesAsia;
                capitals = app.capitalsAsia;
            elseif app.state == 2
                countries = app.countriesOceania;
                capitals = app.capitalsOceania;
            elseif app.state == 3
                countries = app.countriesEurope;
                capitals = app.capitalsEurope;
            elseif app.state == 4
                countries = app.countriesNAmerica;
                capitals = app.capitalsNAmerica;
            elseif app.state == 5
                countries = app.countriesSAmerica;
                capitals = app.capitalsSAmerica;
            elseif app.state == 6
                countries = app.countriesAfrica;
                capitals = app.capitalsAfrica;
            end

            % Random order
            app.correctOrder = randperm(app.numCountries);
            for i = 1:app.numCountries

                % Set the index for the correct answer based on the correct order predefined in the app
                app.correctIndex = app.correctOrder(i);

                % Set the country question and its correct capital answer using the correct index
                app.correctQuestion = countries{app.correctIndex};  % Country name
                app.correctAnswer = capitals{app.correctIndex}; % Corresponding capital
                
                % Choose 3 random indices as incorrect answers
                % Ensuring that they are unique and do not include the correct index
                app.possibleIndices = setdiff(1:app.numCountries, app.correctIndex); % Exclude the correct index
                app.incorrectIndices = randsample(app.possibleIndices, 3);  % Sample 3 random incorrect indices

                % Get the capital cities for these incorrect answers
                app.incorrectAnswers = capitals(app.incorrectIndices);

                % Randomly select a location (1-4) where the correct answer will be placed among the options
                app.answerLocation = randi([1, 4]);
                app.answer()

                % Display the current country in the user interface
                app.CountryLabel.Text = app.correctQuestion;
            end
        end

        function update(app,~,~)
            if mod(app.musicCounter, 2) == 1 % If counter is odd (music is on)
                if ~isplaying(app.music) % Checks if music is on
                    play(app.music); % Plays music
                end
            end

            % If the app is in the initial state, set the time label to the first element of the countdown array
            if app.state == 0
                app.timeLabel=app.countdown(1);

            % If not in the initial state, update the time label using a counter that progresses through the countdown array
            else
                app.timeLabel=app.countdown(app.counter);
                app.counter = app.counter+1; % Increment the counter for the next time this block runs
            end
            app.time = app.time + 1; % Increment time 
            app.TimeLabel.Text = num2str(app.timeLabel); % Update the on-screen time display

            % Calculate the time difference between the current app time and a timestamp taken when the user presses buttons
            app.tDifference=app.time-app.tStamp;

            % Calculate the difference between the computed time difference and the time to answer, given by the gameplay mode
            diff=app.tDifference-app.timeAnswer;
            if app.stateComputer == 1 % Check if the computer player should answer
                if diff == 1 % Check if enough time has passed to answer
                    player2(app) 
                end
            end
            
            % Depending on the previous & new gameplay mode and mode button pressed, new countdown array is made
            % modeState = 0 for easy, = 1 for medium, = 2 for hard
            if app.modeState == 0 && app.transitionState == 0 % transitionState = 0 means same mode button is pressed as the active mode
                if app.counter == 17 % Checks if user has not answered & calls function
                    userNoanswer(app)
                    app.countdown = [15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0];
                end
            end
            if app.modeState == 1 && app.transitionState == 0
                if app.counter == 12 % Checks if user has not answered & calls function
                    userNoanswer(app)
                    app.countdown = [10 9 8 7 6 5 4 3 2 1 0];
                end
            end
            if app.modeState == 2 && app.transitionState == 0
                if app.counter == 7 % Checks if user has not answered & calls function
                    userNoanswer(app)
                    app.countdown = [5 4 3 2 1 0];
                end
            end

            % previousMode = 0 for easy, = 1 for medium, = 2 for hard
            if app.previousMode == 0 && app.transitionState == 1 % transitionState = 1 means different mode button is pressed as the active mode, hence transition occurs
                if app.counter == 17 % Checks if user has not answered & calls function
                    userNoanswer(app)
                    if app.modeState == 1
                        app.countdown = [10 9 8 7 6 5 4 3 2 1 0];
                        app.transitionState = 0;
                    elseif app.modeState == 2
                        app.countdown = [5 4 3 2 1 0];
                        app.transitionState = 0;
                    elseif app.modeState == 0
                        app.countdown = [15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0];
                        app.transitionState = 0; % No transition state after finishing
                    end
                end
            elseif app.previousMode == 1 && app.transitionState == 1
                if app.counter == 12 % Checks if user has not answered & calls function   
                    userNoanswer(app)
                    if app.modeState == 0
                        app.countdown = [15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0];
                        app.transitionState = 0;
                    elseif app.modeState == 2
                        app.countdown = [5 4 3 2 1 0];
                        app.transitionState = 0;
                    elseif app.modeState == 1
                        app.countdown = [10 9 8 7 6 5 4 3 2 1 0];
                        app.transitionState = 0; % No transition state after finishing
                    end
                end
             elseif app.previousMode == 2 && app.transitionState == 1
                if app.counter == 7 % Checks if user has not answered & calls function   
                    userNoanswer(app)
                    if app.modeState == 2
                        app.countdown = [5 4 3 2 1 0];
                        app.transitionState = 0;
                    elseif app.modeState == 1
                        app.countdown = [10 9 8 7 6 5 4 3 2 1 0];
                        app.transitionState = 0;
                    elseif app.modeState == 0
                        app.countdown = [15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0];
                        app.transitionState = 0; % No transition state after finishing
                    end
                end
             end

        end
        
        function player2(app)

            % Computer player method simulates the computer's turn in the game
            app.rNum=rand; % Generate a random number between 0 and 1

            % Check if the generated number is greater than a set probability threshold
            if app.rNum>app.probability % If true, the computer's answer is correct
                app.Player2Lamp.Color = [0 1 0]; % Set the indicator lamp to green
                app.ComputerLabel_2.Text = "Correct!"; % Display "Correct!"
                app.scoreComputer=app.scoreComputer+1; % Increment the computer's score
                app.Player2Gauge.Value = app.scoreComputer; % Update the gauge to reflect the new score
                play(app.correct); % Play a sound indicating a correct answer
            else % If false, the computer's answer is incorrect, the equivalent is done
                app.Player2Lamp.Color = [1 0 0];
                app.ComputerLabel_2.Text = "Incorrect!";
                app.scoreComputer=app.scoreComputer-1;
                if app.scoreComputer == -1 % Ensure the score does not fall below zero
                    app.scoreComputer = 0;
                end
                app.Player2Gauge.Value = app.scoreComputer;
                play(app.incorrect);
            end

            % Check if the computer has reached the winning score of 20
            if  app.scoreComputer == 20 
                app.Instructions.Text="You Lose!"; % Update instructions text to show loss message
                play(app.youlose) % Play a sound indicating the player has lost
                ending(app) % Call a function to handle game-ending tasks
                app.PauseButton.Enable="off"; % Disable the pause button to prevent further interactions
                stop(app.t) % Stop the running timer
            end
            app.tDifference=0;  % Reset the time difference tracker
            app.tStamp=app.time; % Update the timestamp to the current application time
            app.stateComputer=2; % Set the computer player's state = 2, meaning it should not answer
        end
                
        function userCorrect(app)

            % User makes correct answer, equivalent done as for the computer player
            app.Player1Lamp.Color = [0 1 0];
            app.UserLabel_2.Text = "Correct!";
            app.scoreUser=app.scoreUser+1;
            app.Player1Gauge.Value = app.scoreUser;
            play(app.correct);
        end
        
        function userIncorrect(app)

            % User makes incorrect answer, equivalent done again
            app.Player1Lamp.Color = [1 0 0];
            app.UserLabel_2.Text = "Incorrect!";
            app.scoreUser=app.scoreUser-1;
            if app.scoreUser == -1
                app.scoreUser = 0;
            end
            app.Player1Gauge.Value = app.scoreUser;
            play(app.incorrect);
        end
        
        function ending(app)

            % Ending of the game, disabling computer player and buttons
            app.stateComputer = 2;
            app.AfricaButton.Enable="off";
            app.AsiaButton.Enable="off";
            app.EuropeButton.Enable="off";
            app.SouthAmericaButton.Enable="off";
            app.NorthAmericaButton.Enable="off";
            app.OceaniaButton.Enable="off";
            app.Answer1Button.Enable="off";
            app.Answer2Button.Enable="off";
            app.Answer3Button.Enable="off";
            app.Answer4Button.Enable="off";
            app.EasyButton.Enable="off";
            app.MediumButton.Enable="off";
            app.HardButton.Enable="off";
        end
        
        function buttons(app) % Triggered by pressing the answer buttons
            app.counter = 1; % Resets the counter
            if app.transitionState == 1 % Check if in the transition state.

                % Depending on the current mode state, update the countdown array.
                if app.modeState == 2
                    app.countdown = [5 4 3 2 1 0];
                    app.transitionState = 0;
                elseif app.modeState == 1
                    app.countdown = [10 9 8 7 6 5 4 3 2 1 0];
                    app.transitionState = 0;
                elseif app.modeState == 0
                    app.countdown = [15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0];
                    app.transitionState = 0;
                end
            end

            % Check if the user's answer button matches the correct answer button and call the appropriate method
            if app.answerLocation == app.answerButton
                userCorrect(app)
            else
                userIncorrect(app)
            end

            % Check if the user's score has reached the winning score of 20, equaivalent done as when the computer player wins
            if app.scoreUser == 20
                app.Instructions.Text="You Win!";
                play(app.youwin)
                ending(app)
                app.PauseButton.Enable="off";
                stop(app.t)
            else
                app.tStamp=app.time; % Takes a timestamp
                app.timeAnswer = randi([app.min app.max]); % Randomly set a time for the next answer within given bounds (set by the mode)
                app.stateComputer=1; % Computer player remains in active mode
                loopcontinent(app) % Call the loopcontinent method to continue the game
            end
        end
        
        function userNoanswer(app)
                    % User makes no answer
                    app.counter = 1; % Resets the counter, equivalent done as before
                    app.Player1Lamp.Color = [1 0 0];
                    app.UserLabel_2.Text = "No Answer!";
                    app.scoreUser=app.scoreUser-1;
                    app.Player1Gauge.Value = app.scoreUser;
                    play(app.incorrect)
                    app.tStamp=app.time;
                    app.timeAnswer = randi([app.min app.max]);
                    app.stateComputer=1;
                    loopcontinent(app)
        end
        
        function turnOn(app) % Turns on buttons when needed
            app.Answer1Button.Enable="on";
            app.Answer2Button.Enable="on";
            app.Answer3Button.Enable="on";
            app.Answer4Button.Enable="on";
            app.EasyButton.Enable="on";
            app.MediumButton.Enable="on";
            app.HardButton.Enable="on";
            app.ResetButton.Enable="on";
            app.PauseButton.Enable="on";
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            
            % Create a new timer object and assign it to a property of the app class
            app.t = timer("TimerFcn",@app.update); % TimerFcn specifies the method to call (@app.update)
            app.t.Period = 1; % Set the period of the timer to 1 second
            app.t.ExecutionMode = 'fixedRate'; % Maintains a fixed rate of execution
            start(app.t) % This activates the timer

            % Specify the path to your MP3 file
            app.file_path = 'Music.mp3';

            % Use the audioread function to read the MP3 file
            [app.audio_data, app.sample_rate] = audioread(app.file_path);
            app.music = audioplayer(app.audio_data, app.sample_rate);

            % Equivalent done for the rest of the audios 
            app.file_path2 = 'Correct_sound.mp3';
            [app.audio_data2, app.sample_rate2] = audioread(app.file_path2);
            app.correct = audioplayer(app.audio_data2, app.sample_rate2);
            app.file_path3 = 'Incorrect_sound.mp3';
            [app.audio_data3, app.sample_rate3] = audioread(app.file_path3);
            app.incorrect = audioplayer(app.audio_data3, app.sample_rate3);
            app.file_path4 = 'Youwin.mp3';
            [app.audio_data4, app.sample_rate4] = audioread(app.file_path4);
            app.youwin = audioplayer(app.audio_data4, app.sample_rate4);
            app.file_path5 = 'Youlose.mp3';
            [app.audio_data5, app.sample_rate5] = audioread(app.file_path5);
            app.youlose = audioplayer(app.audio_data5, app.sample_rate5);

            % Turns off the buttons for the appropriate start screen
            app.Answer1Button.Enable="off";
            app.Answer2Button.Enable="off";
            app.Answer3Button.Enable="off";
            app.Answer4Button.Enable="off";
            app.EasyButton.Enable="off";
            app.MediumButton.Enable="off";
            app.HardButton.Enable="off";
            app.ResetButton.Enable="off";
            app.PauseButton.Enable="off";
            app.AfricaButton.Visible="off";
            app.AsiaButton.Visible="off";
            app.EuropeButton.Visible="off";
            app.SouthAmericaButton.Visible="off";
            app.NorthAmericaButton.Visible="off";
            app.OceaniaButton.Visible="off";
            app.Answer1Button.Visible="off";
            app.Answer2Button.Visible="off";
            app.Answer3Button.Visible="off";
            app.Answer4Button.Visible="off";
            app.EasyButton.Visible="off";
            app.MediumButton.Visible="off";
            app.HardButton.Visible="off";
            app.CloseButton.Visible="off";
            app.ResetButton.Visible="off";
            app.PauseButton.Visible="off";
            app.MusicOnButton.Visible="off";
            app.ComputerLabel_2.Visible="off";     
            app.UserLabel_2.Visible="off";       
            app.UserLabel.Visible="off";         
            app.ComputerLabel.Visible="off";        
            app.MediumModeLabel.Visible="off";       
            app.TimeLabel.Visible="off";            
            app.Player2Gauge.Visible="off";                  
            app.Player2Lamp.Visible="off";         
            app.Player1Gauge.Visible="off";         
            app.Player1Lamp.Visible="off";          
            app.CountryLabel.Visible="off";         
            app.Instructions.Visible="off";     
        end

        % Button pushed function: AsiaButton
        function AsiaButtonPushed(app, event)
            
            % Defines a list of Asian countries and assign it to the app's property
            app.countriesAsia = {
    'Afghanistan', 'Armenia', 'Azerbaijan', 'Bahrain', 'Bangladesh'... 
    'Bhutan', 'Brunei', 'Cambodia', 'China', 'East Timor', 'India'... 
    'Indonesia', 'Iran', 'Iraq', 'Israel', 'Japan', 'Jordan'... 
    'Kazakhstan', 'Kuwait', 'Kyrgyzstan', 'Laos', 'Lebanon'... 
    'Malaysia', 'Maldives', 'Mongolia', 'Myanmar', 'Nepal', 'North Korea'... 
    'Oman', 'Pakistan', 'Palestine', 'Philippines', 'Qatar'...
    'Saudi Arabia', 'Singapore', 'South Korea', 'Sri Lanka', 'Syria', 'Taiwan'... 
    'Tajikistan', 'Thailand', 'Turkey', 'Turkmenistan', 'United Arab Emirates'... 
    'Uzbekistan', 'Vietnam', 'Yemen'};
            
            % Define a list of capitals corresponding to the countries defined above
            app.capitalsAsia = {
    'Kabul', 'Yerevan', 'Baku', 'Manama', 'Dhaka', 'Thimphu'... 
    'Bandar Seri Begawan', 'Phnom Penh', 'Beijing', 'Dili'... 
    'New Delhi', 'Jakarta', 'Tehran', 'Baghdad', 'Jerusalem'... 
    'Tokyo', 'Amman', 'Astana', 'Kuwait City', 'Bishkek', 'Vientiane'... 
    'Beirut', 'Kuala Lumpur', 'Malé', 'Ulaanbaatar', 'Naypyidaw'... 
    'Kathmandu', 'Pyongyang', 'Muscat', 'Islamabad'...
    'Ramallah', 'Manila', 'Doha', 'Riyadh', 'Singapore'... 
    'Seoul', 'Sri Jayawardenepura Kotte', 'Damascus'... 
    'Taipei', 'Dushanbe', 'Bangkok', 'Ankara', 'Ashgabat', 'Abu Dhabi'... 
    'Tashkent', 'Hanoi', 'Sanaa'};

            turnOn(app) % Turns on the buttons 
            app.tStamp=app.time; % Takes a timestamp
            app.timeAnswer = randi([app.min app.max]); % Randomly set a time for the next answer within given bounds (set by the mode)
            app.state=1; % Continent state
            app.stateComputer=1; % Active computer player state
            app.numCountries=length(app.capitalsAsia); % Checks the number of capitals
            loopcontinent(app) % Sets up the correct & incorrect answers
        end

        % Button pushed function: OceaniaButton
        function OceaniaButtonPushed(app, event)
            
            % Equivalent done as before
            app.countriesOceania = {
      'Australia', 'Cook Islands', 'Fiji', 'Kiribati'... 
      'Marshall Islands', 'Micronesia', 'Nauru'... 
      'New Zealand', 'Niue', 'Palau', 'Papua New Guinea'... 
      'Samoa', 'Solomon Islands', 'Tonga', 'Tuvalu', 'Vanuatu'};

            app.capitalsOceania = {
      'Canberra', 'Avarua', 'Suva', 'South Tarawa'...
      'Majuro', 'Palikir', 'Yaren', 'Wellington'...
      'Alofi', 'Ngerulmud', 'Port Moresby', 'Apia'... 
      'Honiara', 'Nukualofa','Funafuti','Port Vila'};

            turnOn(app)
            app.tStamp=app.time;
            app.timeAnswer = randi([app.min app.max]);
            app.state=2;
            app.stateComputer=1;
            app.numCountries=length(app.capitalsOceania);
            loopcontinent(app)
        end

        % Button pushed function: EuropeButton
        function EuropeButtonPushed(app, event)
            
            % Equivalent done as before
            app.countriesEurope = {
    'Albania', 'Andorra', 'Austria', 'Belarus'... 
    'Belgium', 'Bosnia and Herzegovina', 'Bulgaria', 'Croatia', 'Cyprus'... 
    'Czech Republic', 'Denmark', 'Estonia', 'Finland', 'France', 'Georgia'... 
    'Germany', 'Greece', 'Hungary', 'Iceland', 'Ireland', 'Italy', 'Kosovo'... 
    'Latvia', 'Liechtenstein', 'Lithuania', 'Luxembourg', 'Malta', 'Moldova'... 
    'Monaco', 'Montenegro', 'Netherlands', 'North Macedonia', 'Norway'... 
    'Poland', 'Portugal', 'Romania', 'Russia', 'San Marino', 'Serbia'... 
    'Slovakia', 'Slovenia', 'Spain', 'Sweden', 'Switzerland'... 
    'Ukraine', 'United Kingdom', 'Vatican City'};

            app.capitalsEurope = {
    'Tirana', 'Andorra la Vella', 'Vienna', 'Minsk'... 
    'Brussels', 'Sarajevo', 'Sofia', 'Zagreb', 'Nicosia', 'Prague'...
    'Copenhagen', 'Tallinn', 'Helsinki', 'Paris', 'Tbilisi', 'Berlin'... 
    'Athens', 'Budapest', 'Reykjavik', 'Dublin', 'Rome', 'Pristina'...
    'Riga', 'Vaduz', 'Vilnius', 'Luxembourg City', 'Valletta', 'Chisinau'... 
    'Monaco', 'Podgorica', 'Amsterdam', 'Skopje', 'Oslo', 'Warsaw'... 
    'Lisbon', 'Bucharest', 'Moscow', 'San Marino', 'Belgrade', 'Bratislava'... 
    'Ljubljana', 'Madrid', 'Stockholm', 'Bern', 'Kyiv'... 
    'London', 'Vatican City'};

            turnOn(app)
            app.tStamp=app.time;
            app.timeAnswer = randi([app.min app.max]);
            app.state=3;
            app.stateComputer=1;
            app.numCountries=length(app.capitalsEurope);
            loopcontinent(app)
        end

        % Button pushed function: NorthAmericaButton
        function NorthAmericaButtonPushed(app, event)
            
            % Equivalent done as before
            app.countriesNAmerica = {
    'Antigua and Barbuda', 'Bahamas', 'Barbados', 'Belize', 'Canada'... 
    'Costa Rica', 'Cuba', 'Dominica', 'Dominican Republic', 'El Salvador'... 
    'Grenada', 'Guatemala', 'Haiti', 'Honduras', 'Jamaica', 'Mexico'... 
    'Nicaragua', 'Panama', 'Saint Kitts and Nevis', 'Saint Lucia'... 
    'Saint Vincent and the Grenadines', 'Trinidad and Tobago', 'United States'};

            app.capitalsNAmerica = {
    'St. Johns', 'Nassau', 'Bridgetown', 'Belmopan', 'Ottawa', 'San José'... 
    'Havana', 'Roseau', 'Santo Domingo', 'San Salvador', 'St. George''s', 'Guatemala City'... 
    'Port-au-Prince', 'Tegucigalpa', 'Kingston', 'Mexico City', 'Managua', 'Panama City'...
    'Basseterre', 'Castries', 'Kingstown', 'Port of Spain', 'Washington'};

            turnOn(app)
            app.tStamp=app.time;
            app.timeAnswer = randi([app.min app.max]);
            app.state=4;
            app.stateComputer=1;
            app.numCountries=length(app.capitalsNAmerica);
            loopcontinent(app)
        end

        % Button pushed function: SouthAmericaButton
        function SouthAmericaButtonPushed(app, event)
            
            % Equivalent done as before
            app.countriesSAmerica = {
    'Argentina', 'Bolivia', 'Brazil', 'Chile', 'Colombia'... 
    'Ecuador','Guyana', 'Paraguay', 'Peru'...  
    'Suriname', 'Uruguay', 'Venezuela'};

            app.capitalsSAmerica = {
    'Buenos Aires', 'La Paz', 'Brasilia', 'Santiago'... 
    'Bogotá', 'Quito', 'Georgetown'...
    'Asunción', 'Lima', 'Paramaribo'... 
    'Montevideo', 'Caracas'};

            turnOn(app)
            app.tStamp=app.time;
            app.timeAnswer = randi([app.min app.max]);
            app.state=5;
            app.stateComputer=1;
            app.numCountries=length(app.capitalsSAmerica);
            loopcontinent(app)
        end

        % Button pushed function: AfricaButton
        function AfricaButtonPushed(app, event)
            
            % Equivalent done as before
            app.countriesAfrica = {
    'Algeria', 'Angola', 'Benin', 'Botswana', 'Burkina Faso', 'Burundi', ...
    'Cameroon', 'Cape Verde', 'Central African Republic', 'Chad', 'Comoros', ...
    'Democratic Republic of the Congo', 'Republic of the Congo', 'Djibouti', 'Egypt', ...
    'Equatorial Guinea', 'Eritrea', 'Eswatini', 'Ethiopia', 'Gabon', 'The Gambia', ...
    'Ghana', 'Guinea', 'Guinea-Bissau', 'Ivory Coast', 'Kenya', 'Lesotho', 'Liberia', ...
    'Libya', 'Madagascar', 'Malawi', 'Mali', 'Mauritania', 'Mauritius', 'Morocco', ...
    'Mozambique', 'Namibia', 'Niger', 'Nigeria', 'Rwanda', 'São Tomé and Príncipe', ...
    'Senegal', 'Seychelles', 'Sierra Leone', 'Somalia', 'South Africa', 'South Sudan', ...
    'Sudan', 'Tanzania', 'Togo', 'Tunisia', 'Uganda', 'Zambia', 'Zimbabwe'};

            app.capitalsAfrica = {
    'Algiers', 'Luanda', 'Porto-Novo', 'Gaborone', 'Ouagadougou', 'Gitega', ...           
    'Yaoundé', 'Praia', 'Bangui', 'Ndjamena', 'Moroni', ...            
    'Kinshasa', 'Brazzaville', 'Djibouti', 'Cairo', ...            
    'Malabo', 'Asmara', 'Mbabane', 'Addis Ababa', 'Libreville', 'Banjul', ...             
    'Accra', 'Conakry', 'Bissau', 'Yamoussoukro', 'Nairobi', 'Maseru', 'Monrovia', ...              
    'Tripoli', 'Antananarivo', 'Lilongwe', 'Bamako', 'Nouakchott', 'Port Louis', 'Rabat', ...             
    'Maputo', 'Windhoek', 'Niamey', 'Abuja', 'Kigali', 'São Tomé', ...              
    'Dakar', 'Victoria', 'Freetown', 'Mogadishu', 'Pretoria', 'Juba', ...              
    'Khartoum', 'Dodoma', 'Lomé', 'Tunis', 'Kampala', 'Lusaka', 'Harare'};

            turnOn(app)
            app.tStamp=app.time;
            app.timeAnswer = randi([app.min app.max]);
            app.state=6;
            app.stateComputer=1;
            app.numCountries=length(app.capitalsAfrica);
            loopcontinent(app)
        end

        % Button pushed function: Answer1Button
        function Answer1ButtonPushed(app, event)
            app.answerButton=1; % Sets up correct button state
            buttons(app) % Calls buttons method
        end

        % Button pushed function: Answer2Button
        function Answer2ButtonPushed(app, event)
            app.answerButton=2;
            buttons(app)
        end

        % Button pushed function: Answer3Button
        function Answer3ButtonPushed(app, event)
            app.answerButton=3;
            buttons(app)
        end

        % Button pushed function: Answer4Button
        function Answer4ButtonPushed(app, event)
            app.answerButton=4;
            buttons(app)
        end

        % Button pushed function: ResetButton
        function ResetButtonPushed(app, event)
            
            % Resets the app to default settings (medium mode, 0 scores, inactive states, disables answer buttons, etc.)
            app.state = 0;
            app.stateComputer = 2;
            app.scoreUser = 0;
            app.scoreComputer = 0;
            app.Player1Gauge.Value = app.scoreUser;
            app.Player2Gauge.Value = app.scoreComputer;
            app.Instructions.Text="Click On The Continent Name To Play The Game!";
            app.Player1Lamp.Color = [0.8 0.8 0.8];
            app.Player2Lamp.Color = [0.8 0.8 0.8];
            app.CountryLabel.Text = "Country";
            app.UserLabel_2.Text = "Player1";
            app.ComputerLabel_2.Text = "Player2";
            app.min=2;
            app.max=3;
            app.probability=0.3;
            app.MediumModeLabel.Text="Medium Mode";
            app.AfricaButton.Enable="on";
            app.AsiaButton.Enable="on";
            app.EuropeButton.Enable="on";
            app.SouthAmericaButton.Enable="on";
            app.NorthAmericaButton.Enable="on";
            app.OceaniaButton.Enable="on";
            app.Answer1Button.Enable="off";
            app.Answer2Button.Enable="off";
            app.Answer3Button.Enable="off";
            app.Answer4Button.Enable="off";
            app.EasyButton.Enable="off";
            app.MediumButton.Enable="off";
            app.HardButton.Enable="off";
            app.PauseButton.Enable="off";
            app.ResetButton.Enable="off";
            app.countdown = [10 9 8 7 6 5 4 3 2 1 0];
            app.modeState = 1;
            if strcmp(app.t.Running, 'off') % Checks if timer is not running
                start(app.t) % Turns the timer on
            end
        end

        % Close request function: UIFigure
        function UIFigureCloseRequest(app, event)
            stop(app.t) % Stops timer & deletes app
            delete(app)
        end

        % Button pushed function: EasyButton
        function EasyButtonPushed(app, event)
            
            % Sets up the difficulty parameters like the time range to answer and the probability of the correct answer
            app.min=3;
            app.max=5;
            app.probability=0.35;
            app.MediumModeLabel.Text="Easy Mode";
            app.previousMode = app.modeState; % Checks what the current state is
            app.modeState = 0; % Updates the state to the new mode
            app.transitionState=1; % Transition state is initiated
        end

        % Button pushed function: MediumButton
        function MediumButtonPushed(app, event)
            
            % Equivalent is done here 
            app.min=2;
            app.max=3;
            app.probability=0.25;
            app.MediumModeLabel.Text="Medium Mode";
            app.previousMode = app.modeState;
            app.modeState = 1;
            app.transitionState=1;
        end

        % Button pushed function: HardButton
        function HardButtonPushed(app, event)
            
            % Equivalent is done here 
            app.min=1;
            app.max=2;
            app.probability=0.1;
            app.MediumModeLabel.Text="Hard Mode";
            app.previousMode = app.modeState;
            app.modeState = 2;
            app.transitionState=1;
        end

        % Button pushed function: PauseButton
        function PauseButtonPushed(app, event)
            
            % Checks whether the button is turned on/off based on even/odd
            app.pauseCounter=app.pauseCounter+1;
            if mod(app.pauseCounter, 2) == 0 % Game is on
                app.PauseButton.Text="Pause";
                turnOn(app)
                app.AsiaButton.Enable="on";
                app.AfricaButton.Enable="on";
                app.EuropeButton.Enable="on";
                app.OceaniaButton.Enable="on";
                app.NorthAmericaButton.Enable="on";
                app.SouthAmericaButton.Enable="on";
                app.stateComputer = 1;
                start(app.t)
            else % Game is off
                app.PauseButton.Text="Play";
                ending(app)
                app.ResetButton.Enable="off";
                stop(app.t)
            end
        end

        % Button pushed function: MusicOnButton
        function MusicOnButtonPushed(app, event)
            
            % Checks whether the button is turned on/off based on even/odd
            app.musicCounter = app.musicCounter + 1;
            if mod(app.musicCounter, 2) == 1 % If counter is odd (music is on)
                app.MusicOnButton.Text = 'Music Off';
                play(app.music) % Play the music
            else
                app.MusicOnButton.Text = 'Music On';
                stop(app.music); % Stop the music
            end
        end

        % Button pushed function: CloseButton
        function CloseButtonPushed(app, event)
            
            % Checks if the music/timer are running and stops them
            if isplaying(app.music)
                stop(app.music)
            end
            if strcmp(app.t.Running, 'on')
                stop(app.t)
            end
            delete(app) % Delete the app
        end

        % Button pushed function: StartButton
        function StartButtonPushed(app, event)
            
            % Turns on the necessary components
            app.AfricaButton.Visible="on";
            app.AsiaButton.Visible="on";
            app.EuropeButton.Visible="on";
            app.SouthAmericaButton.Visible="on";
            app.NorthAmericaButton.Visible="on";
            app.OceaniaButton.Visible="on";
            app.Answer1Button.Visible="on";
            app.Answer2Button.Visible="on";
            app.Answer3Button.Visible="on";
            app.Answer4Button.Visible="on";
            app.EasyButton.Visible="on";
            app.MediumButton.Visible="on";
            app.HardButton.Visible="on";
            app.CloseButton.Visible="on";
            app.ResetButton.Visible="on";
            app.PauseButton.Visible="on";
            app.MusicOnButton.Visible="on";
            app.ComputerLabel_2.Visible="on";     
            app.UserLabel_2.Visible="on";       
            app.UserLabel.Visible="on";         
            app.ComputerLabel.Visible="on";        
            app.MediumModeLabel.Visible="on";       
            app.TimeLabel.Visible="on";            
            app.Player2Gauge.Visible="on";                  
            app.Player2Lamp.Visible="on";         
            app.Player1Gauge.Visible="on";         
            app.Player1Lamp.Visible="on";          
            app.CountryLabel.Visible="on";         
            app.Instructions.Visible="on";

            % Turns off the unnecessary components
            app.StartButton.Visible="off";
            app.CapitalsOfTheWorldLabel.Visible="off";
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Get the file path for locating images
            pathToMLAPP = fileparts(mfilename('fullpath'));

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [0 0 1500 800];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @UIFigureCloseRequest, true);

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.Position = [45 150 1432 651];
            app.Image.ImageSource = fullfile(pathToMLAPP, 'world-map.png');

            % Create Answer1Button
            app.Answer1Button = uibutton(app.UIFigure, 'push');
            app.Answer1Button.ButtonPushedFcn = createCallbackFcn(app, @Answer1ButtonPushed, true);
            app.Answer1Button.BackgroundColor = [0.902 0.902 0.902];
            app.Answer1Button.FontName = 'Monospaced';
            app.Answer1Button.FontSize = 14;
            app.Answer1Button.FontWeight = 'bold';
            app.Answer1Button.Position = [320 279 140 50];
            app.Answer1Button.Text = 'Answer 1';

            % Create Answer2Button
            app.Answer2Button = uibutton(app.UIFigure, 'push');
            app.Answer2Button.ButtonPushedFcn = createCallbackFcn(app, @Answer2ButtonPushed, true);
            app.Answer2Button.BackgroundColor = [0.902 0.902 0.902];
            app.Answer2Button.FontName = 'Monospaced';
            app.Answer2Button.FontSize = 14;
            app.Answer2Button.FontWeight = 'bold';
            app.Answer2Button.Position = [600 279 140 50];
            app.Answer2Button.Text = 'Answer 2';

            % Create Answer4Button
            app.Answer4Button = uibutton(app.UIFigure, 'push');
            app.Answer4Button.ButtonPushedFcn = createCallbackFcn(app, @Answer4ButtonPushed, true);
            app.Answer4Button.BackgroundColor = [0.902 0.902 0.902];
            app.Answer4Button.FontName = 'Monospaced';
            app.Answer4Button.FontSize = 14;
            app.Answer4Button.FontWeight = 'bold';
            app.Answer4Button.Position = [1160 279 140 50];
            app.Answer4Button.Text = 'Answer 4';

            % Create Answer3Button
            app.Answer3Button = uibutton(app.UIFigure, 'push');
            app.Answer3Button.ButtonPushedFcn = createCallbackFcn(app, @Answer3ButtonPushed, true);
            app.Answer3Button.BackgroundColor = [0.902 0.902 0.902];
            app.Answer3Button.FontName = 'Monospaced';
            app.Answer3Button.FontSize = 14;
            app.Answer3Button.FontWeight = 'bold';
            app.Answer3Button.Position = [880 279 140 50];
            app.Answer3Button.Text = 'Answer 3';

            % Create AfricaButton
            app.AfricaButton = uibutton(app.UIFigure, 'push');
            app.AfricaButton.ButtonPushedFcn = createCallbackFcn(app, @AfricaButtonPushed, true);
            app.AfricaButton.BackgroundColor = [0.302 0.7451 0.9333];
            app.AfricaButton.FontName = 'Cochin';
            app.AfricaButton.FontSize = 18;
            app.AfricaButton.FontWeight = 'bold';
            app.AfricaButton.Position = [797 487 85 41];
            app.AfricaButton.Text = 'Africa';

            % Create SouthAmericaButton
            app.SouthAmericaButton = uibutton(app.UIFigure, 'push');
            app.SouthAmericaButton.ButtonPushedFcn = createCallbackFcn(app, @SouthAmericaButtonPushed, true);
            app.SouthAmericaButton.BackgroundColor = [1 0 0];
            app.SouthAmericaButton.FontName = 'AppleMyungjo';
            app.SouthAmericaButton.FontSize = 18;
            app.SouthAmericaButton.FontWeight = 'bold';
            app.SouthAmericaButton.Position = [474 410 142 55];
            app.SouthAmericaButton.Text = 'South America';

            % Create NorthAmericaButton
            app.NorthAmericaButton = uibutton(app.UIFigure, 'push');
            app.NorthAmericaButton.ButtonPushedFcn = createCallbackFcn(app, @NorthAmericaButtonPushed, true);
            app.NorthAmericaButton.BackgroundColor = [1 0.4118 0.1608];
            app.NorthAmericaButton.FontName = 'Apple SD Gothic Neo';
            app.NorthAmericaButton.FontSize = 18;
            app.NorthAmericaButton.FontWeight = 'bold';
            app.NorthAmericaButton.Position = [326 607 140 46];
            app.NorthAmericaButton.Text = 'North America';

            % Create EuropeButton
            app.EuropeButton = uibutton(app.UIFigure, 'push');
            app.EuropeButton.ButtonPushedFcn = createCallbackFcn(app, @EuropeButtonPushed, true);
            app.EuropeButton.BackgroundColor = [0.7176 0.2745 1];
            app.EuropeButton.FontName = 'Apple Chancery';
            app.EuropeButton.FontSize = 18;
            app.EuropeButton.FontWeight = 'bold';
            app.EuropeButton.Position = [778 638 91 39];
            app.EuropeButton.Text = 'Europe';

            % Create AsiaButton
            app.AsiaButton = uibutton(app.UIFigure, 'push');
            app.AsiaButton.ButtonPushedFcn = createCallbackFcn(app, @AsiaButtonPushed, true);
            app.AsiaButton.BackgroundColor = [1 1 0];
            app.AsiaButton.FontName = 'American Typewriter';
            app.AsiaButton.FontSize = 18;
            app.AsiaButton.FontWeight = 'bold';
            app.AsiaButton.Position = [1065 629 99 48];
            app.AsiaButton.Text = 'Asia';

            % Create OceaniaButton
            app.OceaniaButton = uibutton(app.UIFigure, 'push');
            app.OceaniaButton.ButtonPushedFcn = createCallbackFcn(app, @OceaniaButtonPushed, true);
            app.OceaniaButton.BackgroundColor = [0 1 0];
            app.OceaniaButton.FontName = 'Heiti SC';
            app.OceaniaButton.FontSize = 18;
            app.OceaniaButton.FontWeight = 'bold';
            app.OceaniaButton.Position = [1177 357 135 37];
            app.OceaniaButton.Text = 'Oceania';

            % Create Instructions
            app.Instructions = uilabel(app.UIFigure);
            app.Instructions.HorizontalAlignment = 'center';
            app.Instructions.FontName = 'Silom';
            app.Instructions.FontSize = 24;
            app.Instructions.FontWeight = 'bold';
            app.Instructions.FontColor = [1 0 0];
            app.Instructions.Position = [313 732 992 58];
            app.Instructions.Text = 'Click On The Continent Name To Play The Game!';

            % Create CountryLabel
            app.CountryLabel = uilabel(app.UIFigure);
            app.CountryLabel.BackgroundColor = [0 0.4471 0.7412];
            app.CountryLabel.HorizontalAlignment = 'center';
            app.CountryLabel.FontName = 'AppleGothic';
            app.CountryLabel.FontSize = 24;
            app.CountryLabel.Position = [469 689 679 31];
            app.CountryLabel.Text = 'Country';

            % Create Player1Lamp
            app.Player1Lamp = uilamp(app.UIFigure);
            app.Player1Lamp.Position = [474 694 20 20];
            app.Player1Lamp.Color = [0.8 0.8 0.8];

            % Create Player1Gauge
            app.Player1Gauge = uigauge(app.UIFigure, 'circular');
            app.Player1Gauge.Limits = [0 20];
            app.Player1Gauge.Position = [123 533 120 120];

            % Create Player2Lamp
            app.Player2Lamp = uilamp(app.UIFigure);
            app.Player2Lamp.Position = [1125 694 20 20];
            app.Player2Lamp.Color = [0.8 0.8 0.8];

            % Create ResetButton
            app.ResetButton = uibutton(app.UIFigure, 'push');
            app.ResetButton.ButtonPushedFcn = createCallbackFcn(app, @ResetButtonPushed, true);
            app.ResetButton.BackgroundColor = [0.651 0.651 0.651];
            app.ResetButton.FontName = 'Futura';
            app.ResetButton.FontSize = 18;
            app.ResetButton.FontWeight = 'bold';
            app.ResetButton.Position = [604 201 175 46];
            app.ResetButton.Text = 'Reset';

            % Create Player2Gauge
            app.Player2Gauge = uigauge(app.UIFigure, 'circular');
            app.Player2Gauge.Limits = [0 20];
            app.Player2Gauge.Position = [1286 533 120 120];

            % Create TimeLabel
            app.TimeLabel = uilabel(app.UIFigure);
            app.TimeLabel.HorizontalAlignment = 'center';
            app.TimeLabel.FontName = 'Rockwell';
            app.TimeLabel.FontSize = 36;
            app.TimeLabel.FontWeight = 'bold';
            app.TimeLabel.Position = [1275 696 104 95];
            app.TimeLabel.Text = 'Time';

            % Create EasyButton
            app.EasyButton = uibutton(app.UIFigure, 'push');
            app.EasyButton.ButtonPushedFcn = createCallbackFcn(app, @EasyButtonPushed, true);
            app.EasyButton.BackgroundColor = [0 1 1];
            app.EasyButton.FontName = 'Rockwell';
            app.EasyButton.FontWeight = 'bold';
            app.EasyButton.Position = [133 410 100 23];
            app.EasyButton.Text = 'Easy';

            % Create MediumButton
            app.MediumButton = uibutton(app.UIFigure, 'push');
            app.MediumButton.ButtonPushedFcn = createCallbackFcn(app, @MediumButtonPushed, true);
            app.MediumButton.BackgroundColor = [0 1 0];
            app.MediumButton.FontName = 'Rockwell';
            app.MediumButton.FontWeight = 'bold';
            app.MediumButton.Position = [133 335 100 23];
            app.MediumButton.Text = 'Medium';

            % Create HardButton
            app.HardButton = uibutton(app.UIFigure, 'push');
            app.HardButton.ButtonPushedFcn = createCallbackFcn(app, @HardButtonPushed, true);
            app.HardButton.BackgroundColor = [1 0 0];
            app.HardButton.FontName = 'Rockwell';
            app.HardButton.FontWeight = 'bold';
            app.HardButton.Position = [133 257 100 23];
            app.HardButton.Text = 'Hard';

            % Create MediumModeLabel
            app.MediumModeLabel = uilabel(app.UIFigure);
            app.MediumModeLabel.HorizontalAlignment = 'center';
            app.MediumModeLabel.FontName = 'Rockwell';
            app.MediumModeLabel.FontSize = 24;
            app.MediumModeLabel.FontWeight = 'bold';
            app.MediumModeLabel.Position = [232 696 286 94];
            app.MediumModeLabel.Text = 'Medium Mode';

            % Create ComputerLabel
            app.ComputerLabel = uilabel(app.UIFigure);
            app.ComputerLabel.FontName = 'Baskerville';
            app.ComputerLabel.FontSize = 18;
            app.ComputerLabel.FontWeight = 'bold';
            app.ComputerLabel.Position = [1300 487 92 24];
            app.ComputerLabel.Text = 'Computer';

            % Create UserLabel
            app.UserLabel = uilabel(app.UIFigure);
            app.UserLabel.FontName = 'Baskerville';
            app.UserLabel.FontSize = 18;
            app.UserLabel.FontWeight = 'bold';
            app.UserLabel.Position = [160 487 46 24];
            app.UserLabel.Text = 'User';

            % Create UserLabel_2
            app.UserLabel_2 = uilabel(app.UIFigure);
            app.UserLabel_2.FontName = 'Baskerville';
            app.UserLabel_2.FontSize = 14;
            app.UserLabel_2.FontWeight = 'bold';
            app.UserLabel_2.Position = [502 693 79 22];
            app.UserLabel_2.Text = 'User';

            % Create ComputerLabel_2
            app.ComputerLabel_2 = uilabel(app.UIFigure);
            app.ComputerLabel_2.HorizontalAlignment = 'right';
            app.ComputerLabel_2.FontName = 'Baskerville';
            app.ComputerLabel_2.FontSize = 14;
            app.ComputerLabel_2.FontWeight = 'bold';
            app.ComputerLabel_2.Position = [1027 693 89 22];
            app.ComputerLabel_2.Text = 'Computer';

            % Create PauseButton
            app.PauseButton = uibutton(app.UIFigure, 'push');
            app.PauseButton.ButtonPushedFcn = createCallbackFcn(app, @PauseButtonPushed, true);
            app.PauseButton.BackgroundColor = [0.3922 0.8314 0.0745];
            app.PauseButton.FontName = 'Kokonor';
            app.PauseButton.FontWeight = 'bold';
            app.PauseButton.Position = [1302 680 50 35];
            app.PauseButton.Text = 'Pause';

            % Create MusicOnButton
            app.MusicOnButton = uibutton(app.UIFigure, 'push');
            app.MusicOnButton.ButtonPushedFcn = createCallbackFcn(app, @MusicOnButtonPushed, true);
            app.MusicOnButton.BackgroundColor = [0.3922 0.8314 0.0745];
            app.MusicOnButton.FontName = 'Kokonor';
            app.MusicOnButton.FontWeight = 'bold';
            app.MusicOnButton.Position = [214 690 100 26];
            app.MusicOnButton.Text = 'Music On';

            % Create CloseButton
            app.CloseButton = uibutton(app.UIFigure, 'push');
            app.CloseButton.ButtonPushedFcn = createCallbackFcn(app, @CloseButtonPushed, true);
            app.CloseButton.BackgroundColor = [0.651 0.651 0.651];
            app.CloseButton.FontName = 'Futura';
            app.CloseButton.FontSize = 18;
            app.CloseButton.FontWeight = 'bold';
            app.CloseButton.Position = [845 201 175 46];
            app.CloseButton.Text = 'Close';

            % Create StartButton
            app.StartButton = uibutton(app.UIFigure, 'push');
            app.StartButton.ButtonPushedFcn = createCallbackFcn(app, @StartButtonPushed, true);
            app.StartButton.BackgroundColor = [0.6353 0.0784 0.1843];
            app.StartButton.FontName = 'Luminari';
            app.StartButton.FontSize = 36;
            app.StartButton.FontWeight = 'bold';
            app.StartButton.Position = [661 371 200 100];
            app.StartButton.Text = 'Start';

            % Create CapitalsOfTheWorldLabel
            app.CapitalsOfTheWorldLabel = uilabel(app.UIFigure);
            app.CapitalsOfTheWorldLabel.HorizontalAlignment = 'center';
            app.CapitalsOfTheWorldLabel.FontName = 'Copperplate';
            app.CapitalsOfTheWorldLabel.FontSize = 48;
            app.CapitalsOfTheWorldLabel.FontWeight = 'bold';
            app.CapitalsOfTheWorldLabel.Position = [464 563 594 61];
            app.CapitalsOfTheWorldLabel.Text = 'Capitals Of The World';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Main_game_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end