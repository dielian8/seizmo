function [data,tpr,fh]=usertaper(data,func,varargin)
%USERTAPER    Interactively taper SEIZMO records
%
%    Usage:    data=usertaper(data)
%              data=usertaper(data,func)
%              data=usertaper(data,func,'field',value,...)
%              [data,tpr]=usertaper(...)
%              [data,tpr,fh]=usertaper(...)
%
%    Description: DATA=USERTAPER(DATA) presents a interactive menu and
%     plot interface to taper records in a dataset with a few mouse clicks.
%     The default taper type is that set by function TAPER.  This may be
%     modified using the menu presented.  By default no mean or trend
%     removal is done after tapering.
%
%     DATA=USERTAPER(DATA,FUNC) applies function FUNC to records in DATA
%     after tapering and before the confirmation window.  FUNC must be a
%     function handle.  Some common function handles for this are
%     @removemean and @removetrend.
%
%     DATA=USERTAPER(DATA,FUNC,'FIELD',VALUE,...) passes field/value pairs
%     to the plotting function, to allow further customization.
%
%     [DATA,TPR]=USERTAPER(...) also returns the taper properties in a
%     struct TPR.  TPR contains fields type, width, and option which are
%     arguments passed to the TAPER function.  Note that these fields are
%     returned as empty unless set interactively.  
%
%     [DATA,TPR,FH]=USERTAPER(...) returns the figure handles in FH.
%
%    Notes:
%
%    Header changes: DEPMEN, DEPMIN, DEPMAX
%
%    Examples:
%     Taper and remove the trend afterwards (before confirmation window):
%      data=usertaper(data,@removetrend);
%
%    See also: taper, userwindow, usercluster, selectrecords

%     Version History:
%        Sep.  9, 2009 - rewrite and added documentation
%
%     Written by Garrett Euler (ggeuler at wustl dot edu)
%     Last Updated Sep.  9, 2009 at 07:30 GMT

% todo:
% - subplot showing taper
% - option for wvtool

% check nargin
msg=nargchk(1,inf,nargin);
if(~isempty(msg)); error(msg); end

% check data structure
msg=seizmocheck(data,'dep');
if(~isempty(msg)); error(msg.identifier,msg.message); end

% check function handle
if(nargin<2 || isempty(func))
    func=@deal;
elseif(~isa(func,'function_handle'))
    error('seizmo:usertaper:badInput','FUNC must be a function handle!');
end

% taper types
types={[],'barthannwin','bartlett','blackman','blackmanharris',...
    'bohmanwin','chebwin','flattopwin','gausswin','hamming','hann',...
    'kaiser','nuttallwin','parzenwin','rectwin','triang','tukeywin'};

% taper defaults
tpr.type=[];
tpr.width=[];
tpr.option=[];

% length normalization
[b,e,npts,delta]=gh(data,'b','e','npts','delta');
data=ch(data,'b',0,'e',1,'delta',1./(npts-1));

