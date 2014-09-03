function varargout = LookupTable_GUIE_pixel(varargin)
% LOOKUPTABLE_GUIE_PIXEL MATLAB code for LookupTable_GUIE_pixel.fig
%      LOOKUPTABLE_GUIE_PIXEL, by itself, creates a new LOOKUPTABLE_GUIE_PIXEL or raises the existing
%      singleton*.
%
%      H = LOOKUPTABLE_GUIE_PIXEL returns the handle to a new LOOKUPTABLE_GUIE_PIXEL or the handle to
%      the existing singleton*.
%
%      LOOKUPTABLE_GUIE_PIXEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LOOKUPTABLE_GUIE_PIXEL.M with the given input arguments.
%
%      LOOKUPTABLE_GUIE_PIXEL('Property','Value',...) creates a new LOOKUPTABLE_GUIE_PIXEL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before LookupTable_GUIE_pixel_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to LookupTable_GUIE_pixel_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help LookupTable_GUIE_pixel

% Last Modified by GUIDE v2.5 06-May-2014 12:33:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @LookupTable_GUIE_pixel_OpeningFcn, ...
                   'gui_OutputFcn',  @LookupTable_GUIE_pixel_OutputFcn, ...
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


% --- Executes just before LookupTable_GUIE_pixel is made visible.
function LookupTable_GUIE_pixel_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to LookupTable_GUIE_pixel (see VARARGIN)

% Choose default command line output for LookupTable_GUIE_pixel
handles.output = hObject;
 
set(handles.zSlider, 'Max', 151);
set(handles.zSlider, 'Min', 1);
set(handles.zSlider, 'SliderStep', [1/151, 2/151]);

set(handles.PixelSlider1, 'Max', 256);
set(handles.PixelSlider1, 'Min', 1);
set(handles.PixelSlider1, 'SliderStep', [1/255, 2/255]);

set(handles.PixelSlider2, 'Max', 256);
set(handles.PixelSlider2, 'Min', 1);
set(handles.PixelSlider2, 'SliderStep', [1/255, 2/255]);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes LookupTable_GUIE_pixel wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = LookupTable_GUIE_pixel_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in LoadLookUpTable.
function loadLUT_Callback(hObject, eventdata, handles)
% hObject    handle to LoadLookUpTable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global data

%  read file from dialog box
set(handles.loadLUT, 'Enable', 'off');
[FileName1,PathName1] = uigetfile({'*.mat', 'MATLAB .mat files'},'Select the lookup table');
if PathName1 ~= 0;
    a = load([PathName1, FileName1]);
    handles.data = a.pp;
    axes(handles.PixelImage1);
    handles.data = a.pp;
    axes(handles.PixelImage2);

end
set(handles.loadLUT, 'Enable', 'on');
curr_slice = round(get(handles.zSlider,'Value'));

curr_pixel1 = round(get(handles.PixelSlider1,'Value'));
curr_pixel2 = round(get(handles.PixelSlider2,'Value'));

z_Value=num2str(curr_slice);
set(handles.zValue, 'String', z_Value);

data = handles.data;

axes(handles.PixelImage1);
pixel_number1=num2str(curr_pixel1);
set(handles.pixelNum1, 'String', pixel_number1);
imagesc(data(:,:,curr_slice,curr_pixel1)); 

axes(handles.PixelImage2);
pixel_number2=num2str(curr_pixel2);
set(handles.pixelNum2, 'String', pixel_number2);
imagesc(data(:,:,curr_slice,curr_pixel2)); 

axes(handles.shifting)
shifting_pixel1_Callback(hObject, eventdata, handles);

axes(handles.shifting2)
shifting_pixel2_Callback(hObject, eventdata, handles);

% Update handles structure
% guidata(hObject, handles);



% --- Executes on Z-slider movement.
function zSlider_Callback(hObject, eventdata, handles)
% hObject    handle to zSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global data

axes(handles.PixelImage1);
curr_slice = round(get(handles.zSlider,'Value'));
curr_pixel1 = round(get(handles.PixelSlider1,'Value'));
imagesc(data(:,:,curr_slice, curr_pixel1));

axes(handles.PixelImage2);
curr_slice = round(get(handles.zSlider,'Value'));
curr_pixel2 = round(get(handles.PixelSlider2,'Value'));
imagesc(data(:,:,curr_slice, curr_pixel2));

z_value=num2str(curr_slice);
set(handles.zValue, 'String', z_value);

guidata(gcf, handles);

% button_state = get(handles.LinLogConvert, 'Value');

flag1 = get(handles.fitting1, 'Value');
flag2 = get(handles.fitting2, 'Value');



if flag1 == 1 && flag2 == 0
    axes(handles.PixelImage1);
    fittingCalculation1(flag1);
    
elseif flag1 == 0 && flag2 == 1 
    axes(handles.PixelImage2);
    fittingCalculation2(flag2);
    
