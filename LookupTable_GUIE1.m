    function varargout = LookupTable_GUIE1(varargin)
% LOOKUPTABLE_GUIE1 MATLAB code for LookupTable_GUIE1.fig
%      LOOKUPTABLE_GUIE1, by itself, creates a new LOOKUPTABLE_GUIE1 or raises the existing
%      singleton*.
%
%      H = LOOKUPTABLE_GUIE1 returns the handle to a new LOOKUPTABLE_GUIE1 or the handle to
%      the existing singleton*.
%
%      LOOKUPTABLE_GUIE1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LOOKUPTABLE_GUIE1.M with the given input arguments.
%
%      LOOKUPTABLE_GUIE1('Property','Value',...) creates a new LOOKUPTABLE_GUIE1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LookupTable_GUIE1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LookupTable_GUIE1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LookupTable_GUIE1

% Last Modified by GUIDE v2.5 06-May-2014 13:38:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LookupTable_GUIE1_OpeningFcn, ...
                   'gui_OutputFcn',  @LookupTable_GUIE1_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before LookupTable_GUIE1 is made visible.
function LookupTable_GUIE1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LookupTable_GUIE1 (see VARARGIN)

% make sure the data refresh when active 
clear -global data2;
clear -global data1;

% Choose default command line output for LookupTable_GUIE1
handles.output = hObject;
 
% set the Max/Min for sliders
set(handles.zSlider, 'Max', 151);
set(handles.zSlider, 'Min', 1);
set(handles.zSlider, 'SliderStep', [1/151, 2/151]);

set(handles.pixelSlider, 'Max', 256);
set(handles.pixelSlider, 'Min', 1);
set(handles.pixelSlider, 'SliderStep', [1/255, 2/255]);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LookupTable_GUIE1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%handles.zListener = addlistener(handles.zSlider,'ContinuousValueChange',@zListenerFunction);



% --- Outputs from this function are returned to the command line.
function varargout = LookupTable_GUIE1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in LoadLookUpTable.
function LoadLookUpTable_Callback(hObject, eventdata, handles)
% hObject    handle to LoadLookUpTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global data1

%  read file from dialog box
set(handles.LoadLookUpTable, 'Enable', 'off');
[FileName1,PathName1] = uigetfile({'*.mat', 'MATLAB .mat files'},'Select the lookup table');
if PathName1 ~= 0;
    a = load([PathName1, FileName1]);
    handles.data = a.pp;
    axes(handles.loadImage);
end
set(handles.LoadLookUpTable, 'Enable', 'on');

curr_slice = round(get(handles.zSlider,'Value'));
curr_pixel = round(get(handles.pixelSlider,'Value'));

z_Value=num2str(curr_slice);
set(handles.zValue, 'String', z_Value);
pixel_number=num2str(curr_pixel);
set(handles.PixelNumber, 'String', pixel_number);

data1= handles.data;

imagesc(data1(:,:,curr_slice,curr_pixel)); 

axes(handles.plotShifting)
plotShift_Callback(hObject, eventdata, handles);



% --- Getting current Z-value.
function zValue_Callback(hObject, eventdata, handles)
% hObject    handle to zValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global data1
global data2

n = str2double(get(handles.zValue,'String'));
n = double(n);


set(handles.zSlider, 'Value', n);

curr_pixel = round(get(handles.pixelSlider,'Value'));

axes(handles.loadImage);
imagesc(data1(:,:,n,curr_pixel));
axes(handles.data2);
imagesc(data2(:,:,n,curr_pixel));

% Hints: get(hObject,'String') returns contents of zValue as text
%        str2double(get(hObject,'String')) returns contents of zValue as a double


% --- Executes during object creation, after setting all properties.
function zValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Getting current Pixel-number.
function PixelNumber_Callback(hObject, eventdata, handles)
% hObject    handle to PixelNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global data1
global data2 

n = str2double(get(handles.PixelNumber,'String'));
n = double(n);

set(handles.pixelSlider, 'Value', n);

