function x = framenow(x,option)

if isfield(option,'frame') && isstruct(option.frame) && ...
        option.frame.toggle && option.frame.size.value
%     x = {sig.frame(x,...
%         'FrameSize',option.frame.size.value,option.frame.size.unit,...
%         'FrameHop',option.frame.hop.value,option.frame.hop.unit)};%,...
%         option.frame.phase.val,option.frame.phase.unit,...
%         option.frame.phase.atend);
    frate = sig.compute(@sig.getfrate,x{1}.Srate,option.frame);
    x{1}.Ydata = x{1}.Ydata.frame(option.frame,x{1}.Srate);
    x{1}.Frate = frate;
end