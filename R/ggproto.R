#    Copyright 2015 Province of British Columbia
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#       https://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

is.waive <- function(x) inherits(x, "waiver")

empty <- function (df) {
  is.null(df) || nrow(df) == 0 || ncol(df) == 0 || is.waive(df)
}

rename <- function (x, replace) 
{
  current_names <- names(x)
  old_names <- names(replace)
  missing_names <- setdiff(old_names, current_names)
  if (length(missing_names) > 0) {
    replace <- replace[!old_names %in% missing_names]
    old_names <- names(replace)
  }
  names(x)[match(old_names, current_names)] <- as.vector(replace)
  x
}

ggname <- function(prefix, grob) {
  grob$name <- grobName(grob, prefix)
  grob
}

#' Base ggproto Classes for ggplot2
#'
#' @seealso [ggplot2::ggplot2-ggproto()]
#' @name ssdtools-ggproto
NULL

#' @rdname ssdtools-ggproto
#' @format NULL
#' @usage NULL
#' @export
StatSsd <- ggproto(
  "StatSsd", Stat,
  compute_panel = function(data, scales) {
    data$density <- ssd_ecd(data$x)
    data
  },
  default_aes = aes(y = ..density..),
  required_aes = "x"
)

#' @rdname ssdtools-ggproto
#' @format NULL
#' @usage NULL
#' @export
StatSsdcens <- ggproto(
  "StatSsdcens", Stat,
  compute_panel = function(data, scales) {
    data$density <- ssd_ecd(rowMeans(data[c("x", "xend")], na.rm = TRUE))
    data
  },
  default_aes = aes(y = ..density..),
  required_aes = c("x", "xend")
)

#' @rdname ssdtools-ggproto
#' @format NULL
#' @usage NULL
#' @export
GeomSsd <- ggproto(
  "GeomSsd", GeomPoint
)

#' @rdname ssdtools-ggproto
#' @format NULL
#' @usage NULL
#' @export
GeomSsdcens <- ggproto(
  "GeomSsdcens", Geom,
  default_aes = aes(
    colour = NA, fill = "grey20", size = 0.5, linetype = 1, # shape = 19,
    alpha = NA
  ),
  required_aes = c("x", "xend"),
  non_missing_aes = c("linetype", "size", "shape"),
  default_aes = aes(colour = "black", size = 0.5, linetype = 1, alpha = NA),
  draw_key = draw_key_path, # should define draw_key_ssdcens
  draw_panel = function(data, panel_params, coord, 
                        lineend = "butt", na.rm = FALSE) {
    
    arrow <- NULL
    linejoin <- "round"
    arrow.fill <- NULL
    
    data <- remove_missing(data, na.rm = na.rm,
                           c("x", "xend", "linetype", "size", "shape"),
                           name = "geom_ssdcens")
    if (empty(data)) return(zeroGrob())
    
    data$group <- 1:nrow(data)
    starts <- subset(data, select = -xend)
    ends <- rename(subset(data, select = -x), c("xend" = "x"))
    
    pieces <- rbind(starts, ends)
    pieces <- pieces[order(pieces$group),]
    
    ggname("geom_ssdcens",
           gTree(children = gList(
             GeomPath$draw_panel(pieces, panel_params, coord, arrow = arrow,
                                 lineend = lineend)
           ))
    )
  }
)

#' @rdname ssdtools-ggproto
#' @format NULL
#' @usage NULL
#' @export
GeomHcintersect <- ggproto(
  "GeomHcintersect", Geom,
  draw_panel = function(data, panel_params, coord) {
    data$group <- 1:nrow(data)
    data$x <- data$xintercept
    data$y <- data$yintercept
    start <- data
    start$x <- 0.0001
    end <- data
    end$y <- -Inf
    
    data <- rbind(start, data, end)
    GeomPath$draw_panel(data, panel_params, coord)
  },
  
  default_aes = aes(colour = "black", size = 0.5, linetype = "dotted", alpha = NA),
  required_aes = c("xintercept", "yintercept"),
  
  draw_key = draw_key_path
)

#' @rdname ssdtools-ggproto
#' @format NULL
#' @usage NULL
#' @export
GeomXribbon <- ggproto(
  "GeomXribbon", Geom,
  default_aes = aes(
    colour = NA, fill = "grey20", size = 0.5, linetype = 1,
    alpha = NA
  ),
  
  required_aes = c("y", "xmin", "xmax"),
  
  draw_key = draw_key_polygon,
  
  handle_na = function(data, params) {
    data
  },
  
  draw_group = function(data, panel_params, coord, na.rm = FALSE) {
    if (na.rm) data <- data[complete.cases(data[c("y", "xmin", "xmax")]), ]
    data <- data[order(data$group, data$y), ]
    
    # Check that aesthetics are constant
    aes <- unique(data[c("colour", "fill", "size", "linetype", "alpha")])
    if (nrow(aes) > 1) {
      err("Aesthetics can not vary with a ribbon.")
    }
    aes <- as.list(aes)
    
    missing_pos <- !complete.cases(data[c("y", "xmin", "xmax")])
    ids <- cumsum(missing_pos) + 1
    ids[missing_pos] <- NA
    
    positions <- summarise(data,
                           y = c(y, rev(y)), x = c(xmax, rev(xmin)), id = c(ids, rev(ids))
    )
    munched <- coord_munch(coord, positions, panel_params)
    
    ggname("geom_ribbon", polygonGrob(
      munched$x, munched$y,
      id = munched$id,
      default.units = "native",
      gp = gpar(
        fill = alpha(aes$fill, aes$alpha),
        col = aes$colour,
        lwd = aes$size * .pt,
        lty = aes$linetype
      )
    ))
  }
)