curr_slice = round(get(handles.zSlider,'Value'));
% h=gca;
axes(handles.loadImage);
imagesc(data1(:,:,curr_slice,n));
axes(handles.data2);
imagesc(data2(:,:,curr_slice,n));

% Hints: get(hObject,'String') returns contents of PixelNumber as text
%        str2double(get(hObject,'String')) returns contents of PixelNumber as a double


% --- Executes during object creation, after setting all properties.
function PixelNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PixelNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on Pixel-slider movement.
function pixelSlider_Callback(hObject, eventdata, handles)
% hObject    handle to pixelSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global data1
global data2 

curr_slice = round(get(handles.zSlider,'Value'));
curr_pixel = round(get(handles.pixelSlider,'Value'));

axes(handles.loadImage);
imagesc(data1(:,:,curr_slice,curr_pixel)); 
axes(handles.data2);
imagesc(data2(:,:,curr_slice,curr_pixel)); 

pixel_number=num2str(curr_pixel);
set(handles.PixelNumber, 'String', pixel_number);


flag = get(handles.fitting, 'Value');
flag2 = get(handles.fitting2, 'Value');
button_state = get(handles.LinLogConvert, 'Value');
guidata(gcf, handles);

% hold the pixelSlider in different situation 
if button_state == 1
    linlogCalculation(button_state);
    
    axes(handles.plotShifting)
    plotShift_Callback(hObject, eventdata, handles)
    
    axes(handles.plotShifting2)
    plotShift2_Callback(hObject, eventdata, handles)
    
elseif flag == 1 && flag2 == 0
    axes(handles.loadImage)
    fittingCalculation(flag,'pixelSlider')
    
    axes(handles.plotShifting)
    plotShift_Callback(hObject, eventdata, handles)
    
    axes(handles.plotShifting2)
    plotShift2_Callback(hObject, eventdata, handles)
    
elseif flag == 0 && flag2 == 1
    axes(handles.loadImage)
    fitting2Calculation(flag2,'pixelSlider')
    
    axes(handles.plotShifting)
    plotShift_Callback(hObject, eventdata, handles)
    
    axes(handles.plotShifting2)
    plotShift2_Callback(hObject, eventdata, handles)

elseif flag == 1 && flag2 == 1
    axes(handles.loadImage)
    fittingCalculation(flag,'pixelSlider')
    axes(handles.loadImage)
    fitting2Calculation(flag2,'pixelSlider')
    
    axes(handles.plotShifting)
    plotShift_Callback(hObject, eventdata, handles)
    
    
    axes(handles.plotShifting2)
    plotShift2_Callback(hObject, eventdata, handles)
else
    axes(handles.plotShifting)
    plotShift_Callback(hObject, eventdata, handles)
    
    axes(handles.plotShifting2)
    plotShift2_Callback(hObject, eventdata, handles)
    
    DecreaseOfcount_Callback(hObject, eventdata, handles);
end


% --- Executes during object creation, after setting all properties.
function pixelSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pixelSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes on Z-slider movement.
function zSlider_Callback(hObject, eventdata, handles)
% hObject    handle to zSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global data1
global data2

curr_slice = round(get(handles.zSlider,'Value'));
curr_pixel = round(get(handles.pixelSlider,'Value'));

axes(handles.loadImage);
imagesc(data1(:,:,curr_slice, curr_pixel));
axes(handles.data2);
imagesc(data2(:,:,curr_slice, curr_pixel));

z_value=num2str(curr_slice);
set(handles.zValue, 'String', z_value);

guidata(gcf, handles);


flag = get(handles.fitting, 'Value');
flag2 = get(handles.fitting2, 'Value');
button_state = get(handles.LinLogConvert, 'Value');

% hold the zSlider in different situation 
if flag == 1 && flag2 == 0 && button_state == 0
    axes(handles.loadImage);
    fittingCalculation(flag,'zSlider');
    
elseif flag == 0 && flag2 == 1 && button_state == 0
    axes(handles.data2);
    fitting2Calculation(flag2,'zSlider');
    
