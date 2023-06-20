%   The Program Start Exceution from the public method.
%   It first calls the Function createComponents() to Intialize the UIFigure and it's Components  
%   Then it calls the Function registerApp() which is a built in function to Register App Designe
%   Then it calls the Function runStartupFcn() which is a built in function also to give the intial start of the program
%   Then it calls the Function startupFcn() which Intializes the number of table points and their itial values
%   Now the program is done, ot waits until the user pushes one of the
%   buttons to do its function (Adding new point, or solve for the current points)

classdef scratch < matlab.apps.AppBase

    % Properties that correspond to app components %
    % The App Components are the following %
    properties (Access = public)
        UIFigure               matlab.ui.Figure;
        DropDown               matlab.ui.control.DropDown;
        
        SolveButton            matlab.ui.control.Button;
        bestButton             matlab.ui.control.Button;
        AddnewpointButton      matlab.ui.control.Button;
       
        LinearRegressionLabel  matlab.ui.control.Label;
        DataLabel              matlab.ui.control.Label;
        ModelLabel             matlab.ui.control.Label;
        UITable                matlab.ui.control.Table;
        
        aLabel                 matlab.ui.control.Label;
        a                      matlab.ui.control.Label;
        
        bLabel                 matlab.ui.control.Label;
        b                      matlab.ui.control.Label;
        
        rLabel                 matlab.ui.control.Label;
        r                      matlab.ui.control.Label;
    end

    methods (Access = private)

        % The Code Which Executes After creation of components %
        function startupFcn(app)
            % Intializing the number of points in the table and also their itial values %
            app.UITable.Data = [ [0 ; 0] [0 ; 0]] ;  
        end
        
        
        function BestButtonPushed(app, event)
            clc;
            % Run The Linear Model to check the r Value %
            app.DropDown.Value = 'Linear Model';
            SolveButtonPushed(app);
            r_Linear = app.r.Text;
            
            % Run The Exponential Model to check the r Value %
            app.DropDown.Value = 'Exponential Model';
            SolveButtonPushed(app);
            r_Exponential = app.r.Text;
            
            % Run The Growth Rate Model to check the r Value %
            app.DropDown.Value = 'Growth Rate Model';
            SolveButtonPushed(app);
            r_GrowthRate = app.r.Text;
            
            % Run The Power Model to check the r Value %
            app.DropDown.Value = 'Power Model';
            SolveButtonPushed(app);
            r_Power = app.r.Text;
            close all;
            
            % Concatinating the value of r in all models %
            bestArray = [str2double(r_Linear) str2double(r_Exponential) str2double(r_Power) str2double(r_GrowthRate)];            
            % Get the maximum value of r and the model which related to it %
            [best, ind] = max(bestArray);
            
            % Check if the Maximum value of r is related to Linear Model %
            if(ind==1)
                app.DropDown.Value = 'Linear Model';
                SolveButtonPushed(app);
            
            % Check if the Maximum value of r is related to Exponential Model %
            elseif(ind==2)
                app.DropDown.Value = 'Exponential Model';
                SolveButtonPushed(app);
            
            % Check if the Maximum value of r is related to Power Model %
            elseif(ind==3)
                app.DropDown.Value = 'Power Model';
                SolveButtonPushed(app);
            
            % Check if the Maximum value of r is related to Growth Rate Model %
            elseif(ind==4)
                app.DropDown.Value = 'Growth Rate Model';
                SolveButtonPushed(app);
            end
        end
        
        % Button pushed function : AddnewpointButton %
        function AddnewpointButtonPushed(app, event)
            
                    % Get The Current data From the Table %
                    data = get(app.UITable , 'data');

                    % Add New Row in X,Y and Intialize by Zero %
                    data(end+1 , : ) = 0;

                    % Update the New Table Data %
                    set(app.UITable, 'data', data);
                end

                % Button pushed function: SolveButton
                function SolveButtonPushed(app, event)

                    % Get The Current data From the Table %
                    data = get(app.UITable , 'data') ; 
                    % Get Number of Points From the Table %
                    n = size(data, 1); 

                    % Get The sum of all X values %
                    SumX = sum(data(: , 1));
                    % Get The square of all X values %
                    SquareX = data(: , 1).* data(: , 1);
                    % Get The sum of all X square values %
                    SumSquareX = sum(SquareX); 
                    % Get The sum of all Y values %
                    SumY = sum(data(: , 2));

                    % Intialize an array of the X*Y Values by Zeros %
                    XY_Array = zeros(n  , 1);
                    % Put the value of the product in the array %
                    XY_Array = data(: , 1) .* data(: , 2); 
                    % Get The sum of X*Y values %
                    SumXY = sum(XY_Array); 

                    % Put the system of equation in the right form %
                    A = [n SumX ; SumX SumSquareX];
                    B = [SumY ; SumXY];
                    % Solving the system to find the values of A0, A1 %
                    solution = linsolve(A,B); 

                    a_0 = solution(1); 
                    a_1 = solution(2);

                    x = linspace(min(data(: , 1)) , max(data(: , 1)) , 1000);
                    % The best fitting equation with the values of A0, A1 %
                    y = a_0 + a_1.*x;
                    
                    figure; 
                    scatter( (data(: , 1))'  , (data(: , 2))'); 
                    hold on; 
                    

            switch app.DropDown.Value
                case 'Linear Model'
                    plot(x, y); 
                    % Getting the old values of X before making the Linear Regression Relation %
                    x_old = data(: , 1);
                    % Getting the old values of Y before making the Linear Regression Relation %
                    y_old = data(: , 2);
                    
                    % Getting the average of the y values using function mean() %
                    avrg = mean(y_old); 
                    % Getting the value of st from the equation giving before %
                    st = sum((y_old - avrg).^2); 
                    % Getting the value of sr from the equation giving before %
                    sr = sum((y_old - a_0 - x_old.*a_1 ).^2); 
                    % Getting the value of r  from the equation giving before %
                    r = sqrt((st - sr)/st); 
                    
                    % Saving the value of a in the application %
                    app.a.Text = string(a_0); 
                    % Saving the value of b in the application %
                    app.b.Text = string(a_1);
                    % Saving the value of Correlation in the application %
                    app.r.Text = string(r); 

                case 'Exponential Model'
                    
                    % Get The Current data From the Table %
                    data = get(app.UITable , 'data');
                    % Get Number of Points From the Table %
                    n = size(data, 1);
                    
                    % Let y equals Log(Y) as the Exponential Modeling %
                    y = log(data(: , 2)); 
                    % Let x equals the same Value of X %
                    x = data(: , 1); 
                    
                    % Get The sum of all X values %
                    SumX = sum(x);
                    % Get The square of all X values %
                    SquareX = x.*x;  
                    % Get The sum of all X square values %
                    SumSquareX = sum(SquareX); 
                    % Get The sum of all Y values %
                    SumY = sum(y);

                    % Intialize an array of the X*Y Values by Zeros %
                    XY_Array = zeros( n  , 1); 
                    % Put the value of the product in the array %
                    XY_Array = x .* y; 
                    % Get The sum of X*Y values %
                    SumXY = sum(XY_Array);
                    
                    % Put the system of equation in the right form %
                    A = [n SumX ; SumX  SumSquareX];
                    B = [SumY ; SumXY];
                    % Solving the system to find the values of A0, A1 %
                    solution = linsolve(A,B); 
                    
                    a_0 = solution(1); 
                    a_1 = solution(2);

                    a = exp(a_0);
                    b = a_1; 
                    
                    % Saving the value of a in the application %
                    app.a.Text = string(a); 
                    % Saving the value of b in the application %
                    app.b.Text = string(b);
                    
                    xgraph = linspace(min(data(:,1)) , max(data(:,1)) , 1000);
                    ygraph = a*exp(xgraph*b); 
                    plot(xgraph , ygraph);
                    title('Exponential Model');

                    % Getting the average of the y values using function mean() %
                    avrg = mean(y);
                    % Getting the value of st from the equation giving before %
                    st = sum((y - avrg).^2); 
                    % Getting the value of sr from the equation giving before %
                    sr = sum((y- a_0 - x.*a_1 ).^2); 
                    % Getting the value of r  from the equation giving before %
                    r = sqrt((st - sr)/st); 
                    % Saving the value of Correlation in the application %
                    app.r.Text = string(r); 
                    
                case 'Growth Rate Model' 
                    
                    % Get The Current data From the Table %
                    data = get(app.UITable , 'data'); 
                    % Get Number of Points From the Table %
                    n = size(data, 1); 
                    
                    % Let x equals 1/X as the Growth Rate Modeling %
                    x = 1./(data(: , 1)); 
                    % Let y equals 1/Y as the Growth Rate Modeling %
                    y = 1./(data(: , 2)); 
                    
                    % Get The sum of all X values %
                    SumX = sum(x);
                    % Get The square of all X values %
                    SquareX = x.* x;  
                    % Get The sum of all X square values %
                    SumSquareX = sum(SquareX);
                    % Get The sum of all Y values %
                    SumY = sum(y);
                    
                    % Intialize an array of the X*Y Values by Zeros %
                    XY_Array = zeros( n  , 1); 
                    % Put the value of the product in the array %
                    XY_Array = x .* y; 
                    % Get The sum of X*Y values %
                    SumXY = sum(XY_Array);
                    
                    % Put the system of equation in the right form %
                    A = [n SumX ; SumX  SumSquareX];
                    B = [SumY ; SumXY];
                    
                    % Solving the system to find the values of A0, A1 %
                    solution = linsolve(A,B); 
                    a_0 = solution(1); 
                    a_1 = solution(2);
                    
                    a = 1/a_0;
                    b = a_1*a;
                    
                    % Saving the value of a in the application %
                    app.a.Text = string(a); 
                    % Saving the value of b in the application %
                    app.b.Text = string(b); 
                    
                    xgraph = linspace(min(data(:,1)) , max(data(:,1)) , 1000);
                    ygraph = (a*xgraph)./(b+xgraph); 
                    plot(xgraph , ygraph); 
                    title('Growth Rate Model');
                    
                    % Getting the average of the y values using function mean() %
                    avrg = mean(y); 
                    % Getting the value of st from the equation giving before %
                    st = sum((y - avrg).^2); 
                    % Getting the value of sr from the equation giving before %
                    sr = sum((y- a_0 - x.*a_1 ).^2); 
                    % Getting the value of r  from the equation giving before %
                    r = sqrt((st - sr)/st); 
                    app.r.Text = string(r); 
                    
                case 'Power Model' 
                    
                    % Get The Current data From the Table %
                    data = get(app.UITable , 'data'); 
                    % Get Number of Points From the Table %
                    n = size(data, 1); 
                    
                    % Let x equals Log10(X) as the Power Modeling %
                    x = log10(data(: , 1));
                    % Let y equals Log10(Y) as the Power Modeling %
                    y = log10(data(: , 2)); 
                     
                    % Get The sum of all X values %
                    SumX = sum(x);
                    % Get The square of all X values %
                    SquareX = x.* x;  
                    % Get The sum of all X square values %
                    SumSquareX = sum(SquareX); 
                    % Get The sum of all Y values %
                    SumY = sum(y);
                    
                    % Intialize an array of the X*Y Values by Zeros %
                    XY_Array = zeros( n  , 1); 
                    % Put the value of the product in the array %
                    XY_Array = x .* y; 
                    % Get The sum of X*Y values %
                    SumXY = sum(XY_Array); 
                    
                    % Put the system of equation in the right form %
                    A = [n SumX ; SumX  SumSquareX];
                    B = [SumY ; SumXY];
                    
                    % Solving the system to find the values of A0, A1 %
                    solution = linsolve(A,B); 
                    a_0 = solution(1); 
                    a_1 = solution(2);
                   
                    a = 10^a_0;
                    b = a_1; 
                    
                    % Saving the value of a in the application %
                    app.a.Text = string(a); 
                    % Saving the value of b in the application %
                    app.b.Text = string(b);
                    
                    xgraph = linspace(min(data(:,1)) , max(data(:,1)) , 1000);
                    ygraph = a*xgraph.^b; 
                    plot(xgraph , ygraph);
                    title('Power Model');
                    
                    % Getting the average of the y values using function mean() %
                    avrg = mean(y); 
                    % Getting the value of st from the equation giving before %
                    st = sum((y - avrg).^2); 
                    % Getting the value of sr from the equation giving before %
                    sr = sum((y- a_0 - x.*a_1 ).^2); 
                    % Getting the value of r  from the equation giving before %
                    r = sqrt((st - sr)/st); 
                    % Saving the value of Correlation in the application %
                    app.r.Text = string(r); 
            end
        end

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure %
            app.UIFigure = uifigure;
            % Put the color of the Figure in RGB values %
            app.UIFigure.Color = [0.9 0.9 0.9];
            % [left bottom width height] %
            app.UIFigure.Position = [100 100 329 550];
            % The Figure Header Name %
            app.UIFigure.Name = 'Linear Regression Figure';
            
            % Create SolveButton
            app.SolveButton = uibutton(app.UIFigure, 'push');
            % Call Back Function that when the Button is Pressed, it goes into %
            % the main function to start the application Functionality %
            app.SolveButton.ButtonPushedFcn = createCallbackFcn(app, @SolveButtonPushed, true);
            % Put the color of the Figure in RGB values %
            app.SolveButton.BackgroundColor = [1 0.7 0.2];
            app.SolveButton.FontSize = 20;
            % Put the font color of the Figure in RGB values %
            app.SolveButton.FontColor = [1 1 1];
            % [left bottom width height] %
            app.SolveButton.Position = [26 64 277 34];
            app.SolveButton.Text = 'Solve';
            
            
            % Create BestButton
            app.SolveButton = uibutton(app.UIFigure, 'push');
            % Call Back Function that when the Button is Pressed, it goes into %
            % the main function to start the application Functionality %
            app.SolveButton.ButtonPushedFcn = createCallbackFcn(app, @BestButtonPushed, true);
            % Put the color of the Figure in RGB values %
            app.SolveButton.BackgroundColor = [0.5 0.7 0.2];
            app.SolveButton.FontSize = 20;
            % Put the font color of the Figure in RGB values %
            app.SolveButton.FontColor = [1 1 1];
            % [left bottom width height] %
            app.SolveButton.Position = [26 20 277 34];
            app.SolveButton.Text = 'Best ?';
            
            % Create DropDown
            app.DropDown = uidropdown(app.UIFigure);
            % The Main Three Moods of the Application %
            app.DropDown.Items = {'Linear Model', 'Exponential Model', 'Power Model', 'Growth Rate Model'};
            app.DropDown.FontSize = 16;
            % [left bottom width height] %
            app.DropDown.Position = [26 124 277 24];
            app.DropDown.Value = 'Linear Model';
            
            % Create LinearRegressionLabel
            app.LinearRegressionLabel = uilabel(app.UIFigure);
            % Put the color of the Figure in RGB values %
            app.LinearRegressionLabel.BackgroundColor = [0.9 0.9 0.9];
            app.LinearRegressionLabel.FontSize = 28;
            % [left bottom width height] %
            app.LinearRegressionLabel.Position = [45 504 253 34];
            app.LinearRegressionLabel.Text = 'Linear Regression';
            
            % Create DataLabel
            app.DataLabel = uilabel(app.UIFigure);
            app.DataLabel.FontSize = 20;
            % [left bottom width height] %
            app.DataLabel.Position = [139 457 49 25];
            app.DataLabel.Text = 'Data';
            
            % Create ModelLabel
            app.ModelLabel = uilabel(app.UIFigure);
            app.ModelLabel.FontSize = 20;
            % [left bottom width height] %
            app.ModelLabel.Position = [140 157 58 25];
            app.ModelLabel.Text = 'Model';
            
            % Create aLabel
            app.aLabel = uilabel(app.UIFigure);
            app.aLabel.FontSize = 16;
            % [left bottom width height] %
            app.aLabel.Position = [28 192 31 25];
            app.aLabel.Text = 'a : ';
            
            % Create a
            app.a = uilabel(app.UIFigure);
            app.a.BackgroundColor = [1 1 0.9];
            app.a.FontSize = 14;
            % [left bottom width height] %
            app.a.Position = [58 192 57 25];
            app.a.Text = '        ';

            % Create bLabel
            app.bLabel = uilabel(app.UIFigure);
            app.bLabel.FontSize = 16;
            % [left bottom width height] %
            app.bLabel.Position = [122 193 27 22];
            app.bLabel.Text = 'b : ';
            
            % Create b
            app.b = uilabel(app.UIFigure);
            % Put the background color of the Figure in RGB values %
            app.b.BackgroundColor = [1 1 0.9];
            app.b.FontSize = 14;
            % [left bottom width height] %
            app.b.Position = [148 192 66 25];
            app.b.Text = '        ';

            % Create rLabel
            app.rLabel = uilabel(app.UIFigure);
            app.rLabel.FontSize = 16;
            % [left bottom width height] %
            app.rLabel.Position = [221 193 25 22];
            app.rLabel.Text = 'r : ';
            
            % Create r
            app.r = uilabel(app.UIFigure);
            % Put the background color of the Figure in RGB values %
            app.r.BackgroundColor = [1 1 0.9];
            app.r.FontSize = 16;
            % [left bottom width height] %
            app.r.Position = [245 193 60 24];
            app.r.Text = '        ';
            
            % Create UITable
            app.UITable = uitable(app.UIFigure);
            app.UITable.ColumnName = {'X'; 'Y'};
            app.UITable.RowName = {};
            app.UITable.ColumnEditable = true;
            app.UITable.FontSize = 16;
            % [left bottom width height] %
            app.UITable.Position = [28 280 277 168];

            % Create AddnewpointButton
            app.AddnewpointButton = uibutton(app.UIFigure, 'push');
            % Call Back Function that when the Button is Pressed, it goes into %
            % the function which responsible for add new point in the table %
            app.AddnewpointButton.ButtonPushedFcn = createCallbackFcn(app, @AddnewpointButtonPushed, true);
            % Put the color of the Figure in RGB values %
            app.AddnewpointButton.BackgroundColor = [0.6 0.67 0.18];
            app.AddnewpointButton.FontSize = 18;
            % Put the color of the Figure in RGB values %
            app.AddnewpointButton.FontColor = [1 1 1];
            % [left bottom width height] %
            app.AddnewpointButton.Position = [26 233 277 34];
            app.AddnewpointButton.Text = 'Add Point';

        end
    end
    
    methods (Access = public)
       
        % Construct app
        function app = scratch
            
            % Configure App Components
            createComponents(app)
            
            % Register App Designe
            registerApp(app, app.UIFigure)
            
            % Run Startup Function
            runStartupFcn(app, @startupFcn)
            
            if nargout == 0
                clear app
            end
        end
        
        % Code Executes before Deletion
        function delete(app)
            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end