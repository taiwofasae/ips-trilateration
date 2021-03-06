function varargout = overall(varargin)
%OVERALL MATLAB code file for overall.fig
%      OVERALL, by itself, creates a new OVERALL or raises the existing
%      singleton*.
%
%      H = OVERALL returns the handle to a new OVERALL or the handle to
%      the existing singleton*.
%
%      OVERALL('Property','Value',...) creates a new OVERALL using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to overall_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      OVERALL('CALLBACK') and OVERALL('CALLBACK',hObject,...) call the
%      local function named CALLBACK in OVERALL.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help overall

% Last Modified by GUIDE v2.5 27-Nov-2017 01:01:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @overall_OpeningFcn, ...
                   'gui_OutputFcn',  @overall_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before overall is made visible.
function overall_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for overall
handles.output = hObject;

handles.parsedData = varargin{1};
handles.actual = get_actual_grid_data();
handles.Error = grid_rmse(trilateration_mmse(handles.parsedData), handles.actual);
%handles.Error = mean(parsedData(:,:,:,1),3);

handles.Acheck = 1;
handles.Bcheck = 0;
handles.Ccheck = 1;
handles.Dcheck = 0;

on_check_box(hObject, eventdata, handles);
% Update handles structure
guidata(hObject, handles);

update_check_boxes(hObject, eventdata, handles);

set(handles.slider1,'Value',0);
set(handles.slider2,'Value',1.0);

update_plot(handles);

% UIWAIT makes overall wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = overall_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function on_check_box(hObject, eventdata, handles)
if(handles.Acheck)
    set(handles.text1,'visible','on');
else 
    set(handles.text1,'visible','off');
end
if(handles.Bcheck)
    set(handles.text10,'visible','on');
else 
    set(handles.text10,'visible','off');
end
if(handles.Ccheck)
    set(handles.text12,'visible','on');
else 
    set(handles.text12,'visible','off');
end
if(handles.Dcheck)
    set(handles.text11,'visible','on');
else 
    set(handles.text11,'visible','off');
end

update_error_data(handles);

function update_check_boxes(hObject, eventdata, handles)
set(handles.checkbox1,'Value',handles.Acheck);
set(handles.checkbox2,'Value',handles.Bcheck);
set(handles.checkbox3,'Value',handles.Ccheck);
set(handles.checkbox4,'Value',handles.Dcheck);

% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
handles.Acheck = get(hObject,'Value');
% Update handles structure
guidata(hObject, handles);

on_check_box(hObject, eventdata, handles);

% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2
handles.Bcheck = get(hObject,'Value');
% Update handles structure
guidata(hObject, handles);

on_check_box(hObject, eventdata, handles);

% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3
handles.Ccheck = get(hObject,'Value');
% Update handles structure
guidata(hObject, handles);

on_check_box(hObject, eventdata, handles);

% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4
handles.Dcheck = get(hObject,'Value');
% Update handles structure
guidata(hObject, handles);

on_check_box(hObject, eventdata, handles);

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
update_error_data(handles);

function update_plot(handles)
% axes(handle);
% surfc(handle, 0.5:9.5,0.5:9.5,data);
plot_surface_data(handles.axes6, handles.Error);
colorbar;
set_azimuth_elevation(handles.axes6, handles);

function set_azimuth_elevation(hObject, handles)
azi = get(handles.slider1,'Value') * 90;
ele = get(handles.slider2,'Value') * 90;
view(hObject, [azi, ele]);


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set_azimuth_elevation(handles.axes6, handles);


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set_azimuth_elevation(handles.axes6, handles);


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
selected = (get(hObject, 'Value'));
update_error_data_by_selected(selected, handles);

function update_error_data(handles)
selected = (get(handles.popupmenu1, 'Value'));
update_error_data_by_selected(selected, handles);

function update_error_data_by_selected(selected, handles)
loading(handles);
update_plot(handles);

if(selected == 1)
    calculated = trilateration_mmse(handles.parsedData);
end
if(selected == 2)
    calculated = trilateration_least_squares(handles.parsedData, [1 1 1 1]);
end
if(selected == 3)
    calculated = nan(20,20,20,2);
end

handles.Error = grid_rmse(calculated, handles.actual);

update_plot(handles);
rmse = overall_rmse(calculated, handles.actual);
rmse_display(rmse, handles);
% Update handles structure
guidata(handles.axes6, handles);

function rmse_display(rmse, handles)
textField(['RMSE: ',num2str(rmse)], handles);

function loading(handles)
textField('...loading', handles);

function textField(message, handles)
set(handles.text13,'String',message);
% Update handles structure
guidata(handles.text13, handles);


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function text13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