elseif flag == 0 && flag2 == 0 && button_state == 1
    linlogCalculation(button_state);
    
elseif flag == 1 && flag2 == 1 && button_state == 0
    axes(handles.loadImage);
    fittingCalculation(flag,'zSlider');
    axes(handles.data2);
    fitting2Calculation(flag2,'zSlider');
    
elseif flag == 1 && flag2 == 0 && button_state == 1
    axes(handles.loadImage);
    fittingCalculation(flag,'zSlider');
    linlogCalculation(button_state);
    
elseif flag == 0 && flag2 == 1 && button_state == 1
    axes(handles.data2);
    fitting2Calculation(flag2,'zSlider');
    linlogCalculation(button_state);
    
else 
    axes(handles.loadImage);
    fittingCalculation(flag,'zslider');
    axes(handles.data2);
    fitting2Calculation(flag2,'zslider');
    linlogCalculation(button_state);
end


% --- Executes during object creation, after setting all properties.
function zSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



% --- Executes on selection change in Colormap.
function Colormap_Callback(hObject, eventdata, handles)
% hObject    handle to Colormap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get current selection of menu
ColorMapContents = cellstr(get(handles.Colormap,'String'));
ColormapSelect = ColorMapContents{get(handles.Colormap, 'Value')};

% select an action
switch ColormapSelect
    case 'jet'
        colormap(jet);
        caxis auto
        axes(handles.loadImage)
        hold on
        colorbar;
        axes(handles.data2)
        hold on
        colorbar;
    case 'hsv'
        colormap(hsv);
        caxis auto
        axes(handles.loadImage)
        hold on
        colorbar;
        axes(handles.data2)
        hold on
        colorbar;
    case 'hot'
        colormap(hot);
        caxis auto
        axes(handles.loadImage)
        hold on
        colorbar;
        axes(handles.data2)
        hold on
        colorbar;
    case 'cool'
        colormap(cool);        
        caxis auto
        axes(handles.loadImage)
        hold on
        colorbar;
        axes(handles.data2)
        hold on
        colorbar;
    case 'spring'
        colormap(spring);
        caxis auto
        axes(handles.loadImage)
        hold on
        colorbar;
        axes(handles.data2)
        hold on
        colorbar;
    case 'summer'
        colormap(summer);
        caxis auto
        axes(handles.loadImage)
        hold on
        colorbar;
        axes(handles.data2)
        hold on
        colorbar;
    case 'autum'
        colormap(autum);
        caxis auto
        axes(handles.loadImage)
        hold on
        colorbar;
        axes(handles.data2)
        hold on
        colorbar;
    case 'winter'
        colormap(winter);
        caxis auto
        axes(handles.loadImage)
        hold on
        colorbar;
        axes(handles.data2)
        hold on
        colorbar;
    case 'gray'
        colormap(gray);
        caxis auto
        axes(handles.loadImage)
        hold on
        colorbar;
        axes(handles.data2)
        hold on
        colorbar;
    case 'bone'
        colormap(bone);
        caxis auto
        axes(handles.loadImage)
        hold on
        colorbar;
        axes(handles.data2)
        hold on
        colorbar;
end


% --- Executes during object creation, after setting all properties.
function Colormap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Colormap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in LinLogConvert.
function LinLogConvert_Callback(hObject, eventdata, handles)
% hObject    handle to LinLogConvert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

button_state = get(handles.LinLogConvert,'Value');
handles.logimage = [];
handles.logimage_log = 0;

guidata(gcf, handles);
linlogCalculation(button_state);

flag = get(handles.fitting, 'Value');
flag2 = get(handles.fitting2, 'Value');


if flag == 1 && flag2 == 0 && button_state == 0
    axes(handles.loadImage);
    fittingCalculation(flag, 'LinLog');
    
elseif flag == 0 && flag2 == 1 && button_state == 0
    axes(handles.data2);
    fitting2Calculation(flag2, 'LinLog');
    