elseif flag1 == 1 && flag2 == 1 
    axes(handles.PixelImage1);
    fittingCalculation1(flag1);
    
    axes(handles.PixelImage2);
    fittingCalculation2(flag2);
    
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


% --- Executes on Pixel1-slider movement.
function PixelSlider1_Callback(hObject, eventdata, handles)
% hObject    handle to PixelSlider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data

curr_slice = round(get(handles.zSlider,'Value'));
curr_pixel1 = round(get(handles.PixelSlider1,'Value'));

% h=gca;

axes(handles.PixelImage1);
imagesc(data(:,:,curr_slice,curr_pixel1));

pixel_number1=num2str(curr_pixel1);
set(handles.pixelNum1, 'String', pixel_number1);

flag1 = get(handles.fitting1, 'Value');


if flag1 == 1 
    axes(handles.PixelImage1);
    fittingCalculation1(flag1);
    
    axes(handles.shifting)
    shifting_pixel1_Callback(hObject, eventdata, handles);

else

    axes(handles.shifting)
    shifting_pixel1_Callback(hObject, eventdata, handles);

end


% --- Executes during object creation, after setting all properties.
function PixelSlider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PixelSlider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on Pixel2-slider movement.
function PixelSlider2_Callback(hObject, eventdata, handles)
% hObject    handle to PixelSlider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data

curr_slice = round(get(handles.zSlider,'Value'));
curr_pixel2 = round(get(handles.PixelSlider2,'Value'));
% h=gca;

% axes(handles.PixelImage1);
% imagesc(handles.data(:,:,curr_slice,curr_pixel1)); 

axes(handles.PixelImage2);
imagesc(data(:,:,curr_slice,curr_pixel2)); 

pixel_number2=num2str(curr_pixel2);
set(handles.pixelNum2, 'String', pixel_number2);

flag2 = get(handles.fitting2, 'Value');

if  flag2 == 1 
    axes(handles.PixelImage2);
    fittingCalculation2(flag2);
    
    axes(handles.shifting2)
    shifting_pixel2_Callback(hObject, eventdata, handles);
else 
    axes(handles.shifting2)
    shifting_pixel2_Callback(hObject, eventdata, handles);
    
end


% --- Executes during object creation, after setting all properties.
function PixelSlider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PixelSlider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Getting current Pixel1-number.
function pixelNum1_Callback(hObject, eventdata, handles)
% hObject    handle to pixelNum1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data

n1 = str2double(get(handles.pixelNum1,'String'));
n1 = double(n1);

set(handles.PixelSlider1, 'Value', n1);

curr_slice = round(get(handles.zSlider,'Value'));
h=gca;
imagesc(data(:,:,curr_slice,n1), 'Parent', h);
% Hints: get(hObject,'String') returns contents of pixelNum1 as text
%        str2double(get(hObject,'String')) returns contents of pixelNum1 as a double


% --- Executes during object creation, after setting all properties.
function pixelNum1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pixelNum1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Getting current Pixel2-number.
function pixelNum2_Callback(hObject, eventdata, handles)
% hObject    handle to pixelNum2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data

n2 = str2double(get(handles.pixelNum2,'String'));
n2 = double(n2);

set(handles.PixelSlider1, 'Value', n2);

curr_slice = round(get(handles.zSlider,'Value'));
h=gca;
imagesc(data(:,:,curr_slice,n2), 'Parent', h);
% Hints: get(hObject,'String') returns contents of pixelNum2 as text
%        str2double(get(hObject,'String')) returns contents of pixelNum2 as a double


% --- Executes during object creation, after setting all properties.
function pixelNum2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pixelNum2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Getting current Z-value.
function zValue_Callback(hObject, eventdata, handles)
% hObject    handle to zValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data

n = str2double(get(handles.zValue,'String'));
n = double(n);

set(handles.zSlider, 'Value', n);

curr_pixel1 = round(get(handles.PixelSlider1,'Value'));
curr_pixel2 = round(get(handles.PixelSlider2,'Value'));

h1=gca;
axes(handles.PixelImage1);
imagesc(data(:,:,n,curr_pixel1), 'Parent', h1);

h2=gca;
axes(handles.PixelImage2);
imagesc(data(:,:,n,curr_pixel2), 'Parent', h2);

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



% --- Executes on button press in shifting.
function shifting_pixel1_Callback(hObject, eventdata, handles)
% hObject    handle to shifting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global data

% if shift == 1
    m = zeros(151,5);
    
    axes(handles.PixelImage1);
    for z = 1:size(data,3)
        
        curr_pixel1 = round(get(handles.PixelSlider1,'Value'));
       
        fit2 = data(:,:,z,curr_pixel1);
    
        fwhm1 = fix(0.4*max(max(fit2)));
        fwhm2 = fix(0.6*max(max(fit2)));
        
        [y,x]=find(fit2>fwhm1 & fit2<fwhm2);
        m(z,1) = z;
    
        shift_Fitting=fit_ellipse(x,y);

        m(z,2) = shift_Fitting.X0_in;
        m(z,3) = shift_Fitting.Y0_in;
    
    end
    
    for i = 1:size(m,1)
        
        m(i,4)=atand(sqrt((m(i,2)-m(1,2))^2+(m(i,3)-m(1,3))^2)/m(i,1));
    
    end
    
    axes(handles.shifting)
    axis([0,152,0,6])
    plot(m(:,1),m(:,4));
    

