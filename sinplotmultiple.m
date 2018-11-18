% sinplotmultiple.m -- plot some harmonics of sin at various intervals
% Copyright (C) 2018  Walter B. Vaughan
% 
% This program is free software: you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by the Free
% Software Foundation, either version 3 of the License, or (at your option) any
% later version.
% 
% This program is distributed in the hope that it will be useful, but WITHOUT
% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
% FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License along
% with this program.  If not, see <https://www.gnu.org/licenses/>.
function retval = sinplotmultiple(corenum, totalcores, steps_per_cycle, num_harmonics)
  warning ("off");
  
  sizes = [2,3,4];
  colrs = { ...
    [0x18 0x36 0x4b]./256, ...
    [0xe9 0x5b 0x16]./256, ...
    [0xec 0xc0 0x55]./256, ...
    [0x9c 0xc3 0xc7]./256, ...
  };
  
  fig = figure(1);
  
  set(fig, 'visible', 'off');
  set(fig, 'papersize', [19.2 10.8]);
  set(fig, 'paperposition', [0.2 0.2, 18.8, 10.4]);
  set(fig, 'paperunits', 'inches');
  
  x = 1:num_harmonics;

  for i = (corenum-1):totalcores:(steps_per_cycle-1);
    hold off;
    
    y = sin(i/steps_per_cycle * 2 * pi .* x);
    plot(x, y, '-o', 'color', cell2mat(colrs(1)), 'linewidth', 15);

    hold on;

    for intervalsize = sizes;
      for s = 1:intervalsize;
        plot(x(s:intervalsize:num_harmonics), y(s:intervalsize:num_harmonics), ...
             'linestyle', '-', ...
             'color', cell2mat(colrs(intervalsize-1)), ...
             'linewidth', 15/(1+intervalsize));
      end
    end

    axis([1 num_harmonics -1.2 1.2]);
    hold off;
    drawnow;
    print(fig, sprintf('%05d.pdf', i), '-dpdf')
  end

end