elseif flag == 0 && flag2 == 0 && button_state == 1
    linlogCalculation(button_state);
    
elseif flag == 1 && flag2 == 1 && button_state == 0
    axes(handles.loadImage);
    fittingCalculation(flag, 'LinLog');
    axes(handles.data2);
    fitting2Calculation(flag2, 'LinLog');
    
elseif flag == 1 && flag2 == 0 && button_state == 1
    axes(handles.loadImage);
    fittingCalculation(flag, 'LinLog');
    linlogCalculation(button_state);
    
elseif flag == 0 && flag2 == 1 && button_state == 1
    axes(handles.data2);
    fitting2Calculation(flag2, 'LinLog');
    linlogCalculation(button_state);
    
else 
    axes(handles.loadImage);
    fittingCalculation(flag, 'LinLog');
    axes(handles.data2);
    fitting2Calculation(flag2, 'LinLog');
    linlogCalculation(button_state);
end

% Hint: get(hObject,'Value') returns toggle state of LinLogConvert


function linlogCalculation(button_state)
myhandles2 = guidata(gcf);

global data1
global data2


if button_state == 1
    
    curr_slice = round(get(myhandles2.zSlider,'Value'));
    curr_pixel = round(get(myhandles2.pixelSlider,'Value'));

    image_log = log(double(data1(:,:,curr_slice,curr_pixel)+1));
    image_log2 = log(double(data2(:,:,curr_slice,curr_pixel)+1));

    myhandles2.logimage_log = myhandles2.logimage_log+1;
    myhandles2.logimage{myhandles2.logimage_log, 1} = image_log;
    myhandles2.logimage{myhandles2.logimage_log, 2} = image_log2;

    axes(myhandles2.loadImage);
    imagesc(myhandles2.logimage{myhandles2.logimage_log, 1});

    axes(myhandles2.data2);
    imagesc(myhandles2.logimage{myhandles2.logimage_log, 2});
    %guidata(gcf, handles);
       
else
    curr_slice = round(get(myhandles2.zSlider,'Value'));
    curr_pixel = round(get(myhandles2.pixelSlider,'Value'));
    
    axes(myhandles2.loadImage);
    imagesc(data1(:,:,curr_slice,curr_pixel));
    axes(myhandles2.data2);
    imagesc(data2(:,:,curr_slice,curr_pixel));
    
end
guidata(gcf, myhandles2);


% --- Executes on button press in fitting.
function fitting_Callback(hObject, eventdata, handles)
% hObject    handle to fitting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

flag = get(handles.fitting, 'Value');

handles.circles = [];
handles.circles_counter = 0;

guidata(gcf, handles);
fittingCalculation(flag,'directFitting');
%%%% do not ever call guidata after this!!!%%%%


function fittingCalculation(flag, origin)
myhandles = guidata(gcf);

global data1

