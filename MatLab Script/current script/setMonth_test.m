function [z] = setMonth_test(source,callbackdata)
        val = source.Value;
        month = source.String;
        % For R2014a and earlier: 
        % val = get(source,'Value');
        % maps = get(source,'String'); 

        newmap = month{val};
        z = val;
    end