%% Continuous Data Acquisition with Integrated Real-Time Fourier Filtering
%  Cameron Coleal
%  5/5/22 UPDATE FOR V3.3
%  Code updated -- 10/12/23

%% Globals
global d
global data
%% Initialize DAQ
d = daq('ni');


% add output channels
ch1 = addoutput(d,'Dev1','ao0','Voltage');% Analog Output for X Waveform
ch2 = addoutput(d,'Dev1','ao1','Voltage');% Analog Output for Y Waveform

% add input channels
ch3 = addinput(d,'Dev1','ai1','Voltage'); % Intensity Signal
ch4 = addinput(d,'Dev1','ai2','Voltage'); % PSD Sum Pin Signal
ch5 = addinput(d,'Dev1','ai3','Voltage'); % PSD X Pin Signal
ch6 = addinput(d,'Dev1','ai5','Voltage'); % PSD Y Pin Signal

%% Change channel voltage range
amplitude = 0.15; % set this to determine the drive voltage to the scanner
                  % allowable range for V3.3 = [0.1V to 0.75V]

% set the input voltage range for the DAQ
ch5.Range = [-5,5]; 
ch6.Range = [-5,5]; 


%% Create the output waveforms
% 6 frames/second
% fx = 810; %Hz
% fy = 798; %Hz
% fo = 6; %GCF, Hz
% nx = fx/fo; %119
% ny = fy/fo; %118

% 3 Frames/second
fx = 804; %Hz
fy = 807; %Hz
fo = 3; %GCF, Hz
nx = fx/fo; %119
ny = fy/fo; %118

k = 2; %symmetric about the origin for k=2,6

phix = 0; %phase on x is zero
phiy = (k*pi)/(4*nx); %phase on y

d.Rate = 62500; % Hz

% Parameters
% Sample Duration (s) -- how long to image for in seconds
sampleDuration = 5; % 1/abs(fx-fy)

% Number of Samples 
nSamps = sampleDuration*d.Rate; 

% Sample Interval (s)
dt = 1/d.Rate;

% Create vector to hold sample data (s)
t = ([1:nSamps+1]-1)*dt;

% Signals
DriveX = amplitude*cos(2*pi*nx*fo*t);
DriveY = amplitude*cos(2*pi*ny*fo*t+phiy);

% Input data rotation

% Image Rotate
phix = 63; %104; %127; %120; %127
phiy = 153;%-22; %4; %36; %30; %36
zeroArray =  0.*[1:1:length(DriveX)]; 

datax = [DriveX; zeroArray];
datay = [DriveY; zeroArray];
rotMatx = [cosd(phix) -sind(phix); sind(phix) cosd(phix)];
rotMaty = [cosd(phiy) -sind(phiy); sind(phiy) cosd(phiy)];
rotDatax = rotMatx*datax; 
rotDatay = rotMaty*datay;
OutX = rotDatax(1,:)+ rotDatay(1,:); 
OutY = rotDatax(2,:) + rotDatay(2,:); 

% OutX =  rotDatax(1,:); 
% OutY =  rotDatax(2,:); 

figure(1); clf; 
plot(OutX, OutY)


%% More parameters
XCORR = 157.66; % psd X axis correction factor
YCORR = 152.615; % psd Y axis correction factor

% units
mm = 1e-3; 
um = 1e-6; 
nm = 1e-9; 


%% set up GUI
fgui = figure(2);
setappdata(fgui,'initialized',0);

hStopButton = uicontrol('Style','togglebutton',...
    'String','Stop','Position', [10, 10,100, 50],'Callback',@stopCallback);


%% Set to rate
d.ScansAvailableFcnCount = round(62500/2); 
d.ScansAvailableFcn = @(d,evt) plotMyData(d,evt,fgui);
  
%% Flush & re-start device
flush(d)
preload(d,[OutX', OutY'])
start(d, 'RepeatOutput');


%% After running the cell above
ein =10800; % ending index
sin = 10; % starting index
sumpin = true(1); % is the sum pin used
sshift = 0; % phase shift on signal
x_shift = 0; % phase shift on x pin
y_shift = 0; % phase shift on y pin
ii = 1; % index -- will always be 1 unless trying to store data as it is acquired in cell array

figure(2);
hImageObj = imagesc(0, 0, 0);
xlabel('X (V)')
ylabel('Y (V)')
axis image

id=1;

% Create array
global data

% initial setup of sampling grid
Signal = data; 

sum = Signal(:,2);
x= Signal(:,3);  
y = Signal(:,4); 
xcal = (10*x)./(2*sum); 
ycal = (10*y)./(2*sum); 

% Apply Correction
xcal = XCORR.*xcal.*um; 
ycal = YCORR.*ycal.*um; 

% x spatial grid
Dx = (max(xcal)-min(xcal));
Nx = round(Dx/(1.35e-6));  % determine grid size for nyquist sampling
xgrid = linspace(min(xcal),max(xcal),Nx);
dx = xgrid(2)-xgrid(1); % x sample spacing
xedges = [xgrid,xgrid(end)+dx];
% fx vector
dfx = 1/Dx; 
fx = dfx*([1:Nx]-Nx/2-1); 