if flag == 1
    
    curr_slice = round(get(myhandles.zSlider,'Value'));
    curr_pixel = round(get(myhandles.pixelSlider,'Value'));
    
    axes(myhandles.loadImage);
    fit = data1(:,:,curr_slice,curr_pixel);
    
    % get the full weight half max. value
    fwhm1 = fix(0.4*max(max(fit)));
    fwhm2 = fix(0.6*max(max(fit)));    
    [y,x]=find(fit>fwhm1 & fit<fwhm2);
    
    % start calculate the ellipse
    Fitting=fit_ellipse(x,y);
    num = 100;
    
    hold on

    theta = linspace(0,2*pi,num);
    p(1,:) = Fitting.a*cos(theta);
    p(2,:) = Fitting.b*sin(theta);

    axis equal
    
    phi = Fitting.phi*pi/180;
    Q = [cos(phi) -sin(phi)
    sin(phi)  cos(phi)];
    p = Q*p;
    p(1,:) = p(1,:) + Fitting.X0_in;
    p(2,:) = p(2,:) + Fitting.Y0_in;
    

    switch origin
        
        case 'pixelSlider'
        plot(p(1,:),p(2,:),'r-','LineWidth', 1.2)
        plot(Fitting.X0_in,Fitting.Y0_in,'b+')
    
        case 'zSlider'
            % save the positions in a cell array
            myhandles.circles_counter = myhandles.circles_counter+1;
            myhandles.circles{myhandles.circles_counter,1} = p(1,:);
            myhandles.circles{myhandles.circles_counter,2} = p(2,:);
            myhandles.circles{myhandles.circles_counter,3} = Fitting;
            myhandles.circles{myhandles.circles_counter,4} = myhandles.zValue;

            for i=1:size(myhandles.circles,1)
                plot(myhandles.circles{i,1},myhandles.circles{i,2},'r-','LineWidth', 1.2)
                plot(myhandles.circles{i,3}.X0_in,myhandles.circles{i,3}.Y0_in,'b+')     
            end
            
        case 'LinLogConvert'
            plot(p(1,:),p(2,:),'r-','LineWidth', 1.2)
            plot(Fitting.X0_in,Fitting.Y0_in,'b+')
            
        otherwise
            plot(p(1,:),p(2,:),'r-','LineWidth', 1.2)
            plot(Fitting.X0_in,Fitting.Y0_in,'b+')
            
    end    
   
    hold off
    
    myhandles.Fitting = Fitting;
    updateFittingInformation(myhandles, 1);

else
    myhandles.circles = [];
    myhandles.circles_counter = 0;
    curr_slice = round(get(myhandles.zSlider,'Value'));
    curr_pixel = round(get(myhandles.pixelSlider,'Value'));
    
    axes(myhandles.loadImage);
    imagesc(data1(:,:,curr_slice,curr_pixel));
    %guidata(gcf, myhandles);
     
end

% Hint: get(hObject,'Value') returns toggle state of fitting
% --- Executes on button press in fitting.


function updateFittingInformation(handles, fitting)

if fitting == 1 
radious1 = handles.Fitting.a;
radious2 = handles.Fitting.b;
center_X = handles.Fitting.X0_in;
center_Y = handles.Fitting.Y0_in;
angle = handles.Fitting.phi;  

else
radious1 = 0;
radious2 = 0;
center_X = 0;
center_Y = 0;
angle = 0;

end

text = sprintf('Radious1:\t%f\n Radious2:\t%f\n Center_X:\t%f\n Center_Y:\t%f\n Angle:\t%f\n',...
    radious1, radious2, center_X, center_Y, angle);
set(handles.fittingInfo, 'String', text);

guidata(gcf, handles);