% end


% --- Executes on button press in fitting1.
function fitting1_Callback(hObject, eventdata, handles)
% hObject    handle to fitting1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

flag1 = get(handles.fitting1, 'Value');

guidata(gcf, handles);
fittingCalculation1(flag1);
% do not ever call guidata after this!!!


function fittingCalculation1(flag1)
myhandles = guidata(gcf);

global data

if flag1 == 1
    
    curr_slice = round(get(myhandles.zSlider,'Value'));
    curr_pixel1 = round(get(myhandles.PixelSlider1,'Value'));
    
    axes(myhandles.PixelImage1);
    fit = data(:,:,curr_slice,curr_pixel1);
    
    fwhm1 = fix(0.4*max(max(fit)));
    fwhm2 = fix(0.6*max(max(fit)));
        
    [y,x]=find(fit>fwhm1 & fit<fwhm2);
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
    
    plot(p(1,:),p(2,:),'r-','LineWidth', 1.2)
    plot(Fitting.X0_in,Fitting.Y0_in,'b+')  
    
    hold off
    
    myhandles.Fitting = Fitting;
    updateFittingInformation1(myhandles, 1);

else
    curr_slice = round(get(myhandles.zSlider,'Value'));
    curr_pixel1 = round(get(myhandles.PixelSlider1,'Value'));
    
    axes(myhandles.PixelImage1);
    imagesc(data(:,:,curr_slice,curr_pixel1));
    %guidata(gcf, myhandles);
     
end

% Hint: get(hObject,'Value') returns toggle state of fitting

function updateFittingInformation1(handles, fitting1)

if fitting1 == 1
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
set(handles.fittingInfo1, 'String', text);

guidata(gcf, handles);


% --- Executes on button press in fitting2.
function fitting2_Callback(hObject, eventdata, handles)
% hObject    handle to fitting2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

flag2 = get(handles.fitting2, 'Value');

guidata(gcf, handles);
fittingCalculation2(flag2);
% do not ever call guidata after this!!!


function fittingCalculation2(flag2)
myhandles2 = guidata(gcf);

global data

if flag2 == 1
    
    curr_slice = round(get(myhandles2.zSlider,'Value'));
    curr_pixel2 = round(get(myhandles2.PixelSlider2,'Value'));
    
    axes(myhandles2.PixelImage2);
    fit = data(:,:,curr_slice,curr_pixel2);
    
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
        
    plot(p(1,:),p(2,:),'r-','LineWidth', 1.2)
    plot(Fitting2.X0_in,Fitting2.Y0_in,'b+')
    
    hold off
    
    myhandles2.Fitting2 = Fitting2;
    updateFittingInformation2(myhandles2, 1);

else
    curr_slice = round(get(myhandles2.zSlider,'Value'));
    curr_pixel2 = round(get(myhandles2.PixelSlider2,'Value'));
    
    axes(myhandles2.PixelImage2);
    imagesc(data(:,:,curr_slice,curr_pixel2));
    %guidata(gcf, myhandles);
    
  
end

% Hint: get(hObject,'Value') returns toggle state of fitting

function updateFittingInformation2(handles, fitting2)

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


% --- Executes on button press in shifting_pixel2.
function shifting_pixel2_Callback(hObject, eventdata, handles)
% hObject    handle to shifting_pixel2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% guidata(gcf, handles);
% shift2 = get(handles.shifting_pixel2, 'Value');
% fittingForAll2(shift2);
% 
% 
% 
% function fittingForAll2(shift2)
% myhandles2 = guidata(gcf);

global data

% if shift2 == 1
    m = zeros(151,5);
    
    axes(handles.PixelImage2);
    for z = 1:size(data,3)
        
        curr_pixel2 = round(get(handles.PixelSlider2,'Value'));
       
        fit2 = data(:,:,z,curr_pixel2);
    
        fwhm1 = fix(0.4*max(max(fit2)));
        fwhm2 = fix(0.6*max(max(fit2)));
        
        [y,x]=find(fit2>fwhm1 & fit2<fwhm2);
        m(z,1) = z;
    
        shift2_Fitting=fit_ellipse(x,y);

        m(z,2) = shift2_Fitting.X0_in;
        m(z,3) = shift2_Fitting.Y0_in;
    
    end
    
    for i = 1:size(m,1)
        
        m(i,4)=atand(sqrt((m(i,2)-m(1,2))^2+(m(i,3)-m(1,3))^2)/m(i,1));
    
    end
    
    axes(handles.shifting2)
    axis([0,152,0,6])
    plot(m(:,1),m(:,4));
    

% end
