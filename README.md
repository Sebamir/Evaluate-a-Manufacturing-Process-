## Evalutate a Manufacturing Process

#Overview

Manufacturing processes for any product is like putting together a puzzle. Products are pieced together step by step, and keeping a close eye on the process is important.
For this project, I'm supporting a team that wants to improve how they monitor and control a manufacturing process. The goal is to implement a more methodical approach known as statistical process control (SPC). SPC is an established strategy that uses data to determine whether the process works well. Processes are only adjusted if measurements fall outside of an acceptable range. 
This acceptable range is defined by an upper control limit (UCL) and a lower control limit (LCL), the formulas for which are:

$ucl = avg\_height + 3 * \frac{stddev\_height}{\sqrt{5}}$

$lcl = avg\_height - 3 * \frac{stddev\_height}{\sqrt{5}}$

The UCL defines the highest acceptable height for the parts, while the LCL defines the lowest acceptable height for the parts. Ideally, parts should fall between the two limits.

# Objective
Using SQL window functions and nested queries, I'll analyze historical manufacturing data to define this acceptable range and identify any points in the process that fall outside of the range and therefore require adjustments. This will ensure a smooth running manufacturing process consistently making high-quality products.
After identifying individual out-of-control products, the team suspects that certain operators may need further training. They want to pinpoint operators whose machines consistently produce parts outside control limits. 
Using common table expressions and aggregations I will identify operators whose machines have a higher-than-average number of alerts compared to the total alerts for all operators.

## The data
The data is available in the `manufacturing_parts` table which has the following fields:
- `item_no`: the item number
- `length`: the length of the item made
- `width`: the width of the item made
- `height`: the height of the item made
- `operator`: the operating machine
