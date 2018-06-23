# Draw smooth lines
set samples 10000

# Draw axes by default
set xzeroaxis
set yzeroaxis

# Some useful functions
# Draw a vertical line, use as eval(vline(x))
vline(x) = sprintf("set arrow nohead from %f, graph 0 to %f, graph 1",x,x)