% outer loop - only breaks free by user command
happy_user=false; fh=[-1 -1];
while(~happy_user)
    % explain to the user how this works with a little prompt
    % and make them decide what kind of plot to use for the
    % windowing, offering them back out options.  This prompt
    % looks like trash because of default menu fonts.
    prompt={'+-------------------------------------------------------+'
            '|                Welcome to SEIZMO''s interactive tapering function                |'
            '+-------------------------------------------------------+'
            '|                                                                                                               |'
            '|                                            MOUSE USAGE                                             |'
            '|                                                                                                               |'
            '|    LEFT CLICK                      MIDDLE CLICK                      RIGHT CLICK   |'
            '+-------------+          +-------------+          +--------------+'
            '|  Mark Untapered                 Finalize Marks                  Mark Untapered  |'
            '|          Start                                                                             End           |'
            '+-------------------------------------------------------+'
            '|                                                                                                               |'
            '|                                                  NOTES                                                   |'
            '|                                                                                                               |'
            '|          + You may refine tapering limits until you finalize                       |'
            '|          + When finalized, a new plot with the tapered                              |'
            '|              waveforms will appear, as well as a confirmation                     |'
            '|              prompt.  You will have the option to re-taper.                         |'
            '|                                                                                                               |'
            '+-------------------------------------------------------+'
            '|                                                                                                               |'
            '|                PLEASE CHOOSE AN OPTION BELOW TO PROCEED!                 |'
            '|                                                                                                               |'
            '+-------------------------------------------------------+'};
    
    
    % way cooler menu -- if only matlab gui's used fixed width
    %{
    prompt={'+-------------------------------------------------------+'
            '|   Welcome to SEIZMO''s interactive tapering function   |'
            '+-------------------------------------------------------+'
            '|                                                       |'
            '|                     MOUSE USAGE:                      |'
            '|                                                       |'
            '|   LEFT CLICK        MIDDLE CLICK         RIGHT CLICK  |'
            '+---------------+   +--------------+    +---------------+'
            '| Mark Untapered     Finalize Marks      Mark Untapered |'
            '|     Start                                    End      |'
            '+-------------------------------------------------------+'
            '|                                                       |'
            '|                        NOTES:                         |'
            '|                                                       |'
            '|  + You may refine tapering limits until you finalize  |'
            '|  + When finalized, a new plot with the tapered        |'
            '|    waveforms will appear, as well as a confirmation   |'
            '|    prompt.  You will have the option to re-window.    |'
            '|                                                       |'
            '+-------------------------------------------------------+'
            '|                                                       |'
            '|        PLEASE CHOOSE AN OPTION BELOW TO PROCEED!      |'
            '|                                                       |'
            '+-------------------------------------------------------+'};
    %}
    
    % display prompt and get user choice
    choice=menu(prompt,'CHOOSE TAPER','OVERLAY PLOT',...
        'EVENLY SPACED PLOT','DISTANCE SPACED PLOT',...
        'DO NOT TAPER','DIE!');
    
    % proceed by user choice
    switch choice
        case 1 % taper select
            j=menu('CHOOSE A TAPER TYPE','DEFAULT','BARTHANN','BARTLETT',...
            'BLACKMAN','BLACKMAN-HARRIS','BOHMAN','CHEBYCHEV',...
            'FLAT TOP','GAUSSIAN','HAMMING','HANN','KAISER',...
            'NUTTALL','PARZEN','RECTANGULAR','TRIANGULAR','TUKEY');
            tpr.type=types{j};
            
            % taper options
            switch j
                case 7 % cheb
                    tpr.option=inputdlg(['Chebychev - Stopband '...
                        'Attenuation (in dB)? [100]:'],...
                        'Chebychev Taper Option',1,{'100'});
                    if(isempty(tpr.option))
                        tpr.option=100;
                    else
                        tpr.option=str2double(tpr.option{:});
                    end
                    if(isempty(tpr.option) || isnan(tpr.option))
                        tpr.option=100;
                    end
                case 9 % gauss
                    tpr.option=inputdlg(['Gaussian - Number of std dev?'...
                        ' [3.5]:'],'Gaussian Taper Option',1,{'3.5'});
                    if(isempty(tpr.option))
                        tpr.option=3.5;
                    else
                        tpr.option=str2double(tpr.option{:});
                    end
                    if(isempty(tpr.option) || isnan(tpr.option))
                        tpr.option=3.5;
                    end
                case 12 % kaiser
                    tpr.option=inputdlg(['Kaiser - Stopband '...
                        'Attenuation Factor Beta? [7.5]:'],...
                        'Kaiser Taper Option',1,{'7.5'});
                    if(isempty(tpr.option))
                        tpr.option=7.5;
                    else
                        tpr.option=str2double(tpr.option{:});
                    end
                    if(isempty(tpr.option) || isnan(tpr.option))
                        tpr.option=7.5;
                    end
                case 17 % tukey
                    tpr.option=inputdlg(['Tukey - Taper to Constant '...
                        'Ratio? [1]:'],'Tukey Taper Option',1,{'1'});
                    if(isempty(tpr.option))
                        tpr.option=1;
                    else
                        tpr.option=str2double(tpr.option{:});
                    end
                    if(isempty(tpr.option) || isnan(tpr.option))
                        tpr.option=1;
                    end
            end
            % go back to main menu
            continue;
        case 2 % overlay
            fh(1)=plot2(data,varargin{:});
        case 3 % evenly spaced
            fh(1)=plot0(data,varargin{:});
        case 4 % distance spaced
            fh(1)=recordsection(data,varargin{:});
        case 5 % no taper
            tpr.type=[];
            tpr.width=[];
            tpr.option=[];
            data=ch(data,'b',b,'e',e,'delta',delta);
            return;
        case 6 % immediate death
            error('seizmo:usertaper:killYourSelf',...
                'User demanded Seppuku!')
    end
    
    % add taper limit markers
    figure(fh(1));
    span=ylim;
    tpr.width=xlim;
    hold on
    goh(1)=plot([tpr.width(1) tpr.width(1)],span,'g','linewidth',4);
    goh(2)=plot([tpr.width(2) tpr.width(2)],span,'r','linewidth',4);
    hold off
    
    % loop until user finalizes markers
    final=false;
    while(~final)
        % focus plot and let user pick
        figure(fh(1));
        [x,y,button]=ginput(1);
        
        % which mouse button?
        switch button
            case 1
                % left click - update untapered start
                tpr.width(1)=x;
                set(goh(1),'xdata',[x x])
            case 3
                % right click - update untapered end
                tpr.width(2)=x;
                set(goh(2),'xdata',[x x])
            case 2
            % middle click - finalize markers
            if (tpr.width(1)>tpr.width(2))
                % start and end reversed - fix
                tpr.width=tpr.width([2 1]);
                set(goh(1),'xdata',[tpr.width(1) tpr.width(1)])
                set(goh(2),'xdata',[tpr.width(2) tpr.width(2)])
            end
            final=true;
        end
    end
    
    % fix end taper
    tpr.width(2)=1-tpr.width(2);
    
    % get windowed data
    data2=taper(data,tpr.width,tpr.type,tpr.option);
    
    % apply function post cut
    data2=func(data2);

    % proceed by user choice
    switch choice
        case 2 % overlay
            fh(2)=plot2(data2,varargin{:});
        case 3 % evenly spaced
            fh(2)=plot0(data2,varargin{:});
        case 4 % distance spaced
            fh(2)=recordsection(data2,varargin{:});
    end
    
    % confirm results
    choice=menu('KEEP TAPER?','YES','NO - TRY AGAIN','NO - DIE!');
    switch choice
        case 1 % all done!
            data=ch(data2,'b',b,'e',e,'delta',delta);
            happy_user=true;
        case 2 % please try again
            close(fh);
            fh=[-1 -1];
        case 3 % i bear too great a shame to go on
            error('seizmo:usertaper:killYourSelf',...
                'User demanded Seppuku!')
    end
end