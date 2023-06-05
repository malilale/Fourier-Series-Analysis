classdef fourier < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        P0EditField                    matlab.ui.control.EditField
        P0EditFieldLabel               matlab.ui.control.Label
        F0EditField                    matlab.ui.control.EditField
        F0EditFieldLabel               matlab.ui.control.Label
        InputTypeSwitch                matlab.ui.control.Switch
        GoButton                       matlab.ui.control.StateButton
        a0EditField                    matlab.ui.control.EditField
        a0EditFieldLabel               matlab.ui.control.Label
        NumberofVariablesSpinner       matlab.ui.control.Spinner
        NumberofVariablesSpinnerLabel  matlab.ui.control.Label
        Graph2                         matlab.ui.control.UIAxes
        Graph1                         matlab.ui.control.UIAxes
    end

    
    properties (Access = private)
        
        nvariables=6; % Number of variables
        a; %ak coefficents
        F; % Frequencies
        Phase;
        F0=2; 
        stop_state=false; % Finish plotting boolean
    end
    
    methods (Access = private)
        
        %% Fourier Series with Coefficents only
        function Calc(app, N, t) 
                res=0;
                for k = 1:N-1
                    res = res + app.a(k)*exp(1j*2*pi*k*app.F0*t);
                end

                for i = 1:length(t)
                    result1 = 0;
                     ylim(app.Graph2,[-10, 10]);
                     xlim(app.Graph2,[-10, 10]);
                        
                    for k = 1:N-1
                    result2 = result1 + app.a(k)*exp(1j*2*pi*k*app.F0*t(i));
                    plot(app.Graph2,real([result1 result2]),imag([result1 result2]));
                        %plot from previous signal sum(result1) to current sum (result2)

                    result1 = result2;
                    hold(app.Graph2,"on")
                    end
                     hold(app.Graph2,"off")
                
                   plot(app.Graph1,(1:i),(real(res(1:i))));
                   xlim(app.Graph1,[0, length(t)]);
                   ylim(app.Graph1,[-10, 10]);
                  
                     drawnow
                     if(app.stop_state) %Finish plotting
                         break
                     end
                end
        end
        
        %% Fourier Series with Coefficents, Frequency and Phase
        function CalcWithPhase(app,N,t)
                res=app.a(1);
                for k = 2:N
                    res = res + app.a(k)*cos(2*pi*app.F(k)*t + app.Phase(k));
                end
                
                for i = 1:length(t)
                    plot(app.Graph1,(1:i),res(1:i)); 
                    xlim(app.Graph1,[0, length(t)]);
                  
                    drawnow
                    if(app.stop_state)  %Finish plotting
                        break
                    end
                end
        end
        %% 
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            clc;
            for i = 2:12
                %% Create a0EditFieldLabel
                app.a0EditFieldLabel(i) = uilabel(app.UIFigure);
                app.a0EditFieldLabel(i).HorizontalAlignment = 'right';
                app.a0EditFieldLabel(i).Text = ['a',int2str(i-1)];
    
                %% Create a0EditField
                app.a0EditField(i) = uieditfield(app.UIFigure, 'text');
                app.a0EditField(i).Tag = int2str(i);

                %% Create F0EditFieldLabel
                app.F0EditFieldLabel(i) = uilabel(app.UIFigure);
                app.F0EditFieldLabel(i).HorizontalAlignment = 'right';
                app.F0EditFieldLabel(i).Text = ['F',int2str(i-1)];
    
                %% Create F0EditField
                app.F0EditField(i) = uieditfield(app.UIFigure, 'text');
                app.F0EditField(i).Tag = int2str(i);

                %% Create P0EditFieldLabel
                app.P0EditFieldLabel(i) = uilabel(app.UIFigure);
                app.P0EditFieldLabel(i).HorizontalAlignment = 'right';
                app.P0EditFieldLabel(i).Text = ['Phase',int2str(i-1)];
    
                %% Create P0EditField
                app.P0EditField(i) = uieditfield(app.UIFigure, 'text');
                app.P0EditField(i).Tag = int2str(i);

                %% Callback
                app.a0EditField(i).ValueChangedFcn = createCallbackFcn(app, @a0EditFieldValueChanged, true);
                app.F0EditField(i).ValueChangedFcn = createCallbackFcn(app, @F0EditFieldValueChanged, true);
                app.P0EditField(i).ValueChangedFcn = createCallbackFcn(app, @P0EditFieldValueChanged, true);
                   
                %% positions
                if i<7
                    %a positions
                    app.a0EditFieldLabel(i).Position = [45 250-35*(i-1) 25 22];
                    app.a0EditField(i).Position = [85 250-35*(i-1) 105 22];

                    %F positions
                    app.F0EditFieldLabel(i).Position = [140 (250-35*(i-1)) 25 22];
                    app.F0EditField(i).Position = [180 250-35*(i-1) 50 22];

                    %Phase positions
                    app.P0EditFieldLabel(i).Position = [235 250-35*(i-1) 50 22];
                    app.P0EditField(i).Position = [290 250-35*(i-1) 50 22];

                    %invisible F,P
                    app.F0EditField(i).Visible="off";
                    app.F0EditFieldLabel(i).Visible="off";
                    app.P0EditField(i).Visible="off";
                    app.P0EditFieldLabel(i).Visible="off";
                else
                    app.a0EditFieldLabel(i).Position = [370 250-35*(i-7) 25 22];
                    app.a0EditField(i).Position = [410 250-35*(i-7) 105 22];

                    %F positions
                    app.F0EditFieldLabel(i).Position = [465 (250-35*(i-7)) 25 22];
                    app.F0EditField(i).Position = [505 250-35*(i-7) 50 22];

                    %Phase positions
                    app.P0EditFieldLabel(i).Position = [560 250-35*(i-7) 50 22];
                    app.P0EditField(i).Position = [625 250-35*(i-7) 50 22];

                    %invisible a
                    app.a0EditField(i).Visible="off";
                    app.a0EditFieldLabel(i).Visible="off";
                    %invisible F,P
                    app.F0EditField(i).Visible="off";
                    app.F0EditFieldLabel(i).Visible="off";
                    app.P0EditField(i).Visible="off";
                    app.P0EditFieldLabel(i).Visible="off";
                end
                
            end
            
        end

        % Value changed function: NumberofVariablesSpinner
        function NumberofVariablesSpinnerValueChanged(app, event)
            value = app.NumberofVariablesSpinner.Value;
            app.nvariables = value;
            for i = 2:value
                %% show a(k) boxes
                app.a0EditField(i).Visible="on";
                app.a0EditFieldLabel(i).Visible="on";

                %% show F and Phase boxes
                if(app.InputTypeSwitch.Value=="With Phase and Frequency") 
                    app.F0EditField(i).Visible="on";
                    app.F0EditFieldLabel(i).Visible="on";
                    app.P0EditField(i).Visible="on";
                    app.P0EditFieldLabel(i).Visible="on";
                end
            end

            for i = 12:-1:value+1
                %% hide a(k) boxes above N
                app.a0EditField(i).Visible="off";
                app.a0EditFieldLabel(i).Visible="off";

                %% hide F and Phase boxes
                if(app.InputTypeSwitch.Value=="With Phase and Frequency") 
                    app.F0EditField(i).Visible="off";
                    app.F0EditFieldLabel(i).Visible="off";
                    app.P0EditField(i).Visible="off";
                    app.P0EditFieldLabel(i).Visible="off";
                end
            end
            
        end

        % Value changed function: a0EditField
        function a0EditFieldValueChanged(app, event)
            value = event.Source.Value;
                %put given coefficents to a array
            index=str2num(event.Source.Tag);
            app.a(index) = eval(value);

        end

        % Value changed function: GoButton
        function GoButtonValueChanged(app, event)
            value = app.GoButton.Text;
            N = app.nvariables;
            Fs=100;
            t = 0:1/Fs:N;
            if strcmp(value,"Go")
                app.GoButton.Text = "Finish";
                app.stop_state=false;
                if (app.InputTypeSwitch.Value=="With Phase and Frequency")
                    app.CalcWithPhase(N,t);
                else
                    app.Calc(N,t);
                end
            elseif strcmp(value,"Finish")
                app.GoButton.Text = "Go";
                app.stop_state=true;    
            end
        end

        % Value changed function: InputTypeSwitch
        function InputTypeSwitchValueChanged(app, event)
            value = app.InputTypeSwitch.Value;
            spinner=app.NumberofVariablesSpinner.Value;
            if value=="With Phase and Frequency"
                w=50;
                % hide graph2
                app.Graph2.Visible="off";
                app.Graph1.set("Position",[12,283,700,272]);
                %% Show F and Phase boxes
                for i=2:spinner
                    app.F0EditField(i).Visible="on";
                    app.F0EditFieldLabel(i).Visible="on";  
                    app.P0EditField(i).Visible="on";
                    app.P0EditFieldLabel(i).Visible="on";
                end
            else
                w=105;
                app.Graph2.Visible="on";
                app.Graph1.set("Position",[12,283,368,272]);
               
                %% Hide F and Phase boxes
                for i=2:spinner
                    app.F0EditField(i).Visible="off";
                    app.F0EditFieldLabel(i).Visible="off";  
                    app.P0EditField(i).Visible="off";
                    app.P0EditFieldLabel(i).Visible="off";
                end
            end
            %% arrange width of a(k) boxes
             for i=1:12
                P=app.a0EditField(i).Position;
                app.a0EditField(i).set("Position",[P(1) P(2) w P(4)])
             end
        end

        % Value changed function: F0EditField
        function F0EditFieldValueChanged(app, event)
            value = event.Source.Value;
            %put given frequency values to F array
            index=str2num(event.Source.Tag);
                app.F(index) = eval(value);
        end

        % Value changed function: P0EditField
        function P0EditFieldValueChanged(app, event)
            value = event.Source.Value;
            %put given phase values to Phase array
            index=str2num(event.Source.Tag);
                app.Phase(index) = eval(value);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 724 565];
            app.UIFigure.Name = 'MATLAB App';

            % Create Graph1
            app.Graph1 = uiaxes(app.UIFigure);
            title(app.Graph1, 'Grafik1')
            xlabel(app.Graph1, 'Time')
            ylabel(app.Graph1, 'imaginer')
            zlabel(app.Graph1, 'Z')
            app.Graph1.YGrid = 'on';
            app.Graph1.Position = [12 283 368 272];

            % Create Graph2
            app.Graph2 = uiaxes(app.UIFigure);
            title(app.Graph2, 'Grafik2')
            xlabel(app.Graph2, 'Real')
            zlabel(app.Graph2, 'Z')
            app.Graph2.YGrid = 'on';
            app.Graph2.Position = [348 283 360 272];

            % Create NumberofVariablesSpinnerLabel
            app.NumberofVariablesSpinnerLabel = uilabel(app.UIFigure);
            app.NumberofVariablesSpinnerLabel.HorizontalAlignment = 'right';
            app.NumberofVariablesSpinnerLabel.FontSize = 14;
            app.NumberofVariablesSpinnerLabel.Position = [46 20 131 22];
            app.NumberofVariablesSpinnerLabel.Text = 'Number of Variables';

            % Create NumberofVariablesSpinner
            app.NumberofVariablesSpinner = uispinner(app.UIFigure);
            app.NumberofVariablesSpinner.Limits = [2 12];
            app.NumberofVariablesSpinner.RoundFractionalValues = 'on';
            app.NumberofVariablesSpinner.ValueDisplayFormat = '%.0f';
            app.NumberofVariablesSpinner.ValueChangedFcn = createCallbackFcn(app, @NumberofVariablesSpinnerValueChanged, true);
            app.NumberofVariablesSpinner.FontSize = 14;
            app.NumberofVariablesSpinner.Position = [184 20 63 22];
            app.NumberofVariablesSpinner.Value = 6;

            % Create a0EditFieldLabel
            app.a0EditFieldLabel = uilabel(app.UIFigure);
            app.a0EditFieldLabel.HorizontalAlignment = 'right';
            app.a0EditFieldLabel.Position = [45 250 25 22];
            app.a0EditFieldLabel.Text = 'a0';

            % Create a0EditField
            app.a0EditField = uieditfield(app.UIFigure, 'text');
            app.a0EditField.ValueChangedFcn = createCallbackFcn(app, @a0EditFieldValueChanged, true);
            app.a0EditField.Tag = '1';
            app.a0EditField.Position = [85 250 105 22];

            % Create GoButton
            app.GoButton = uibutton(app.UIFigure, 'state');
            app.GoButton.ValueChangedFcn = createCallbackFcn(app, @GoButtonValueChanged, true);
            app.GoButton.Text = 'Go';
            app.GoButton.Position = [280 19 100 23];

            % Create InputTypeSwitch
            app.InputTypeSwitch = uiswitch(app.UIFigure, 'slider');
            app.InputTypeSwitch.Items = {'Only Coefficients', 'With Phase and Frequency'};
            app.InputTypeSwitch.ValueChangedFcn = createCallbackFcn(app, @InputTypeSwitchValueChanged, true);
            app.InputTypeSwitch.Position = [502 20 45 20];
            app.InputTypeSwitch.Value = 'Only Coefficients';

            % Create F0EditFieldLabel
            app.F0EditFieldLabel = uilabel(app.UIFigure);
            app.F0EditFieldLabel.HorizontalAlignment = 'right';
            app.F0EditFieldLabel.Visible = 'off';
            app.F0EditFieldLabel.Position = [140 250 25 22];
            app.F0EditFieldLabel.Text = 'F0';

            % Create F0EditField
            app.F0EditField = uieditfield(app.UIFigure, 'text');
            app.F0EditField.InputType = 'digits';
            app.F0EditField.ValueChangedFcn = createCallbackFcn(app, @F0EditFieldValueChanged, true);
            app.F0EditField.Tag = '1';
            app.F0EditField.Visible = 'off';
            app.F0EditField.Position = [180 250 50 22];

            % Create P0EditFieldLabel
            app.P0EditFieldLabel = uilabel(app.UIFigure);
            app.P0EditFieldLabel.HorizontalAlignment = 'right';
            app.P0EditFieldLabel.Visible = 'off';
            app.P0EditFieldLabel.Position = [240 250 45 22];
            app.P0EditFieldLabel.Text = 'Phase0';

            % Create P0EditField
            app.P0EditField = uieditfield(app.UIFigure, 'text');
            app.P0EditField.InputType = 'digits';
            app.P0EditField.ValueChangedFcn = createCallbackFcn(app, @P0EditFieldValueChanged, true);
            app.P0EditField.Tag = '1';
            app.P0EditField.Visible = 'off';
            app.P0EditField.Position = [290 250 50 22];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = fourier

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