% y spatial grid
Dy = (max(ycal)-min(ycal)); 
Ny = round(Dy/(1.35e-6)); % determine grid size for nyquist sampling
ygrid = linspace(min(ycal),max(ycal), Ny);
dy = ygrid(2)-ygrid(1); 
yedges = [ygrid,ygrid(end)+dy];
% fy vector
dfy = 1/Dy; 
fy = dfy*([1:Ny]-Ny/2-1); 
% matrices
[Xt, Yt] = meshgrid(xgrid,ygrid); 
    
% radial coordinate
Rt = sqrt(Xt.^2+Yt.^2); 

% transverse spatial frequencies
[FXt, FYt] = meshgrid(fx, fy); 
FRt = sqrt(FXt.^2 + FYt.^2); 

% imaging parameters
NA = 0.13; 
Mag = 0.5; % f2/f1
ftube = 15*mm; % this is the second lens
n = 1; 
lambda = 785*nm; 

% objective focal length 
fobj = ftube/Mag; % this is f1

% spatial frequency cutoff - radial
mult = 1; 
kc = mult*NA/(n*lambda); 

% CTF
BeamSpatFreq = 1; 
CTF = rectpuls((FRt)./kc); 
BeamSpatFreqFilt = BeamSpatFreq.*CTF; 

% fourier filtering
mask = BeamSpatFreqFilt; 

Irunning = zeros(Ny,Nx);

while d.Running
    global data

    Signal = data; 
    
    s = Signal(:,1);
    sum = Signal(:,2);
    x= Signal(:,3); 
    y = Signal(:,4); 
    x_cal = (10*x)./(2*sum); 
    y_cal = (10*y)./(2*sum); 

    xcal = XCORR.*x_cal.*um; 
    ycal = YCORR.*y_cal.*um; 
   
    % Plot Image
    Irecon = zeros(Ny,Nx);
    N = 0*Irecon;
    ns = length(s);
    
    % phase offset
    s_offs = 0;
    
    for ind = 1:length(s)
            
        [~,ind_y] = min(abs(yedges - ycal(ind)));
        ind_y = max(ind_y,1);
        ind_y = min(ind_y,Ny);
        
        [~,ind_x] = min(abs(xedges - xcal(ind)));
        ind_x = max(ind_x,1);
        ind_x = min(ind_x,Nx);
       
        ind_s = round(ind+s_offs);
    
        if (ind_y > 0) && (ind_y <= ns) && (ind_s > 0) && (ind_s <=ns)
            Irecon( ind_y, ind_x ) = Irecon( ind_y, ind_x ) + s(ind_s);
            N( ind_y, ind_x ) = N( ind_y, ind_x ) + 1;
        end
    
    end
    

    IreconReg = Irecon./ N;
%     cut = 20; %round(0.1*max([length(xgrid), length(ygrid)]))
%     Original = IreconReg(cut:end-cut, cut:end-cut); 
%     mask2 = mask(cut:end-cut, cut:end-cut); 
    Original = IreconReg;
    
    

    % Index values to keep
    index = (Original>0); 
    
    % start iterative process
    previous_image = Irunning; 
    loss = [];
    cycle = 6; % set the number of cycles

    Irunning(index) = IreconReg(index);


    % Take the FT of the Image
    FTimage = fftshift(fft2(ifftshift(Irunning))); 
    % Multiply the FT by a Fourier Mask
    Filt = mask.*FTimage;       
    % Take the inverse FT
    Irunning = fftshift(ifft2(ifftshift(Filt))); 
    view = Irunning; % for viewing the inverse FT before pixel replacement
    % process &= replace sampled pixels
    Irunning(isnan(Irunning)) = 0; % set nulls to zero  
    
    % calculate loss
    previous_image = Irunning;      
    

    % sampled image
    subplot(121);
    imagesc([min(xgrid), max(xgrid)]./um, [min(ygrid), max(ygrid)]./um, abs(IreconReg))
    colormap(gray)
    xlabel('X (um)')
    ylabel('Y (um)')
    title('Acquired Data')
    axis equal
    caxis([min(s),max(s)])
%     xlim([-200, 150])
%     ylim([-200, 300])
    
    % view final estimated image
    subplot(122);
    imagesc([min(xgrid), max(xgrid)]./um, [min(ygrid), max(ygrid)]./um, abs(view))
    colormap(gray)
    xlabel('X (um)')
    ylabel('Y (um)')
    title('Estimated Image')
    axis equal
%     colorbar()
    caxis([min(s),max(s)])
%     xlim([-200, 150])
%     ylim([-200, 300])
    drawnow
    
    clear('data'); 
    id = id+1; 
end

%% Function
function plotMyData(d, ~, fgui)
    global data
    data = read(d, d.ScansAvailableFcnCount, "OutputFormat", "Matrix"); 
end

function stopCallback(src,event)
    global d
    stop(d)
    disp('stopped and released')
end
