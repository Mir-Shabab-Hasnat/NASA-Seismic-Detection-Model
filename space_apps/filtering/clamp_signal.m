## Copyright (C) 2024 Bristine Muluh
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <https://www.gnu.org/licenses/>.

## -*- texinfo -*-
## @deftypefn {} {@var{retval} =} clamp_by_amplitude (@var{input1}, @var{input2})
##
## @seealso{}
## @end deftypefn


function signal_clamped = clamp_signal(signal, threshold_clamp)
    signal_clamped = signal;
    signal_clamped(abs(signal) < threshold_clamp) = 0;
end
