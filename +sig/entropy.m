function varargout = entropy(varargin)
    varargout = sig.operate('sig','entropy',...
                            initoptions,@init,@main,@after,varargin);
end


%%
function options = initoptions
    options = sig.signal.signaloptions('FrameAuto',.05,.5);
    
        center.key = 'Center';
        center.type = 'Boolean';
        center.default = 0;
    options.center = center;
    
        minrms.key = 'MinRMS';
        minrms.when = 'After';
        minrms.type = 'Numerical';
        minrms.default = .005;
    options.minrms = minrms;
end


%%
function [x type] = init(x,option,frame)
    if x.istype('sig.signal')
        x = sig.spectrum(x,'FrameConfig',frame);
    end
    type = 'sig.signal';
end


function out = main(in,option)
    x = in{1};
    if ~strcmpi(x.yname,'Entropy')
        res = sig.compute(@routine,x.Ydata,option);
        x = sig.signal(res,'Name','Entropy',...
                       'Srate',x.Srate,'Ssize',x.Ssize,...
                       'FbChannels',x.fbchannels);
    end
    out = {x};
end


function out = routine(d,option)
    e = d.apply(@algo,{option},{'element'},1);
    out = {e};
end


function y = algo(d,option)
    if option.center
        d = d-mean(d);
    end
    
    % Negative data is trimmed:
    d(d<0) = 0;
    
    % Data is normalized such that the sum is equal to 1.
    d = d./sum(d);
    
    % Actual computation of entropy
    y = -sum(d.*log(d + 1e-12))./log(size(d,1));
end


function x = after(x,option)
end