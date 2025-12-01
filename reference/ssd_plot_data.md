# Plot Species Sensitivity Data

Plots species sensitivity data.

## Usage

``` r
ssd_plot_data(
  data,
  left = "Conc",
  right = left,
  ...,
  label = NULL,
  shape = NULL,
  color = NULL,
  size = 2.5,
  xlab = "Concentration",
  ylab = "Species Affected",
  shift_x = 3,
  add_x = 0,
  big.mark = ",",
  decimal.mark = getOption("OutDec", "."),
  suffix = "%",
  bounds = c(left = 1, right = 1),
  trans = "log10",
  xbreaks = waiver()
)
```

## Arguments

- data:

  A data frame.

- left:

  A string of the column in data with the concentrations.

- right:

  A string of the column in data with the right concentration values.

- ...:

  Unused.

- label:

  A string of the column in data with the labels.

- shape:

  A string of the column in data for the shape aesthetic.

- color:

  A string of the column in data for the color aesthetic.

- size:

  A number for the size of the labels. Deprecated for `label_size`. \#'
  **\[deprecated\]**

- xlab:

  A string of the x-axis label.

- ylab:

  A string of the x-axis label.

- shift_x:

  The value to multiply the label x values by (after adding `add_x`).

- add_x:

  The value to add to the label x values (before multiplying by
  `shift_x`).

- big.mark:

  A string specifying the thousands separator.

- decimal.mark:

  A string specifying the numeric decimal point.

- suffix:

  Additional text to display after the number on the y-axis.

- bounds:

  A named non-negative numeric vector of the left and right bounds for
  uncensored missing (0 and Inf) data in terms of the orders of
  magnitude relative to the extremes for non-missing values.

- trans:

  A string of which transformation to use. Accepted values include
  `"log10"`, `"log"`, and `"identity"` (`"log10"` by default).

- xbreaks:

  The x-axis breaks as one of:

  - `NULL` for no breaks

  - [`waiver()`](https://ggplot2.tidyverse.org/reference/waiver.html)
    for the default breaks

  - A numeric vector of positions

## See also

[`ssd_plot()`](https://bcgov.github.io/ssdtools/reference/ssd_plot.md)
and
[`geom_ssdpoint()`](https://bcgov.github.io/ssdtools/reference/geom_ssdpoint.md)

## Examples

``` r
ssd_plot_data(ssddata::ccme_boron, label = "Species", shape = "Group")
```