% --- Executes on button press in DecreaseOfcount.
function DecreaseOfcount_Callback(hObject, eventdata, handles)
% hObject    handle to DecreaseOfcount (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

guidata(gcf, handles);

counts = get(handles.DecreaseOfcount, 'Value');
flag = get(handles.fitting, 'Value');
flag2 = get(handles.fitting2, 'Value');

if counts == 1
    DecreaseCalculation(counts);
    
elseif flag == 1 && flag2 == 0 
    axes(handles.loadImage);
    fittingCalculation(flag, 'LinLog');

elseif flag == 0 && flag2 == 1 
    axes(handles.data2);
    fitting2Calculation(flag2, 'LinLog');

elseif flag == 1 && flag2 == 1 

    axes(handles.loadImage);
    fittingCalculation(flag, 'LinLog');
    axes(handles.data2);
    fitting2Calculation(flag2, 'LinLog');

end


%Hint: get(hObject,'Value') returns toggle state of DecreaseOfcount

function DecreaseCalculation(counts)
handles = guidata(gcf);

global data1
global data2

if counts == 1
    
    axes(handles.loadImage)
    distance1 = 1:size(data1,3);
    axes(handles.data2)
    distance2 = 1:size(data2,3);
    
    curr_pixel = round(get(handles.pixelSlider,'Value'));
    
    axes(handles.loadImage)
    counts(distance1) = sum(sum(data1(:,:,distance1, curr_pixel)));
    plot(distance1,counts, 'r-')
    
    axes(handles.data2)
    counts(distance2) = sum(sum(data2(:,:,distance2, curr_pixel)));
    plot(distance2,counts, 'r-')
   
    
else
    curr_slice = round(get(handles.zSlider,'Value'));
    curr_pixel = round(get(handles.pixelSlider,'Value'));
    
    axes(handles.loadImage);
    imagesc(data1(:,:,curr_slice,curr_pixel));

    axes(handles.data2)
    imagesc(data2(:,:,curr_slice,curr_pixel));

end


% --- Executes on button press in plotShift.
function plotShift_Callback(hObject, eventdata, handles)
% hObject    handle to plotShift (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

guidata(gcf, handles);

global data1

m = zeros(151,5);
axes(handles.loadImage);

for z = 1:size(data1,3)

    curr_pixel = round(get(handles.pixelSlider,'Value'));

    fit2 = data1(:,:,z,curr_pixel);

    fwhm1 = fix(0.4*max(max(fit2)));
    fwhm2 = fix(0.6*max(max(fit2)));

    [y,x]=find(fit2>fwhm1 & fit2<fwhm2);
    m(z,1) = z;

    Fitting=fit_ellipse(x,y);

    m(z,2) = Fitting.X0_in;
    m(z,3) = Fitting.Y0_in; 

end

% calculation the shifting angles from the center x,y value from the
% ellipse fitting 
for i = 1:size(m,1)

    m(i,4)=atand(sqrt((m(i,2)-m(1,2))^2+(m(i,3)-m(1,3))^2)/m(i,1));

end

axes(handles.plotShifting)
axis([0,151,0,6])
zvalues = m(:,1);
angles = m(:,4);
plot(zvalues, angles);



% --- Executes on button press in LoadSimulation.
function LoadSimulation_Callback(hObject, eventdata, handles)
% hObject    handle to LoadSimulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global data2

set(handles.LoadSimulation, 'Enable', 'off');
[FileName1,PathName1] = uigetfile({'*.mat', 'MATLAB .mat files'},'Select the lookup table');
if PathName1 ~= 0;
    a = load([PathName1, FileName1]);
    handles.data_simulate = a.ww;
    axes(handles.data2);
end
set(handles.LoadSimulation, 'Enable', 'on');
curr_slice = round(get(handles.zSlider,'Value'));
curr_pixel = round(get(handles.pixelSlider,'Value'));

data2 = handles.data_simulate;
imagesc(data2(:,:,curr_slice,curr_pixel)); 

axes(handles.plotShifting2)
plotShift2_Callback(hObject, eventdata, handles)

% guidata(hObject, handles2);


% --- Executes on button press in fitting2.
function fitting2_Callback(hObject, eventdata, handles)
% hObject    handle to fitting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

flag2 = get(handles.fitting2, 'Value');

handles.circles2 = [];
handles.circles2_counter = 0;

guidata(gcf, handles);
fitting2Calculation(flag2, 'directFitting');
% do not ever call guidata after this!!!


function fitting2Calculation(flag2, origin)
myhandles4 = guidata(gcf);

global data2

if flag2 == 1
    
    curr_slice = round(get(myhandles4.zSlider,'Value'));
    curr_pixel = round(get(myhandles4.pixelSlider,'Value'));
  
    axes(myhandles4.data2);
    fit = data2(:,:,curr_slice,curr_pixel);
    
    fwhm1 = fix(0.4*max(max(fit)));
    fwhm2 = fix(0.6*max(max(fit)));
        
    [y,x]=find(fit>fwhm1 & fit<fwhm2);
    Fitting2=fit_ellipse(x,y);
    num = 100;
    
    hold on

    theta = linspace(0,2*pi,num);
    p(1,:) = Fitting2.a*cos(theta);
    p(2,:) = Fitting2.b*sin(theta);

    axis equal
    
    phi = Fitting2.phi*pi/180;
    Q = [cos(phi) -sin(phi)
    sin(phi)  cos(phi)];
    p = Q*p;
    p(1,:) = p(1,:) + Fitting2.X0_in;
    p(2,:) = p(2,:) + Fitting2.Y0_in;
        
    switch origin
        
        case 'pixelslider'
            
            plot(p(1,:), p(2,:), 'r-', 'LineWidth', 1.2);
            plot(Fitting2.X_in, Fitting2.Y0_in, 'b+');
            
        case 'zSlider'
            % save the positions in a cell array
            myhandles4.circles2_counter = myhandles4.circles2_counter+1;
            myhandles4.circles2{myhandles4.circles2_counter,1} = p(1,:);
            myhandles4.circles2{myhandles4.circles2_counter,2} = p(2,:);
            myhandles4.circles2{myhandles4.circles2_counter,3} = Fitting2;
            myhandles4.circles2{myhandles4.circles2_counter,4} = myhandles4.zValue;


            for i=1:size(myhandles4.circles2,1)
                plot(myhandles4.circles2{i,1},myhandles4.circles2{i,2},'r-','LineWidth', 1.2)
                plot(myhandles4.circles2{i,3}.X0_in,myhandles4.circles2{i,3}.Y0_in,'b+')     
            end
            
        case 'LinLogConvert'
            plot(p(1,:),p(2,:),'r-','LineWidth', 1.2)
            plot(Fitting.X0_in,Fitting.Y0_in,'b+')
        
        otherwise             
            plot(p(1,:), p(2,:), 'r-', 'LineWidth', 1.2);
            plot(Fitting2.X0_in, Fitting2.Y0_in, 'b+');
    end
    
    
    hold off
    
    myhandles4.Fitting2 = Fitting2;
    updateFitting2Information(myhandles4, 1);
 
else
    myhandles4.circles2 = [];
    myhandles4.circles2_counter = 0;
    curr_slice = round(get(myhandles4.zSlider,'Value'));
    curr_pixel = round(get(myhandles4.pixelSlider,'Value'));
    
    axes(myhandles4.data2);
    imagesc(data2(:,:,curr_slice,curr_pixel));
    %guidata(gcf, myhandles);
     
end
% Hint: get(hObject,'Value') returns toggle state of fitting


function updateFitting2Information(handles, fitting2)

if fitting2 == 1
radious1 = handles.Fitting2.a;
radious2 = handles.Fitting2.b;
center_X = handles.Fitting2.X0_in;
center_Y = handles.Fitting2.Y0_in;
angle = handles.Fitting2.phi;  

else
radious1 = 0;
radious2 = 0;
center_X = 0;
center_Y = 0;
angle = 0;
end

text = sprintf('Radious1:\t%f\n Radious2:\t%f\n Center_X:\t%f\n Center_Y:\t%f\n Angle:\t%f\n',...
    radious1, radious2, center_X, center_Y, angle);
set(handles.fittingInfo2, 'String', text);

guidata(gcf, handles);



% --- Executes on button press in plotShift2.
function plotShift2_Callback(hObject, eventdata, handles)
% hObject    handle to plotShift2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global data2

m = zeros(151,5);

axes(handles.data2);
    
for z = 1:size(data2,3)

    curr_pixel = round(get(handles.pixelSlider,'Value'));

    fit2 = data2(:,:,z,curr_pixel);

    fwhm1 = fix(0.4*max(max(fit2)));
    fwhm2 = fix(0.6*max(max(fit2)));

    [y,x]=find(fit2>fwhm1 & fit2<fwhm2);
    m(z,1) = z;

    Fitting2=fit_ellipse(x,y);

    m(z,2) = Fitting2.X0_in;
    m(z,3) = Fitting2.Y0_in;

end
 
for i = 1:size(m,1)

    m(i,4)=atand(sqrt((m(i,2)-m(1,2))^2+(m(i,3)-m(1,3))^2)/m(i,1));

end

axes(handles.plotShifting2)
axis([0,151,0,6])
plot(m(:,1),m(:,4));




