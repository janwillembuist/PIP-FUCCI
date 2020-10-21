function varargout = FUCCI_V4(varargin)
% FUCCI_V4 MATLAB code for FUCCI_V4.fig
%   FUCCI_V4, by itself, creates a new FUCCI_V4 or raises the existing
%   singleton
%
%   H = FUCCI_V4 returns the handle to a new FUCCI_V4 or the handle to the
%   existing singleton*.
%
%   FUCCI_V4('CALLBACK',hObject,eventData,handles,...) calls the local
%   function named CALLBACK in FUCCI_V4.M with the given input arguments.
%
%   FUCCI_V4('Property','Value',...) creates a new FUCCI_V4 or raises the
%   existing singleton*.  Starting from the left, property value pairs are
%   applied to the GUI before FUCCI_V4_OpeningFcn gets called. An
%   unrecognized property name or invalid value makes property application
%   stop.  All inputs are passed to FUCCI_V4_OpeningFcn via varargin.
%
%   Run guide(FUCCI_V4.fig) to edit the GUI.
%
%   *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%   instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FUCCI_V4

% Last Modified by GUIDE v2.5 21-Oct-2020 13:50:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FUCCI_V4_OpeningFcn, ...
                   'gui_OutputFcn',  @FUCCI_V4_OutputFcn, ...
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


% --- Executes just before FUCCI_V4 is made visible.
function FUCCI_V4_OpeningFcn(hObject, eventdata, handles, varargin)
% This function sets the base values in all edit boxes of the FUCCI GUI.
set(handles.edit1,'string','0.001')
set(handles.edit2,'string','-0.05')
set(handles.edit3,'string','20')
set(handles.edit4,'string','3')
set(handles.edit5,'string','5000')
set(handles.listbox1,'string','1')
set(handles.edit7,'string','1');
set(handles.edit8,'string','10');
set(handles.listbox2,'value',1);

% Choose default command line output for FUCCI_V4
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FUCCI_V4 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FUCCI_V4_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
annotated_data=handles.annotated_data;
V=get(hObject,'Value');
tracks = get(hObject,'String');
current_track = str2num(tracks(V,:));
handles.current_track=current_track;
params = get_params(handles);
is_mitosis=check_for_mitosis_an(handles.annotated_data,current_track,handles);
current_cell=1;
[green_channel, red_channel, white_channel, green_channel2,red_channel2, white_channel2] = get_channels_an(handles.annotated_data,current_track,current_cell);
green_Slope2=calc_slope(green_channel2);
red_Slope2=calc_slope(red_channel2);
white_Slope2=calc_slope(white_channel2);
a0=find(annotated_data(:,1)==current_track);
b0=find(annotated_data(a0,2)==current_cell);
classified=annotated_data(a0(b0),6);

% Save into handles
handles.classified=classified;
handles.green_channel2 = green_channel2;
handles.red_channel2   = red_channel2;
handles.white_channel2 = white_channel2;
handles.annotated_data = annotated_data;

% Update plots
update_plots(handles)

guidata(hObject,handles);

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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Save_data.
function Save_data_Callback(hObject, eventdata, handles)
% hObject    handle to Save_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 [filename, pathname] = uiputfile('*.xlsx','save file as..');
 annotated_data=handles.annotated_data;

    xlswrite([pathname filename], {'track #', 'cell #' , 'red channel' , 'green channel','white channel', 'cell cycle stage'}, 'sheet1' , 'A1')
    xlswrite([pathname filename], annotated_data, 'sheet1', 'A2');
    handles.annotated_data=annotated_data;
guidata(hObject,handles);


% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function open_file_Callback(hObject, eventdata, handles)
% hObject [   handle to open_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function open_Callback(hObject, eventdata, handles)
% hObject    handle to open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile('*.xlsx');
[NUM,TXT,RAW]=xlsread([pathname, filename]);
handles.NUM=NUM;
handles.TXT=TXT;
handles.RAW=RAW;
f0=~isnan(NUM(:,2));

set(handles.popupmenu1,'string',num2str(unique(NUM(f0,2))));
%annotata and tabulate data
annotated_data=[];
params=get_params(handles);
list_track=get(handles.popupmenu1,'string');
for ii=1:length(list_track)
    try
        current_track=str2num(list_track(ii,:));
        is_mitosis=check_for_mitosis(handles.NUM,current_track,handles);
        for current_cell=0+1:is_mitosis+1
            % Get channels
            [green_channel, red_channel, white_channel, green_channel2,red_channel2, white_channel2]=get_channels(handles.NUM,current_track,current_cell);
            
            % Calculate slopes
            green_Slope2 = calc_slope(green_channel2);
            red_Slope2   = calc_slope(red_channel2);
            white_Slope2 = calc_slope(white_channel2);
            
            % Classify and annotate
            classified=classify_stages(params,red_Slope2,green_Slope2,white_Slope2,red_channel,green_channel,white_channel,red_channel2,green_channel2,white_channel2);
            annotated_data = [annotated_data ; ones(size(classified))'*current_track,...
                ones(size(classified))'*current_cell, green_channel(1:length(classified)), ...
                red_channel(1:length(classified)), white_channel(1:length(classified)), classified'];
        end
    catch ME
       disp([ 'the track is' num2str(current_track)])
       pause
    end
end
% Save annotated data
handles.annotated_data=annotated_data;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate axes1

function [green_channel, red_channel, white_channel, ...
    green_channel2, red_channel2, white_channel2] = get_channels(NUM,ii,current_cell)
% Function to get the channels from the NUM part of the excel file
aa=find(NUM(:,2)==ii);
if ~isempty(aa)
    green_channel=NUM(aa,11);
    red_channel=NUM(aa,12);
    white_channel=NUM(aa,13);
    
    % Create normalized channels
    for kk=2:length(green_channel)-1
        if current_cell==1
            green_channel2(kk)=max(green_channel(kk-1:kk+1));
            red_channel2(kk)=max(red_channel(kk-1:kk+1));
            white_channel2(kk)=max(white_channel(kk-1:kk+1));
        else
            green_channel2(kk)=min(green_channel(kk-1:kk+1));
            red_channel2(kk)=min(red_channel(kk-1:kk+1));
            white_channel2(kk)=min(white_channel(kk-1:kk+1));
        end
    end
    green_channel2 = green_channel2/max(green_channel2);
    red_channel2   = red_channel2/max(red_channel2);
    white_channel2 = white_channel2/max(white_channel2);
    green_channel2 = medfilt1(green_channel2, 5);
    red_channel2   = medfilt1(red_channel2, 5);
    white_channel2 = medfilt1(white_channel2, 5);
end

function green_Slope=calc_slope(green_channel2)
  for jj=1:length(green_channel2)-4
      green_vect=green_channel2(jj:jj+4);
      P=polyfit([1:5],green_vect,1);
      green_Slope(jj+1)=P(1);
  end

function classified=classify_stages(params,...
    red_Slope, green_Slope, white_Slope,...
    red_channel, green_channel, white_channel,...
    red_channel2, green_channel2, white_channel2)
% Function to classify the stages in channels. White channels are not used
% for classification yet.
thresh_gradual=params.thresh_gradual;
thresh_steep=params.thresh_steep;
time_interval_mitosis=params.time_interval_mitosis;
time_min_mitosis=params.time_min_mitosis;
min_signal_drop=params.min_signal_drop;
classified=zeros(size(green_Slope));
% find mitosis
a0=find(red_Slope<thresh_steep);
classified(a0)=1;
% find beginning of all mitosis events
if ~isempty(a0)
a00=find(diff(a0)>1);

mitosis_begin=[a0(1) a0(a00+1)];
if length(mitosis_begin)>1
    mitosis_begin2=mitosis_begin(1);
    for ii=1:length(mitosis_begin)-1
        if mitosis_begin(ii+1)-mitosis_begin(ii)>time_interval_mitosis
            mitosis_begin2=[mitosis_begin2 mitosis_begin(ii+1)];
        else
            classified(mitosis_begin(ii):mitosis_begin(ii+1))=1;
        end
    end
        mitosis_begin=mitosis_begin2;
    mitosis_end=[mitosis_begin(2:end) a0(end)];
else
    mitosis_end=a0(end);
end

num_mitosis_events = length(mitosis_begin);
mitosis_begin2=[];
mitosis_end2=[];
for jj=1:length(mitosis_begin)
    mitosis_event=red_channel(mitosis_begin(jj):mitosis_end(jj));
    signal_drop=max(mitosis_event)-min(mitosis_event);
    if signal_drop>min_signal_drop
        mitosis_begin2 = [mitosis_begin2 mitosis_begin(jj)];
        mitosis_end2 = [mitosis_end2 mitosis_end(jj)];
    end
end
mitosis_begin=mitosis_begin2;
mitosis_end=mitosis_end2;
num_mitosis_events=length(mitosis_begin);
else
    num_mitosis_events=0;
end

%find G1-S transition
b0 = find(green_Slope<thresh_steep);
c0 = find(red_Slope(b0)>0);
%add function to count all G1-S transitions
classified(b0(c0))=3;
c00=find(diff(b0(c0))>1);
if ~isempty(c0)
G1_S_begin=[b0(c0(1)) b0(c0(c00+1))];
G1_S_begin2=G1_S_begin(1);
    for ii=1:length(G1_S_begin)-1
        if G1_S_begin(ii+1)-G1_S_begin(ii)>time_interval_mitosis
            G1_S_begin2=[G1_S_begin2 G1_S_begin(ii+1)];
        else
            classified(G1_S_begin(ii):G1_S_begin(ii+1))=3;
        end
    end
    G1_S_begin=G1_S_begin2;
if length(G1_S_begin)>1
    G1_S_end=[mitosis_begin(2:end) b0(c0(end))];
else
    G1_S_end=b0(c0(end));
end
num_G1_S_events=length(G1_S_begin);
else
    num_G1_S_events=0;
end
% num_G1_S_events;
% num_mitosis_events;
if num_G1_S_events==0 & num_mitosis_events==0
    gr_mean=mean(green_channel);
    rd_mean=mean(red_channel(:));
    if gr_mean<rd_mean
        classified=ones(size(classified))*4;
    else
        classified=ones(size(classified))*2;
    end
elseif num_G1_S_events==0 & num_mitosis_events==1
    classified(1:mitosis_begin-1)=4;
    classified(mitosis_end+1:end)=2;
elseif num_G1_S_events==1 & num_mitosis_events==0
    classified(1:G1_S_begin-1)=2;
    classified(G1_S_end+1:end)=4;
elseif num_G1_S_events==1 & num_mitosis_events==1
    if G1_S_begin<mitosis_begin
        classified(1:G1_S_begin-1)=2;
        classified(G1_S_end+1:mitosis_begin-1)=4;
        classified(mitosis_end+1:end)=2;
    else
        classified(1:mitosis_begin-1)=4;
        classified(mitosis_end+1:G1_S_begin-1)=2;
        classified(G1_S_end+1:end)=4;
    end
end
% split region 4 into 5 different sections
a0=find(classified==4);
if ~isempty(a0)
    a00=find(green_channel2(a0)>0);
    a0=a0(a00);
end
if ~isempty(a0)
min4=(min(green_channel2(a0)));
b0=find(green_channel2(a0)==min4);
a0=a0(b0:end);
max4=max(green_channel2(a0));
thresh=min4+0.1*(max4-min4);
G2_Region=find(green_channel2(a0)>thresh);
if ~isempty(G2_Region)
classified(a0(G2_Region(1):end))=5;
end
end

function params=get_params(handles)
% function that gets the edit parameters from edit boxes
params.thresh_gradual        = str2num(get(handles.edit1,'string'));
params.thresh_steep          = str2num(get(handles.edit2,'string'));
params.time_interval_mitosis = str2num(get(handles.edit3,'string'));
params.time_min_mitosis      = str2num(get(handles.edit4,'string'));
params.min_signal_drop       = str2num(get(handles.edit5,'string'));

function is_mitosis =check_for_mitosis(NUM,ii,handles)
aa=find(NUM(:,2)==ii);
if ~isempty(aa)
    a0=length(NUM(aa,8));
    b0=length(unique(NUM(aa,8)));
    if a0==b0
        is_mitosis=0;
        set(handles.listbox1,'string','1');
        set(handles.listbox1,'value',1)
    else
        is_mitosis=1;
        set(handles.listbox1,'string',{'1';'2'});
        set(handles.listbox1,'value',1);
    end
end

function annotated_data = annotate_data(NUM,handles)
    params=get_params(handles);

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
val=get(hObject,value);
    
% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
annotated_data=handles.annotated_data;
current_cell=get(hObject,'value');
current_track=handles.current_track;

[green_channel, red_channel, white_channel, green_channel2,red_channel2, white_channel2] = get_channels_an(handles.NUM,current_track,current_cell);
a0=find(annotated_data(:,1)==current_track);
b0=find(annotated_data(a0,2)==current_cell);
classified=annotated_data(a0(b0),6);

% Save into handles
handles.classified=classified;
handles.green_channel2 = green_channel2;
handles.red_channel2   = red_channel2;
handles.white_channel2 = white_channel2;
handles.annotated_data = annotated_data;

% Update plots
update_plots(handles)

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in annotater.
function annotater_Callback(hObject, eventdata, handles)
% hObject    handle to annotater (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uiputfile('*.xlsx','save file as..');
annotated_data=[];
params=get_params(handles);
list_track=get(handles.popupmenu1,'string');
for ii=1:length(list_track)
    try
        current_track=str2num(list_track(ii,:));
        is_mitosis=check_for_mitosis(handles.NUM,current_track,handles);
        for current_cell=0+1:is_mitosis+1
            [green_channel, red_channel, white_channel, green_channel2,red_channel2, white_channel2]=get_channels(handles.NUM,current_track,current_cell);
            green_Slope2=calc_slope(green_channel2);
            red_Slope2=calc_slope(red_channel2);
            white_Slope2=calc_slope(white_channel2);
            classified=classify_stages(params,red_Slope2,green_Slope2,white_Slope2,red_channel,green_channel,white_channel,red_channel2,green_channel2,white_channel2);
            annotated_data=[annotated_data ; ones(size(classified))'*current_track, ones(size(classified))'*current_cell,green_channel(1:length(classified)),red_channel(1:length(classified)),white_channel(1:length(classified)),classified'];
        end
    catch ME
       disp([ 'the track is' num2str(current_track)])
       pause
    end
end
xlswrite([pathname filename], {'track #', 'cell #' , 'red channel' , 'green channel','white channel', 'cell cycle stage'}, 'sheet1' , 'A1')
xlswrite([pathname filename], annotated_data, 'sheet1', 'A2');
handles.annotated_data=annotated_data;
guidata(hObject,handles);

function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double

% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2

% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    annotated_data=handles.annotated_data;
    current_track=handles.current_track;
    current_cell=get(handles.listbox1,'value');
    start_value=str2num(get(handles.edit7,'string'));
    end_value=str2num(get(handles.edit8,'string'));
    cycle_phase=get(handles.listbox2,'value');
    handles.classified(start_value:end_value)=cycle_phase;
    
    % Update plots
    update_plots(handles)
    
    % update annotated_data
    a0=find(annotated_data(:,1)==current_track);
    b0=find(annotated_data(a0,2)==current_cell);
    annotated_data(a0(b0),6)=handles.classified;
    handles.annotated_data=annotated_data;
    guidata(hObject,handles);

% --------------------------------------------------------------------
function open_classified_Callback(hObject, eventdata, handles)
% hObject    handle to open_classified (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname]=uigetfile('*.xlsx');
[NUM,TXT,RAW]=xlsread([pathname, filename]);
handles.NUM=NUM;
handles.TXT=TXT;
handles.RAW=RAW;
handles.annotated_data=NUM;
set(handles.popupmenu1,'string',num2str(unique(NUM(:,1))));
guidata(hObject,handles);

function is_mitosis=check_for_mitosis_an(annotated_data,current_track,handles)
is_mitosis=0;
set(handles.listbox1,'string','1');
set(handles.listbox1,'value',1)
a0 = find(annotated_data(:,1)==current_track);
b0 = unique(annotated_data(a0, 2));
if length(b0) > 1
    is_mitosis = 1;
    set(handles.listbox1,'string',{'1';'2'});
    set(handles.listbox1,'value',1);
end
        
function [green_channel, red_channel, white_channel, green_channel2,red_channel2, white_channel2]=get_channels_an(annotated_data,current_track,current_cell)
a0=find(annotated_data(:,1)==current_track);
aa=find(annotated_data(a0,2)==current_cell);
if ~isempty(aa)
    green_channel=annotated_data(aa,3);
    red_channel=annotated_data(aa,4);
    white_channel=annotated_data(aa,5);
    for kk=2:length(green_channel)-1
        if current_cell==1
            green_channel2(kk)=max(green_channel(kk-1:kk+1));
            red_channel2(kk)=max(red_channel(kk-1:kk+1));
            white_channel2(kk)=max(white_channel(kk-1:kk+1));
        else
            green_channel2(kk)=min(green_channel(kk-1:kk+1));
            red_channel2(kk)=min(red_channel(kk-1:kk+1));
            white_channel2(kk)=min(white_channel(kk-1:kk+1));
        end
    end
    green_channel2=green_channel2/max(green_channel2);
    red_channel2=red_channel2/max(red_channel2);
    white_channel2=white_channel2/max(white_channel2);
    green_channel2=medfilt1(green_channel2,5);
    red_channel2=medfilt1(red_channel2,5);
    white_channel2=medfilt1(white_channel2,5);
end

function update_plots(handles)
% The plot is updated through this function
hold on
plot(handles.green_channel2,'g')
plot(handles.red_channel2,'r')
plot(handles.white_channel2,'c')
plot(handles.classified/3,'k')
hold off
legend('PIP-mVenus','Gem-mCherry','SiR-DNA','Classification', 'Location', 'best')
xlabel('Frame')
ylabel('Relative intensity')